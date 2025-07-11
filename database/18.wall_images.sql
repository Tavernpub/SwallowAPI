CREATE TABLE wall_images (
    id INT AUTO_INCREMENT PRIMARY KEY,
    content_id INT NOT NULL COMMENT '所属内容',
    image_url VARCHAR(255) NOT NULL COMMENT '图片URL',
    sort_order TINYINT DEFAULT 0 COMMENT '排序序号(0-8)',
    FOREIGN KEY (content_id) REFERENCES wall_content(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='内容图片';