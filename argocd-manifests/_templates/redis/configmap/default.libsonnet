function(app)
	local default = |||
	  bind 0.0.0.0
	  protected-mode yes
	  port 6379
	  tcp-backlog 511
	  timeout 0
	  tcp-keepalive 300
	  daemonize no
	  pidfile /var/run/redis_6379.pid
	  loglevel notice
	  databases 16
	  always-show-logo no
	  set-proc-title yes
	  proc-title-template '{title} {listen-addr} {server-mode}'
	  stop-writes-on-bgsave-error yes
	  rdbcompression yes
	  rdbchecksum yes
	  dbfilename dump.rdb
	  rdb-del-sync-files no
	  dir /data
	  replica-serve-stale-data yes
	  replica-read-only yes
	  repl-diskless-sync no
	  repl-diskless-sync-delay 5
	  repl-diskless-load disabled
	  repl-disable-tcp-nodelay no
	  replica-priority 100
	  requirepass <requirepass_replace_me>
	  acllog-max-len 128
	  lazyfree-lazy-eviction no
	  lazyfree-lazy-expire no
	  lazyfree-lazy-server-del no
	  replica-lazy-flush no
	  lazyfree-lazy-user-del no
	  lazyfree-lazy-user-flush no
	  oom-score-adj no
	  oom-score-adj-values 0 200 800
	  disable-thp yes
	  appendonly yes
	  appendfilename 'appendonly.aof'
	  appendfsync everysec
	  no-appendfsync-on-rewrite no
	  auto-aof-rewrite-percentage 100
	  auto-aof-rewrite-min-size 64mb
	  aof-load-truncated yes
	  aof-use-rdb-preamble yes
	  lua-time-limit 5000
	  slowlog-log-slower-than 10000
	  slowlog-max-len 128
	  latency-monitor-threshold 0
	  notify-keyspace-events ''
	  hash-max-ziplist-entries 512
	  hash-max-ziplist-value 64
	  list-max-ziplist-size -2
	  list-compress-depth 0
	  set-max-intset-entries 512
	  zset-max-ziplist-entries 128
	  zset-max-ziplist-value 64
	  hll-sparse-max-bytes 3000
	  stream-node-max-bytes 4096
	  stream-node-max-entries 100
	  activerehashing yes
	  client-output-buffer-limit normal 0 0 0
	  client-output-buffer-limit replica 256mb 64mb 60
	  client-output-buffer-limit pubsub 32mb 8mb 60
	  hz 10
	  dynamic-hz yes
	  aof-rewrite-incremental-fsync yes
	  rdb-save-incremental-fsync yes
	  jemalloc-bg-thread yes
	|||;

	local default_tmp1 = std.strReplace(default, '<requirepass_replace_me>', app.password);
	local result = default_tmp1;

	result
