CREATE TABLE wall_comment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    content_id INT NOT NULL COMMENT '所属内容',
    user_id INT NOT NULL COMMENT '评论者',
    content VARCHAR(500) NOT NULL COMMENT '评论内容',
    ip VARCHAR(45) COMMENT '评论IP',
    ip_location VARCHAR(100) COMMENT 'IP归属地',
    like_count INT DEFAULT 0 COMMENT '点赞数',
    comment_time DATETIME NOT NULL COMMENT '评论时间',
    FOREIGN KEY (content_id) REFERENCES wall_content(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='内容评论';