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
* `method` 指定我们想要调用的服务\(`avm` \)和方法\(`getTxStatus`\)。
* `params` 指定方法的参数。
* `id` 是此请求的ID, 请求的ID是唯一的。

就是这样!

### JSON RPC 成功响应

如果调用成功，响应将如下所示:

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "Status":"Success"
    },
    "id": 1
}
```

* `id`是此响应对应的请求的ID。
* `result` 是`getTxStatus`的返回值。

### JSON RPC 错误响应

如果调用的API方法返回一个错误，那么响应将有一个`error`字段代替`result`。此外，还有一个额外的字段`data`，它包含有关所发生错误的额外信息。

这样的反应看起来是这样的:

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

## 其他API 格式

一些API可能使用JSON RPC 2.0以外的标准来格式化它们的请求和响应。这样的扩展应该在文档中指定如何对它们进行调用和解析响应。

## 发送和接收字节

除非另有说明，当字节在API调用/响应中发送时，它们都是以[CB58](https://support.avalabs.org/en/articles/4587395-what-is-cb58) 表示的，这是一种带有校验和的base-58编码。


<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE2MDAxNjc1MTksLTE0NTc3MjAyNDEsMT
UwODA4MDA0MSwtNTc0NTg5MTgyXX0=
-->