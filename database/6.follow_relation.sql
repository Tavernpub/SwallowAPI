CREATE TABLE follow_relation (
    follower_id INT NOT NULL COMMENT '关注者ID',
    followed_id INT NOT NULL COMMENT '被关注者ID',
    create_time DATETIME NOT NULL COMMENT '关注时间',
    PRIMARY KEY (follower_id, followed_id),
    FOREIGN KEY (follower_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (followed_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户关注关系';