[
		{
      name: 'wan',
      chartName: 'ingress-nginx',
      chartVersion: '4.12.0',
      namespace: 'ingress-nginx',
      valueFiles: [
        'values-' + self.name + '.yaml'
      ]
		},
]
