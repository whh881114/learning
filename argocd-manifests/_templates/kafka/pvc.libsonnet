function(app)
	local pvcController = [
		{
		  apiVersion: 'v1',
		  kind: 'PersistentVolumeClaim',
		  metadata: {
		    name:  type + '-' + app.name + '-controller-' + i,
		    labels: {app: type + '-' + app.name + '-controller-' + i},
		  },
	    spec: {
	      accessModes: ["ReadWriteOnce"],
	      resources:
		      if type == 'data' then
		        {requests: {storage: app.controller.dataStorageClassCapacity}}
			    else
						{requests: {storage: app.controller.logsStorageClassCapacity}},
	      storageClassName: app.controller.storageClassName,
	    },
    }
    for i in std.range(0, app.controller.replicas-1)
    for type in ['data', 'logs']
  ];

  local pvcKafka = [
		{
		  apiVersion: 'v1',
		  kind: 'PersistentVolumeClaim',
		  metadata: {
		    name:  type + '-' + app.name + '-kafka-' + i,
		    labels: {app: type + '-' + app.name + '-kafka-' + i},
		  },
	    spec: {
	      accessModes: ["ReadWriteOnce"],
	      resources:
		      if type == 'data' then
		        {requests: {storage: app.kafka.dataStorageClassCapacity}}
			    else
						{requests: {storage: app.kafka.logsStorageClassCapacity}},
	      storageClassName: app.kafka.storageClassName,
	    },
    }
    for i in std.range(0, app.kafka.replicas-1)
    for type in ['data', 'logs']
  ];

	pvcController + pvcKafka


