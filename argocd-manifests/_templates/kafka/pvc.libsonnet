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

  local pvcBroker = [
		{
		  apiVersion: 'v1',
		  kind: 'PersistentVolumeClaim',
		  metadata: {
		    name:  type + '-' + app.name + '-broker-' + i,
		    labels: {app: type + '-' + app.name + '-broker-' + i},
		  },
	    spec: {
	      accessModes: ["ReadWriteOnce"],
	      resources:
		      if type == 'data' then
		        {requests: {storage: app.broker.dataStorageClassCapacity}}
			    else
						{requests: {storage: app.broker.logsStorageClassCapacity}},
	      storageClassName: app.broker.storageClassName,
	    },
    }
    for i in std.range(0, app.broker.replicas-1)
    for type in ['data', 'logs']
  ];

	pvcController + pvcBroker


