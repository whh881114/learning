function(app)
	local serviceClusterController = [
		{
		  apiVersion: 'v1',
		  kind: 'Service',
		  metadata: {
		    name:  app.name + '-controller-' + i,
		    labels: {app: app.name + '-controller-' + i},
		  },
	    spec: {
	      selector: {app: app.name + '-controller-' + i},
	      type: 'ClusterIP',
	      ports: [
	        {
			      name: 'controller',
			      port: 9093,
			      targetPort: 9093,
	        },
	      ],
	    },
	  }
	  for i in std.range(0, app.controller.replicas-1)
  ];

  local serviceNodePortController = [
	  {
		  apiVersion: 'v1',
		  kind: 'Service',
		  metadata: {
		    name:  app.name + '-controller-' + i + '-nodeport',
		    labels: {app: app.name + '-controller-' + i + '-nodeport'},
		  },
	    spec: {
	      selector: {app: app.name + '-controller-' + i},
	      type: 'NodePort',
	      ports: [
	        {
			      name: 'controller',
			      port: 9093,
			      targetPort: 9093,
	        },
	      ],
	    },
	  }
    for i in std.range(0, app.controller.replicas-1)
  ];

	local serviceClusterKafka = [
		{
		  apiVersion: 'v1',
		  kind: 'Service',
		  metadata: {
		    name:  app.name + '-kafka-' + i,
		    labels: {app: app.name + '-kafka-' + i},
		  },
	    spec: {
	      selector: {app: app.name + '-kafka-' + i},
	      type: 'ClusterIP',
	      ports: [
	        {
			      name: 'kafka',
			      port: 9092,
			      targetPort: 9092,
	        },
	      ],
	    },
	  }
	  for i in std.range(0, app.kafka.replicas-1)
  ];

  local serviceNodePortKafka = [
	  {
		  apiVersion: 'v1',
		  kind: 'Service',
		  metadata: {
		    name:  app.name + '-kafka-' + i + '-nodeport',
		    labels: {app: app.name + '-kafka-' + i + '-nodeport'},
		  },
	    spec: {
	      selector: {app: app.name + '-kafka-' + i},
	      type: 'NodePort',
	      ports: [
	        {
			      name: 'kafka',
			      port: 9092,
			      targetPort: 9092,
	        },
	      ],
	    },
	  }
	  for i in std.range(0, app.kafka.replicas-1)
  ];



  serviceClusterController +
  serviceNodePortController +
  serviceClusterKafka +
  serviceNodePortKafka

