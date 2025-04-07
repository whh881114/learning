# 安装kubernetes-dashboard

## 前言
- https://github.com/kubernetes/dashboard/releases/download/kubernetes-dashboard-7.5.0/kubernetes-dashboard-7.5.0.tgz

## 部署
- 部署方式由`ansible`转向`argocd`。

- 涉及修改的配置`argocd-manifests/_charts/kubernetes-dashboard/7.5.0/charts/metrics-server/values.yaml`。
  ```yaml
  image:
    repository: harbor.idc.roywong.work/registry.k8s.io/metrics-server/metrics-server
    tag: "0.7.1"
  replicas: 3
  resources:
    requests:
      cpu: 100m
      memory: 200Mi
    limits:
      cpu: 1
      memory: 1024Mi
  ```

- 涉及修改的配置`argocd-manifests/_charts/kubernetes-dashboard/7.5.0/values.yaml`。
  ```yaml
  app:
    ingress:
      enabled: true
      hosts:
        - kubernetes-dashboard.idc-ingress-nginx-lan.roywong.work
      ingressClassName: ingress-nginx-lan
      useDefaultIngressClass: false
      useDefaultAnnotations: false
      pathType: ImplementationSpecific
      path: /
      issuer:
        name: roywong-work-tls-cluster-issuer
        scope: cluster
      tls:
        enabled: true
        hosts:
          - "*.idc-ingress-nginx-lan.roywong.work"
        secretName: "roywong-work-tls-cert"
      labels: {}
      annotations:
        nginx.ingress.kubernetes.io/rewrite-target: /
        nginx.ingress.kubernetes.io/ssl-redirect: "true"
  
  auth:
    role: auth
    image:
      repository: harbor.idc.roywong.work/docker.io/kubernetesui/dashboard-auth
      tag: 1.1.3
    scaling:
      replicas: 3
  
  api:
    role: api
    image:
      repository: harbor.idc.roywong.work/docker.io/kubernetesui/dashboard-api
      tag: 1.7.0
    scaling:
      replicas: 3
  
  web:
    role: web
    image:
      repository: harbor.idc.roywong.work/docker.io/kubernetesui/dashboard-web
      tag: 1.4.0
    scaling:
      replicas: 3
  
  metricsScraper:
    enabled: true
    role: metrics-scraper
    image:
      repository: harbor.idc.roywong.work/docker.io/kubernetesui/dashboard-metrics-scraper
      tag: 1.1.1
    scaling:
      replicas: 3
  
  metrics-server:
    enabled: true
    args:
      - --kubelet-preferred-address-types=InternalIP
      - --kubelet-insecure-tls
  
  kong:
    enabled: true
    replicaCount: 3
    image:
      repository: harbor.idc.roywong.work/docker.io/library/kong
      tag: "3.6"
    env:
      dns_order: LAST,A,CNAME,AAAA,SRV
      plugins: 'off'
      nginx_worker_processes: 1
    ingressController:
      enabled: false
    dblessConfig:
      configMap: kong-dbless-config
    proxy:
      type: ClusterIP
      http:
        enabled: false
  
  cert-manager:
    enabled: false
    installCRDs: false
  ```

- 涉及修改的配置`_charts/kubernetes-dashboard/7.5.0/templates/networking/ingress.yaml`，指定`tls.hosts`，这样是为了兼容`letsencrypt`证书签发而不必每这个域名单独配置一个issuer。
  ```
  spec:
    {{- if not .Values.app.ingress.useDefaultIngressClass }}
    ingressClassName: {{ .Values.app.ingress.ingressClassName }}
    {{- end }}
    {{- if and .Values.app.ingress.tls.enabled .Values.app.ingress.tls.hosts }}
    tls:
      - hosts:
        {{- toYaml .Values.app.ingress.tls.hosts | nindent 6 }}
        {{- if .Values.app.ingress.tls.secretName }}
        secretName: {{ .Values.app.ingress.tls.secretName }}
        {{- else }}
        secretName: {{ template "kubernetes-dashboard.app.ingress.secret.name" . }}
        {{- end }}
    {{- end }}
  ```

## 访问kubernetes-dashboard
- 创建token，文档位于`argocd-manifests/rbac`目录下。