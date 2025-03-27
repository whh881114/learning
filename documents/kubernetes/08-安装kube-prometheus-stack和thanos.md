# 安装kube-prometheus-stack和thanos


## 参考资料
- https://prometheus.io/
- https://thanos.io/
- https://huisebug.github.io/2023/06/28/kube-prometheus-thanos/


##  前言
- 之前使用的是`kube-prometheus`，提供很多开箱即用的功能，非常适合萌新上手。但是，涉及到大规模集群时，收集的数据越来越多，  
  要涉及到很多自定义配置时，那么就不太适合了。此外，目前官方更新的进展也很慢了，写此文档时，`prometheus-operator/kube-prometheus`  
  最后的`release`时间是`2023/09/06（v0.13.0）`，与现在`（2024/08/12）`相差近11个月。

- 部署方式由`ansible`转向`argocd`。


## 配置全局变量
- 配置文件：`argocd-manifests/_charts/kube-prometheus-stack/61.8.0/values.yaml`，修改内容如下：
  ```yaml
  namespaceOverride: "monitoring"
  kubeTargetVersionOverride: "1.30.3"
  crds:
    enabled: false
  global:
    imageRegistry: "harbor.idc.roywong.work"
  ```
- **特别说明**：`crds.enabled=false`，部署时不安装`crds`。默认情况下是开启`crds`安装，即使在`prometheus`应用中添加同步参数
  `ApplyStrategy=create`，是可以将部分`crds`创建出来，但`create`逻辑只适合于初次创建，创建好后，还需要将此参数删除，之后就是
  `apply`逻辑了，也会报错。  
  **错误信息**：`The CustomResourceDefinition "***********" is invalid: metadata.annotations: Too long: must have at most 262144 bytes`  
  **个人解决方法**：将代码拉取到`kubernetes`集群的主机上，然后使用`kubectl create -f xxx.yaml`方法创建于`crds`资源。
  ```shell
  [root@master-1.k8s.freedom.org /data/learning/argocd-manifests/_charts/kube-prometheus-stack/61.8.0/charts/crds/crds 13:45]# 31> ls | xargs -n 1 kubectl create -f
  customresourcedefinition.apiextensions.k8s.io/alertmanagerconfigs.monitoring.coreos.com created
  customresourcedefinition.apiextensions.k8s.io/alertmanagers.monitoring.coreos.com created
  customresourcedefinition.apiextensions.k8s.io/podmonitors.monitoring.coreos.com created
  customresourcedefinition.apiextensions.k8s.io/probes.monitoring.coreos.com created
  customresourcedefinition.apiextensions.k8s.io/prometheusagents.monitoring.coreos.com created
  customresourcedefinition.apiextensions.k8s.io/prometheuses.monitoring.coreos.com created
  customresourcedefinition.apiextensions.k8s.io/prometheusrules.monitoring.coreos.com created
  customresourcedefinition.apiextensions.k8s.io/scrapeconfigs.monitoring.coreos.com created
  customresourcedefinition.apiextensions.k8s.io/servicemonitors.monitoring.coreos.com created
  customresourcedefinition.apiextensions.k8s.io/thanosrulers.monitoring.coreos.com created
  [root@master-1.k8s.freedom.org /data/learning/argocd-manifests/_charts/kube-prometheus-stack/61.8.0/charts/crds/crds 13:45]# 32> 
  
  [root@master-1.k8s.freedom.org /data/learning/argocd-manifests/_charts/kube-prometheus-stack/61.8.0/charts/crds/crds 14:32]# 3> ll
  总用量 3332
  -rw-r--r-- 1 root root 439093  3月 27 13:29 crd-alertmanagerconfigs.yaml
  -rw-r--r-- 1 root root 523281  3月 27 13:29 crd-alertmanagers.yaml
  -rw-r--r-- 1 root root  48118  3月 27 13:29 crd-podmonitors.yaml
  -rw-r--r-- 1 root root  46592  3月 27 13:29 crd-probes.yaml
  -rw-r--r-- 1 root root 626429  3月 27 13:29 crd-prometheusagents.yaml
  -rw-r--r-- 1 root root 736313  3月 27 13:29 crd-prometheuses.yaml
  -rw-r--r-- 1 root root   6624  3月 27 13:29 crd-prometheusrules.yaml
  -rw-r--r-- 1 root root 418557  3月 27 13:29 crd-scrapeconfigs.yaml
  -rw-r--r-- 1 root root  49299  3月 27 13:29 crd-servicemonitors.yaml
  -rw-r--r-- 1 root root 497408  3月 27 13:29 crd-thanosrulers.yaml
  [root@master-1.k8s.freedom.org /data/learning/argocd-manifests/_charts/kube-prometheus-stack/61.8.0/charts/crds/crds 14:32]# 4>
  ```

## 配置grafana
- 配置文件：`argocd-manifests/_charts/kube-prometheus-stack/61.8.0/values.yaml`，修改内容如下：
  ```yaml
  grafana:
    adminPassword: prom-operator    # 管理员admin默认密码
    ingress:
      enabled: true
      ingressClassName: ingress-nginx-lan
      annotations:
        cert-manager.io/cluster-issuer: roywong-work-tls-cluster-issuer
        nginx.ingress.kubernetes.io/rewrite-target: /
        nginx.ingress.kubernetes.io/ssl-redirect: "true"
      hosts:
        - "grafana.idc-ingress-nginx-lan.roywong.work"
      path: /
      tls:
        - secretName: roywong-work-tls-cert
          hosts:
            - "*.idc-ingress-nginx-lan.roywong.work"
    useStatefulSet: true
    persistence:
      enabled: true
      type: sts
      storageClassName: "infra"
      accessModes:
        - ReadWriteOnce
      size: 20Gi
      finalizers:
        - kubernetes.io/pvc-protection
  ```

- 配置文件：`argocd-manifests/_charts/kube-prometheus-stack/61.8.0/charts/grafana/values.yaml`，修改内容如下：
  ```yaml
  image:
    repository: docker.io/grafana/grafana
  initChownData:
    image:
      repository: docker.io/library/busybox
  sidecar:
    image:
      repository: quay.io/kiwigrid/k8s-sidecar
  ```


## 配置kube-state-metrics
- 配置文件`argocd-manifests/_charts/kube-prometheus-stack/61.8.0/charts/kube-state-metrics/values.yaml`，修改内容如下：
  ```yaml
  image:
    repository: registry.k8s.io/kube-state-metrics/kube-state-metrics
    tag: "v2.13.0"
  
  replicas: 3
  ```

## 配置prometheus-node-exporter
- 配置文件`argocd-manifests/_charts/kube-prometheus-stack/61.8.0/charts/prometheus-node-exporter/values.yaml`，修改内容如下：
  ```yaml
  image:
    repository: quay.io/prometheus/node-exporter
    tag: "v1.8.2"
  ```

## 配置prometheusOperator
- 配置文件`argocd-manifests/_charts/kube-prometheus-stack/61.8.0/values.yaml`，修改内容如下：
  ```yaml
  prometheusOperator:
    image:
      repository: quay.io/prometheus-operator/prometheus-operator
      tag: "v0.75.2"
    prometheusConfigReloader:
      image:
        repository: quay.io/prometheus-operator/prometheus-config-reloader
        tag: "v0.75.2"
    thanosImage:
      repository: quay.io/thanos/thanos
      tag: v0.36.0
  ```


## 配置prometheus
- 配置文件`argocd-manifests/_charts/kube-prometheus-stack/61.8.0/values.yaml`，修改内容如下：
```yaml
prometheus:
  thanosService:
    enabled: true
  thanosServiceMonitor:
    enabled: true
  prometheusSpec:
    image:
      repository: quay.io/prometheus/prometheus
      tag: v2.54.0
    replicas: 3
    retention: 30d    # 启用了thanos后，此参数没有任何作用了，因为thanos默认以2小时为间隔将本地数据写向thanos。
    storageSpec:
      volumeClaimTemplate:
        spec:
          storageClassName: infra
          accessModes: ["ReadWriteOnce"]
          resources:
            requests:
              storage: 300Gi
```

## 配置alertmanager
- 配置文件`argocd-manifests/_charts/kube-prometheus-stack/61.8.0/values.yaml`，修改内容如下：
```yaml
alertmanager:
  ingress:
    enabled: true
    ingressClassName: ingress-nginx-lan
    annotations:
      cert-manager.io/cluster-issuer: roywong-work-tls-cluster-issuer
      nginx.ingress.kubernetes.io/rewrite-target: /
      nginx.ingress.kubernetes.io/ssl-redirect: "true"
    hosts:
      - alertmanager.idc-ingress-nginx-lan.roywong.work
    paths:
     - /
    tls:
      - secretName: roywong-work-tls-cert
        hosts:
          - "*.idc-ingress-nginx-lan.roywong.work"
  alertmanagerSpec:
    image:
      repository: quay.io/prometheus/alertmanager
      tag: v0.27.0
    replicas: 3
    storage:
      volumeClaimTemplate:
        spec:
          storageClassName: infra
          accessModes: [ "ReadWriteOnce" ]
          resources:
            requests:
              storage: 1Gi
```