# 序列化原语

[Avalanche](../../#avalanche) 对所有内部数据使用简单、统一、简洁的表示。本文档描述了如何在Avalanche平台上编码基元类型。所有交易都是按照这些基本基元类型编码的。

## 字节

字节按原样打包到消息有效负载中。

示例:

```text
Packing:
    0x01
Results in:
    [0x01]
```

## 短消息

短消息以BigEndian格式打包到消息有效负载中。

示例:

```text
Packing:
    0x0102
Results in:
    [0x01, 0x02]
```

## 整数

整数是32位值，以BigEndian格式打包到消息有效负载中。

示例:

```text
Packing:
    0x01020304
Results in:
    [0x01, 0x02, 0x03, 0x04]
```

## 长整数

长整数是以BigEndian格式打包到消息有效负载中的64位值。

示例:

```text
Packing:
    0x0102030405060708
Results in:
    [0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08]
```

## IP 地址

IP地址表示为16字节的IPv6格式，端口作为短消息附加到消息有效负载中。IPv4地址以12字节的0x00s开头填充。

IPv4 示例:

```text
Packing:
    "127.0.0.1:9650"
Results in:
    [
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0xff, 0xff, 0x7f, 0x00, 0x00, 0x01,
        0x25, 0xb2,
    ]
```

IPv6 示例:

```text
Packing:
    "[2001:0db8:ac10:fe01::]:12345"
Results in:
    [
        0x20, 0x01, 0x0d, 0xb8, 0xac, 0x10, 0xfe, 0x01,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x30, 0x39,
    ]
```

## 固定长度的数组

固定长度的数组，其长度提前已知，并通过上下文，按顺序打包。

Byte array example:

```text
Packing:
    [0x01, 0x02]
Results in:
    [0x01, 0x02]
```

Integer array example:

```text
Packing:
    [0x03040506]
Results in:
    [0x03, 0x04, 0x05, 0x06]
```

## Variable Length Array

The length of the array is prefixed in Integer format, followed by the packing of the array contents in Fixed Length Array format.

Byte array example:

```text
Packing:
    [0x01, 0x02]
Results in:
    [0x00, 0x00, 0x00, 0x02, 0x01, 0x02]
```

Int array example:

```text
Packing:
    [0x03040506]
Results in:
    [0x00, 0x00, 0x00, 0x01, 0x03, 0x04, 0x05, 0x06]
```

## String

A String is packed similarly to a variable-length byte array. However, the length prefix is a short rather than an int. Strings are encoded in UTF-8 format.

Example:

```text
Packing:
    "Avax"
Results in:
    [0x00, 0x04, 0x41, 0x76, 0x61, 0x78]
```

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTk2MDE2MDgwN119
-->