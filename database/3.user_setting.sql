CREATE TABLE user_setting (
    user_id INT PRIMARY KEY COMMENT '关联用户ID',
    follow TINYINT DEFAULT 0 COMMENT '关注可见性:0自己/1好友/2所有人',
    fans TINYINT DEFAULT 0 COMMENT '粉丝可见性',
    birthday TINYINT DEFAULT 0 COMMENT '生日可见性',
    signature TINYINT DEFAULT 0 COMMENT '签名可见性',
    email TINYINT DEFAULT 0 COMMENT '邮箱可见性',
    message TINYINT DEFAULT 2 COMMENT '私信可见性:0禁止陌生人/1陌生人限额/2所有人可私信',
    stranger_msg_limit INT DEFAULT 0 COMMENT '陌生人每日私信上限（0为不限）',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户隐私设置';