local basicAuthIndex = import './basicAuthIndex.libsonnet';
local authString = std.get(configmapIndex, app.name);

function(app)
  local basicAuth = {
    apiVersion: 'v1',
    kind: 'Secret',
    metadata: {
      name: 'baisc-auth-' + app.name,
    },
    data: {
      auth: std.base64(authString),
    },
    type: 'Opaque',
  };

  [basicAuth]
