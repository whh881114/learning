local clusterParams = import '../clusterParams.libsonnet';

{
  apiVersion: 'cert-manager.io/v1',
  kind: 'ClusterIssuer',
  metadata: {
    name: clusterParams.clusterIssuerName,
    namespace: 'cert-manager'
  },
  spec: {
    acme: {
      server: 'https://acme-v02.api.letsencrypt.org/directory',
      email: 'whh881114@gmail.com',
      privateKeySecretRef: {
        name: clusterParams.clusterIssuerName
      },
      solvers: [
        {
          selector: {
            dnsZones: clusterParams.dnsZones
          },
          dns01: {
            cloudflare: {
              apiTokenSecretRef: {
                name: clusterParams.apiTokenSecret,
                key: 'api-token'
              }
            }
          }
        }
      ]
    }
  }
}