local scrapeConfigsCvmMinio = import './scrapeConfigsCvmMinio.libsonnet';
local scrapeConfigCvmMysqlZabbixMaster = import './scrapeConfigCvmMysqlZabbixMaster.libsonnet';


local scrapeConfigs = [] + scrapeConfigsCvmMinio +
                           scrapeConfigCvmMysqlZabbixMaster;


local encodedScrapeConfigs = std.base64(std.toString(scrapeConfigs));

{
  apiVersion: 'v1',
  kind: 'Secret',
  metadata: {
    name: 'additional-scrape-configs-secret',
  },
  type: 'Opaque',
  data: {
    'additional-scrape-configs.yaml': encodedScrapeConfigs,
  }
}
