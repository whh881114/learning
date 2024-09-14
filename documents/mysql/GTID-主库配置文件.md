# GTID-主库配置文件

```
# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/8.0/en/server-configuration-defaults.html

[mysql]
prompt="\u@mysqldb \R:\m:\s [\d]> "
no-auto-rehash

[mysqld]
#
# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
# innodb_buffer_pool_size = 128M
#
# Remove the leading "# " to disable binary logging
# Binary logging captures changes between backups and is enabled by
# default. It's default setting is log_bin=binlog
# disable_log_bin
#
# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M
#
# Remove leading # to revert to previous value for default_authentication_plugin,
# this will increase compatibility with older clients. For background, see:
# https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_default_authentication_plugin
# default-authentication-plugin=mysql_native_password

datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock

log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid


server-id = 1
gtid_mode = ON
enforce_gtid_consistency = ON
sync-binlog = 1
innodb_flush_log_at_trx_commit=1
binlog_expire_logs_seconds=864000
binlog_cache_size=65536
skip-name-resolve = 1
event_scheduler=ON
open_files_limit=10000
innodb_thread_concurrency = 4
max_allowed_packet = 128M
max_connections = 9190
max_connect_errors = 10000
key_buffer_size = 128M
long_query_time = 1
sql_mode=''
group_concat_max_len=200000000
table_open_cache=400
thread_cache_size=1000
log_timestamps=SYSTEM
innodb_print_all_deadlocks=on
innodb_lock_wait_timeout=10
innodb_io_capacity=2000
innodb_io_capacity_max=3000
innodb_flush_method=O_DIRECT
innodb_flush_neighbors=0
sort_buffer_size = 2M
join_buffer_size = 2M
read_buffer_size = 2M
read_rnd_buffer_size = 2M
innodb_sort_buffer_size = 4M
table_definition_cache=2000 
tmp_table_size = 128M
max_heap_table_size = 512M
bulk_insert_buffer_size = 64M
innodb_temp_data_file_path = ibtmp1:12M:autoextend:max:1G
innodb_buffer_pool_size = 1024M
innodb_log_buffer_size = 32M
innodb_read_io_threads = 4
innodb_write_io_threads = 4
innodb_thread_concurrency = 4 
default_authentication_plugin=caching_sha2_password
```