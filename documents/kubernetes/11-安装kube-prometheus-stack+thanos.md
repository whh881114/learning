# 安装kube-prometheus-stack+thanos


## 参考资料
- https://prometheus.io/
- https://thanos.io/
- https://huisebug.github.io/2023/06/28/kube-prometheus-thanos/


##  前言
- 之前使用的是`kube-prometheus`，提供很多开箱即用的功能，非常适合萌新上手。但是，涉及到大规模集群时，收集的数据越来越多，  
  要涉及到很多自定义配置时，那么就不太适合了。此外，目前官方更新的进展也很慢了，写此文档时，`prometheus-operator/kube-prometheus`  
  最后的`release`时间是`2023/09/06（v0.13.0）`，与现在`（2024/08/12）`相差近11个月。

- **文中记录的配置，只涉及到重点配置，其余的修改请查看相对应的ansible角色。**

- **安装kube-prometheus-stack时，先把helm chart文件中涉及到的镜像全部push到本地镜像库，否则安装时就会报错。**

- **服务期望值：**

  - **第一阶段：**
    - 目标：
        - 不用开启prometheus的thanos sidecar容器。
        - 部署prometheus/alertmanager/grafana均为多实例，并且开启持久化。

    - 配置：
      - 各个监控对象是否存活。
          - kubeDns.enabled=false，默认情况下使用的是CoreDns。

          - serviceMonitor/monitoring/kube-prometheus-stack-kube-controller-manager/0 (3/3 up)
            - 修改对象：所有master节点。
            - 配置文件`/etc/kubernetes/manifests/kube-controller-manager.yaml`，将`--bind-address=127.0.0.1`修改为
              `--bind-address=0.0.0.0`。
            
          - serviceMonitor/monitoring/kube-prometheus-stack-kube-etcd/0 (3/3 up)
            - 修改对象：所有master节点。
            - 配置文件`/etc/kubernetes/manifests/etcd.yaml`，将`--listen-metrics-urls=http://127.0.0.1:2381`修改为
              `--listen-metrics-urls=http://0.0.0.0:2381`。   
              
          - serviceMonitor/monitoring/kube-prometheus-stack-kube-scheduler/0 (3/3 up)
            - 修改对象：所有master节点。
            - 配置文件`/etc/kubernetes/manifests/kube-scheduler.yaml`，将`--bind-address=127.0.0.1`修改为
              `--bind-address=0.0.0.0`。  
              
          - serviceMonitor/monitoring/kube-prometheus-stack-kube-proxy/0 (6/6 up)
            - 修改对象：集群配置文件`kube-proxy.kube-system`。
            - 将配置文件中的`metricsBindAddress: ""`修改为`metricsBindAddress: "0.0.0.0:10249"`。  
            - 重启daemonset，`kubectl rollout restart daemonset kube-proxy -n kube-system`。  
              
    - 验证：
      - 持久化验证，删除kube-prometheus-stack，`helm uninstall kube-prometheus-stack -n monitoring`，查看pvc是否存在即可。

  - **第二阶段：**
    - 目标：
      - 在第一阶段的基础上，对prometheus配置thanos sidecar容器。thanos会将prometheus本地的监控数据写入到cos中，并不提供其他功能。
    
    - 配置：
      - 配置`prometheus.prometheusSpec.retention`为2h，本地只保留2小时数据，所以查询时只会有2小时的数据。
      - 启用`prometheus.prometheusSpec.thanos`配置，配置`objectStorageConfig`，文档地址：https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#thanosspec。
        ```yaml
        objectStorageConfig:
          secret:
            type: S3
            config:
              bucket: "[[ s3_bucket ]]"
              endpoint: "[[ s3_endpoint ]]"
              access_key: "[[ s3_access_key ]]"
              secret_key: "[[ s3_secret_key ]]"
        # BlockDuration controls the size of TSDB blocks produced by Prometheus.
        # The default value is 2h to match the upstream Prometheus defaults.
        blockSize: 1h
        ```

    - 验证：
      - 查看prometheus容器，是否存在thanos sidecar。
      - 在prometheus管理界面上查询指标是否只会显示两小时的数据，查询语句示例：`avg by (node) ( container_memory_working_set_bytes{pod=~".*kube-proxy.*"} )`。
      - 在minio管理界面上查看`kubernetes-prometheus`桶是否有数据写入，新旧数据之前的时间间隔是否相差1小时。

  - **第三阶段：**
    - 目标：
      - 安装thanos，启用compactor，query，query-frontend和storegateway组件即可，各组件启用多副本。
      - grafana查询数据时，其结果能显示超过2小时的数据。
  
    - 配置：
      - 恢复第二阶段的配置：`prometheus.prometheusSpec.retention=7d`，删除`prometheus.prometheusSpec.thanos.blockSize`。
      - 修改kube-prometheus-stack的配置文件：`grafana.sidecar.datasources.url=http://thanos-query-frontend:9090/`
      - 修改thanos的配置文件：`query.extraFlags=[--endpoint=dnssrv+_grpc._tcp.kube-prometheus-stack-thanos-discovery.monitoring.svc.cluster.local]`
  
    - 验证：
      - thanos各组件正常运行。
      - 在grafana终端上查询数据，查询语句示例：`avg by (node) ( container_memory_working_set_bytes{pod=~".*kube-proxy.*"} )`。
      - 在没有配置`query.extraFlags`参数之前，grafana配置prometheus数据源地址要为thanos-query-frontend组件地址，查询监控数据是会  
        缺少近两小时的数据，这是因为prometheus的thanos-sidecar是每隔两小时将prometheus的本地址写入到cos中。


## Thanos sidecar模式下各组件介绍
- sidecard
  - 和prometheus部署在一起，定期将prometheus的数据上传到对象存储中。

- query
  - 与prometheus管理界面相同功能，实现对多个prometheus进行聚合，同样是使用thnaos容器镜像，指定参数为query，并且指定endpoint使用
    grpc协议向底层组件(边车thanos-sidecar,存储thanos-store）获取数据。
  - 可以对监控数据自动去重。

- queryFrontend
  - 当查询的数据规模较大的时候，对query组件也会有很大的压力，queryFrontend组件来提升查询性能，queryFrontend组件连接对象是query。

- compactor
  - 将云存储中的数据进行压缩和下采样和保留。
  - 管理对象存储中的数据（管理、压缩、删除等）。

- store
  - sidecar将prometheus数据上传到了对象存储，需要进行查询就需要经过store的处理提供给query进行查询。
  - 并且store提供了缓存，加快查询速度的功能。

- ruler
  - 连接对象是query，经过query组件定期地获取指标数据，主要是prometheus的记录规则（record）和报警（alert）规则，
    其本身不会抓取metrics接口数据。
  - 可将记录规则（record）上传到对象存储中 。
  - 可连接alertmanager服务统一将告警信息发送至alertmanager。 
  - 建议：避免alertmanager服务告警过于复杂，报警(alert)规则还是由各kubernetes集群prometheus进行处理。


## 安装结果
```shell
ok: [10.255.1.12] => {
    "msg": [
        [
            "release \"kube-prometheus-stack\" uninstalled",
            "NAME: kube-prometheus-stack",
            "LAST DEPLOYED: Mon Aug 12 11:19:13 2024",
            "NAMESPACE: monitoring",
            "STATUS: deployed",
            "REVISION: 1",
            "NOTES:",
            "kube-prometheus-stack has been installed. Check its status by running:",
            "  kubectl --namespace monitoring get pods -l \"release=kube-prometheus-stack\"",
            "",
            "Visit https://github.com/prometheus-operator/kube-prometheus for instructions on how to create & configure Alertmanager and Prometheus instances using the Operator."
        ],
        []
    ]
}
```

```shell
ok: [10.255.1.12] => {
    "msg": [
        [
            "release \"thanos\" uninstalled",
            "NAME: thanos",
            "LAST DEPLOYED: Tue Aug 13 11:46:48 2024",
            "NAMESPACE: monitoring",
            "STATUS: deployed",
            "REVISION: 1",
            "TEST SUITE: None",
            "NOTES:",
            "CHART NAME: thanos",
            "CHART VERSION: 15.7.19",
            "APP VERSION: 0.36.0",
            "",
            "** Please be patient while the chart is being deployed **",
            "",
            "Thanos chart was deployed enabling the following components:",
            "- Thanos Query",
            "- Thanos Compactor",
            "- Thanos Ruler",
            "- Thanos Store Gateway",
            "",
            "Thanos Query can be accessed through following DNS name from within your cluster:",
            "",
            "    thanos-query.monitoring.svc.cluster.local (port 9090)",
            "",
            "To access Thanos Query from outside the cluster execute the following commands:",
            "",
            "1. Get the Thanos Query URL and associate Thanos Query hostname to your cluster external IP:",
            "",
            "   export CLUSTER_IP=$(minikube ip) # On Minikube. Use: `kubectl cluster-info` on others K8s clusters",
            "   echo \"Thanos Query URL: https://query-http-thanos.idc-ingress-nginx.roywong.top/\"",
            "   echo \"$CLUSTER_IP  query-http-thanos.idc-ingress-nginx.roywong.top\" | sudo tee -a /etc/hosts",
            "",
            "2. Open a browser and access Thanos Query using the obtained URL.",
            "",
            "WARNING: There are \"resources\" sections in the chart not set. Using \"resourcesPreset\" is not recommended for production. For production installations, please set the following values according to your workload needs:",
            "  - compactor.resources",
            "  - query.resources",
            "  - queryFrontend.resources",
            "  - ruler.resources",
            "  - storegateway.resources",
            "+info https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/",
            "",
            "⚠ SECURITY WARNING: Original containers have been substituted. This Helm chart was designed, tested, and validated on multiple platforms using a specific set of Bitnami and Tanzu Application Catalog containers. Substituting other containers is likely to cause degraded security and performance, broken chart features, and missing environment variables.",
            "",
            "Substituted images detected:",
            "  - docker.io/docker.io/bitnami/thanos:0.36.0-debian-12-r1"
        ],
        []
    ]
}
```