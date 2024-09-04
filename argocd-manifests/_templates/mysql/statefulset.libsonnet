local clusterParams = import '../../clusterParams.libsonnet';


function(app)
  local mysqldExporterContainer = {
    name: 'mysqld-expoter',
    image: clusterParams.registry + '/docker.io/bitnami/mysqld-exporter:0.15.1',
    imagePullPolicy: app.imagePullPolicy,
	  env: [
	    { name: "MYSQLD_EXPORTER_PASSWORD", value: app.exporter.password }
	  ],
	  args: [
	    '--mysqld.username',
	    app.exporter.username,
	  ],
    ports: [{name: 'metrics', port: 9104, containerPort: 9104}],
  };

  local mysqlStatefulSet = {
      apiVersion: 'apps/v1',
      kind: 'StatefulSet',
      metadata: {
        name: app.name,
        labels: {app: app.name},
      },
      spec: {
        serviceName: app.name,
        replicas: app.replicas,
        selector: {matchLabels: {app: app.name}},
        template: {
          metadata: {
            labels: {app: app.name},
          },
          spec: {
            imagePullSecrets: clusterParams.imagePullSecrets,
            containers: [
              {
                name: 'mysql',
                image: app.image,
                imagePullPolicy: app.imagePullPolicy,
                env: [
                  {MYSQL_ROOT_PASSWORD: app.password},
                ] + app.env,
                ports: [{name: 'mysql', port: 3306, containerPort: 3306}],
                resources: app.resources,
                volumeMounts: [
//                  {name: 'conf', mountPath: '/etc/my.cnf', subPath: 'my.cnf', readOnly: true},
                  {name: 'data', mountPath: '/var/lib/mysql'},
                ],
              }, mysqldExporterContainer
            ],
            volumes: [
//              {name: 'conf', configMap: {name: app.name}},
              {name: 'data', persistentVolumeClaim: {claimName: 'data-' + app.name}},
            ],
          },
        },
      },
    };

  mysqlStatefulSet