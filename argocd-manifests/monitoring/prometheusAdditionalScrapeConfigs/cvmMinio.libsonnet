local staticConfigs = [
	{targets: ['minio-s3.idc.roywong.top']},
];

local metrics = [
	'api',
	'system',
	'debug',
	'cluster',
	'ilm',
	'audit',
	'logger',
	'replication',
	'notification',
	'scanner',
];

local jobs = [
  {
    job_name: 'cvm/minio/' + metric,
    metrics_path: '/minio/metrics/v3/' + metric,
    scheme: 'https',
    static_configs: staticConfigs
  }
  for metric in metrics
];

jobs