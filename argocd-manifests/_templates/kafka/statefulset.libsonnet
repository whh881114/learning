local clusterParams = import '../../clusterParams.libsonnet';


function(app)
  // KAFKA_CONTROLLER_QUORUM_VOTERS: 1@controller-1:9093,2@controller-2:9093,3@controller-3:9093
  local KAFKA_CONTROLLER_QUORUM_VOTERS = [
    i + 1 + '@' + app.name + '-%s:9093' % i
    for i in std.range(0, app.controller.replicas-1)
  ];



  local controllerStatefulSet = [
	  {
	      apiVersion: 'apps/v1',
	      kind: 'StatefulSet',
	      metadata: {
	        name: app.name + '-controller-' + i,
	        labels: {app: app.name + '-controller-' + i},
	      },
	      spec: {
	        serviceName: app.name,
	        replicas: 1,
	        selector: {matchLabels: {app: app.name + '-controller-' + i}},
	        template: {
	          metadata: {
	            labels: {app: app.name + '-controller-' + i},
	          },
	          spec: {
	            imagePullSecrets: clusterParams.imagePullSecrets,
	            containers: [
	              {
	                name: 'controller',
	                image: app.image,
	                imagePullPolicy: app.imagePullPolicy,
	                env: app.controller.env + [
	                  {name: 'KAFKA_NODE_ID', value: i + 1},
	                  {name: 'KAFKA_CONTROLLER_QUORUM_VOTERS', value: std.join(",", KAFKA_CONTROLLER_QUORUM_VOTERS)},
	                ]
	                ,
	                ports: [{name: 'controller', port: 9302, containerPort: 9302}],
	                resources: app.controller.resources,
	                volumeMounts: [
	                  {name: 'data', mountPath: '/var/lib/kafka/data'},
	                ],
	              },
	            ],
	            volumes: [
	              {name: 'data', persistentVolumeClaim: {claimName: 'data-' + app.name + '-controller-' + i}},
	            ],
	          },
	        },
	      },
	    }
	    for i in std.range(0, app.controller.replicas-1)
    ];

  local brokerStatefulSet = [
	  {
	      apiVersion: 'apps/v1',
	      kind: 'StatefulSet',
	      metadata: {
	        name: app.name + '-broker-' + i,
	        labels: {app: app.name + '-broker-' + i},
	      },
	      spec: {
	        serviceName: app.name,
	        replicas: 1,
	        selector: {matchLabels: {app: app.name + '-broker-' + i}},
	        template: {
	          metadata: {
	            labels: {app: app.name + '-broker-' + i},
	          },
	          spec: {
	            imagePullSecrets: clusterParams.imagePullSecrets,
	            containers: [
	              {
	                name: 'controller',
	                image: app.image,
	                imagePullPolicy: app.imagePullPolicy,
	                env: app.controller.env + [
	                  {name: 'KAFKA_NODE_ID', value: i + app.controller.replicas + 1},
	                  {name: 'KAFKA_CONTROLLER_QUORUM_VOTERS', value: std.join(",", KAFKA_CONTROLLER_QUORUM_VOTERS)},
	                  {name: 'KAFKA_ADVERTISED_LISTENERS', value:  },
	                  //  KAFKA_ADVERTISED_LISTENERS: 'PLAINTEXT://broker-1:19092,PLAINTEXT_HOST://localhost:29092'
	                ]
	                ,
	                ports: [{name: 'controller', port: 9302, containerPort: 9302}],
	                resources: app.controller.resources,
	                volumeMounts: [
	                  {name: 'data', mountPath: '/var/lib/kafka/data'},
	                ],
	              },
	            ],
	            volumes: [
	              {name: 'data', persistentVolumeClaim: {claimName: 'data-' + app.name + '-controller-' + i}},
	            ],
	          },
	        },
	      },
	    }
	    for i in std.range(0, app.controller.replicas-1)
    ];
