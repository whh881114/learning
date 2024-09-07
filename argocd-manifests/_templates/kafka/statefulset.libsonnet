local clusterParams = import '../../clusterParams.libsonnet';


function(app)
  // KAFKA_CONTROLLER_QUORUM_VOTERS: 1@controller-1:9093,2@controller-2:9093,3@controller-3:9093
  local KAFKA_CONTROLLER_QUORUM_VOTERS = [
    i + 1 + '@' + app.name + '-controller-%s:9093' % i
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
	        serviceName: app.name + '-controller-' + i,
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
	                  {name: 'CLUSTER_ID', value: app.clusterID},
	                  {name: 'KAFKA_NODE_ID', value: '%d' % [i + 1]},
	                  {name: 'KAFKA_CONTROLLER_QUORUM_VOTERS', value: std.join(",", KAFKA_CONTROLLER_QUORUM_VOTERS)},
	                  {name: 'KAFKA_LOG_DIRS', value: app.kafkaLogDirs},
	                ]
	                ,
	                ports: [{name: 'controller', port: 9093, containerPort: 9093}],
	                resources: app.controller.resources,
	                volumeMounts: [
	                  {name: 'data', mountPath: app.kafkaDataDirs},
	                  {name: 'logs', mountPath: app.kafkaLogDirs},
	                ],
	              },
	            ],
	            volumes: [
	              {name: 'data', persistentVolumeClaim: {claimName: 'data-' + app.name + '-controller-' + i}},
	              {name: 'logs', persistentVolumeClaim: {claimName: 'logs-' + app.name + '-controller-' + i}},
	            ],
	          },
	        },
	      },
	    }
	    for i in std.range(0, app.controller.replicas-1)
    ];

  local kafkaStatefulSet = [
	  {
	      apiVersion: 'apps/v1',
	      kind: 'StatefulSet',
	      metadata: {
	        name: app.name + '-kafka-' + i,
	        labels: {app: app.name + '-kafka-' + i},
	      },
	      spec: {
	        serviceName: app.name + '-kafka-' + i,
	        replicas: 1,
	        selector: {matchLabels: {app: app.name + '-kafka-' + i}},
	        template: {
	          metadata: {
	            labels: {app: app.name + '-kafka-' + i},
	          },
	          spec: {
	            imagePullSecrets: clusterParams.imagePullSecrets,
	            containers: [
	              {
	                name: 'kafka',
	                image: app.image,
	                imagePullPolicy: app.imagePullPolicy,
	                env: app.controller.env + [
                    {name: 'CLUSTER_ID', value: app.clusterID},
	                  {name: 'KAFKA_NODE_ID', value: '%d' % [i + app.controller.replicas + 1]},
	                  {name: 'KAFKA_CONTROLLER_QUORUM_VOTERS', value: std.join(",", KAFKA_CONTROLLER_QUORUM_VOTERS)},
	                  {name: 'KAFKA_ADVERTISED_LISTENERS', value: 'PLAINTEXT://%s-kafka-%d:9092,PLAINTEXT_HOST://localhost:9092' % [app.name, i]},
	                  {name: 'KAFKA_LOG_DIRS', value: app.kafkaLogDirs},
	                ]
	                ,
	                ports: [{name: 'kafka', port: 9092, containerPort: 9092}],
	                resources: app.kafka.resources,
	                volumeMounts: [
	                  {name: 'data', mountPath: app.kafkaDataDirs},
	                  {name: 'logs', mountPath: app.kafkaLogDirs},
	                ],
	              },
	            ],
	            volumes: [
	              {name: 'data', persistentVolumeClaim: {claimName: 'data-' + app.name + '-controller-' + i}},
	              {name: 'logs', persistentVolumeClaim: {claimName: 'logs-' + app.name + '-controller-' + i}},
	            ],
	          },
	        },
	      },
	    }
	    for i in std.range(0, app.controller.replicas-1)
    ];

    controllerStatefulSet + kafkaStatefulSet
