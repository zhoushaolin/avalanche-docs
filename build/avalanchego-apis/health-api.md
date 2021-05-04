# 健康API

此API可用于测量节点运行状况。

要获取指示节点运行状况的HTTP状态码响应，请向`/ext/health`发出`GET`请求。如果节点是健康的，它将返回一个`200`状态码。如果需要关于节点运行状况的更深入信息，请使用以下方法。  

## 格式

这个API使用`json 2.0` RPC格式。有关JSON RPC调用的更多信息，请参见[这里](issuing-api-calls.md)。  
This API uses the。`json 2.0` RPC forma or more information on making JSON RPC calls, see [here](issuing-api-calls.md).

## Endpoint

```text
/ext/health
```

## Methods

### health.getLiveness

The node runs a set of health checks every 30 seconds, including a health check for each chain. This method returns the last set of health check results.

#### **Signature**

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

`healthy` is true if the node if all health checks are passing.

`checks` is a list of health check responses.

* A check response may include a `message` with additional context.
* A check response may include an `error` describing why the check failed.
* `timestamp` is the timestamp of the last health check.
* `duration` is the execution duration of the last health check, in nanoseconds.
* `contiguousFailures` is the number of times in a row this check failed.
* `timeOfFirstFailure` is the time this check first failed.

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
eyJoaXN0b3J5IjpbLTUwNTk3ODU0OV19
-->