# IPC API

IPC API允许用户创建UNIX域套接字, 以便区块链发布到其中。当区块链接受一个顶点/块时，它将把这个顶点/块发布到一个套接字中，其中包含的决策将被发布到另一个套接字中。

一个节点只有在使用[command line argument](../references/command-line-interface.md) `api-ipcs-enabled=true`启动时才会公开这个API。

## IPC 消息格式

套接字消息由一个BigEndian格式的64位整数组成, 后面跟着非常多字节。

示例:

```text
Sending:
    [0x41, 0x76, 0x61, 0x78]
Writes to the socket:
    [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x41, 0x76, 0x61, 0x78]
```

## IPC 套接字URL格式

套接字的名称形式为`<network_id>-<chain_id>-<event_type>`，其中`<event_type>`要么是`consensus`, 要么是`decisions`。共识套接字接收顶点和块，而决策套接字接收单个事务。

## 格式

这个API使用`json 2.0`  RPC格式。

## 端点

`/ext/ipcs`

## 方法

### ipcs.发布区块链

注册一个区块链，以便它接受的顶点发布到Unix域套接字。

#### **签名**

```cpp
ipcs.publishBlockchain({blockchainID: string}) -> {consensusURL: string, decisionsURL: string}
```

* `blockchainID` 是将发布接受的顶点的区块链。
* `consensusURL` 是发布顶点的Unix域套接字的路径。
* `decisionsURL` 是发布事务的Unix域套接字的路径。

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "ipcs.publishBlockchain",
    "params":{
        "blockchainID":"11111111111111111111111111111111LpoYY"
    },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/ipcs
```

#### **Example Response**

```cpp
{
    "jsonrpc":"2.0",
    "result":{
        "decisionsURL":"/tmp/1-11111111111111111111111111111111LpoYY-consensus",
        "consensusURL":"/tmp/1-11111111111111111111111111111111LpoYY-decisions"
    },
    "id":1
}
```

### ipcs.unpublishBlockchain

Deregister a blockchain so that it no longer publishes to a Unix domain socket.

#### **Signature**

```cpp
ipcs.unpublishBlockchain({blockchainID: string}) -> {success: bool}
```

* `blockchainID` is the blockchain that will no longer publish to a Unix domain socket.

#### **Example Call**

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "ipcs.unpublishBlockchain",
    "params":{
        "blockchainID":"11111111111111111111111111111111LpoYY"
    },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/ipcs
```

#### **Example Response**

```cpp
{
    "jsonrpc":"2.0",
    "result":{
        "success":true
    },
    "id":1
}
```

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTQzOTg2MTY0MSwxMjUwNDEyNTM0LC01Nj
E1NzQyMTcsLTE5MTI5NzA2MDUsLTQxODY1MTM1MSwxOTAxOTM3
Mzc1XX0=
-->