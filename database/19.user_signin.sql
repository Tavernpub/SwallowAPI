CREATE TABLE user_signin (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '签到记录ID',
    user_id INT NOT NULL COMMENT '用户ID',
    signin_date DATE NOT NULL COMMENT '签到日期',
    UNIQUE KEY unique_signin (user_id, signin_date),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户每日签到记录';