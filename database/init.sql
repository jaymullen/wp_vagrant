DROP SCHEMA IF EXISTS wp_app;
CREATE SCHEMA wp_app;

CREATE USER 'wp_app'@'%' IDENTIFIED BY 'admin';
GRANT ALL ON wp_app.* TO 'wp_app'@'%';
