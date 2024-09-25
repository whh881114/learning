# qywxbot项目说明


## 功能
- 将prometheus中的alertmanager发送的post数据进行一次解析再封装一次，将内容整理成符合企业微信机器人所需的格式，其中告警内容需要定制。


## 接口说明
- alertmanager发送的数据类型说明：https://prometheus.io/docs/alerting/latest/configuration/#webhook_config
- 企业微信机器人接口说明：https://developer.work.weixin.qq.com/document/path/90236

## 设计细节
- 程序启动时需要指定配置文件，例如：`qywxbot -c default.yaml -d robot_list`
- 告警内容规划：
    - 发送消息类型为`markdown`。
    - 消息状态为`firing`时，其字体颜色为红色。
    - 消息状态为`resolved`时，其字体颜色为蓝色。
    - 消息内容包含：消息状态和消息主体（引用alert实例中的annoations.description），告警内容固定成此模式。
    