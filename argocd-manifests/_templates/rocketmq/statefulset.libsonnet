local clusterParams = import '../../clusterParams.libsonnet';


function(app)
  local rocketmqExporterContainer = {
    name: 'rocketmq-expoter',
    image: clusterParams.registry + '/docker.io/apache/rocketmq-exporter:0.0.2',
    imagePullPolicy: app.imagePullPolicy,
    ports: [{name: 'metrics', port: 5557, containerPort: 5557}],
  };

  local nameSrvStatefulSet = [
	  {
	      apiVersion: 'apps/v1',
	      kind: 'StatefulSet',
	      metadata: {
	        name: app.name + '-namesrv-' + i,
	        labels: {app: app.name + '-namesrv-' + i},
	      },
	      spec: {
	        serviceName: app.name,
	        replicas: 1,
	        selector: {matchLabels: {app: app.name + '-namesrv-' + i}},
	        template: {
	          metadata: {
	            labels: {app: app.name + '-namesrv-' + i},
	          },
	          spec: {
	            imagePullSecrets: clusterParams.imagePullSecrets,
	            containers: [
	              {
	                name: 'namesrv',
	                image: app.image,
	                imagePullPolicy: app.imagePullPolicy,
	                env: app.nameSrv.env,
	                ports: [{name: 'namesrv', port: 9876, containerPort: 9876}],
	                resources: app.nameSrv.resources,
	                volumeMounts: [
	                  {name: 'data', mountPath: '/home/rocketmq/store'},
	                  {name: 'logs', mountPath: '/home/rocketmq/logs'},
	                ],
	              }, rocketmqExporterContainer
	            ],
	            volumes: [
	              {name: 'data', persistentVolumeClaim: {claimName: 'data-' + app.name + '-namesrv-' + i}},
	              {name: 'logs', persistentVolumeClaim: {claimName: 'logs-' + app.name + '-namesrv-' + i}},
	            ],
	          },
	        },
	      },
	    }
	    for i in std.range(0, app.nameSrv.replicas-1)
    ];

  local brokerStatefulSet = [
    {
      apiVersion: 'apps/v1',
      kind: 'StatefulSet',
      metadata: {
        name: app.name + '-' + i,
        labels: {app: app.name + '-' + i},
      },
      spec: {
        serviceName: app.name + '-' + i,
        replicas: 1,
        selector: {matchLabels: {app: app.name + '-' + i}},
        template: {
          metadata: {
            labels: {app: app.name + '-' + i},
          },
          spec: {
            imagePullSecrets: clusterParams.imagePullSecrets,
            containers: [
              {
                name: 'broker',
                image: app.image,
                imagePullPolicy: app.imagePullPolicy,
                env: app.broker.env,
                ports: [
                  {name: 'fast',   port: 10909, containerPort: 10909},
                  {name: 'broker', port: 10911, containerPort: 10911},
                  {name: 'ha',     port: 10912, containerPort: 10912},
                ],
                resources: app.broker.resources,
                volumeMounts: [
	                  {name: 'data', mountPath: '/home/rocketmq/store'},
	                  {name: 'logs', mountPath: '/home/rocketmq/logs'},
                ],
              },
            ],
            volumes: [
	              {name: 'data', persistentVolumeClaim: {claimName: 'data-' + app.name + '-' + i}},
	              {name: 'logs', persistentVolumeClaim: {claimName: 'logs-' + app.name + '-' + i}},
            ],
          },
        },
      },
    }
    for i in [app.brokerM1.name, app.brokerS1.name, app.brokerM2.name, app.brokerS2.name]
  ];


  nameSrvStatefulSet + brokerStatefulSet
