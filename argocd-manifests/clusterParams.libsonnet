{
  registry: 'harbor.idc.roywong.work',
  ingressNginxDomainName: 'idc-ingress-nginx.roywong.work',
  ingressIstioDomainName: 'idc-ingress-istio.roywong.work',

  ingressNginxDomainNameTLS: 'tls-wildcard-idc-ingress-nginx-roywong-work',

  appRootDir: 'argocd-manifests',

  repo: {
    url: 'git@github.com:whh881114/learning.git',
    branch: 'master',
  },

  argocdNamespace: 'argocd',

  imagePullSecrets: [
    {name: "docker-credential-harbor-idc-roywong-work"},
  ],

  // cert-manager相关变量
  repoSecrets: {
    url: 'git@github.com:whh881114/argocd-manifests-secrets.git',
    branch: 'master',
  },

  clusterIssuerName: 'roywong-work-tls',

  dnsZones: [
    '*.idc-ingress-nginx-lan.roywong.work',
    '*.idc-ingress-nginx-wan.roywong.work',
    '*.idc-istio-gateway-lan.roywong.work',
    '*.idc-istio-gateway-wan.roywong.work',
  ],

  apiTokenSecret: 'cloudflare-api-token-secret',
}
