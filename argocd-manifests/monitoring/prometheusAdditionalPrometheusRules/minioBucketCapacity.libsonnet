[
  {
    name: 'minioBucketCapacityKubernetesPrometheus',
    interval: '5m',
    rules: [
      {
        expr: |||
          minio_cluster_usage_buckets_total_bytes{bucket="kubernetes-prometheus"}/1024/1024/1024 < 200
        |||,
        labels: {severity: 'warning'},
        record: 'minio::BucketCapacity::KubernetesPrometheus',
      }
    ],
  },
]
