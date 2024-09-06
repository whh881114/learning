local clusterParams = import '../../clusterParams.libsonnet';

{
	rocketmqVersion: '4.9.7',
  image: clusterParams.registry + '/docker.io/apache/rocketmq:' + rocketmqVersion,
  imagePullPolicy: 'IfNotPresent',

	nameSrv: {
		env: [
			{name: 'NODE_ROLE', value: 'nameserver'},
		],
		replicas: 2,
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

	broker: {
		env: [
			{name: 'NODE_ROLE', value: 'broker'},
		],
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

	brokerM1: {
		name: 'broker-m1',
		replicas: 1,
		configFile: 'brokerM1',
	},
	brokerS1: {
		name: 'broker-s1',
		replicas: 1,
		configFile: 'brokerS1',
	},
	brokerM2: {
		name: 'broker-m2',
		replicas: 1,
		configFile: 'brokerM2',
	},
	brokerS2: {
		name: 'broker-s2',
		replicas: 1,
		configFile: 'brokerS2',
	},
}

