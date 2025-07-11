CREATE TABLE user_identity (
    user_id INT NOT NULL COMMENT '用户ID',
    identity_id INT NOT NULL COMMENT '身份类型ID',
    assign_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '分配时间',
    PRIMARY KEY (user_id, identity_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (identity_id) REFERENCES identity_type(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户与身份关联表';