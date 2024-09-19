# prometheus配置webhook告警


## prometheus配置alertmanager

### 默认配置内容
```yaml
alerting:
  alert_relabel_configs:
  - separator: ;
    regex: prometheus_replica
    replacement: $1
    action: labeldrop
  alertmanagers:
  - follow_redirects: true
    enable_http2: true
    scheme: http
    path_prefix: /
    timeout: 10s
    api_version: v2
    relabel_configs:
    - source_labels: [__meta_kubernetes_service_name]
      separator: ;
      regex: kube-prometheus-stack-alertmanager
      replacement: $1
      action: keep
    - source_labels: [__meta_kubernetes_endpoint_port_name]
      separator: ;
      regex: http-web
      replacement: $1
      action: keep
    kubernetes_sd_configs:
    - role: endpoints
      kubeconfig_file: ""
      follow_redirects: true
      enable_http2: true
      namespaces:
        own_namespace: false
        names:
        - monitoring
```

### alert_relabel_configs
```
alert_relabel_configs，是Prometheus中用于对发送给Alertmanager的告警信息进行重写和过滤的配置项。
它和relabel_configs类似，但专门用于处理告警（alerts）。通过这个配置项，你可以对告警的标签、接收方式等信息进行修改或过滤，
以便控制哪些告警最终会发送到Alertmanager，或者如何修改告警内容。
```

### alertmanagers
```
alertmanagers，是配置Alertmanager服务器参数，此时没有使用传统的static_configs配置，而是使用kubernetes_sd_configs和relabel_configs
结合，将重写出Alertmanager服务地址。
```


## prometheus配置告警规则
```yaml
rule_files:
- /etc/prometheus/rules/prometheus-kube-prometheus-stack-prometheus-rulefiles-0/*.yaml
```


## alertmanager配置告警通知渠道