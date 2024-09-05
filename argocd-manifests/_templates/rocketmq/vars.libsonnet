local clusterParams = import '../../clusterParams.libsonnet';

local main = {
  storageClassName: 'infra',
  storageClassCapacity: '10Gi',

  image: clusterParams.registry + '/docker.io/apache/rocketmq:4.9.7',
  imagePullPolicy: 'IfNotPresent',

	nameSrv: {},
	broker: {},
};

local nameSrv = {
	nameSrv: {
		env: [
			{name: 'NODE_ROLE', value: 'nameserver'},
		],
		replicas: 3,
	  resources: {
	    requests: {
	      cpu: '1000m',
	      memory: '1Gi',
	    },
	    limits: {
	      cpu: '2000m',
	      memory: '4Gi',
	    }
	  },
  },
};

local borker = {
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
	broker: [
		{
			name: 'borker-m1',
			replicas: 1,
		},
		{
			name: 'borker-s1',
			replicas: 1,
		},
		{
			name: 'borker-m2',
			replicas: 1,
		},
		{
			name: 'borker-s2',
			replicas: 1,
		},
	]
};

main + nameSrv + borker


