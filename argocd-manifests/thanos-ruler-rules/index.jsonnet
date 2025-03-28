local minioBucketCapacity = import './minioBucketCapacity.libsonnet';


local prometheusRules = [] +
                        minioBucketCapacity;

{
  apiVersion: 'v1',
  kind: 'ConfigMap',
  metadata: {
    name: 'thanos-ruler-rules',
  },
  data: {
    'ruler.yml': prometheusRules
  }
}
