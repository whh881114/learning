local clusterParams = import '../../clusterParams.libsonnet';

{
  image: clusterParams.registry + '/docker.io/apache/kafka:3.8.0',
  imagePullPolicy: 'IfNotPresent',

  kafkaDataDirs: '/var/lib/kafka/data',
  kafkaLogDirs: '/tmp/kraft-combined-logs',

  controller: {
    env: [
      {name: 'KAFKA_PROCESS_ROLES',                             value: 'controller'},
      {name: 'KAFKA_INTER_BROKER_LISTENER_NAME',                value: 'PLAINTEXT'},
      {name: 'KAFKA_CONTROLLER_LISTENER_NAMES',                 value: 'CONTROLLER'},
      {name: 'KAFKA_LISTENERS',                                 value: 'CONTROLLER://:9093'},
      {name: 'KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR',          value: 1},
      {name: 'KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS',          value: 0},
      {name: 'KAFKA_TRANSACTION_STATE_LOG_MIN_ISR',             value: 1},
      {name: 'KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR',  value: 1},
    ],
    replicas: 3,
    resources: {
	    requests: {
	      cpu: '1000m',
	      memory: '2Gi',
	    },
	    limits: {
	      cpu: '2000m',
	      memory: '4Gi',
	    }
    },
    storageClassName: 'infra',
    dataStorageClassCapacity: '100Gi',
    logsStorageClassCapacity: '20Gi',
  },

  kafka: {
    env: [
      {name: 'KAFKA_PROCESS_ROLES',                             value: 'broker'},
      {name: 'KAFKA_LISTENERS',                                 value: 'PLAINTEXT://:9092,PLAINTEXT_HOST://:9092'},
      {name: 'KAFKA_LISTENER_SECURITY_PROTOCOL_MAP',            value: 'CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT'},
      {name: 'KAFKA_INTER_BROKER_LISTENER_NAME',                value: 'PLAINTEXT'},
      {name: 'KAFKA_CONTROLLER_LISTENER_NAMES',                 value: 'CONTROLLER'},
      {name: 'KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR',          value: 1},
      {name: 'KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS',          value: 0},
      {name: 'KAFKA_TRANSACTION_STATE_LOG_MIN_ISR',             value: 1},
      {name: 'KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR',  value: 1},
    ],
    replicas: 3,
    resources: {
	    requests: {
	      cpu: '2000m',
	      memory: '4Gi',
	    },
	    limits: {
	      cpu: '8000m',
	      memory: '16Gi',
	    }
    },
    storageClassName: 'infra',
    dataStorageClassCapacity: '100Gi',
    logsStorageClassCapacity: '20Gi',
  },
}
