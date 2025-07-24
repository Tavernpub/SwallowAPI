CREATE TABLE wall_forward (
    id INT AUTO_INCREMENT PRIMARY KEY,
    content_id INT NOT NULL COMMENT '被转发内容',
    user_id INT NOT NULL COMMENT '转发者',
    forward_to INT COMMENT '平台内转发目标用户',
    forward_url VARCHAR(255) COMMENT '外部分享链接',
    forward_time DATETIME NOT NULL COMMENT '转发时间',
    FOREIGN KEY (content_id) REFERENCES wall_content(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (forward_to) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='内容转发';