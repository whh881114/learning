# 安装argo-cd


## 参考资料
- https://argo-cd.readthedocs.io/en/stable/
- https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd
- https://argo-cd.readthedocs.io/en/stable/operator-manual/architecture/
- https://github.com/DandyDeveloper/charts/blob/master/charts/redis-ha/values.yaml
- https://argo-cd.readthedocs.io/en/stable/operator-manual/high_availability/
- https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/
- https://github.com/bitnami-labs/sealed-secrets


## 前言
- 以高可用模式部署。
- 理解各个服务功能。
  ```
  argocd-application-controller:    The argocd-application-controller uses argocd-repo-server to get generated 
                                    manifests and Kubernetes API server to get the actual cluster state.
                                    
  argocd-repo-server:               The argocd-repo-server is responsible for cloning Git repository, keeping it 
                                    up to date and generating manifests using the appropriate tool.
                                    
  argocd-server:                    The argocd-server is stateless and probably the least likely to cause issues. 
                                    To ensure there is no downtime during upgrades, consider increasing the number 
                                    of replicas to 3 or more and repeat the number in the 
                                    ARGOCD_API_SERVER_REPLICAS environment variable.
                                    
  redis-ha-server:                  argocd-redis is pre-configured with the understanding of only three total 
                                    redis servers/sentinels.
                                    
  argocd-dex-server:                The argocd-dex-server uses an in-memory database, and two or more instances 
                                    would have inconsistent data. 
                                    
  argocd-applicationset-controller: The ApplicationSet controller adds Application automation and seeks to improve 
                                    multi-cluster support and cluster multitenant support within Argo CD.
                                    
  argocd-notifications-controller:  Argo CD Notifications continuously monitors Argo CD applications and provides 
                                    a flexible way to notify users about important changes in the application state. 
  ```



## 安装
- `values.yaml`文件内容不算复杂，配置起来还不算复杂，如果安装报错，根据错误信息再结合template进行排查即可。
- 启用`redis-ha`时，不需要再启用`haproxy`，这个配置项目是建议连接外部的`redis-cluster`。
- 启用`redis-ha`时，还需要配置`externalRedis.existingSecret="argocd-redis"`，如果此值为空，那么安装时会报错。
- 指定登录用户`admin`的密码，修改`config.secret.argocdServerAdminPassword`的值，设置方法`htpasswd -nbBC 10 "" $ARGO_PWD | tr -d ':\n' | sed 's/$2y/$2a/'`。


## 结果
```shell
ok: [10.255.1.12] => {
    "msg": [
        [
            "customresourcedefinition.apiextensions.k8s.io \"applications.argoproj.io\" deleted",
            "customresourcedefinition.apiextensions.k8s.io \"applicationsets.argoproj.io\" deleted",
            "customresourcedefinition.apiextensions.k8s.io \"appprojects.argoproj.io\" deleted",
            "NAME: argocd",
            "LAST DEPLOYED: Thu Aug 29 15:40:32 2024",
            "NAMESPACE: argocd",
            "STATUS: deployed",
            "REVISION: 1",
            "NOTES:",
            "In order to access the server UI you have the following options:",
            "",
            "1. kubectl port-forward service/argocd-server -n argocd 8080:443",
            "",
            "    and then open the browser on http://localhost:8080 and accept the certificate",
            "",
            "2. enable ingress in the values file `server.ingress.enabled` and either",
            "      - Add the annotation for ssl passthrough: https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/#option-1-ssl-passthrough",
            "      - Set the `configs.params.\"server.insecure\"` in the values file and terminate SSL at your ingress: https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/#option-2-multiple-ingress-objects-and-hosts",
            "",
            "",
            "After reaching the UI the first time you can login with username: admin and the random password generated during the installation. You can find the password by running:",
            "",
            "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 -d",
            "",
            "(You should delete the initial secret afterwards as suggested by the Getting Started Guide: https://argo-cd.readthedocs.io/en/stable/getting_started/#4-login-using-the-cli)"
        ],
        [
            "Error: uninstall: Release not loaded: argocd: release: not found"
        ]
    ]
}
```

```shell
[root@master-1.k8s.freedom.org ~ 15:47]# 1> kubectl get pods -o wide -n argocd
NAME                                                READY   STATUS    RESTARTS   AGE     IP             NODE                       NOMINATED NODE   READINESS GATES
argocd-application-controller-0                     1/1     Running   0          6m48s   10.251.3.58    worker-1.k8s.freedom.org   <none>           <none>
argocd-application-controller-1                     1/1     Running   0          6m36s   10.251.5.98    worker-3.k8s.freedom.org   <none>           <none>
argocd-application-controller-2                     1/1     Running   0          6m26s   10.251.4.197   worker-2.k8s.freedom.org   <none>           <none>
argocd-applicationset-controller-58f79b645f-8gfs8   1/1     Running   0          6m48s   10.251.5.49    worker-3.k8s.freedom.org   <none>           <none>
argocd-applicationset-controller-58f79b645f-gvdbr   1/1     Running   0          6m48s   10.251.3.69    worker-1.k8s.freedom.org   <none>           <none>
argocd-applicationset-controller-58f79b645f-pg6lr   1/1     Running   0          6m48s   10.251.4.119   worker-2.k8s.freedom.org   <none>           <none>
argocd-dex-server-68c8456c6c-6srth                  1/1     Running   0          6m48s   10.251.3.24    worker-1.k8s.freedom.org   <none>           <none>
argocd-notifications-controller-57d64dc894-nt57g    1/1     Running   0          6m48s   10.251.3.155   worker-1.k8s.freedom.org   <none>           <none>
argocd-redis-ha-server-0                            3/3     Running   0          6m48s   10.251.3.151   worker-1.k8s.freedom.org   <none>           <none>
argocd-redis-ha-server-1                            3/3     Running   0          5m31s   10.251.5.168   worker-3.k8s.freedom.org   <none>           <none>
argocd-redis-ha-server-2                            3/3     Running   0          4m16s   10.251.4.108   worker-2.k8s.freedom.org   <none>           <none>
argocd-repo-server-6bb75f6d8f-5k425                 1/1     Running   0          6m48s   10.251.3.204   worker-1.k8s.freedom.org   <none>           <none>
argocd-repo-server-6bb75f6d8f-95c8w                 1/1     Running   0          6m33s   10.251.5.222   worker-3.k8s.freedom.org   <none>           <none>
argocd-repo-server-6bb75f6d8f-prn7g                 1/1     Running   0          6m33s   10.251.4.105   worker-2.k8s.freedom.org   <none>           <none>
argocd-server-69cf54895f-8c8rz                      1/1     Running   0          6m33s   10.251.5.68    worker-3.k8s.freedom.org   <none>           <none>
argocd-server-69cf54895f-ddrwz                      1/1     Running   0          6m33s   10.251.4.225   worker-2.k8s.freedom.org   <none>           <none>
argocd-server-69cf54895f-v7zsr                      1/1     Running   0          6m48s   10.251.3.251   worker-1.k8s.freedom.org   <none>           <none>
[root@master-1.k8s.freedom.org ~ 15:47]# 2> 
```

## 登录
- 使用kubectl进行端口转发，其监听地址只能为本地回环地址，所以还需要结合socat进行再次转发。
```shell
kubectl port-forward service/argocd-server -n argocd 8080:443 &
socat TCP-LISTEN:8443,reuseaddr,fork TCP:127.0.0.1:8080
```