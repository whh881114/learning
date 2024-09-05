local configmapIndex = import './configmapIndex.libsonnet';

function(app)
	local configmap = {
	  apiVersion: 'v1',
	  kind: 'ConfigMap',
	  metadata: {
	    name: app.name,
	    labels: {app: app.name},
	  },
	  data: {
	    'brokerM1.conf': std.get(configmapIndex, app.brokerM1.configFile),
	    'brokerS1.conf': std.get(configmapIndex, app.brokerS1.configFile),
	    'brokerM2.conf': std.get(configmapIndex, app.brokerM2.configFile),
	    'brokerS2.conf': std.get(configmapIndex, app.brokerS2.configFile),
	  }
	};

  configmap