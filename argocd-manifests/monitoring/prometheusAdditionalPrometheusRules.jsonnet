local minioBucketCapacity = import './prometheusAdditionalPrometheusRules/minioBucketCapacity.libsonnet';


local prometheusRules = [] +
                        minioBucketCapacity;

{
  apiVersion: 'monitoring.coreos.com/v1',
  kind: 'PrometheusRule',
  metadata: {
    name: 'additional-prometheus-rules',
  },
  spec: {
    groups: prometheusRules,
  }
}
