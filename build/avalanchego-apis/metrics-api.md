# API指标

该API允许客户端获取关于节点运行状况和性能的统计数据。

## 端点

```text
/ext/metrics
```

## 惯例

要获取节点指标:

```cpp
curl -X POST 127.0.0.1:9650/ext/metrics
```

## 格式

这个API产生了Prometheus兼容的指标, 请参阅这里[here](https://github.com/prometheus/docs/blob/master/content/docs/instrumenting/exposition_formats.md) 以获悉有关Prometheus格式的信息。

(../tutorials/nodes-and-staking/setting-up-node-monitoring.md)是一个教程，展示了如何设置Prometheus和Grafana来使用Metrics API监视AvalancheGo节点。

[Here](../tutorials/nodes-and-staking/setting-up-node-monitoring.md) is a tutorial that shows how to set up Prometheus and Grafana to monitor AvalancheGo node using the Metrics API.

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTkyMjI3NTQzMV19
-->