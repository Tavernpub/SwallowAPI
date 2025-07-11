CREATE TABLE wall_reply (
    id INT AUTO_INCREMENT PRIMARY KEY,
    comment_id INT NOT NULL COMMENT '所属评论',
    user_id INT NOT NULL COMMENT '回复者',
    content VARCHAR(500) NOT NULL COMMENT '回复内容',
    ip VARCHAR(45) COMMENT '回复IP',
    ip_location VARCHAR(100) COMMENT 'IP归属地',
    like_count INT DEFAULT 0 COMMENT '点赞数',
    reply_time DATETIME NOT NULL COMMENT '回复时间',
    FOREIGN KEY (comment_id) REFERENCES wall_comment(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评论回复';

ALTER TABLE wall_reply ADD COLUMN parent_reply_id INT DEFAULT NULL COMMENT '父回复ID（多级回复）' AFTER comment_id;