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

现在，调用X- chain可以使用`/ext/bc/X`或者`/ext/myAlias`
调用' /ext/bc/X '，或者等价地调用' /ext/myAlias '。
Now, calls to the X-Chain can be made to either `/ext/bc/X` or, equivalently, to `/ext/myAlias`.

### admin.aliasChain

Give a blockchain an alias, a different name that can be used any place the blockchain’s ID is used.

#### **Signature**

```text
admin.aliasChain(
    {
        chain:string,
        alias:string
    }
) -> {success:bool}
```

* `chain` is the blockchain’s ID.
* `alias` can now be used in place of the blockchain’s ID \(in API endpoints, for example.\)

#### **Example Call**

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

#### **Example Response**

```javascript
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "success":true
    }
}
```

Now, instead of interacting with the blockchain whose ID is `sV6o671RtkGBcno1FiaDbVcFv2sG5aVXMZYzKdP4VQAWmJQnM` by making API calls to `/ext/bc/sV6o671RtkGBcno1FiaDbVcFv2sG5aVXMZYzKdP4VQAWmJQnM`, one can also make calls to `ext/bc/myBlockchainAlias`.

### admin.getChainAliases

Returns the aliases of the chain

#### **Signature**

```text
admin.getChainAliases(
    {
        chain:string
    }
) -> {aliases:string[]}
```

* `chain` is the blockchain’s ID.

#### **Example Call**

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

#### **Example Response**

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

### admin.lockProfile

Writes a profile of mutex statistics to `lock.profile`.

#### **Signature**

```text
admin.lockProfile() -> {success:bool}
```

#### **Example Call**

```text
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"admin.lockProfile",
    "params" :{}
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/admin
```

#### **Example Response**

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

Writes a memory profile of the to `mem.profile`.

#### **Signature**

```text
admin.memoryProfile() -> {success:bool}
```

#### **Example Call**

```text
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"admin.memoryProfile",
    "params" :{}
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/admin
```

#### **Example Response**

```javascript
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "success":true
    }
}
```

### admin.startCPUProfiler

Start profiling the CPU utilization of the node. To stop, call `admin.stopCPUProfiler`. On stop, writes the profile to `cpu.profile`.

#### **Signature**

```text
admin.startCPUProfiler() -> {success:bool}
```

#### **Example Call**

```text
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"admin.startCPUProfiler",
    "params" :{}
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/admin
```

#### **Example Response**

```javascript
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "success":true
    }
}
```

### admin.stopCPUProfiler

Stop the CPU profile that was previously started.

#### **Signature**

```text
admin.stopCPUProfiler() -> {success:bool}
```

#### **Example Call**

```text
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"admin.stopCPUProfiler"
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/admin
```

#### **Example Response**

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
eyJoaXN0b3J5IjpbLTg4OTc0NDk0MSwtMjMyMDk3MTU0LDE4Mz
c3MTY5MDksLTExNjQ5ODU3NDgsMjA5ODI5OTFdfQ==
-->