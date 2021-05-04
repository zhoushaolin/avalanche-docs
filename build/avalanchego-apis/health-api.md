# 健康API

此API可用于测量节点运行状况。

要获取指示节点运行状况的HTTP状态码响应，请向`/ext/health`发出`GET`请求。如果节点是健康的，它将返回一个`200`状态码。如果需要关于节点运行状况的更深入信息，请使用以下方法。  

## 格式

这个API使用`json 2.0` RPC格式。有关JSON RPC调用的更多信息，请参见这里[here](issuing-api-calls.md)。  

## 端点

```text
/ext/health
```

## 方法

### health.getLiveness

节点每30秒运行一组健康检查，包括对每个链的健康检查。此方法返回最后一组运行状况检查结果。

#### **签名**

```cpp
health.getLiveness() -> {
    checks: []{
        checkName: {
            message: JSON,
            error: JSON,
            timestamp: string,
            duration: int,
            contiguousFailures: int,
            timeOfFirstFailure: int
        }
    },
    healthy: bool
}
```

`healthy`显示为“true”, 如果节点的所有健康检查都通过。
`checks`是运行状况检查响应列表。

* 一个检查响应可能包含一个带有附加上下文的`message` 。
* 检查响应可能包含一个描述检查失败原因的`error` 。
* `timestamp` 是上次健康检查的时间戳。
* `duration` 上一次健康检查的执行时间，单位为纳秒。
* `contiguousFailures` 是连续检查失败的次数。
* `timeOfFirstFailure`是该检查第一次失败的时间。

More information on these measurements can be found in the documentation for the [go-sundheit](https://github.com/AppsFlyer/go-sundheit) library.

#### **Example Call**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"health.getLiveness"
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/health
```

#### **Example Response**

In this example response, the C-Chain’s health check is failing.

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "checks": {
            "C": {
                "message": null,
                "error": {
                    "message": "example error message"
                },
                "timestamp": "2020-10-14T14:04:20.57759662Z",
                "duration": 465253,
                "contiguousFailures": 50,
                "timeOfFirstFailure": "2020-10-14T13:16:10.576435413Z"
            },
            "P": {
                "message": {
                    "percentConnected": 0.9967694992864075
                },
                "timestamp": "2020-10-14T14:04:08.668743851Z",
                "duration": 433363830,
                "contiguousFailures": 0,
                "timeOfFirstFailure": null
            },
            "X": {
                "timestamp": "2020-10-14T14:04:20.3962705Z",
                "duration": 1853,
                "contiguousFailures": 0,
                "timeOfFirstFailure": null
            },
            "chains.default.bootstrapped": {
                "timestamp": "2020-10-14T14:04:04.238623814Z",
                "duration": 8075,
                "contiguousFailures": 0,
                "timeOfFirstFailure": null
            },
            "network.validators.heartbeat": {
                "message": {
                    "heartbeat": 1602684245
                },
                "timestamp": "2020-10-14T14:04:05.610007874Z",
                "duration": 6124,
                "contiguousFailures": 0,
                "timeOfFirstFailure": null
            }
        },
        "healthy": false
    },
    "id": 1
}
```

<!--stackedit_data:
eyJoaXN0b3J5IjpbMjExMDk2NDQyN119
-->