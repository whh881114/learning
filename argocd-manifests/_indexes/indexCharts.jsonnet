# https://argo-cd.readthedocs.io/en/stable/user-guide/application-specification/

local indexCharts = import '../indexCharts.libsonnet';
local clusterParams = import '../clusterParams.libsonnet';

[
  {
    apiVersion: 'argoproj.io/v1alpha1',
    kind: 'Application',
    metadata: {
      name: chart.name,
      namespace: clusterParams.argocdNamespace,
    },
    spec: {
      destination: {
        server: 'https://kubernetes.default.svc',
        namespace: chart.namespace,
      },
      project: 'default',
      source: {
        repoURL: clusterParams.repo.url,
        targetRevision: clusterParams.repo.branch,
        path: clusterParams.appRootDir + '/' + chart.path,
        helm: {
          valueFiles: chart.valueFiles
        }
      },
      syncPolicy: {
        syncOptions: [
          'CreateNamespace=true',
          'ApplyStrategy=create',
        ],
      },
    },
  }

  for chart in indexCharts
]