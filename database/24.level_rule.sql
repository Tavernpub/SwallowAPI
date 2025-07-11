CREATE TABLE level_rule (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '等级ID',
    level INT NOT NULL UNIQUE COMMENT '等级',
    exp_required INT NOT NULL COMMENT '所需经验值',
    name VARCHAR(50) NOT NULL COMMENT '等级名称',
    description VARCHAR(255) COMMENT '等级描述'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='等级规则表'; 