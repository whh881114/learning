local clusterParams = import '../../clusterParams.libsonnet';

{
  image: clusterParams.registry + '/docker.io/apache/rocketmq:4.9.7',
  imagePullPolicy: 'IfNotPresent',

	nameSrv: {
		env: [
			{name: 'NODE_ROLE', value: 'nameserver'},
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
    storageClassCapacity: '100Gi',
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

