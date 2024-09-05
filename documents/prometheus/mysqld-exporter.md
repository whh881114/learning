# mysqld-exporter

## 正文
- https://github.com/prometheus/mysqld_exporter

- 在`v0.14.0`版本中，配置环境变量`DATA_SOURCE_NAME`即可和mysql容器通信。

- 在`v0.15.1`版本中，则需要配置环境变量`MYSQLD_EXPORTER_PASSWORD`，并且需配置启动参数`--mysqld.username exporter`。

- `mysql`配置`exporter`用户。
  ```shell
  CREATE USER 'exporter'@'localhost' IDENTIFIED BY 'XXXXXXXX' WITH MAX_USER_CONNECTIONS 3;
  GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'localhost';
  ```