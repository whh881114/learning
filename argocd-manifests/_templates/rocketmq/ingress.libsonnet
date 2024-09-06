local clusterParams = import '../../clusterParams.libsonnet';

function(app)
  local ingress = {
    apiVersion: 'networking.k8s.io/v1',
    kind: 'Ingress',
    metadata: {
      annotations: {
        'nginx.ingress.kubernetes.io/ssl-redirect': 'true',
      },
      labels: {app: app.name},
      name: app.name,
    },
    spec: {
      ingressClassName: app.ingressClassName,
      rules: [
        {
          host: '%s-%s.idc-ingress-nginx.roywong.top' % [app.name, app.namespace],
          http: {
            paths: [
              {
                backend: {
                  service: {
                    name: app.name + '-rocketmq-console',
                    port: {
                      number: 8080,
                    },
                  },
                },
                path: '/',
                pathType: 'ImplementationSpecific',
              },
            ],
          },
        },
      ],
      tls: [
        {
          hosts: [
            '%s-%s.idc-ingress-nginx.roywong.top' % [app.name, app.namespace],
          ],
          'secretName': clusterParams.ingressNginxDomainNameTLS,
        }
      ]
    },
  };

  [ingress]