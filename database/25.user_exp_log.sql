CREATE TABLE user_exp_log (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '记录ID',
    user_id INT NOT NULL COMMENT '用户ID',
    action VARCHAR(50) NOT NULL COMMENT '行为标识',
    exp_value INT NOT NULL COMMENT '获得经验',
    log_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '获得时间',
    ref_id INT COMMENT '关联业务ID（如内容ID、评论ID等，可选）',
    description VARCHAR(255) COMMENT '备注',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户经验获取明细';