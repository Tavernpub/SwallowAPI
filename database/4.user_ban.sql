CREATE TABLE user_ban (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL COMMENT '被封禁用户',
    ban_time DATETIME NOT NULL COMMENT '封禁时间',
    unban_time DATETIME COMMENT '解封时间',
    ban_reason VARCHAR(255) COMMENT '封禁原因',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户封禁记录';