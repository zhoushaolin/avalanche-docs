# 网络协议

雪崩网络定义了雪崩节点之间的核心通信格式。它使用[原始序列化](serialization-primitives.md)格式进行负载打包。

`"Containers"`在说明书中被大量提及。容器只是块或顶点的通用术语，不需要指定一致算法是DAG还是Chain。

## GetVersion

`GetVersion`请求一个`Version`消息作为响应发送。

`GetVersion` 消息使用的操作码是: `0x00`.

### GetVersion包含什么

`GetVersion`消息的有效负载为空。 

```text
[]
```

### GetVersion是如何处理的

一个接收到`GetVersion` 消息的节点必须用包含当前时间和节点版本的`Version`消息进行响应。

### GetVersion什么时候发送

当一个节点连接到另一个节点，`GetVersion`被发送出来, 但还没有收到`Version`消息。那么, 它可能在任何时候重新发送。

## 版本

`Version`确保我们所连接的节点运行的是兼容版本的Avalanche，并且至少在当前时间上大致一致。

`Version`消息使用的操作码是:`0x01`。

### 版本包含什么

`Version`包含节点的当前时间(Unix时间格式，以1970年01月01日开始的毫秒数表示)，以及描述节点正在运行的代码版本的版本字符串。

当前:

```text
[
    Long   <- Unix Timestamp (Seconds)
    String <- Version String
]
```

### 如何处理版本

如果版本不兼容或当前时间相差太大，连接将被终止。

### 版本什么时候发送

`Version`是响应`GetVersion`消息发送的。

### 版本示例

发送时间`November 16th, 2008 at 12:00am (UTC)`和版本为`avalanche/0.0.1`的`Version`信息

```text
[
    Long   <- 1226793600 = 0x00000000491f6280
    String <- "avalanche/0.0.1"
]
=
[
    0x00, 0x00, 0x00, 0x00, 0x49, 0x1f, 0x62, 0x80,
    0x00, 0x0f, 0x61, 0x76, 0x61, 0x6c, 0x61, 0x6e,
    0x63, 0x68, 0x65, 0x2f, 0x30, 0x2e, 0x30, 0x2e,
    0x31,
]
```

## GetPeers

### 概述

`GetPeers` 请求将`Peers`消息作为响应发送。

`GetPeers` 消息使用的操作码是:`0x02`。

### GetPeers包含什么

`GetPeers`消息的有效负载为空。

```text
[]
```

### 如何处理GetPeers

一个接收`GetPeers`请求的节点必须响应一个`Peers` 消息，该消息包含其连接的、质押节点的IP地址。

### GetPeers什么时候发送

一个节点在启动时发送`GetPeers`消息来发现网络中的参与者。它也可能定期发送`GetPeers`消息，以便在新节点到达网络时发现它们。

## 对等体

### 概述

`Peers`消息包含以IP地址表示的对等体列表。注意, IP地址同时包含IP和端口号，支持IPv4和IPv6两种格式。

`Peers`消息使用的操作码是:`0x03`。

### 对等体包含什么

`Peers`包含该节点当前连接到的质押节点的IP地址。

内容:

```text
[
    Variable Length IP Address Array
]
```

### 如何处理对等点

在接收到`Peers`消息时，节点应该将消息中出现的节点与它自己的邻居列表进行比较，并与所有新节点建立连接。

### 对等点什么时候发送

`Peers`消息不需要响应`GetPeers`消息，而是定期发送，以宣布新到达的节点。这种推送八卦的默认时间是60秒。

### 对等体示例

发送一个`Peers`消息与IP地址`"127.0.0.1:9650"`和`"[2001:0db8:ac10:fe01::]:12345"`

```text
[
    Variable Length IP Address Array <- ["127.0.0.1:9650", "[2001:0db8:ac10:fe01::]:12345"]
]
=
[
    0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff,
    0x7f, 0x00, 0x00, 0x01, 0x25, 0xb2, 0x20, 0x01,
    0x0d, 0xb8, 0xac, 0x10, 0xfe, 0x01, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x30, 0x39,
]
```

## Get

### 概述

一个`Get`消息从一个节点请求一个容器，即块或顶点。

`Get`消息使用的操作码是:`0x04`。

### Get包含什么

`Get` 消息包含`SubnetID`, `RequestID`和`ContainerID`。

**`SubnetID`** 定义此消息的目的地子网。

**`RequestID`** is a counter that helps keep track of the messages sent by a node. Each time a node sends an un-prompted message, the node will create a new unique `RequestID` for the message.

**`ContainerID`** is the identifier of the requested container.

```text
[
    Length 32 Byte Array <- SubnetID
    UInt                 <- RequestID
    Length 32 Byte Array <- ContainerID
]
```

### How Get is handled

The node should reply with a `Put` message with the same `SubnetID`, `RequestID`, and `ContainerID` along with the `Container` with the specified identifier. Under correct situations, a node should only be asked for a container that it has. Therefore, if the node does not have the specified container, the `Get` message can safely be dropped.

### When Get is sent

A node will send a `Get` message to a node that tells us about the existence of a container. For example, suppose we have two nodes: Rick and Morty. If Rick sends a `PullQuery` message that contains a `ContainerID`, that Morty doesn’t have the container for, then Morty will send a Get message containing the missing `ContainerID`.

### Get Example

```text
[
    SubnetID    <- 0x0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20
    RequestID   <- 43110 = 0x0000A866
    ContainerID <- 0x2122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f40
]
=
[
    0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08,
    0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10,
    0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18,
    0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f, 0x20,
    0x00, 0x00, 0xa8, 0x66, 0x21, 0x22, 0x23, 0x24,
    0x25, 0x26, 0x27, 0x28, 0x29, 0x2a, 0x2b, 0x2c,
    0x2d, 0x2e, 0x2f, 0x30, 0x31, 0x32, 0x33, 0x34,
    0x35, 0x36, 0x37, 0x38, 0x39, 0x3a, 0x3b, 0x3c,
    0x3d, 0x3e, 0x3f, 0x40,
]
```

## Put

### Overview

A `Put` message provides a requested container to a node.

The OpCode used by `Put` messages is: `0x05`.

### What Put contains

A `Put` message contains a `SubnetID`, `RequestID`, `ContainerID`, and `Container`.

**`SubnetID`** defines which subnet this message is destined for.

**`RequestID`** is a counter that helps keep track of the messages sent by a node.

**`ContainerID`** is the identifier of the container this message is sending.

**`Container`** is the bytes of the container this message is sending.

```text
[
    Length 32 Byte Array       <- SubnetID
    UInt                       <- RequestID
    Length 32 Byte Array       <- ContainerID
    Variable Length Byte Array <- Container
]
```

### How Put is handled

The node should attempt to add the container to consensus.

### When Put is sent

A node will send a `Put` message in response to receiving a Get message for a container the node has access to.

### Put Example

```text
[
    SubnetID    <- 0x0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20
    RequestID   <- 43110 = 0x0000A866
    ContainerID <- 0x5ba080dcf6861c94c24ec62bc09a3c8b0fdd4691ebf02491e0e921dd0c77206f
    Container   <- 0x2122232425
]
=
[
    0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08,
    0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10,
    0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18,
    0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f, 0x20,
    0x00, 0x00, 0xa8, 0x66, 0x5b, 0xa0, 0x80, 0xdc,
    0xf6, 0x86, 0x1c, 0x94, 0xc2, 0x4e, 0xc6, 0x2b,
    0xc0, 0x9a, 0x3c, 0x8b, 0x0f, 0xdd, 0x46, 0x91,
    0xeb, 0xf0, 0x24, 0x91, 0xe0, 0xe9, 0x21, 0xdd,
    0x0c, 0x77, 0x20, 0x6f, 0x00, 0x00, 0x00, 0x05,
    0x21, 0x22, 0x23, 0x24, 0x25,
]
```

## PushQuery

### Overview

A `PushQuery` message requests the preferred containerIDs from the node after the specified `ContainerID` has been added to consensus. If the `ContainerID` is not known, the `Container` is optimistically provided.

The OpCode used by `PushQuery` messages is: `0x06`.

### What PushQuery contains

A `Put` message contains a `SubnetID`, `RequestID`, `ContainerID`, and `Container`.

**`SubnetID`** defines which subnet this message is destined for.

**`RequestID`** is a counter that helps keep track of the messages sent by a node.

**`ContainerID`** is the identifier of the container this message expects to have been added to consensus before the response is sent.

**`Container`** is the bytes of the container with identifier `ContainerID`.

```text
[
    Length 32 Byte Array       <- SubnetID
    UInt                       <- RequestID
    Length 32 Byte Array       <- ContainerID
    Variable Length Byte Array <- Container
]
```

### How PushQuery is handled

The node should attempt to add the container to consensus. After the container is added to consensus, a `Chits` message should be sent with the current preference\(s\) of the node.

### When PushQuery is sent

A node should send a `PushQuery` message if it wants to learn of this node’s current preferences and it feels that it is possible the node hasn’t learned of `Container` yet. The node will want to learn of nodes preferences when it learns of a new container or it has had pending containers for “awhile”.

### PushQuery Example

```text
[
    SubnetID    <- 0x0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20
    RequestID   <- 43110 = 0x0000A866
    ContainerID <- 0x5ba080dcf6861c94c24ec62bc09a3c8b0fdd4691ebf02491e0e921dd0c77206f
    Container   <- 0x2122232425
]
=
[
    0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08,
    0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10,
    0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18,
    0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f, 0x20,
    0x00, 0x00, 0xa8, 0x66, 0x5b, 0xa0, 0x80, 0xdc,
    0xf6, 0x86, 0x1c, 0x94, 0xc2, 0x4e, 0xc6, 0x2b,
    0xc0, 0x9a, 0x3c, 0x8b, 0x0f, 0xdd, 0x46, 0x91,
    0xeb, 0xf0, 0x24, 0x91, 0xe0, 0xe9, 0x21, 0xdd,
    0x0c, 0x77, 0x20, 0x6f, 0x00, 0x00, 0x00, 0x05,
    0x21, 0x22, 0x23, 0x24, 0x25,
]
```

## PullQuery

### Overview

A `PullQuery` message requests the preferred containerIDs from the node after the specified `ContainerID` has been added to consensus.

The OpCode used by `PullQuery` messages is: `0x07`.

### What PullQuery contains

A `Put` message contains a `SubnetID`, `RequestID`, and `ContainerID`.

**`SubnetID`** defines which subnet this message is destined for.

**`RequestID`** is a counter that helps keep track of the messages sent by a node.

**`ContainerID`** is the identifier of the container this message expects to have been added to consensus before the response is sent.

```text
[
    Length 32 Byte Array <- SubnetID
    UInt                 <- RequestID
    Length 32 Byte Array <- ContainerID
]
```

### How PullQuery is handled

If the node hasn’t added `ContainerID`, it should attempt to add the container to consensus. After the container is added to consensus, a `Chits` message should be sent with the current preference\(s\) of the node.

### When PullQuery is sent

A node should send a `PullQuery` message if it wants to learn of this node’s current preferences and it feels that it quite likely the node has already learned of `Container`. The node will want to learn of nodes preferences when it learns of a new container or it has had pending containers for “awhile”.

### PullQuery Example

```text
[
    SubnetID    <- 0x0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20
    RequestID   <- 43110 = 0x0000A866
    ContainerID <- 0x5ba080dcf6861c94c24ec62bc09a3c8b0fdd4691ebf02491e0e921dd0c77206f
]
=
[
    0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08,
    0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10,
    0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18,
    0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f, 0x20,
    0x00, 0x00, 0xa8, 0x66, 0x5b, 0xa0, 0x80, 0xdc,
    0xf6, 0x86, 0x1c, 0x94, 0xc2, 0x4e, 0xc6, 0x2b,
    0xc0, 0x9a, 0x3c, 0x8b, 0x0f, 0xdd, 0x46, 0x91,
    0xeb, 0xf0, 0x24, 0x91, 0xe0, 0xe9, 0x21, 0xdd,
    0x0c, 0x77, 0x20, 0x6f,
]
```

## Chits

### Overview

A `Chits` message provides a requested set of preferred container\(s\) to a node.

The OpCode used by `Chits` messages is: `0x08`.

### What Chits contains

A `Chits` message contains a `SubnetID`, `RequestID`, and `Preferences`.

**`SubnetID`** defines which subnet this message is destined for.

**`RequestID`** is a counter that helps keep track of the messages sent by a node.

**`Preferences`** is the list of containerIDs that fully describe the node’s preferences.

```text
[
    Length 32 Byte Array                         <- SubnetID
    UInt                                         <- RequestID
    Variable Length (Length 32 Byte Array) Array <- Preferences
]
```

### How Chits is handled

The node should attempt to add any referenced containers to consensus. If the referenced containers can’t be added, the node can ignore the missing containers and apply the remaining chits to the poll. Once a poll is completed, container confidences should be updated appropriately.

### When Chits is sent

A node will send a `Chits` message in response to receiving a `PullQuery` or `PushQuery` message for a container the node has added to consensus.

### Chits Example

```text
[
    SubnetID    <- 0x0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20
    RequestID   <- 43110 = 0x0000A866
    Preferences <- [
        0x2122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f40,
        0x4142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f60,
    ]
]
=
[
        0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08,
        0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10,
        0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18,
        0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f, 0x20,
        0x00, 0x00, 0xa8, 0x66, 0x00, 0x00, 0x00, 0x02,
        0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28,
        0x29, 0x2a, 0x2b, 0x2c, 0x2d, 0x2e, 0x2f, 0x30,
        0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38,
        0x39, 0x3a, 0x3b, 0x3c, 0x3d, 0x3e, 0x3f, 0x40,
        0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48,
        0x49, 0x4a, 0x4b, 0x4c, 0x4d, 0x4e, 0x4f, 0x50,
        0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58,
        0x59, 0x5a, 0x5b, 0x5c, 0x5d, 0x5e, 0x5f, 0x60,
]
```

<!--stackedit_data:
eyJoaXN0b3J5IjpbNzU5ODQ2OTIyLDE0OTExNTg1NTYsMzYzNj
Y0ODA5LDgwMDQ5NDg3OSwtMjkzNzc1NTY2LC0xMDQwMzAzNzIx
LC0yMDk4NzQ4MDMwLC0yMDc3NzU2NTA3LDg4ODQ1NzkwOCwtMT
U4NTA3NjU1OV19
-->