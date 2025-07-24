CREATE TABLE user_conversation (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '会话ID',
    user1_id INT NOT NULL COMMENT '用户1',
    user2_id INT NOT NULL COMMENT '用户2',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '会话创建时间',
    last_msg_time DATETIME COMMENT '最后一条消息时间',
    UNIQUE KEY unique_pair (user1_id, user2_id),
    FOREIGN KEY (user1_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (user2_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户私信会话表';