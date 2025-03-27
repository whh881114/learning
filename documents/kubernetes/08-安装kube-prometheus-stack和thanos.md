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


## grafana
- 配置文件：`argocd-manifests/_charts/kube-prometheus-stack/61.8.0/values.yaml`，修改内容如下：
  ```yaml
  # 全局变量修改
  namespaceOverride: "monitoring"
  kubeTargetVersionOverride: "1.30.3"
  crds:
    enabled: false
  global:
    imageRegistry: "harbor.idc.roywong.work"

  # grafana变量修改
  grafana:
    adminPassword: prom-operator    # 管理员admin默认密码
    ingress:
      enabled: true
      ingressClassName: ingress-nginx-lan
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

- **特别说明**：`crds.enabled=false`，部署时不安装`crds`。默认情况下是开启`crds`安装，即使在`prometheus`应用中添加同步参数
  `ApplyStrategy=create`，是可以将部分`crds`创建出来，但`create`逻辑只适合于初次创建，创建好后，还需要将此参数删除，之后就是
  `apply`逻辑了，也会报错。  
  **错误信息**：`The CustomResourceDefinition "***********" is invalid: metadata.annotations: Too long: must have at most 262144 bytes`  
  **个人解决方法**：将代码拉取到`kubernetes`集群的主机上，然后使用`kubectl create -f xxx.yaml`方法创建于`crds`资源。