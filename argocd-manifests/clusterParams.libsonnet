{
  registry: 'harbor.idc.roywong.top',
  ingressNginxDomainName: 'idc-ingress-nginx.roywong.top',
  ingressIstioDomainName: 'idc-ingress-istio.roywong.top',

  appRootDir: 'argocd-manifests',

  repo: {
    url: 'git@github.com:whh881114/learning.git',
    branch: 'master',
  },

  argocdNamespace: 'argocd',

  imagePullSecrets: [
    {name: "docker-credential-harbor-idc-roywong-top"},
  ],
}
