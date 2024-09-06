local clusterParams = import '../../clusterParams.libsonnet';


function(app)
	local consoleDeployment = {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      name: app.name + '-rocketmq-console',
      labels: {app: app.name + '-rocketmq-console'},
    },
    spec: {
      replicas: 1,
      selector: {matchLabels: {app: app.name + '-rocketmq-console'}},
      template: {
        metadata: {
          labels: {app: app.name + '-rocketmq-console'},
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
									name: 'JAVA_OPTS',
									value: '-Drocketmq.namesrv.addr=%s-namesrv-0:9876;%s-namesrv-1:9876; -Dcom.rocketmq.sendMessageWithVIPChannel=false' % [ app.name, app.name]
								}
							],
              ports: [{name: 'console', port: 8080, containerPort: 8080}],
              resources: app.console.resources,
            }
          ],
        },
      },
    }
	};

	[consoleDeployment]
