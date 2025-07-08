# SwallowPro Go 后端服务

## 项目简介

SwallowPro 是一个基于 Go (Gin + GORM) 的社区/上墙内容后端服务，支持用户注册、登录、发帖（上墙）、评论、回复、点赞、收藏、图片上传、消息通知、隐私设置等功能，适配 uni-app/Vue 前端及多端应用。

---

## 文件上传服务器搭建推荐

本项目推荐配合 [SwallowFileAPI](https://github.com/Tavernpub/SwallowFileAPI) 文件上传服务器，实现图片等多媒体内容的安全存储与访问。

### 快速搭建步骤

1. **获取 FileAPI 项目**
   ```bash
   git clone https://github.com/Tavernpub/SwallowFileAPI.git
   cd SwallowFileAPI
   ```
2. **上传 FileAPI.sh 脚本到云服务器 /opt 目录**
3. **运行一键部署脚本**
   ```bash
   cd /opt
   chmod +x FileAPI.sh
   ./FileAPI.sh
   ```
4. **服务启动后，图片上传接口默认地址为** `http://localhost:3000/upload`，文件访问为 `/files/{filename}`。
5. **在 SwallowPro 后端 config.yaml 中配置 file_upload_url**，如：
   ```yaml
   file_upload_url: http://localhost:3000
   ```

### FileAPI 简介

SwallowFileAPI 是一个基于 Node.js + Express + Multer 的高性能文件上传服务，支持多种图片格式（JPEG, PNG, GIF, BMP, WEBP, SVG, TIFF, ICO），自动类型校验、大小限制、CORS、日志、Nginx 反代、systemd 管理等，适配 uni-app、H5、小程序、APP 等多端图片上传需求。

- **支持格式**：jpg, jpeg, png, gif, bmp, webp, svg, tiff, ico
- **最大文件大小**：10MB
- **自动识别类型**，防止伪造扩展名
- **一键部署**，自动安装 Node.js、依赖、systemd 服务
- **详细文档与二次开发教程**，详见 [FileAPI README](https://github.com/Tavernpub/SwallowFileAPI/blob/main/README.md)

> 详细部署、接口、Nginx 配置、前端集成等请参考 [FileAPI 项目文档](https://github.com/Tavernpub/SwallowFileAPI/blob/main/README.md)。

---

## 技术栈与依赖

- **主语言**：Go 1.18+（推荐 1.20+）
- **Web 框架**：Gin v1.8+
- **ORM**：GORM v1.23+
- **数据库**：MySQL 5.5.62/5.7/8.0（本项目开发环境为 MySQL 5.5.62，兼容 5.7/8.0）
- **配置**：YAML（gopkg.in/yaml.v2）
- **日志**：log（内置）
- **依赖管理**：go mod
- **中间件**：JWT（自定义）、CORS（gin-cors）、日志
- **图片上传**：配合 Node.js + Express + Multer 文件服务（SwallowFileAPI）
- **其他依赖**：
  - github.com/gin-gonic/gin
  - gorm.io/gorm
  - gorm.io/driver/mysql
  - gopkg.in/yaml.v2
  - github.com/dgrijalva/jwt-go
  - 详见 go.mod

---

## 运行环境要求

- **操作系统**：Linux（推荐 CentOS 7+/Ubuntu 18.04+），Windows/macOS 亦可开发
- **Go 版本**：1.18 及以上
- **MySQL**：5.7/8.0，建议开启 utf8mb4
- **Node.js**：如需本地图片上传服务，需 Node.js 12+
- **云服务器**：1核2G及以上，开放 8080 端口

---

## 目录结构

```
SwallowAPI/
├── config/         # 配置加载
├── database/       # 数据库建表SQL
├── handlers/       # 路由处理器（业务逻辑）
├── middleware/     # 中间件（鉴权等）
├── models/         # 数据模型
├── routes/         # 路由注册
├── temp_uploads/   # （可选）图片临时目录
├── utils/          # 工具函数
├── main.go         # 启动入口
├── config.yaml     # 配置文件
├── go.mod/go.sum   # 依赖管理
└── README.md       # 项目说明
```

---

## 云服务器部署流程

1. **准备云服务器**
   - 推荐 CentOS 7+/Ubuntu 18.04+，1核2G及以上
   - 开放 8080 端口（安全组设置）

2. **安装 Go 环境**
   ```bash
   # 以 CentOS 为例
   wget https://go.dev/dl/go1.20.13.linux-amd64.tar.gz
   tar -C /usr/local -xzf go1.20.13.linux-amd64.tar.gz
   export PATH=$PATH:/usr/local/go/bin
   go version
   ```

3. **安装 MySQL 并导入表结构**
   ```bash
   # 安装MySQL，略
   mysql -u root -p
   CREATE DATABASE swallowpro DEFAULT CHARACTER SET utf8mb4;
   # 导入 SwallowAPI/database/*.sql
   ```

4. **上传后端代码**
   ```bash
   # 推荐用 scp/xftp/宝塔面板等上传 SwallowAPI 目录
   ```

5. **配置 config.yaml**
   ```yaml
   mysql:
     host: 127.0.0.1
     dbname: swallowpro
     user: root
     password: yourpassword
   server:
     port: 8080
   ```

6. **安装依赖并编译/运行**
   ```bash
   cd SwallowAPI
   go mod tidy
   go build -o main main.go
   ./main
   # 或后台运行
   nohup ./main > server.log 2>&1 &
   ```

7. **（可选）配置 systemd 服务**
   ```ini
   [Unit]
   Description=SwallowPro Go API
   After=network.target

   [Service]
   Type=simple
   User=root
   WorkingDirectory=/opt/SwallowAPI
   ExecStart=/opt/SwallowAPI/main
   Restart=always

   [Install]
   WantedBy=multi-user.target
   ```
   ```bash
   systemctl daemon-reload
   systemctl enable swallowpro
   systemctl start swallowpro
   ```

8. **（可选）Nginx 反向代理**
   ```nginx
   server {
     listen 80;
     server_name api.swallowpro.top;
     location / {
       proxy_pass http://127.0.0.1:8080;
       proxy_set_header Host $host;
       proxy_set_header X-Real-IP $remote_addr;
       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
     }
   }
   ```

---

## 开发文档与常用命令

### 本地开发

```bash
# 拉取依赖
cd SwallowAPI
go mod tidy
# 启动开发
go run main.go
# 编译
go build -o main main.go
# 后台运行
nohup ./main > server.log 2>&1 &
# 查看日志
cat server.log
# 停止进程
kill $(pgrep main)
```

### 数据库迁移
- 所有表结构在 database/*.sql，按顺序导入即可。
- 如需变更表结构，建议用 Navicat/Workbench 可视化工具。

### 依赖升级
```bash
go get -u github.com/gin-gonic/gin
go get -u gorm.io/gorm
go mod tidy
```

### 代码热重载（开发用）
```bash
go install github.com/cosmtrek/air@latest
air
```

---

## 主要接口说明（部分）

- `POST   /api/register`         用户注册
- `POST   /api/login`            用户登录
- `GET    /api/wall/list`        上墙内容列表
- `GET    /api/wall/detail`      上墙内容详情
- `POST   /api/wall/content/publish`  发布上墙内容
- `POST   /api/wall/upload/image`     图片上传（转发到Node服务）
- `GET    /api/wall/comment/list`     评论列表
- `POST   /api/wall/comment`          发表评论
- `POST   /api/wall/reply`            回复评论
- `POST   /api/wall/like`             点赞/取消点赞
- `POST   /api/wall/collect`          收藏/取消收藏
- `GET    /api/user/setting`          获取用户隐私设置
- `POST   /api/user/setting`          更新用户隐私设置

> 更多接口详见 handlers 目录源码和前端 pages 目录调用。

---

## 配置说明
- `config.yaml` 用于数据库和服务端口配置。
- 图片上传需配合 file_upload_url（Node.js 文件服务地址），详见 handlers/wall.go。

---

## 数据库说明
- 所有建表SQL在 `database/` 目录，按编号顺序导入。
- 主要表：users, wall_content, wall_images, wall_comment, wall_reply, comment_like, reply_like, user_setting, user_notification 等。

---

## 常见问题
- **无法连接数据库**：检查 config.yaml 配置和数据库服务状态。
- **图片上传失败**：检查 Node.js 文件服务是否正常，file_upload_url 配置是否正确。
- **接口401未授权**：前端需带上 token，后端路由需加鉴权中间件。
- **跨域问题**：建议前端通过同源代理或Nginx转发。

---

## 贡献与定制
- 欢迎提交 Issue、PR，或根据业务需求扩展 models/handlers。
- 可自定义经验、积分、等级、通知等业务模块。

---

## 联系方式
- 作者邮箱：tavernpub@yeah.net
- QQ：2196008384

---

**本项目仅用于学习和开发用途，禁止用于商业非法用途。**

---

## 宝塔面板部署Go后端（二进制）教程

### 1. 打包Go后端为二进制文件

在开发机或服务器上执行：
```bash
cd SwallowAPI
# Linux 64位
GOOS=linux GOARCH=amd64 go build -o swallowpro main.go
# Windows 64位
# GOOS=windows GOARCH=amd64 go build -o swallowpro.exe main.go
```
生成的 `swallowpro`（或 swallowpro.exe）即为可直接运行的后端服务。

### 2. 上传到宝塔面板服务器

- 通过宝塔面板的“文件”功能，将 `swallowpro` 二进制文件、`config.yaml`、`database/`、`static/`（如有）、`README.md` 等相关目录上传到如 `/www/wwwroot/swallowpro/` 目录。
- 推荐目录结构：

```
/www/wwwroot/swallowpro/
├── swallowpro           # Go后端二进制文件
├── config.yaml          # 配置文件
├── database/            # 数据库建表SQL（可选）
├── static/              # 静态资源（如有）
├── logs/                # 日志目录（建议新建）
└── README.md
```

### 3. 配置数据库连接

编辑 `/www/wwwroot/swallowpro/config.yaml`，填写你的MySQL信息：
```yaml
mysql:
  host: 127.0.0.1
  dbname: swallowpro
  user: root
  password: 你的数据库密码
server:
  port: 8080
file_upload_url: http://localhost:3000
```
- **host**：本地数据库可用127.0.0.1，远程请填写实际IP。
- **dbname**：数据库名，需提前在宝塔MySQL中新建。
- **user/password**：数据库账号密码，建议用宝塔面板生成的。
- **file_upload_url**：文件上传服务地址，配合 SwallowFileAPI。

### 4. 宝塔面板添加守护进程/计划任务

- 在宝塔面板“计划任务”中添加自定义Shell脚本：
  ```bash
  cd /www/wwwroot/swallowpro && nohup ./swallowpro > logs/server.log 2>&1 &
  ```
- 或用 Supervisor 插件添加 swallowpro 进程守护。
- 也可用“终端”手动运行：
  ```bash
  cd /www/wwwroot/swallowpro
  nohup ./swallowpro > logs/server.log 2>&1 &
  ```

### 5. 配置宝塔Nginx反向代理

- 在宝塔面板“网站”中新建站点（如 api.swallowpro.top），类型选纯静态。
- 进入站点设置，添加反向代理：
  - 目标URL填写 `http://127.0.0.1:8080`
  - 保留默认Header设置
- 可选：配置SSL证书，实现HTTPS访问。

### 6. 日志与维护

- 日志建议输出到 `logs/server.log`，便于宝塔面板查看。
- 可用“文件”或“终端”管理日志、二进制、配置等。

---
