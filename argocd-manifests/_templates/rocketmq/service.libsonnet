function(app)
	local serviceClusterNameSrv = {
	  apiVersion: 'v1',
	  kind: 'Service',
	  metadata: {
	    name:  app.name + '-namesrv',
	    labels: {app: app.name + '-namesrv'},
	  },
    spec: {
      selector: {app: app.name + '-namesrv'},
      type: 'ClusterIP',
      ports: [
        {
		      name: 'namesrv',
		      port: 9876,
		      targetPort: 9876,
        },
        {
		      name: 'metrics',
		      port: 5557,
		      targetPort: 5557,
        },
      ],
    },
  };

  local serviceNodePortNameSrv = {
	  apiVersion: 'v1',
	  kind: 'Service',
	  metadata: {
	    name:  app.name + '-namesrv--nodeport',
	    labels: {app: app.name + '-namesrv-nodeport'},
	  },
    spec: {
      selector: {app: app.name + '-namesrv-nodeport'},
      type: 'NodePort',
      ports: [
        {
		      name: 'namesrv',
		      port: 9876,
		      targetPort: 9876,
        },
        {
		      name: 'metrics',
		      port: 5557,
		      targetPort: 5557,
        },
      ],
    },
  };

	local serviceClusterBroker = {
	  apiVersion: 'v1',
	  kind: 'Service',
	  metadata: {
	    name:  app.name + '-broker',
	    labels: {app: app.name + '-broker'},
	  },
    spec: {
      selector: {app: app.name + '-broker'},
      type: 'ClusterIP',
      ports: [
        //10909 端口
				//作用: 主要用于 Broker 之间的通信，特别是 Master 和 Slave 之间的同步。
				//用途:
				//数据同步: Master 节点将消息同步到 Slave 节点时，会使用这个端口。
				//心跳检测: Broker 节点之间会通过这个端口发送心跳包，监测彼此的状态。
        {
		      name: 'fast',
		      port: 10909,
		      targetPort: 10909,
        },
        //10911 端口
				//作用: 用于处理 Producer 发送的消息，以及 Consumer 拉取消息的请求。
				//用途:
				//消息发送: Producer 将消息发送到 Broker 时，会连接到这个端口。
				//消息消费: Consumer 从 Broker 拉取消息时，也会连接到这个端口。
        {
		      name: 'broker',
		      port: 10911,
		      targetPort: 10911,
        },
				//10912 端口
				//作用: 主要用于 Broker 的 VIP 通道，即 VIP Channel。
				//用途:
				//高可用: 在高可用场景下，当 Master 节点故障时，Slave 节点可以快速切换为 Master，继续提供服务。VIP 通道可以保证 Producer
				//       和 Consumer 无感知地切换到新的 Master 节点。
        {
		      name: 'ha',
		      port: 10911,
		      targetPort: 10911,
        },
      ],
    },
  };

  local serviceNodePortBroker = {
	  apiVersion: 'v1',
	  kind: 'Service',
	  metadata: {
	    name:  app.name + '-broker-nodeport',
	    labels: {app: app.name + '-broker-nodeport'},
	  },
    spec: {
      selector: {app: app.name + '-broker-nodeport'},
      type: 'NodePort',
      ports: [
        {
		      name: 'fast',
		      port: 10909,
		      targetPort: 10909,
        },
        {
		      name: 'broker',
		      port: 10911,
		      targetPort: 10911,
        },
        {
		      name: 'ha',
		      port: 10911,
		      targetPort: 10911,
        },
      ],
    },
  };

  [serviceClusterNameSrv, serviceNodePortNameSrv, serviceClusterBroker, serviceNodePortBroker]