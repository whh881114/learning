[
    {name: 'default',    namespace: self.name, path: self.name, project: 'default'},
    {name: 'kafka',      namespace: self.name, path: self.name, project: 'default'},
    {name: 'mysql',      namespace: self.name, path: self.name, project: 'default'},
    {name: 'redis',      namespace: self.name, path: self.name, project: 'default'},
    {name: 'rocketmq',   namespace: self.name, path: self.name, project: 'default'},
    {name: 'zookeeper',  namespace: self.name, path: self.name, project: 'default'},

    {name: 'cert-manager-issuers', namespace: 'cert-manager', path: self.name, project: 'default'},
    {name: 'argocd-ingress',       namespace: 'argocd',       path: 'argocd',  project: 'default'},

    {name: 'monitoring',           namespace: self.name,      path: self.name, project: 'default'},
    {name: 'thanos-ruler-rules',   namespace: 'monitoring',   path: self.name, project: 'default'},
]
