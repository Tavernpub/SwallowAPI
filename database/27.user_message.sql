CREATE TABLE user_message (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '消息ID',
    conversation_id INT NOT NULL COMMENT '会话ID',
    sender_id INT NOT NULL COMMENT '发送者ID',
    receiver_id INT NOT NULL COMMENT '接收者ID',
    content TEXT NOT NULL COMMENT '消息内容',
    send_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发送时间',
    is_read TINYINT DEFAULT 0 COMMENT '是否已读:0未读/1已读',
    read_time DATETIME COMMENT '已读时间',
    FOREIGN KEY (conversation_id) REFERENCES user_conversation(id) ON DELETE CASCADE,
    FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户私信消息表';