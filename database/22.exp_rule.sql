CREATE TABLE exp_rule (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '规则ID',
    action VARCHAR(50) NOT NULL UNIQUE COMMENT '行为标识（如signin, post, like, ...）',
    exp_value INT NOT NULL COMMENT '获得经验值',
    description VARCHAR(255) COMMENT '规则描述'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='经验获取规则表'; 