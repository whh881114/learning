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
}
