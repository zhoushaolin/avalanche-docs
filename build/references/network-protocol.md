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

**`RequestID`** 是一个计数器，用于帮助跟踪节点发送的消息。每当一个节点发送一条非提示消息时，该节点将为该消息创建一个新的惟一的`RequestID`。

**`ContainerID`** 被请求容器的标识符。

```text
[
    Length 32 Byte Array <- SubnetID
    UInt                 <- RequestID
    Length 32 Byte Array <- ContainerID
]
```

### 如何处理Get

节点应该用具有相同的`SubnetID`、`RequestID`和`ContainerID`的`Put`消息响应，并使用指定标识符的`Container`。在正确的情况下，应该只向节点请求它拥有的容器。因此，如果节点没有指定的容器，则可以安全地删除`Get`消息。

### Get什么时候发送

一个节点将发送一个`Get`消息给另一个节点，告诉我们容器的存在。例如，假设我们有两个节点: Rick和Morty, 如果Rick发送一个包含`ContainerID`的`PullQuery`消息，而Morty没有对应的容器，那么Morty将发送一个包含缺少的`ContainerID`的Get消息。

### Get 示例

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

### 概述

`Put`消息将请求的容器提供给节点。

`Put`消息使用的操作码是:`0x05`。

### Put 包含什么

`Put` 消息包含`SubnetID`, `RequestID`, `ContainerID`和`Container`。

**`SubnetID`** 定义此消息的目的地子网。

**`RequestID`** 是一个计数器，用于帮助跟踪节点发送的消息。

**`ContainerID`** 此消息正在发送的容器的标识符。

**`Container`** 是此消息正在发送的容器的字节。

```text
[
    Length 32 Byte Array       <- SubnetID
    UInt                       <- RequestID
    Length 32 Byte Array       <- ContainerID
    Variable Length Byte Array <- Container
]
```

### 如何处理Put

节点应该尝试将容器添加到一致性。

### Put什么时候发送
一个节点将发送一个`Put`消息来响应接收到的一个节点可以访问的容器的Get消息。

### Put 示例

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

### 概述

在指定的`ContainerID`被添加到consensus之后，`PushQuery` 消息从节点请求首选的ContainerID。如果`ContainerID`未知，则乐观地提供`Container`。

`PushQuery`消息使用的操作码是:`0x06`。

### PushQuery包含什么

`Put` 消息包含`SubnetID`, `RequestID`, `ContainerID`, 和`Container`。

**`SubnetID`** 定义此消息的目的地子网。

**`RequestID`** 是一个计数器，用于帮助跟踪节点发送的消息。

**`ContainerID`** 是此消息期望在发送响应之前已添加到共识的容器的标识符。

**`Container`** 是容器的标识符`ContainerID`的字节

```text
[
    Length 32 Byte Array       <- SubnetID
    UInt                       <- RequestID
    Length 32 Byte Array       <- ContainerID
    Variable Length Byte Array <- Container
]
```

### PushQuery是如何处理的

节点应该尝试将容器添加到一致性。在容器被添加到共识之后，一个`Chits`消息应该被发送，并带有节点的当前首选项。

### PushQuery什么时候发送

如果一个节点想要了解这个节点的当前首选项，并且认为该节点可能还没有了解到`Container`，那么它应该发送一个`PushQuery`消息。当节点了解到一个新的容器或它有“一段时间”挂起的容器时，它将希望了解节点首选项。

### PushQuery示例

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

### 概述

一个`PullQuery`消息在指定的`ContainerID`被添加到consensus之后从节点请求首选的ContainerID。

`PullQuery`消息使用的操作码是:`0x07`。

### PullQuery包含什么

 `Put` 消息包含`SubnetID`, `RequestID`和`ContainerID`。

**`SubnetID`** 定义此消息的目的地子网。

**`RequestID`** 是一个计数器，用于帮助跟踪节点发送的消息。

**`ContainerID`** 是此消息期望在发送响应之前已添加到共识的容器的标识符。

```text
[
    Length 32 Byte Array <- SubnetID
    UInt                 <- RequestID
    Length 32 Byte Array <- ContainerID
]
```

### 如何处理PullQuery

如果节点没有添加`ContainerID`，它应该尝试将容器添加到一致性。在容器被添加到共识之后，一个`Chits` 消息应该被发送，并带有节点的当前首选项。

### PullQuery什么时候发送

如果一个节点想要了解该节点当前的首选项，并且它认为该节点很可能已经了解了`Container`，那么它应该发送一个' PullQuery '消息。当节点了解到一个新的容器或它有“一段时间”挂起的容器时，它将希望了解节点首选项。A node should send a `PullQuery` message if it wants to learn of this node’s current preferences and it feels that it quite likely the node has already learned of `Container`. The node will want to learn of nodes preferences when it learns of a new container or it has had pending containers for “awhile”.

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
eyJoaXN0b3J5IjpbLTU4OTExNTI5Nyw2ODQ0NzI5MjAsNzU5OD
Q2OTIyLDE0OTExNTg1NTYsMzYzNjY0ODA5LDgwMDQ5NDg3OSwt
MjkzNzc1NTY2LC0xMDQwMzAzNzIxLC0yMDk4NzQ4MDMwLC0yMD
c3NzU2NTA3LDg4ODQ1NzkwOCwtMTU4NTA3NjU1OV19
-->