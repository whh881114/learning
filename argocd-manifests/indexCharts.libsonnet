[
		{
      name: 'nfs-infra',
      version: '4.0.18',
      path:'/_charts/nfs-subdir-external-provisioner/' + self.version,
      namespace: 'storageclass',
      valueFiles: [
        'values-infra.yaml'
      ]
		},
		{
      name: 'nfs-mysql',
      version: '4.0.18',
      path:'/_charts/nfs-subdir-external-provisioner/' + self.version,
      namespace: 'storageclass',
      valueFiles: [
        'values-mysql.yaml'
      ]
		},
		{
      name: 'nfs-redis',
      version: '4.0.18',
      path:'/_charts/nfs-subdir-external-provisioner/' + self.version,
      namespace: 'storageclass',
      valueFiles: [
        'values-redis.yaml'
      ]
		},
		{
      name: 'ingress-nginx-wan',
      version: '4.12.0',
      path:'/_charts/ingress-nginx/' + self.version,
      namespace: 'ingress-nginx',
      valueFiles: [
        'values-wan.yaml'
      ]
		},
		{
      name: 'ingress-nginx-lan',
      version: '4.12.0',
      path:'/_charts/ingress-nginx/' + self.version,
      namespace: 'ingress-nginx',
      valueFiles: [
        'values-lan.yaml'
      ]
		},
		{
      name: 'istio-base',
      version: '1.23.0',
      path:'/_charts/istio/' + self.version + '/base',
      namespace: 'istio-system',
      valueFiles: [
        'values.yaml'
      ]
		},
		{
      name: 'istio-istiod',
      version: '1.23.0',
      path:'/_charts/istio/' + self.version + '/istiod',
      namespace: 'istio-system',
      valueFiles: [
        'values.yaml'
      ]
		},
		{
      name: 'istio-gateway-lan',
      version: '1.23.0',
      path:'/_charts/istio/' + self.version + '/gateway',
      namespace: 'istio-system',
      valueFiles: [
        'values-lan.yaml'
      ]
		},
    {
      name: 'istio-gateway-wan',
      version: '1.23.0',
      path:'/_charts/istio/' + self.version + '/gateway',
      namespace: 'istio-system',
      valueFiles: [
        'values-wan.yaml'
      ]
		},
]
