# prometheus配置webhook告警

## prometheus配置alertmanager
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

## prometheus配置告警规则
```yaml
rule_files:
- /etc/prometheus/rules/prometheus-kube-prometheus-stack-prometheus-rulefiles-0/*.yaml
```


## alertmanager配置告警通知渠道