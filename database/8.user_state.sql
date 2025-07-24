CREATE TABLE user_state (
    user_id INT PRIMARY KEY,
    state ENUM('online','invisible','busy','dnd','offline') DEFAULT 'online' COMMENT '用户状态',
    reply_content VARCHAR(255) COMMENT '自动回复内容',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户在线状态';