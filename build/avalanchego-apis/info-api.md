# 信息API

此API可用于访问节点的基本信息。

## 格式

这个API使用`json 2.0` RPC格式, 有关JSON RPC调用的更多信息，请参见这里[here](issuing-api-calls.md)。

## 端点

```text
/ext/info
```

## API 方法

### 信息获取区块链ID

给定区块链的别名，获取它的ID。\([详见`admin.aliasChain`](admin-api.md#admin-aliaschain)\)

#### **签名**

```cpp
info.getBlockchainID({alias:string}) -> {blockchainID:string}
```

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"info.getBlockchainID",
    "params": {
        "alias":"X"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/info
```

#### **响应示例Example Response**

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "blockchainID":"sV6o671RtkGBcno1FiaDbVcFv2sG5aVXMZYzKdP4VQAWmJQnM"
    }
}
```

### 获取网络ID

获取此节点参与的网络的ID。

#### **签名info.getNetworkID

Get the ID of the network this node is participating in.

#### **Signature**

```cpp
info.getNetworkID() -> {networkID:int}
```

#### **调用示例Example Call**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"info.getNetworkID"
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/info
```

#### **响应示例Example Response**

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "networkID":"2"
    }
}
```

### 获取网络名

获取此节点参与的网络的名称。

#### **签名info.getNetworkName

Get the name of the network this node is participating in.

#### **Signature**

```cpp
info.getNetworkName() -> {networkName:string}
```

#### **调用示例Example Call**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"info.getNetworkName"
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/info
```

#### **响应示例Example Response**

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "networkName":"local"
    }
}
```

### 获取节点ID

获取此节点的ID。

#### **签名info.getNodeID

Get the ID of this node.

#### **Signature**

```cpp
info.getNodeID() -> {nodeID: string}
```

#### **调用示例Example Call**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"info.getNodeID"
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/info
```

#### **响应示例Example Response**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "nodeID": "NodeID-5mb46qkSBj81k9g9e4VFjGGSbaaSLFRzD"
    },
    "id": 1
}
```

### 获取节点IP

获取此节点的IP。

#### **签名info.getNodeIP

Get the IP of this node.

#### **Signature**

```text
info.getNodeIP() -> {ip: string}
```

#### **调用示例Example Call**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"info.getNodeIP"
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/info
```

#### **响应示例Example Response**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "ip": "192.168.1.1:9651"
    },
    "id": 1
}
```

### 获取节点版本

获取此节点的版本。

#### **签名info.getNodeVersion

Get the version of this node.

#### **Signature**

```cpp
info.getNodeVersion() -> {version: string}
```

#### **调用示例Example Call**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"info.getNodeVersion"
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/info
```

#### **响应示例Example Response**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "version": "avalanche/1.1.0"
    },
    "id": 1
}
```

### 引导程序

检查给定链是否完成了引导。

#### **签名info.isBootstrapped

Check whether a given chain is done bootstrapping

#### **Signature**

```cpp
info.isBootstrapped({chain: string}) -> {isBootstrapped: bool}
```

`chain`是链的ID或别名。

#### **调用示例 is the ID or alias of a chain.

#### **Example Call**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"info.isBootstrapped",
    "params": {
        "chain":"X"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/info
```

#### **响应示例Example Response**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "isBootstrapped": true
    },
    "id": 1
}
```

### info.peers

获取对等连接的描述。

#### **签名Get a description of peer connections.

#### **Signature**

```cpp
info.peers() -> 
{
    numPeers: int,
    peers:[]{
        ip: string,
        publicIP: string,
        nodeID: string,
        version: string,
        lastSent: string,
        lastReceived: string
    }
}
```

#### **调用示例Example Call**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"info.peers"
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/info
```

#### **响应示例Example Response**

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "numPeers":3,
        "peers":[
          {
             "ip":"206.189.137.87:9651",
             "publicIP":"206.189.137.87:9651",
             "nodeID":"NodeID-8PYXX47kqLDe2wD4oPbvRRchcnSzMA4J4",
             "version":"avalanche/0.5.0",
             "lastSent":"2020-06-01T15:23:02Z",
             "lastReceived":"2020-06-01T15:22:57Z"
          },
          {
             "ip":"158.255.67.151:9651",
             "publicIP":"158.255.67.151:9651",
             "nodeID":"NodeID-C14fr1n8EYNKyDfYixJ3rxSAVqTY3a8BP",
             "version":"avalanche/0.5.0",
             "lastSent":"2020-06-01T15:23:02Z",
             "lastReceived":"2020-06-01T15:22:34Z"
          },
          {
             "ip":"83.42.13.44:9651",
             "publicIP":"83.42.13.44:9651",
             "nodeID":"NodeID-LPbcSMGJ4yocxYxvS2kBJ6umWeeFbctYZ",
             "version":"avalanche/0.5.0",
             "lastSent":"2020-06-01T15:23:02Z",
             "lastReceived":"2020-06-01T15:22:55Z"
          }
        ]
    }
}
```

###  获取Tx费用

获取网络费用。

#### **签名info.getTxFee

Get the fees of the network.

#### **Signature**

```cpp
info.getTxFee() -> 
{
    creationTxFee: uint64,
    txFee: uint64
}
```

* `creationTxFee`是在网络上创建资产的费用。
* `txFee`是在网络上进行交易的费用。

#### **调用示例 is the fee for creating assets on the network.
* `txFee` is the fee for making transactions on the network.

#### **Example Call**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"info.getTxFee"
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/info
```

#### **响应示例Example Response**

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "creationTxFee": "10000000",
        "txFee": "1000000"
    }
}
```

<!--stackedit_data:
eyJoaXN0b3J5IjpbMzI0NDEwNTU4LDEzODIyMTgxMTUsLTE2Mz
U5ODcyOTMsLTExMjQwOTIxNzEsLTE3NDE2MjA2OTMsMTk4MzY5
Mzg5OF19
-->