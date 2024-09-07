local clusterParams = import '../../clusterParams.libsonnet';

{
  image: clusterParams.registry + '/docker.io/apache/kafka:3.8.0',
  imagePullPolicy: 'IfNotPresent',

  crontoller: {
    env: [
      {name: 'KAFKA_PROCESS_ROLES',                     value: 'controller'},
      {name: 'KAFKA_LISTENERS',                         value: 'CONTROLLER://:9093'},
      {name: 'KAFKA_INTER_BROKER_LISTENER_NAME',        value: 'PLAINTEXT'},
      {name: 'KAFKA_CONTROLLER_LISTENER_NAMES',         value: 'CONTROLLER'},
      {name: 'KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS',  value: 0},
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
    storageClassCapacity: '20Gi',
  },

  broker: {
    env: [
      {name: 'KAFKA_PROCESS_ROLES',                     value: 'broker'},
      {name: 'KAFKA_LISTENERS',                         value: 'PLAINTEXT://:19092,PLAINTEXT_HOST://:9092'},
      {name: 'KAFKA_INTER_BROKER_LISTENER_NAME',        value: 'PLAINTEXT'},
      {name: 'KAFKA_CONTROLLER_LISTENER_NAMES',         value: 'CONTROLLER'},
      {name: 'KAFKA_LISTENER_SECURITY_PROTOCOL_MAP',    value: 'CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT'},
      {name: 'KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS',  value: 0},
    ],
    replicas: 3,
    resources: {
      requests: {
        cpu: '2000m',
        memory: '4Gi',
      },
      limits: {
        cpu: '4000m',
        memory: '8Gi',
      }
    },
    storageClassName: 'infra',
    storageClassCapacity: '100Gi',
  },
}

