# IPC API

IPC API允许用户创建UNIX域套接字, 以便区块链发布到其中。当区块链接受一个顶点/块时，它将把这个顶点/块发布到一个套接字中，其中包含的决策将被发布到另一个套接字中。

一个节点只有在使用[command line argument](../references/command-line-interface.md) `api-ipcs-enabled=true`启动时才会公开这个API。

## IPC 消息格式

套接字消息由一个BigEndian格式的64位整数组成, 后面跟着非常duo字节。

Socket messages consist of a 64bit integer in BigEndian format followed by that many bytes.

示例:

```text
Sending:
    [0x41, 0x76, 0x61, 0x78]
Writes to the socket:
    [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x41, 0x76, 0x61, 0x78]
```

## IPC Socket URL Format

The names of the sockets are of the form `<network_id>-<chain_id>-<event_type>` where `<event_type>` is either `consensus` or `decisions`. The consensus socket receives verticies and blocks and while the decisions socket recives individual transactions.

## Format

This API uses the `json 2.0` RPC format.

## Endpoint

`/ext/ipcs`

## Methods

### ipcs.publishBlockchain

Register a blockchain so it publishes accepted vertices to a Unix domain socket.

#### **Signature**

```cpp
ipcs.publishBlockchain({blockchainID: string}) -> {consensusURL: string, decisionsURL: string}
```

* `blockchainID` is the blockchain that will publish accepted vertices.
* `consensusURL` is the path of the Unix domain socket the vertices are published to.
* `decisionsURL` is the path of the Unix domain socket the transactions are published to.

#### **Example Call**

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
eyJoaXN0b3J5IjpbLTIwNzA3NDg0NzIsLTE5MTI5NzA2MDUsLT
QxODY1MTM1MSwxOTAxOTM3Mzc1XX0=
-->