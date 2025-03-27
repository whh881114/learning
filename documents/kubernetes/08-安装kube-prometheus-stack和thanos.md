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
  global:
    imageRegistry: "harbor.idc.roywong.work"

  # grafana变量修改
  grafana:
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