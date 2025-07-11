CREATE TABLE user_notification (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '通知ID',
    user_id INT NOT NULL COMMENT '被通知用户ID',
    type VARCHAR(30) NOT NULL COMMENT '通知类型',
    ref_id INT NOT NULL COMMENT '关联业务ID',
    from_user_id INT COMMENT '触发通知的用户ID',
    content VARCHAR(255) COMMENT '通知内容（可选）',
    is_read TINYINT DEFAULT 0 COMMENT '是否已读:0未读/1已读',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '通知时间',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (from_user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户通知表';