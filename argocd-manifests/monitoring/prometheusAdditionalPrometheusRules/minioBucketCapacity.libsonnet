[
  {
    name: '自定义告警规则',
    interval: '5m',
    rules: [
      {
        expr: |||
          minio_cluster_usage_buckets_total_bytes{bucket="kubernetes-prometheus"}/1024/1024/1024 < 200
        |||,
        'for': '5m',
        labels: {severity: 'warning'},
        annotations: {
          summary: "High bucket capacity usage detected",
          description: "Instance kubernetes-prometheus has high bucket capacity usage for the last 2 minutes."
        },
        record: 'minio:BucketCapacity:kubernetes-prometheus',
      }
    ],
  },
]
