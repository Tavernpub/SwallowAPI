CREATE TABLE user_relation (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user1_id INT NOT NULL COMMENT '主动方用户',
    user2_id INT NOT NULL COMMENT '被动方用户',
    relation_type ENUM('lover','bro','sister','classmate','family') NOT NULL COMMENT '关系类型',
    visibility TINYINT DEFAULT 2 COMMENT '可见性:0自己/1好友/2所有人',
    UNIQUE KEY unique_relation (user1_id, user2_id, relation_type),
    CHECK (user1_id < user2_id),
    FOREIGN KEY (user1_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (user2_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户特殊关系';