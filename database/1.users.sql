CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '用户唯一ID',
    uid VARCHAR(10) UNIQUE NOT NULL COMMENT '5-10位用户UID',
    avatar VARCHAR(255) COMMENT '头像URL',
    background VARCHAR(255) COMMENT '背景图URL',
    account VARCHAR(50) UNIQUE NOT NULL COMMENT '登录账号',
    username VARCHAR(50) NOT NULL COMMENT '用户名',
    password VARCHAR(255) NOT NULL COMMENT '加密密码',
    ip VARCHAR(45) COMMENT '最后登录IP',
    ip_location VARCHAR(100) COMMENT 'IP归属地',
    follow_count INT DEFAULT 0 COMMENT '关注数',
    fans_count INT DEFAULT 0 COMMENT '粉丝数',
    like_count INT DEFAULT 0 COMMENT '获赞总数',
    birthday DATE COMMENT '生日',
    signature VARCHAR(255) COMMENT '个性签名',
    email VARCHAR(100) COMMENT '邮箱',
    status TINYINT DEFAULT 0 COMMENT '状态:0正常/1封禁',
    role ENUM('user','admin') DEFAULT 'user' NOT NULL COMMENT '用户角色',
    exp INT DEFAULT 0 NOT NULL COMMENT '总经验值',
    level INT DEFAULT 1 NOT NULL COMMENT '当前等级',
    register_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
    update_time DATETIME COMMENT '最后更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户主表';