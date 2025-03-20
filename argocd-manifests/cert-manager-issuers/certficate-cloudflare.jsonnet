local clusterParams = import '../clusterParams.libsonnet';

local namespaceApps = import '../indexApps.libsonnet';
local namespaceCharts = import '../indexCharts.libsonnet';

local namespace1 = [ app.namespace for app in  namespaceApps];
local namespace2 = [ app.namespace for app in  namespaceCharts];
local namespaces = std.uniq(std.sort(namespace1 + namespace2));


[
  {
    apiVersion: 'cert-manager.io/v1',
    kind: 'Certificate',
    metadata: {
      name: clusterParams.clusterIssuerName,
      namespace: namespace,
    },
    spec: {
      secretName: clusterParams.clusterIssuerName,
      issuerRef: {
        kind: 'ClusterIssuer',
        name: clusterParams.clusterIssuerName,
      },
      dnsNames: clusterParams.dnsZones
    }
  }

  for namespace in namespaces
]