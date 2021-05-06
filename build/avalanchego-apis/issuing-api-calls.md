# 发布 API 调用

本指南解释了如何调用Avalanche节点公开的api。This guide explains how to make calls to APIs exposed by Avalanche nodes.

### 端点

对端点(URL)进行API调用, URL的基础总是:

`[node-ip]:[http-port]`

这里

* `node-ip`是调用所要访问的节点的IP地址。
* `http-port` 是节点监听HTTP调用的端口。这是由[command-line argument](../references/command-line-interface.md#http-server) `http-port`指定的\(默认值`9650`\)。

例如，基础URL可能是这样的: `127.0.0.1:9650`。    

每个API的文档都指定了用户应该调用的端点, 以访问API的方法，用户应该调用哪个端点。

## JSON RPC 格式化的 API

一些内置API使用[JSON RPC 2.0](https://www.jsonrpc.org/specification) 格式来描述它们的请求和响应, 这些API包括平台API和X链API。

### 创建JSON RPC请求

假设我们想调用[X-Chain API](exchange-chain-x-chain-api.md)的`getTxStatus`方法。X链API文档告诉我们，这个API的端点是`/ext/bc/X`。

这意味着我们发送API调用的端点是:

`[node-ip]:[http-port]/ext/bc/X`

X链API文档告诉我们，`getTxStatus`的签名是:

[`avm.getTxStatus`](exchange-chain-x-chain-api.md#avm-gettxstatus)`(txID:bytes) -> (status:string)`

在这里:

* 参数`txID`是我们正在获取状态的事务的ID。
* 返回值`status`是相关事务的状态。

要调用此方法，则:

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :4,
    "method" :"avm.getTxStatus",
    "params" :{
        "txID":"2QouvFWUbjuySRxeX5xMbNCuAaKWfbk5FeEa2JmoF85RKLk2dD"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

* `jsonrpc` 指定JSON RPC协议的版本。\(实际上总是2.0\)
* `method` 指定我们想要调用的服务\(`avm` \)和方法\(' getTxStatus ' \)。
specifies the service \(`avm`\) and method \(`getTxStatus`\) that we want to invoke.
* `params` specifies the arguments to the method.
* `id` is the ID of this request. Request IDs should be unique.

That’s it!

### JSON RPC Success Response

If the call is successful, the response will look like this:

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "Status":"Success"
    },
    "id": 1
}
```

* `id` is the ID of the request that this response corresponds to.
* `result` is the returned values of `getTxStatus`.

### JSON RPC Error Response

If the API method invoked returns an error then the response will have a field `error` in place of `result`. Additionally, there is an extra field, `data`, which holds additional information about the error that occurred.

Such a response would look like:

```cpp
{
    "jsonrpc": "2.0",
    "error": {
        "code": -32600,
        "message": "[Some error message here]",
        "data": [Object with additional information about the error]
    },
    "id": 1
}
```

## Other API Formats

Some APIs may use a standard other than JSON RPC 2.0 to format their requests and responses. Such extension should specify how to make calls and parse responses to them in their documentation.

## Sending and Receiving Bytes

Unless otherwise noted, when bytes are sent in an API call/response, they are in [CB58](https://support.avalabs.org/en/articles/4587395-what-is-cb58) representation, a base-58 encoding with a checksum

<!--stackedit_data:
eyJoaXN0b3J5IjpbNTQzMjAwMjA1LC0xNDU3NzIwMjQxLDE1MD
gwODAwNDEsLTU3NDU4OTE4Ml19
-->