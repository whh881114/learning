local global = import './global.libsonnet';
local route = import './route.libsonnet';
local inhibitRules = import './inhibitRules.libsonnet';
local receivers = import './receivers.libsonnet';


local mainConfigs = global + route + inhibitRules + receivers;
local encodedMainConfigs = std.base64(std.toString(mainConfigs));


{
  apiVersion: 'v1',
  kind: 'Secret',
  metadata: {
    name: 'alertmanager-configuration-customized',
  },
  type: 'Opaque',
  data: {
    'alertmanager.yaml': encodedMainConfigs,
  }
}