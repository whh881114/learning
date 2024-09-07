local clusterParams = import '../../clusterParams.libsonnet';


function(app)
	local consoleDeployment = {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      name: app.name + '-console',
      labels: {app: app.name + '-console'},
    },
    spec: {
      replicas: 1,
      selector: {matchLabels: {app: app.name + '-console'}},
      template: {
        metadata: {
          labels: {app: app.name + '-console'},
        },
        spec: {
          imagePullSecrets: clusterParams.imagePullSecrets,
          containers: [
            {
              name: 'console',
              image: app.console.image,
              imagePullPolicy: app.imagePullPolicy,
              env: [
								{
									name: 'KAFKA_BROKERS',
									value: 'default-broker-0:9092',
								}
							],
              ports: [{name: 'console', port: 8080, containerPort: 8080}],
              resources: app.console.resources,
              volumeMounts: [
                {name: 'localtime', mountPath: '/etc/localtime', readOnly: true},
              ],
            }
          ],
          volumes: [
            {name: 'localtime', hostPath: {path: '/etc/localtime', type: 'File'}},
          ],
        },
      },
    }
	};

	[consoleDeployment]
