#!/bin/bash
# SwallowAPI 一键部署脚本
# 适用环境：CentOS 7+/兼容系统
# 作用：自动部署Go后端到/opt/SwallowAPI
# 作者：https://github.com/Tavernpub/SwallowAPI

set -e

# 只允许在/opt目录下运行
if [ "$(pwd)" != "/opt" ]; then
  echo "请在/opt目录下运行本脚本！"
  exit 1
fi

LOG="/tmp/swallowapi_install.log"
echo "[SwallowAPI] 部署日志: $LOG"
exec > >(tee -a "$LOG") 2>&1

# 询问是否继续某步骤
yes_or_no() {
  local msg="$1"
  read -p "$msg (y/n)：" yn
  if [[ "$yn" != "y" && "$yn" != "Y" ]]; then
    echo "已跳过：$msg"
    return 1
  fi
  return 0
}

# 1. 检查并安装基础依赖（自动执行，无需确认）
function install_base() {
  echo "[1/9] 检查并安装基础依赖..."
  yum install -y wget git unzip mysql || { echo "依赖安装失败"; exit 1; }
}

# 2. 检查并安装Go 1.23.0（自动执行，无需确认）
function install_go() {
  if command -v go >/dev/null 2>&1; then
    GOVERSION=$(go version | awk '{print $3}')
    if [[ "$GOVERSION" =~ go1.23.* || "$GOVERSION" =~ go1.24.* ]]; then
      echo "Go已安装: $GOVERSION，跳过Go安装。"
      return
    else
      echo "检测到Go版本($GOVERSION)，将升级为Go 1.23.0"
    fi
  fi
  echo "[2/9] 安装Go 1.23.0..."
  cd /tmp
  wget -O go1.23.0.linux-amd64.tar.gz https://go.dev/dl/go1.23.0.linux-amd64.tar.gz
  rm -rf /usr/local/go
  tar -C /usr/local -xzf go1.23.0.linux-amd64.tar.gz
  echo 'export PATH=$PATH:/usr/local/go/bin' > /etc/profile.d/go.sh
  export PATH=$PATH:/usr/local/go/bin
  source /etc/profile.d/go.sh
  go version
}

# 3. 拉取后端代码
yes_or_no_clone_repo() {
  yes_or_no "是否拉取/更新后端代码？"
}
function clone_repo() {
  if yes_or_no_clone_repo; then
    echo "[3/9] 拉取后端代码..."
    if [ ! -d /opt ]; then mkdir /opt; fi
    if [ ! -d /opt/SwallowAPI ]; then
      mkdir -p /opt/SwallowAPI
      cd /opt
      git clone https://github.com/Tavernpub/SwallowAPI.git SwallowAPI-tmp
      cp -r SwallowAPI-tmp/* SwallowAPI/
      rm -rf SwallowAPI-tmp
    else
      cd /opt/SwallowAPI
      git pull || echo "已存在/opt/SwallowAPI，跳过git pull"
    fi
  fi
}

# 4. 检查main可执行文件
function check_main() {
  if yes_or_no "是否检查/编译main可执行文件？"; then
    echo "[4/9] 检查可执行文件..."
    cd /opt/SwallowAPI
    if [ ! -f main ]; then
      echo "未检测到main可执行文件，尝试编译..."
      if [ -f main.go ]; then
        go build -o main main.go || { echo "Go编译失败"; exit 1; }
      else
        echo "缺少main.go源码，无法编译。请上传main可执行文件。"; exit 1
      fi
    fi
    chmod +x main
  fi
}

# 5. 生成config.yaml
function gen_config() {
  if yes_or_no "是否生成/覆盖配置文件config.yaml？"; then
    echo "[5/9] 生成配置文件/opt/SwallowAPI/config.yaml..."
    local config_file="/opt/SwallowAPI/config.yaml"
    if [ -f "$config_file" ]; then
      echo "已存在config.yaml，跳过自动生成。"
      return
    fi
    echo "请输入数据库相关信息（直接回车使用默认值，可自行修改）："
    read -e -i "localhost" -p "数据库地址：" dbhost
    read -e -i "3306" -p "数据库端口：" dbport
    read -e -i "swallowpro" -p "数据库名：" dbname
    while [ -z "$dbname" ]; do
      echo "数据库名不能为空，请重新输入。"
      read -e -i "swallowpro" -p "数据库名：" dbname
    done
    read -e -i "root" -p "数据库用户名：" dbuser
    while [ -z "$dbuser" ]; do
      echo "数据库用户名不能为空，请重新输入。"
      read -e -i "root" -p "数据库用户名：" dbuser
    done
    read -e -i "123456" -p "数据库密码：" dbpass
    while [ -z "$dbpass" ]; do
      echo "数据库密码不能为空，请重新输入。"
      read -e -i "123456" -p "数据库密码：" dbpass
    done
    read -e -i "8080" -p "后端服务端口：" apiport
    cat > "$config_file" <<EOF
mysql:
  host: $dbhost
  dbname: $dbname
  user: $dbuser
  password: $dbpass
  port: $dbport
server:
  # 后端服务监听端口
  port: $apiport
EOF
    echo "已生成/opt/SwallowAPI/config.yaml"
  fi
}

# 6. 导入数据库建表SQL
function import_sql() {
  if yes_or_no "是否自动导入数据库建表SQL？"; then
    echo "[6/10] 开始导入数据库建表SQL..."
    local config_file="/opt/SwallowAPI/config.yaml"
    if [ ! -f "$config_file" ]; then
      echo "未找到配置文件，无法导入数据库。"; exit 1
    fi
    # 解析配置文件
    dbhost=$(grep 'host:' $config_file | awk '{print $2}')
    dbport=$(grep 'port:' $config_file | head -1 | awk '{print $2}')
    dbname=$(grep 'dbname:' $config_file | awk '{print $2}')
    dbuser=$(grep 'user:' $config_file | awk '{print $2}')
    dbpass=$(grep 'password:' $config_file | awk '{print $2}')
    sql_dir="/opt/SwallowAPI/database"
    if [ ! -d "$sql_dir" ]; then
      echo "未找到数据库SQL目录 $sql_dir"; exit 1
    fi

    # 询问用户文件上传服务器地址
    upload_url_default="https://file.swallowpro.top/"
    read -p "请输入文件上传服务器地址（用于图片/文件上传）[默认$upload_url_default]：" upload_url
    upload_url=${upload_url:-$upload_url_default}

    for sqlfile in $(ls $sql_dir/*.sql | sort -V); do
      if [[ $(basename $sqlfile) == "23.system_config.sql" ]]; then
        # 替换 file_upload_url 行
        tmpfile="${sqlfile}.tmp"
        sed "s#'file_upload_url', '[^']*'#'file_upload_url', '$upload_url'#g" "$sqlfile" > "$tmpfile"
        echo "正在导入：$(basename $sqlfile) ..."
        mysql -h$dbhost -P$dbport -u$dbuser -p$dbpass $dbname < "$tmpfile" && \
          echo "成功导入：$(basename $sqlfile)" || { echo "导入失败：$(basename $sqlfile)"; exit 1; }
        rm -f "$tmpfile"
      else
        echo "正在导入：$(basename $sqlfile) ..."
        mysql -h$dbhost -P$dbport -u$dbuser -p$dbpass $dbname < $sqlfile && \
          echo "成功导入：$(basename $sqlfile)" || { echo "导入失败：$(basename $sqlfile)"; exit 1; }
      fi
    done
    echo "所有表已导入完成。"
  fi
}

# 7. 安装Supervisor
function install_supervisor() {
  if yes_or_no "是否安装/启动Supervisor？"; then
    echo "[7/9] 检查并安装Supervisor..."
    if ! command -v supervisord >/dev/null 2>&1; then
      yum install -y epel-release
      yum install -y supervisor
      systemctl enable supervisord
      systemctl start supervisord
    else
      systemctl start supervisord
    fi
  fi
}

# 8. 配置Supervisor守护SwallowAPI
function config_supervisor() {
  if yes_or_no "是否配置Supervisor守护SwallowAPI？"; then
    echo "[8/9] 配置Supervisor守护SwallowAPI..."
    SUPCONF="/etc/supervisord.d/swallowapi.ini"
    cat > $SUPCONF <<EOF
[program:swallowapi]
command=/opt/SwallowAPI/main
directory=/opt/SwallowAPI
autostart=true
autorestart=true
stderr_logfile=/opt/SwallowAPI/main.err.log
stdout_logfile=/opt/SwallowAPI/main.out.log
user=root
environment=PATH="/usr/local/go/bin:/usr/bin:/bin"
EOF
    supervisorctl reread
    supervisorctl update
    supervisorctl restart swallowapi || supervisorctl start swallowapi
  fi
}

# 9. 提示用户配置数据库和config.yaml
function remind_config() {
  echo "[9/9] 请根据README.md完成数据库建表（如首次部署）"
  echo "- 数据库建表SQL位于/opt/SwallowAPI/database/"
  echo "- 配置文件/opt/SwallowAPI/config.yaml"
  echo "- 如需修改端口或数据库信息，请编辑config.yaml后重启服务：supervisorctl restart swallowapi"
}

# 10. 完成
function finish() {
  echo "[10/10] 部署完成！"
  echo "后端服务已由Supervisor守护，接口地址：http://服务器IP:$(grep port: /opt/SwallowAPI/config.yaml | tail -1 | awk '{print $2}')/api"
  echo "如需查看日志：tail -f /opt/SwallowAPI/main.out.log"
}

# 主流程
install_base
install_go
clone_repo
check_main
gen_config
import_sql
install_supervisor
config_supervisor
remind_config
finish 
