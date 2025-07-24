REPLACE INTO system_config (config_key, config_value, description)
VALUES ('wall_content_audit', 'on', '内容发布是否需要审核，on为需要，off为无需审核');

REPLACE INTO system_config (config_key, config_value, description)
VALUES ('file_upload_url', 'https://file.swallowpro.top/', '文件上传服务器地址');

-- 插入邮件配置信息
REPLACE INTO system_config (config_key, config_value, description) VALUES
('mail_smtp', 'smtp.qq.com', 'SMTP服务器地址'),
('mail_account', '2196008384@qq.com', '邮箱账户'),
('mail_password', 'ysnifqwjeyjtebca', '邮箱授权码'),
('mail_from', 'Swallow <2196008384@qq.com>', '发信者'),
('mail_port', '465', 'SMTP端口'),
('mail_name', 'Swallow', '发信名称');