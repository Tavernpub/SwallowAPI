# SwallowPro 后端部署说明

## 项目简介
SwallowPro 后端基于 Go 语言开发，使用 Gin 框架和 GORM ORM，支持用户注册、登录、内容发布、评论、点赞、私信等功能。数据库采用 MySQL。

---

## 依赖环境
- **Go 1.23.x 或 1.24.x**（需与 go.mod 保持一致，建议使用 go1.23.0 及以上版本）
  - go.mod 中声明为 `go 1.23.0`，推荐安装 [Go 1.23.0](https://golang.org/dl/) 或更高版本
- **MySQL 5.5.62 及以上**
  - 推荐使用 MySQL 5.5.62（已在此版本下测试），也兼容 5.7/8.0
- CentOS 7（生产环境）
- 依赖包见 `go.mod`，主要有：
  - github.com/gin-gonic/gin
  - gorm.io/gorm
  - gorm.io/driver/mysql
  - github.com/spf13/viper
  - 其他依赖以 go.mod 为准

---

## 已有可执行文件后的宝塔面板部署教程

### 1. 上传后端文件
- 通过宝塔面板的“文件”功能，将以下内容上传到服务器指定目录（如 `/www/swallowpro`）：
  - `main`（Linux下编译好的可执行文件）
  - `config.yaml`（配置文件，根据实际情况修改）
  - `database/`（首次部署需用到建表 SQL）
  - 其他依赖目录（如 `uploads/`，用于本地临时存储图片，可选）

### 2. 配置数据库
- 在宝塔面板“数据库”中新建 MySQL 数据库，记下数据库名、用户名、密码。
- 进入“数据库管理”，用 phpMyAdmin 或命令行导入 `database/` 目录下所有 SQL 文件：
  - 可逐个导入，也可用命令行批量导入：
    ```bash
    cd /www/swallowpro/database
    for f in *.sql; do mysql -u用户名 -p数据库名 < $f; done
    ```
- **注意：如使用 MySQL 5.5.62，所有表结构已兼容此版本。**

### 3. 修改配置文件
- 编辑 `config.yaml`，填写正确的数据库连接信息，例如：
  ```yaml
  mysql:
    host: 127.0.0.1
    dbname: swallowpro
    user: root
    password: 你的密码
  server:
    port: 8080
  ```
- 如需更改端口，可修改 `port` 字段。

### 4. 配置防火墙
- 在宝塔面板“安全”或“防火墙”中，放行后端服务端口（如 8080），确保外部可访问。

### 5. 设置守护进程（推荐 Supervisor）
- 在宝塔面板“软件商店”安装 Supervisor 管理器。
- 添加新的守护任务，配置如下：
  - **名称**：swallowpro
  - **启动命令**：
    ```bash
    /www/swallowpro/main
    ```
  - **工作目录**：
    ```bash
    /www/swallowpro
    ```
  - **日志路径**：可自定义，如 `/www/swallowpro/main.log`
  - **启动用户**：root 或 www（根据实际情况）
- 启动并设置为开机自启。

### 6. 启动/重启服务
- 在 Supervisor 管理器中点击“启动”或“重启”按钮即可。
- 或者在宝塔面板“终端”中手动运行：
  ```bash
  cd /www/swallowpro
  chmod +x main
  ./main
  ```
  （建议用 Supervisor 守护，避免进程意外退出）

### 7. 访问后端接口
- 通过 `http://服务器IP:8080/api` 访问后端接口。
- 如需对外提供 HTTPS，建议用宝塔面板的 Nginx/Apache 反向代理。

---

## 常见问题
- **端口被占用**：修改 `config.yaml` 的端口或释放端口
- **数据库连接失败**：检查数据库配置、网络、防火墙
- **依赖缺失**：确保上传的是 Linux 下编译好的可执行文件
- **图片上传失败**：检查 `file_upload_url` 配置和服务器网络

---

## 其他说明
- 日志输出在控制台或 Supervisor 日志文件，如需持久化请重定向或用日志管理工具
- 如有新表/字段，需同步更新数据库

---

如有问题请联系开发者或提交 issue。 
