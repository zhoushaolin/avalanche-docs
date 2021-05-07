# API指标

该API允许客户端获取关于节点运行状况和性能的统计数据。
The API allows clients to get statistics about a node’s health and performance.

## Endpoint

```text
/ext/metrics
```

## Usage

To get the node metrics:

```cpp
curl -X POST 127.0.0.1:9650/ext/metrics
```

## Format

This API produces Prometheus compatible metrics. See [here](https://github.com/prometheus/docs/blob/master/content/docs/instrumenting/exposition_formats.md) for information on Prometheus’ formatting.

[Here](../tutorials/nodes-and-staking/setting-up-node-monitoring.md) is a tutorial that shows how to set up Prometheus and Grafana to monitor AvalancheGo node using the Metrics API.

<!--stackedit_data:
eyJoaXN0b3J5IjpbMTM1OTM1NDExN119
-->