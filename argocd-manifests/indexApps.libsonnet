[
    {name: 'default',    namespace: self.name, path: self.name},
    {name: 'kafka',      namespace: self.name, path: self.name},
    // {name: 'monitoring', namespace: self.name, path: self.name},
    {name: 'mysql',      namespace: self.name, path: self.name},
    {name: 'redis',      namespace: self.name, path: self.name},
    {name: 'rocketmq',   namespace: self.name, path: self.name},
    {name: 'zookeeper',  namespace: self.name, path: self.name},

    {name: 'cert-manager-issuers', namespace: 'cert-manager', path: self.name},
    {name: 'argocd-ingress',       namespace: 'argocd',       path: 'argocd'},
    {name: 'thanos-ruler-rules',   namespace: 'monitoring',   path: 'monitoring'},
]
