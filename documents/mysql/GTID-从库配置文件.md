# GTID-从库配置文件

```
#
# This group are read by MySQL server.
# Use it for options that only the server (but not clients) should see
#
# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/en/server-configuration-defaults.html

# Settings user and group are ignored when systemd is used.
# If you need to run mysqld under a different user or group,
# customize your systemd unit file for mysqld according to the
# instructions in http://fedoraproject.org/wiki/Systemd

[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
log-error=/var/log/mysql/mysqld.log
pid-file=/run/mysqld/mysqld.pid

server-id = 2
gtid_mode = ON
enforce_gtid_consistency = ON
relay-log=relay-bin
relay-log-index=relay-bin.index
read-only = 1
master_info_repository=TABLE
relay_log_info_repository=TABLE 
binlog_cache_size=65536
relay_log_recovery=ON
log_slave_updates=on
log_timestamps=SYSTEM
sql_mode=''
group_concat_max_len=200000000
table_open_cache=400 
table_definition_cache=2000 
skip-name-resolve = 1
max_allowed_packet = 128M
max_connections = 9190
max_connect_errors = 100000
thread_stack = 1024K
thread_cache_size=1000
open_files_limit=10000
net_read_timeout=600
net_write_timeout=600
connect_timeout=60
sort_buffer_size = 2M
join_buffer_size = 2M
read_buffer_size = 2M
read_rnd_buffer_size = 2M
innodb_sort_buffer_size = 2M
thread_cache_size = 1000
key_buffer_size =128M
tmp_table_size = 128M
max_heap_table_size = 128M
bulk_insert_buffer_size = 64M
innodb_buffer_pool_size = 1024M
innodb_read_io_threads = 4
innodb_write_io_threads = 4
innodb_thread_concurrency = 4
innodb_log_buffer_size = 32M
innodb_flush_log_at_trx_commit=1
innodb_flush_method=O_DIRECT
innodb_io_capacity=2000
innodb_io_capacity_max=3000
innodb_flush_neighbors=0
binlog_expire_logs_seconds=864000
innodb_temp_data_file_path = ibtmp1:12M:autoextend:max:1G
max_execution_time=120000
default_authentication_plugin=caching_sha2_password


replicate-ignore-db=information_schema
replicate-ignore-db=mysql
replicate-ignore-db=performance_schema
replicate-ignore-db=sys
```