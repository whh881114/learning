local minioBucketCapacity = import './minioBucketCapacity.libsonnet';


local prometheusRules = [] +
                        minioBucketCapacity;

local groups = {'groups': prometheusRules};

{
  apiVersion: 'v1',
  kind: 'ConfigMap',
  metadata: {
    name: 'thanos-ruler-rules',
  },
  data: {
    'ruler.yml': std.manifestYamlDoc(groups)
  }
}
