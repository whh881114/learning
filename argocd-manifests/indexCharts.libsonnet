[
		{
      name: 'ingress-nginx',
      version: '4.12.0',
      instance: 'wan',
      namespace: 'default',
      valueFiles: [
        'values-' + self.instance + '.yaml'
      ]
		},
    {
      name: 'ingress-nginx',
      version: '4.12.0',
      instance: 'lan',
      namespace: 'default',
      valueFiles: [
        'values-' + self.instance + '.yaml'
      ]
		},
]
