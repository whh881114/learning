# https://argo-cd.readthedocs.io/en/stable/user-guide/application-specification/

local indexApp = import '../indexApp.libsonnet';
local clusterParams = import '../clusterParams.libsonnet';

[
  {
    apiVersion: 'argoproj.io/v1alpha1',
    kind: 'Application',
    metadata: {
      name: name,
      namespace: clusterParams.argocdNamespace,
    },
    spec: {
      destination: {
        server: 'https://kubernetes.default.svc',
        namespace: name,
      },
      project: 'default',
      source: {
        path: clusterParams.appRootDir + '/' + name,
        directory: {
          jsonnet: {},
          recurse: true,
        },
        repoURL: clusterParams.repo.url,
        targetRevision: clusterParams.repo.branch,
      },
      syncPolicy: {
        syncOptions: [
          "CreateNamespace=true"
        ],
      },
    },
  }

  for name in indexApp
]
