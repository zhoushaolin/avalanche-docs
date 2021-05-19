# 管理员 API

此API可用于测试节点运行状况和调试。注意，出于安全原因，Admin API在默认情况下是禁用的。要运行启用了管理API的节点，请使用[command line argument](../references/command-line-interface.md) `--api-admin-enabled=true`。

## 格式

这个API使用`json 2.0` RPC格式。

## 端点

```text
/ext/admin
```

## API 方法

### admin.alias

为API端点分配别名，即API的另一个端点。原始端点仍然可以工作。此更改只影响此节点;其他节点并不知道这个别名。

#### **签名**

```text
admin.alias({endpoint:string, alias:string}) -> {success:bool}
```

* `endpoint` 是API的原始端点, `endpoint` 应该只包含`/ext/`后面的端点部分。
* 别名API现在可以在`ext/alias`处调用 。
* `alias` 最多512个字符。

#### **调用示例**

```text
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"admin.alias",
    "params": {
        "alias":"myAlias",
        "endpoint":"bc/X"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/admin
```

#### **响应示例**

```javascript
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "success":true
    }
}
```

现在，调用X- chain可以使用`/ext/bc/X`或者`/ext/myAlias`进行调用。

### admin.aliasChain

给区块链一个别名，可以在使用区块链ID的任何地方使用。

#### **签名**

```text
admin.aliasChain(
    {
        chain:string,
        alias:string
    }
) -> {success:bool}
```

* `chain` 是区块链的ID.
* `alias` 现在可以在使用区块链ID的地方使用(例如, 在API端点\)。

#### **调用示例**

```text
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"admin.aliasChain",
    "params": {
        "chain":"sV6o671RtkGBcno1FiaDbVcFv2sG5aVXMZYzKdP4VQAWmJQnM",
        "alias":"myBlockchainAlias"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/admin
```

#### **响应示例**

```javascript
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "success":true
    }
}
```

现在, 无需通过API调用`/ext/bc/sV6o671RtkGBcno1FiaDbVcFv2sG5aVXMZYzKdP4VQAWmJQnM`来与ID是`sV6o671RtkGBcno1FiaDbVcFv2sG5aVXMZYzKdP4VQAWmJQnM`的区块链进行交互, 可以直接调用`ext/bc/myBlockchainAlias`进行。

### 管理员获取链别名

返回链的别名。

#### **签名**

```text
admin.getChainAliases(
    {
        chain:string
    }
) -> {aliases:string[]}
```

* `chain` 是区块链的ID。

#### **调用示例**

```text
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"admin.getChainAliases",
    "params": {
        "chain":"sV6o671RtkGBcno1FiaDbVcFv2sG5aVXMZYzKdP4VQAWmJQnM"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/admin
```

#### **响应示例**

```javascript
{
    "jsonrpc": "2.0",
    "result": {
        "aliases": [
            "X",
            "avm",
            "2eNy1mUFdmaxXNj1eQHUe7Np4gju9sJsEtWQ4MX3ToiNKuADed"
        ]
    },
    "id": 1
}
```

### 管理员锁定配置文件

将互斥统计数据配置文件写入`lock.profile`。

#### **签名**

```text
admin.lockProfile() -> {success:bool}
```

#### **调用示例**

```text
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"admin.lockProfile",
    "params" :{}
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/admin
```

#### **响应示例**

```javascript
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "success":true
    }
}
```

### admin.memoryProfile

将内存配置文件写入`mem.profile`。

#### **签名**

```text
admin.memoryProfile() -> {success:bool}
```

#### **调用示例**

```text
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"admin.memoryProfile",
    "params" :{}
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/admin
```

#### **响应示例**

```javascript
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "success":true
    }
}
```

### 管理员开启CPU分析器

开始分析节点的CPU利用率。要停止，调用`admin.stopCPUProfiler`。在停止时，将配置文件写入`cpu.profile`。

#### **签名**

```text
admin.startCPUProfiler() -> {success:bool}
```

#### **调用示例**

```text
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"admin.startCPUProfiler",
    "params" :{}
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/admin
```

#### **响应示例**

```javascript
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "success":true
    }
}
```

### 管理员停止CPU分析器

停止之前启动的CPU配置文件。

#### **签名**

```text
admin.stopCPUProfiler() -> {success:bool}
```

#### **调用示例**

```text
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"admin.stopCPUProfiler"
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/admin
```

#### **响应示例**

```javascript
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "success":true
    }
}
```

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE4MTc2OTM2MCwxMTc1ODczNDUyLDEwND
A5NjY0ODAsLTIzMjA5NzE1NCwxODM3NzE2OTA5LC0xMTY0OTg1
NzQ4LDIwOTgyOTkxXX0=
-->