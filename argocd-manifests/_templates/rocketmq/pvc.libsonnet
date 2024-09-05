function(app)
	local pvcNameSrv = [
		{
		  apiVersion: 'v1',
		  kind: 'PersistentVolumeClaim',
		  metadata: {
		    name:  'data-' + app.name + '-namesrv-' + i,
		    labels: {app: 'data-' + app.name + '-namesrv-' + i},
		  },
	    spec: {
	      accessModes: ["ReadWriteOnce"],
	      resources: {
	        requests: { storage: app.nameSrv.storageClassCapacity },
	      },
	      storageClassName: app.nameSrv.storageClassName,
	    },
    }
    for i in std.range(0, app.nameSrv.replicas-1)
  ];

  local pvcBroker = [
		{
		  apiVersion: 'v1',
		  kind: 'PersistentVolumeClaim',
		  metadata: {
		    name:  'data-' + app.name + '-' + i,
		    labels: {app: 'data-' + app.name + '-' + i},
		  },
	    spec: {
	      accessModes: ["ReadWriteOnce"],
	      resources: {
	        requests: { storage: app.broker.storageClassCapacity },
	      },
	      storageClassName: app.broker.storageClassName,
	    },
    }
    for i in [app.brokerM1.name, app.brokerS1.name, app.brokerM2.name, app.brokerS2.name]
  ];

	pvcNameSrv + pvcBroker
