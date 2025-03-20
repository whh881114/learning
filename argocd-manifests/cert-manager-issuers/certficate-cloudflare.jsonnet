local clusterParams = import '../clusterParams.libsonnet';


{
  apiVersion: 'cert-manager.io/v1',
  kind: 'Certificate',
  metadata: {
    name: clusterParams.clusterIssuerName,
    namespace: clusterParams.certManagerNamespace,
  },
  spec: {
    secretName: clusterParams.clusterIssuerName + '-secret',
    issuerRef: {
      kind: 'ClusterIssuer',
      name: clusterParams.clusterIssuerName,
    },
    dnsNames: clusterParams.dnsZones
  }
}
