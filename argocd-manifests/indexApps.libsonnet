[
    {name: 'default',    namespace: self.name, path: self.name, project: self.name},
    {name: 'kafka',      namespace: self.name, path: self.name, project: self.name},
    {name: 'mysql',      namespace: self.name, path: self.name, project: self.name},
    {name: 'redis',      namespace: self.name, path: self.name, project: self.name},
    {name: 'rocketmq',   namespace: self.name, path: self.name, project: self.name},
    {name: 'zookeeper',  namespace: self.name, path: self.name, project: self.name},

    {name: 'cert-manager-issuers', namespace: 'cert-manager', path: self.name, project: 'system'},
    {name: 'argocd-ingress',       namespace: 'argocd',       path: 'argocd',  project: 'system'},

    {name: 'monitoring',           namespace: self.name,      path: self.name, project: self.name},
    {name: 'thanos-ruler-rules',   namespace: 'monitoring',   path: self.name, project: 'monitoring'},
]
