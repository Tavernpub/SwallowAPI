# SwallowPro 后端部署说明

## 项目简介
SwallowPro 后端基于 Go 语言开发，使用 Gin 框架和 GORM ORM，支持用户注册、登录、内容发布、评论、点赞、私信等功能。数据库采用 MySQL。

---

## 依赖环境
- CentOS 7 及以上（推荐）
- Go 1.23.x 或 1.24.x（脚本自动安装）
- MySQL 5.5.62 及以上
- Supervisor（脚本自动安装）
- 服务器需能访问公网（拉取代码、下载依赖）

---

## 一键部署（推荐）

> **注意：SwallowAPI.sh 脚本必须在 /opt 目录下运行，否则会自动退出！**

1. **上传脚本**
   将 `SwallowAPI.sh` 上传到服务器 `/opt` 目录。

2. **赋予执行权限**
   ```bash
   cd /opt
   chmod +x SwallowAPI.sh
   ```

3. **运行脚本**
   ```bash
   ./SwallowAPI.sh
   ```

4. **按提示输入**
   - 数据库地址、端口、库名、用户名、密码
   - 后端服务端口
   - 是否自动导入数据库建表SQL（推荐首次部署选择y）
   - 文件上传服务器地址（如无特殊需求用默认即可）

5. **部署完成后**
   - 后端服务由 Supervisor 守护，接口地址如 `http://服务器IP:端口/api`
   - 日志见 `/opt/SwallowAPI/main.out.log`
   - 如需重启服务：
     ```bash
     supervisorctl restart swallowapi
     ```

---

## 配置文件说明（/opt/SwallowAPI/config.yaml）
```yaml
mysql:
  host: localhost
  dbname: your_db
  user: your_user
  password: your_pass
  port: 3306
server:
  # 后端服务监听端口
  port: 8080
```
- 修改后需重启服务生效。

---

## 数据库初始化
- 所有建表SQL位于 `/opt/SwallowAPI/database/`，脚本可自动导入。
- 如需手动导入：
  ```bash
  cd /opt/SwallowAPI/database
  for f in *.sql; do mysql -h主机 -P端口 -u用户名 -p密码 数据库名 < $f; done
  ```
- `23.system_config.sql` 中的文件上传服务器地址可在脚本执行时自定义。

---

## 常见问题
- **端口被占用**：修改 `config.yaml` 的端口或释放端口
- **数据库连接失败**：检查数据库配置、网络、防火墙
- **依赖缺失**：脚本会自动安装Go和Supervisor
- **图片上传失败**：检查 `file_upload_url` 配置和服务器网络

---

## 联系方式
如有问题请联系开发者或提交 issue。

---

**本项目开源地址**：[https://github.com/Tavernpub/SwallowAPI](https://github.com/Tavernpub/SwallowAPI)
