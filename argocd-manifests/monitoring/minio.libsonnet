local staticConfigs = [
	{targets: ['minio-1.freedom.org:9000', 'minio-2.freedom.org:9000', 'minio-3.freedom.org:9000', 'minio-4.freedom.org:9000']},
];

local scrapeConfigsMinio = [
  {
    job_name: 'minio-job-api',
    metrics_path: '/minio/metrics/v3/api',
    scheme: 'http',
    static_configs: staticConfigs
  },
  {
    job_name: 'minio-job-system',
    metrics_path: '/minio/metrics/v3/system',
    scheme: 'http',
    static_configs: staticConfigs
  },
  {
    job_name: 'minio-job-debug',
    metrics_path: '/minio/metrics/v3/debug',
    scheme: 'http',
    static_configs: staticConfigs
  },
  {
    job_name: 'minio-job-cluster',
    metrics_path: '/minio/metrics/v3/cluster',
    scheme: 'http',
    static_configs: staticConfigs
  },
  {
    job_name: 'minio-job-ilm',
    metrics_path: '/minio/metrics/v3/ilm',
    scheme: 'http',
    static_configs: staticConfigs
  },
  {
    job_name: 'minio-job-audit',
    metrics_path: '/minio/metrics/v3/audit',
    scheme: 'http',
    static_configs: staticConfigs
  },
  {
    job_name: 'minio-job-logger',
    metrics_path: '/minio/metrics/v3/logger',
    scheme: 'http',
    static_configs: staticConfigs
  },
  {
    job_name: 'minio-job-replication',
    metrics_path: '/minio/metrics/v3/replication',
    scheme: 'http',
    static_configs: staticConfigs
  },
  {
    job_name: 'minio-job-notification',
    metrics_path: '/minio/metrics/v3/notification',
    scheme: 'http',
    static_configs: staticConfigs
  },
  {
    job_name: 'minio-job-scanner',
    metrics_path: '/minio/metrics/v3/scanner',
    scheme: 'http',
    static_configs: staticConfigs
  },
];

scrapeConfigsMinio