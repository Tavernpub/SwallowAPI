CREATE TABLE email_verify (
    user_id INT PRIMARY KEY,
    verify_status TINYINT DEFAULT 0 COMMENT '0未验证/1已验证',
    verify_code CHAR(6) COMMENT '6位验证码',
    user_ip VARCHAR(45) COMMENT '申请IP',
    expire_time DATETIME COMMENT '验证码过期时间',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='邮箱验证';