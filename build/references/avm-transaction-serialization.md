# AVM 交易格式 

这个文件是我们如何在雪崩虚拟机(AVM)中序列化交易的唯一来源。 本文档使用[primitive serialization](serialization-primitives.md)格式进行打包，使用[secp256k1](cryptoic -primitives.md#secp256k1-addresses)格式进行加密用户标识。 


## 编解码器  ID

一些数据前面有一个编解码器ID \(unt16\)，它表示应该如何反序列化数据。 现在，唯一有效的编解码器ID是0 \(`0x00 0x00`\)。 

## 可传输的输出 

可传输输出用资产ID包装输出。 

### 可传输输出包含什么  

可传输的输出包含一个`AssetID`和一个[`Output`](avm-transaction-serialization.md#outputs)。 

* **`AssetID`** 是一个32字节数组，它定义了该输出引用的资产。
* **`Output`** 是一个输出, 定义如下[below](avm-transaction-serialization.md#outputs)。例如, 这个可以是一个[SECP256K1 传输输出](avm-transaction-serialization.md#secp256k1-transfer-output).

### Gantt 可传输输出规范 

```text
+----------+----------+-------------------------+
| 资产_id : [32]字节 |                32 字节 |
+----------+----------+-------------------------+
| 输出   : 输出   |       大小(输出) 字节 |
+----------+----------+-------------------------+
                      | 32 + 大小(输出) 字节 |
                      +-------------------------+
```

### Proto 可传输的输出规范 

```text
message TransferableOutput {
    bytes asset_id = 1; // 32 bytes
    Output output = 2;  // size(output)
}
```

### 可传输的输出示例

我们来进行一个可传输输出:

* `AssetID`: `0x000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f`
* `Output`: `"Example SECP256K1 Transfer Output from below"`

```text
[
    AssetID <- 0x000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f
    Output  <- 0x000000070000000000003039000000000000d431000000010000000251025c61fbcfc078f69334f834be6dd26d55a955c3344128e060128ede3523a24a461c8943ab0859,
]
=
[
    // assetID:
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
    0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
    0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
    0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
    // output:
    0x00, 0x00, 0x00, 0x07, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x30, 0x39, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0xd4, 0x31, 0x00, 0x00, 0x00, 0x01,
    0x00, 0x00, 0x00, 0x02, 0x51, 0x02, 0x5c, 0x61,
    0xfb, 0xcf, 0xc0, 0x78, 0xf6, 0x93, 0x34, 0xf8,
    0x34, 0xbe, 0x6d, 0xd2, 0x6d, 0x55, 0xa9, 0x55,
    0xc3, 0x34, 0x41, 0x28, 0xe0, 0x60, 0x12, 0x8e,
    0xde, 0x35, 0x23, 0xa2, 0x4a, 0x46, 0x1c, 0x89,
    0x43, 0xab, 0x08, 0x59,
]
```

## 可传输的输入 

可传输输入用一个提供的传输输入描述一个特定的UTXO。 

### 可传输输出包含什么  

一个可传输的输入包含`TxID`、`UTXOIndex`、 `AssetID`和一个`Input`。

* **`TxID`** 是一个32字节的数组，它定义了该输入从哪个交易中消费输出。
* **`UTXOIndex`** 是一个int，定义该输入在指定交易中使用哪个utxo。
* **`AssetID`** 是一个32字节数组，它定义了该输入引用的资产。
* **`Input`** 是输入，定义如下。 目前只能是[SECP256K1 transfer input](avm-transaction-serialization.md#secp256k1-transfer-input) 


### Gantt 可传输的输入规范 

```text
+------------+----------+------------------------+
| tx_id      : [32]字节 |               32 字节 |
+------------+----------+------------------------+
| utxo_index : int      |               04 字节 |
+------------+----------+------------------------+
| asset_id   : [32]字节 |               32 字节  |
+------------+----------+------------------------+
| 输入        : 输入     |      大小(输入) 字节 |
+------------+----------+------------------------+
                        | 68 + 大小(输入) 字节 |
                        +------------------------+
```

### Proto 可传输输入规范 

```text
message TransferableInput {
    bytes tx_id = 1;       // 32 bytes
    uint32 utxo_index = 2; // 04 bytes
    bytes asset_id = 3;    // 32 bytes
    Input input = 4;       // size(input)
}
```

### 可传输输入示例

我们来进行一个可传输输入:

* `TxID`: `0xf1e1d1c1b1a191817161514131211101f0e0d0c0b0a090807060504030201000`
* `UTXOIndex`: `5`
* `AssetID`: `0x000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f`
* `Input`: `"Example SECP256K1 Transfer Input from below"`

```text
[
    TxID      <- 0xf1e1d1c1b1a191817161514131211101f0e0d0c0b0a090807060504030201000
    UTXOIndex <- 0x00000005
    AssetID   <- 0x000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f
    Input     <- 0x0000000500000000075bcd15000000020000000700000003
]
=
[
    // txID:
    0xf1, 0xe1, 0xd1, 0xc1, 0xb1, 0xa1, 0x91, 0x81,
    0x71, 0x61, 0x51, 0x41, 0x31, 0x21, 0x11, 0x01,
    0xf0, 0xe0, 0xd0, 0xc0, 0xb0, 0xa0, 0x90, 0x80,
    0x70, 0x60, 0x50, 0x40, 0x30, 0x20, 0x10, 0x00,
    // utxoIndex:
    0x00, 0x00, 0x00, 0x05,
    // assetID:
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
    0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
    0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
    0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
    // input:
    0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00, 0x00,
    0x07, 0x5b, 0xcd, 0x15, 0x00, 0x00, 0x00, 0x02,
    0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x07
]
```

## 可传输 Op

可传输操作用一个提供的可传输操作描述了一组UTXO。 每个操作只能引用一个资产ID。 

### 可传输Op包含什么

一个可传输的操作包含`AssetID`， `UTXOIDs`和`TransferOp`。 

* **`AssetID`** 是一个32字节的数组，它定义了该操作更改的资产。
* **`UTXOIDs`** 是TxID-OutputIndex元组的数组, 这个数组必须按字典序排序。
* **`TransferOp`** 是[可转移的操作对象] (avm-transaction-serialization.md#operations)。

### Gantt 可转移的Op规范 

```text
+-------------+------------+------------------------------+
| asset_id    : [32]字节   |                     32 字节 |
+-------------+------------+------------------------------+
| utxo_ids    : []UTXOID   | 4 + 36 * len(utxo_ids) 字节 |
+-------------+------------+------------------------------+
| transfer_op : TransferOp |      大小(transfer_op) 字节 |
+-------------+------------+------------------------------+
                           |   36 + 36 * len(utxo_ids)    |
                           |    + 大小(transfer_op) 字节 |
                           +------------------------------+
```

### Proto 可转移的Op规范

```text
message UTXOID {
    bytes tx_id = 1;       // 32 bytes
    uint32 utxo_index = 2; // 04 bytes
}
message TransferableOp {
    bytes asset_id = 1;           // 32 bytes
    repeated UTXOID utxo_ids = 2; // 4 + 36 * len(utxo_ids) bytes
    TransferOp transfer_op = 3;   // size(transfer_op)
}
```

### 可转移的Op示例

我们来进行一个可转移操作:

* `AssetID`: `0x000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f`
* `UTXOIDs`:
  * `UTXOID`:
    * `TxID`: `0xf1e1d1c1b1a191817161514131211101f0e0d0c0b0a090807060504030201000`
    * `UTXOIndex`: `5`
* `Op`: `"Example Transfer Op from below"`

```text
[
    AssetID   <- 0x000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f
    UTXOIDs   <- [
        {
            TxID:0xf1e1d1c1b1a191817161514131211101f0e0d0c0b0a090807060504030201000
            UTXOIndex:5
        }
    ]
    Op     <- 0x0000000d0000000200000003000000070000303900000003431100000000010000000251025c61fbcfc078f69334f834be6dd26d55a955c3344128e060128ede3523a24a461c8943ab0859
]
=
[
    // assetID:
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
    0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
    0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
    0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
    // number of utxoIDs:
    0x00, 0x00, 0x00, 0x01,
    // txID:
    0xf1, 0xe1, 0xd1, 0xc1, 0xb1, 0xa1, 0x91, 0x81,
    0x71, 0x61, 0x51, 0x41, 0x31, 0x21, 0x11, 0x01,
    0xf0, 0xe0, 0xd0, 0xc0, 0xb0, 0xa0, 0x90, 0x80,
    0x70, 0x60, 0x50, 0x40, 0x30, 0x20, 0x10, 0x00,
    // utxoIndex:
    0x00, 0x00, 0x00, 0x05,
    // op:
    0x00, 0x00, 0x00, 0x0d, 0x00, 0x00, 0x00, 0x02,
    0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x07,
    0x00, 0x00, 0x30, 0x39, 0x00, 0x00, 0x00, 0x03,
    0x43, 0x11, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00,
    0x00, 0x00, 0x02, 0x51, 0x02, 0x5c, 0x61, 0xfb,
    0xcf, 0xc0, 0x78, 0xf6, 0x93, 0x34, 0xf8, 0x34,
    0xbe, 0x6d, 0xd2, 0x6d, 0x55, 0xa9, 0x55, 0xc3,
    0x34, 0x41, 0x28, 0xe0, 0x60, 0x12, 0x8e, 0xde,
    0x35, 0x23, 0xa2, 0x4a, 0x46, 0x1c, 0x89, 0x43,
    0xab, 0x08, 0x59,
]
```

## 输出

输出有四种可能的类型 : [`SECP256K1TransferOutput`](avm-transaction-serialization.md#secp256k1-transfer-output), [`SECP256K1MintOutput`](avm-transaction-serialization.md#secp256k1-mint-output), [`NFTTransferOutput`](avm-transaction-serialization.md#nft-transfer-output) 和 [`NFTMintOutput`](avm-transaction-serialization.md#nft-mint-output)。

## SECP256K1 转移输出 


一个[secp256k1](cryptographics -primitives.md#secp-256-k1-addresses)传输输出允许在指定的unix时间后将一定数量的资产发送到地址集合。 

### **SECP256K1 转移输出包含什么**

secp256k1传输输出包含`TypeID`、`Amount`、`Locktime`、`Threshold`和`Addresses`。 

* **`TypeID`** 是此输出类型的ID, 这是`0x00000007`。
* **`Amount`** 是指定此输出拥有的资产数量的长值。 必须是积极的。
* **`Locktime`** 包含Unix时间戳的长字符串，该时间戳可以在此输出之后使用。 unix时间戳是特定于秒的。
* **`Threshold`** 是一个int，用于指定花费输出所需的唯一签名的数量。 必须小于或等于**`Addresses`**的长度。 如果** `Addresses`**为空，则必须为0。
* **`Addresses`** 是与可用于使用此输出的私钥对应的唯一地址列表。 地址必须按字典顺序排序。 

### **Gantt SECP256K1 转移输出规范**

```text
+-----------+------------+--------------------------------+
| type_id   : int        |                        4 bytes |
+-----------+------------+--------------------------------+
| amount    : long       |                        8 bytes |
+-----------+------------+--------------------------------+
| locktime  : long       |                        8 bytes |
+-----------+------------+--------------------------------+
| threshold : int        |                        4 bytes |
+-----------+------------+--------------------------------+
| addresses : [][20]byte |  4 + 20 * len(addresses) bytes |
+-----------+------------+--------------------------------+
                         | 28 + 20 * len(addresses) bytes |
                         +--------------------------------+
```

### **Proto SECP256K1 转移输出规范**

```text
message SECP256K1TransferOutput {
    uint32 typeID = 1;            // 04 bytes
    uint64 amount = 2;            // 08 bytes
    uint64 locktime = 3;          // 08 bytes
    uint32 threshold = 4;         // 04 bytes
    repeated bytes addresses = 5; // 04 bytes + 20 bytes * len(addresses)
}
```

### **SECP256K1 转移输出示例**

我们来进行一个 secp256k1 转移输出:

* **`TypeID`**: `7`
* **`Amount`**: `12345`
* **`Locktime`**: `54321`
* **`Threshold`**: `1`
* **`Addresses`**:
* `0x51025c61fbcfc078f69334f834be6dd26d55a955`
* `0xc3344128e060128ede3523a24a461c8943ab0859`

```text
[
    TypeID    <- 0x00000007
    Amount    <- 0x0000000000003039
    Locktime  <- 0x000000000000d431
    Threshold <- 0x00000001
    Addresses <- [
        0x51025c61fbcfc078f69334f834be6dd26d55a955,
        0xc3344128e060128ede3523a24a461c8943ab0859,
    ]
]
=
[
    // typeID:
    0x00, 0x00, 0x00, 0x07,
    // amount:
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x30, 0x39,
    // locktime:
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xd4, 0x31,
    // threshold:
    0x00, 0x00, 0x00, 0x01,
    // number of addresses:
    0x00, 0x00, 0x00, 0x02,
    // addrs[0]:
    0x51, 0x02, 0x5c, 0x61, 0xfb, 0xcf, 0xc0, 0x78,
    0xf6, 0x93, 0x34, 0xf8, 0x34, 0xbe, 0x6d, 0xd2,
    0x6d, 0x55, 0xa9, 0x55,
    // addrs[1]:
    0xc3, 0x34, 0x41, 0x28, 0xe0, 0x60, 0x12, 0x8e,
    0xde, 0x35, 0x23, 0xa2, 0x4a, 0x46, 0x1c, 0x89,
    0x43, 0xab, 0x08, 0x59,
]
```

## SECP256K1 铸造输出

 [secp256k1](cryptographic-primitives.md#secp-256-k1-addresses) 铸造输出是一个地址集所拥有的输出。

### **SECP256K1铸造输出包含什么**

secp256k1 铸造输出包含 `TypeID`、`Locktime`、`Threshold`和 `Addresses`。

* **`TypeID`** 是这个输出类型的ID, 它是`0x00000006`。
* **`Locktime`** 包含Unix时间戳的长字符串，该时间戳可以在此输出之后使用。unix时间戳是特定于秒的。
* **`Threshold`** 是一个int，用于指定花费输出所需的唯一签名的数量。必须小于或等于** `Addresses` **的长度。如果** `Addresses`**为空，则必须为0。
* **`Addresses`** 是与可用于使用此输出的私钥对应的唯一地址列表。地址必须按字典顺序排序。

### **Gantt SECP256K1 铸造输出规范**

```text
+-----------+------------+--------------------------------+
| type_id   : int        |                       4 bytes  |
+-----------+------------+--------------------------------+
| locktime  : long       |                       8 bytes  |
+-----------+------------+--------------------------------+
| threshold : int        |                       4 bytes  |
+-----------+------------+--------------------------------+
| addresses : [][20]byte |  4 + 20 * len(addresses) bytes |
+-----------+------------+--------------------------------+
                         | 20 + 20 * len(addresses) bytes |
                         +--------------------------------+
```

### **Proto SECP256K1 铸造输出规范**

```text
message SECP256K1MintOutput {
    uint32 typeID = 1;            // 04 bytes
    uint64 locktime = 2;          // 08 bytes
    uint32 threshold = 3;         // 04 bytes
    repeated bytes addresses = 4; // 04 bytes + 20 bytes * len(addresses)
}
```

### **SECP256K1 铸造输出示例**

我们来进行一个SECP256K1铸造输出:

* **`TypeID`**: `6`
* **`Locktime`**: `54321`
* **`Threshold`**: `1`
* **`Addresses`**:
* `0x51025c61fbcfc078f69334f834be6dd26d55a955`
* `0xc3344128e060128ede3523a24a461c8943ab0859`

```text
[
    TypeID    <- 0x00000006
    Locktime  <- 0x000000000000d431
    Threshold <- 0x00000001
    Addresses <- [
        0x51025c61fbcfc078f69334f834be6dd26d55a955,
        0xc3344128e060128ede3523a24a461c8943ab0859,
    ]
]
=
[
    // typeID:
    0x00, 0x00, 0x00, 0x06,
    // locktime:
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xd4, 0x31,
    // threshold:
    0x00, 0x00, 0x00, 0x01,
    // number of addresses:
    0x00, 0x00, 0x00, 0x02,
    // addrs[0]:
    0x51, 0x02, 0x5c, 0x61, 0xfb, 0xcf, 0xc0, 0x78,
    0xf6, 0x93, 0x34, 0xf8, 0x34, 0xbe, 0x6d, 0xd2,
    0x6d, 0x55, 0xa9, 0x55,
    // addrs[1]:
    0xc3, 0x34, 0x41, 0x28, 0xe0, 0x60, 0x12, 0x8e,
    0xde, 0x35, 0x23, 0xa2, 0x4a, 0x46, 0x1c, 0x89,
    0x43, 0xab, 0x08, 0x59,
]
```

## NFT 转移输出

NFT传输输出的是一组地址所拥有的NFT。

### **NFT 转移输出包含什么**

NFT 转移输出包含 `TypeID`, `GroupID`, `Payload`, `Locktime`, `Threshold` 和`Addresses`。

* **`TypeID`** 是此输出类型的ID。它是`0x0000000b`。
* **`GroupID`** 是一个int，它指定发布该NFT的组。
* **`Payload`** 是一个不多于1024个字节的任意字符串。 
* **`Locktime`** 包含Unix时间戳的长字符串，该时间戳可以在此输出之后使用。unix时间戳是特定于秒的。
* **`Threshold`** 是一个int，用于指定花费输出所需的唯一签名的数量。必须小于或等于** `Addresses`**的长度。如果** `Addresses`**为空，则必须为0。 
* **`Addresses`** 是与可用于使用此输出的私钥对应的唯一地址列表。地址必须按字典顺序排序。

### **Gantt NFT 转移输出规范**

```text
+-----------+------------+-------------------------------+
| type_id   : int        |                       4 bytes |
+-----------+------------+-------------------------------+
| group_id  : int        |                       4 bytes |
+-----------+------------+-------------------------------+
| payload   : []byte     |        4 + len(payload) bytes |
+-----------+------------+-------------------------------+
| locktime  : long       |                       8 bytes |
+-----------+------------+-------------------------------+
| threshold : int        |                       4 bytes |
+-----------+------------+-------------------------------+
| addresses : [][20]byte | 4 + 20 * len(addresses) bytes |
+-----------+------------+-------------------------------+
                         |             28 + len(payload) |
                         |  + 20 * len(addresses) bytes  |
                         +-------------------------------+
```

### **Proto NFT 转移输出规范**

```text
message NFTTransferOutput {
    uint32 typeID = 1;            // 04 bytes
    uint32 group_id = 2;          // 04 bytes
    bytes payload = 3;            // 04 bytes + len(payload)
    uint64 locktime = 4           // 08 bytes
    uint32 threshold = 5;         // 04 bytes
    repeated bytes addresses = 6; // 04 bytes + 20 bytes * len(addresses)
}
```

### **NFT 转移输出示例**

我们进行一个NFT传输输出:

* **`TypeID`**: `11`
* **`GroupID`**: `12345`
* **`Payload`**: `0x431100`
* **`Locktime`**: `54321`
* **`Threshold`**: `1`
* **`Addresses`**:
* `0x51025c61fbcfc078f69334f834be6dd26d55a955`
* `0xc3344128e060128ede3523a24a461c8943ab0859`

```text
[
    TypeID    <- 0x0000000b
    GroupID   <- 0x00003039
    Payload   <- 0x431100
    Locktime  <- 0x000000000000d431
    Threshold <- 0x00000001
    Addresses <- [
        0x51025c61fbcfc078f69334f834be6dd26d55a955,
        0xc3344128e060128ede3523a24a461c8943ab0859,
    ]
]
=
[
    // TypeID:
    0x00, 0x00, 0x00, 0x0b,
    // groupID:
    0x00, 0x00, 0x30, 0x39,
    // length of payload:
    0x00, 0x00, 0x00, 0x03,
    // payload:
    0x43, 0x11, 0x00,
    // locktime:
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xd4, 0x31,
    // threshold:
    0x00, 0x00, 0x00, 0x01,
    // number of addresses:
    0x00, 0x00, 0x00, 0x02,
    // addrs[0]:
    0x51, 0x02, 0x5c, 0x61, 0xfb, 0xcf, 0xc0, 0x78,
    0xf6, 0x93, 0x34, 0xf8, 0x34, 0xbe, 0x6d, 0xd2,
    0x6d, 0x55, 0xa9, 0x55,
    // addrs[1]:
    0xc3, 0x34, 0x41, 0x28, 0xe0, 0x60, 0x12, 0x8e,
    0xde, 0x35, 0x23, 0xa2, 0x4a, 0x46, 0x1c, 0x89,
    0x43, 0xab, 0x08, 0x59,
]
```

## NFT 铸造输出

一个NFT 铸造输出是一个由地址集合拥有的NFT。

### **NFT铸造输出包含什么**

NFT 铸造输出包含`TypeID`, `GroupID`, `Locktime`, `Threshold`和 `Addresses`。

* **`TypeID`** 是此类型的ID, 它是 `0x0000000a`。
* **`GroupID`** 是一个int，由它指定这个NFT被发给哪个组。
* **`Locktime`** 包含Unix时间戳的长字符串，该时间戳可以在此输出之后使用。unix时间戳是特定于秒的。
* **`Threshold`** 是一个int，用于指定花费输出所需的唯一签名的数量。必须小于或等于 **`Addresses`的长度。如果**`Addresses`为空，则必须为0。
* **`Addresses`** 是与可用于使用此输出的私钥对应的唯一地址列表。地址必须按字典顺序排序。

### **Gantt NFT 铸造输出规范**

```text
+-----------+------------+--------------------------------+
| type_id   : int        |                        4 bytes |
+-----------+------------+--------------------------------+
| group_id  : int        |                        4 bytes |
+-----------+------------+--------------------------------+
| locktime  : long       |                        8 bytes |
+-----------+------------+--------------------------------+
| threshold : int        |                        4 bytes |
+-----------+------------+--------------------------------+
| addresses : [][20]byte |  4 + 20 * len(addresses) bytes |
+-----------+------------+--------------------------------+
                         | 24 + 20 * len(addresses) bytes |
                         +--------------------------------+
```

### **Proto NFT 铸造输出规范**

```text
message NFTMintOutput {
    uint32 typeID = 1;            // 04 bytes
    uint32 group_id = 2;          // 04 bytes
    uint64 locktime = 3;          // 08 bytes
    uint32 threshold = 4;         // 04 bytes
    repeated bytes addresses = 5; // 04 bytes + 20 bytes * len(addresses)
}
```

### **NFT 铸造输出示例**

我们来进行一个NFT铸造输出:

* **`TypeID`**: `10`
* **`GroupID`**: `12345`
* **`Locktime`**: `54321`
* **`Threshold`**: `1`
* **`Addresses`**:
* `0x51025c61fbcfc078f69334f834be6dd26d55a955`
* `0xc3344128e060128ede3523a24a461c8943ab0859`

```text
[
    TypeID    <- 0x0000000a
    GroupID   <- 0x00003039
    Locktime  <- 0x000000000000d431
    Threshold <- 0x00000001
    Addresses <- [
        0x51025c61fbcfc078f69334f834be6dd26d55a955,
        0xc3344128e060128ede3523a24a461c8943ab0859,
    ]
]
=
[
    // TypeID
    0x00, 0x00, 0x00, 0x0a,
    // groupID:
    0x00, 0x00, 0x30, 0x39,
    // locktime:
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xd4, 0x31,
    // threshold:
    0x00, 0x00, 0x00, 0x01,
    // number of addresses:
    0x00, 0x00, 0x00, 0x02,
    // addrs[0]:
    0x51, 0x02, 0x5c, 0x61, 0xfb, 0xcf, 0xc0, 0x78,
    0xf6, 0x93, 0x34, 0xf8, 0x34, 0xbe, 0x6d, 0xd2,
    0x6d, 0x55, 0xa9, 0x55,
    // addrs[1]:
    0xc3, 0x34, 0x41, 0x28, 0xe0, 0x60, 0x12, 0x8e,
    0xde, 0x35, 0x23, 0xa2, 0x4a, 0x46, 0x1c, 0x89,
    0x43, 0xab, 0x08, 0x59,
]
```

## 输入

输入有一种可能的类型: `SECP256K1TransferInput`.

## SECP256K1 转移输入

[secp256k1](cryptographic-primitives.md#secp-256-k1-addresses) 传输输入允许花费未使用过的secp256k1传输输出。

### **SECP256K1转移输入包含什么**

secp256k1转移输入包含`Amount` 和`AddressIndices`。

* **`TypeID`**是此类型的ID, 它是`0x00000005`。
* **`Amount`** 是一个长值，它指定该输入应该从UTXO消耗的数量。必须是积极的。必须等于UTXO中指定的数量。
* **`AddressIndices`** 是一个唯一的整数列表，它定义了用于花费UTXO的私钥。每个UTXO都有一个可以使用UTXO的地址数组。每个int表示该地址数组中将签名该交易的索引。数组必须从低到高排序。

### **Gantt SECP256K1 转移输入规范 **

```text
+-------------------------+-------------------------------------+
| type_id         : int   |                             4 bytes |
+-----------------+-------+-------------------------------------+
| amount          : long  |                             8 bytes |
+-----------------+-------+-------------------------------------+
| address_indices : []int |  4 + 4 * len(address_indices) bytes |
+-----------------+-------+-------------------------------------+
                          | 16 + 4 * len(address_indices) bytes |
                          +-------------------------------------+
```

### **Proto SECP256K1  转移输入规范**

```text
message SECP256K1TransferInput {
    uint32 typeID = 1;                   // 04 bytes
    uint64 amount = 2;                   // 08 bytes
    repeated uint32 address_indices = 3; // 04 bytes + 04 bytes * len(address_indices)
}
```

### **SECP256K1  转移输入示例**

让我们进行一个支付输入:

* **`TypeId`**: `5`
* **`Amount`**: `123456789`
* **`AddressIndices`**: \[`3`,`7`\]

```text
[
    TypeID         <- 0x00000005
    Amount         <- 123456789 = 0x00000000075bcd15,
    AddressIndices <- [0x00000003, 0x00000007]
]
=
[
    // type id:
    0x00, 0x00, 0x00, 0x05,
    // amount:
    0x00, 0x00, 0x00, 0x00, 0x07, 0x5b, 0xcd, 0x15,
    // length:
    0x00, 0x00, 0x00, 0x02,
    // sig[0]
    0x00, 0x00, 0x00, 0x03,
    // sig[1]
    0x00, 0x00, 0x00, 0x07,
]
```

## 操作

操作有三种可能的类型:: `SECP256K1MintOperation`, `NFTMintOp`和 `NFTTransferOp`。

## **SECP256K1 铸造操作**

一个[secp256k1](cryptographic-primitives.md#secp-256-k1-addresses) 铸造操作消耗一个SECP256K1铸造输出，创建一个新的铸造输出，并向一组新的所有者发送一个传输输出。

### **SECP256K1 铸造操作包含什么**

secp256k1铸造操作包含`TypeID`, `AddressIndices`, `MintOutput`和 `TransferOutput`。

* **`TypeID`**是此类型的ID, 它是`0x00000008`。
* **`AddressIndices`** 是一个唯一的整数列表，它定义了用于使用[UTXO](avm-transaction-serialization.md# UTXO)的私钥。每个UTXO都有一个可以使用UTXO的地址数组。每个整数表示该地址数组中将签名该交易的索引。数组必须从低到高排序。
* **`MintOutput`** 是一个 [SECP256K1 铸造输出](avm-transaction-serialization.md#secp256k1-mint-output)。
* **`TransferOutput`** 是一个[SECP256K1 转移输出](avm-transaction-serialization.md#secp256k1-transfer-output)。

### **Gantt SECP256K1 铸造操作规范**

```text
+----------------------------------+------------------------------------+
| type_id         : int            |                            4 bytes |
+----------------------------------+------------------------------------+
| address_indices : []int          | 4 + 4 * len(address_indices) bytes |
+----------------------------------+------------------------------------+
| mint_output     : MintOutput     |            size(mint_output) bytes |
+----------------------------------+------------------------------------+
| transfer_output : TransferOutput |        size(transfer_output) bytes |
+----------------------------------+------------------------------------+
                                   |       8 + 4 * len(address_indices) |
                                   |                + size(mint_output) |
                                   |      + size(transfer_output) bytes |
                                   +------------------------------------+
```

### **Proto SECP256K1 铸造操作规范**

```text
message SECP256K1MintOperation {
    uint32 typeID = 1;                   // 4 bytes
    repeated uint32 address_indices = 2; // 04 bytes + 04 bytes * len(address_indices)
    MintOutput mint_output = 3;          // size(mint_output
    TransferOutput transfer_output = 4;  // size(transfer_output)
}
```

### **SECP256K1 铸造操作示例**

我们来进行一个 [secp256k1](cryptographic-primitives.md#secp-256-k1-addresses) 铸造操作:

* **`TypeId`**: `8`
* **`AddressIndices`**:
* `0x00000003`
* `0x00000007`
* **`MintOutput`**: `“Example SECP256K1 Mint Output from above”`
* **`TransferOutput`**: `“Example SECP256K1 Transfer Output from above”`

```text
[
    TypeID <- 0x00000008
    AddressIndices <- [0x00000003, 0x00000007]
    MintOutput <- 0x00000006000000000000d431000000010000000251025c61fbcfc078f69334f834be6dd26d55a955c3344128e060128ede3523a24a461c89
    TransferOutput <- 0x000000070000000000003039000000000000d431000000010000000251025c61fbcfc078f69334f834be6dd26d55a955c3344128e060128ede3523a24a461c8943ab0859
]
=
[
    // typeID
    0x00, 0x00, 0x00, 0x08,
    // number of address_indices:
    0x00, 0x00, 0x00, 0x02,
    // address_indices[0]:
    0x00, 0x00, 0x00, 0x03,
    // address_indices[1]:
    0x00, 0x00, 0x00, 0x07,
    // mint output
    0x00, 0x00, 0x00, 0x06, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0xd4, 0x31, 0x00, 0x00, 0x00, 0x01,
    0x00, 0x00, 0x00, 0x02, 0x51, 0x02, 0x5c, 0x61,
    0xfb, 0xcf, 0xc0, 0x78, 0xf6, 0x93, 0x34, 0xf8,
    0x34, 0xbe, 0x6d, 0xd2, 0x6d, 0x55, 0xa9, 0x55,
    0xc3, 0x34, 0x41, 0x28, 0xe0, 0x60, 0x12, 0x8e,
    0xde, 0x35, 0x23, 0xa2, 0x4a, 0x46, 0x1c, 0x89,
    0x43, 0xab, 0x08, 0x59,
    // transfer output
    0x00, 0x00, 0x00, 0x07, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x30, 0x39, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0xd4, 0x31, 0x00, 0x00, 0x00, 0x01,
    0x00, 0x00, 0x00, 0x02, 0x51, 0x02, 0x5c, 0x61,
    0xfb, 0xcf, 0xc0, 0x78, 0xf6, 0x93, 0x34, 0xf8,
    0x34, 0xbe, 0x6d, 0xd2, 0x6d, 0x55, 0xa9, 0x55,
    0xc3, 0x34, 0x41, 0x28, 0xe0, 0x60, 0x12, 0x8e,
    0xde, 0x35, 0x23, 0xa2, 0x4a, 0x46, 0x1c, 0x89,
    0x43, 0xab, 0x08, 0x59,
]
```

## NFT 铸造操作

NFT铸币操作使用NFT铸币输出，并将未使用的输出发送给一组新的所有者。

### **NFT铸造操作包含什么**

NFT铸造操作包含`TypeID`, `AddressIndices`, `GroupID`, `Payload`和`Output` 的地址。

* **`TypeID`** 是此操作类型的ID, 它是`0x0000000c`。
* **`AddressIndices`** 是一个唯一的整数列表，它定义了用于花费UTXO的私钥。每个UTXO都有一个可以使用UTXO的地址数组。每个整数表示该地址数组中将签名该交易的索引。数组必须从低到高排序。
* **`GroupID`** 是一个整数，指定这个NFT是发给哪个组的。
* **`Payload`** 是不超过1024字节的任意字节字符串。
* **`Output`** 不是`TransferableOutput`，而是一个锁定时间、阈值和一组唯一地址，这些地址对应于私钥，私钥可用于使用该输出。地址必须按字典顺序排序。

### **Gantt NFT 铸造操作规范**

```text
+------------------------------+------------------------------------+
| type_id         : int        |                            4 bytes |
+-----------------+------------+------------------------------------+
| address_indices : []int      | 4 + 4 * len(address_indices) bytes |
+-----------------+------------+------------------------------------+
| group_id        : int        |                            4 bytes |
+-----------------+------------+------------------------------------+
| payload         : []byte     |             4 + len(payload) bytes |
+-----------------+------------+------------------------------------+
| outputs         : []Output   |            4 + size(outputs) bytes |
+-----------------+------------+------------------------------------+
                               |                               20 + |
                               |         4 * len(address_indices) + |
                               |                     len(payload) + |
                               |                size(outputs) bytes |
                               +------------------------------------+
```

### **Proto NFT 铸造操作规范**

```text
message NFTMintOp {
    uint32 typeID = 1;                   // 04 bytes
    repeated uint32 address_indices = 2; // 04 bytes + 04 bytes * len(address_indices)
    uint32 group_id = 3;                 // 04 bytes
    bytes payload = 4;                   // 04 bytes + len(payload)
    repeated bytes outputs = 5;          // 04 bytes + size(outputs)
}
```

### **NFT 铸造操作示例**

我们来进行一个NFT 铸造操作:

* **`TypeId`**: `12`
* **`AddressIndices`**:
  * `0x00000003`
  * `0x00000007`
* **`GroupID`**: `12345`
* **`Payload`**: `0x431100`
* **`Locktime`**: `54321`
* **`Threshold`**: `1`
* **`Addresses`**:
* `0xc3344128e060128ede3523a24a461c8943ab0859`

```text
[
    TypeID         <- 0x0000000c
    AddressIndices <- [
        0x00000003,
        0x00000007,
    ]
    GroupID        <- 0x00003039
    Payload        <- 0x431100
    Locktime       <- 0x000000000000d431
    Threshold      <- 0x00000001
    Addresses      <- [
        0xc3344128e060128ede3523a24a461c8943ab0859
    ]
]
=
[
    // Type ID
    0x00, 0x00, 0x00, 0x0c,
    // number of address indices:
    0x00, 0x00, 0x00, 0x02,
    // address index 0:
    0x00, 0x00, 0x00, 0x03,
    // address index 1:
    0x00, 0x00, 0x00, 0x07,
    // groupID:
    0x00, 0x00, 0x30, 0x39,
    // length of payload:
    0x00, 0x00, 0x00, 0x03,
    // payload:
    0x43, 0x11, 0x00,
    // number of outputs:
    0x00, 0x00, 0x00, 0x01,
    // outputs[0]
    // locktime:
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xd4, 0x31,
    // threshold:
    0x00, 0x00, 0x00, 0x01,
    // number of addresses:
    0x00, 0x00, 0x00, 0x01,
    // addrs[0]:
    0xc3, 0x34, 0x41, 0x28, 0xe0, 0x60, 0x12, 0x8e,
    0xde, 0x35, 0x23, 0xa2, 0x4a, 0x46, 0x1c, 0x89,
    0x43, 0xab, 0x08, 0x59,
]
```

## NFT 传输操作

NFT传输操作将未使用的NFT传输输出发送给一组新的所有者。

### **NFT 传输操作包含什么**

一个NFT传输操作包含 `TypeID`, `AddressIndices` 和一个非类型化的`NFTTransferOutput`。

* **`TypeID`** 是此输出类型的ID, 它是 `0x0000000d`。
* **`AddressIndices`** 是一个唯一的整数列表，它定义了用于花费UTXO的私钥。每个UTXO都有一个可以使用UTXO的地址数组。每个整数表示该地址数组中将签名该交易的索引。数组必须从低到高排序。
* **`NFTTransferOutput`** 是该操作的输出，必须是[NFT传输输出](avm-transaction-serialization.md# NFT - Transfer -output)。此输出没有** `TypeId` **，因为该类型是由该操作的上下文所知道的。

### **Gantt NFT 传输操作规范**

```text
+------------------------------+------------------------------------+
| type_id         : int        |                            4 bytes |
+-----------------+------------+------------------------------------+
| address_indices : []int      | 4 + 4 * len(address_indices) bytes |
+-----------------+------------+------------------------------------+
| group_id        : int        |                            4 bytes |
+-----------------+------------+------------------------------------+
| payload         : []byte     |             4 + len(payload) bytes |
+-----------------+------------+------------------------------------+
| locktime        : long       |                            8 bytes |
+-----------+------------+------------------------------------------+
| threshold       : int        |                            4 bytes |
+-----------------+------------+------------------------------------+
| addresses       : [][20]byte |      4 + 20 * len(addresses) bytes |
+-----------------+------------+------------------------------------+
                               |                  36 + len(payload) |
                               |        + 4 * len(address_indices)  |
                               |        + 20 * len(addresses) bytes |
                               +------------------------------------+
```

### **Proto NFT 传输操作规范**

```text
message NFTTransferOp {
    uint32 typeID = 1;                   // 04 bytes
    repeated uint32 address_indices = 2; // 04 bytes + 04 bytes * len(address_indices)
    uint32 group_id = 3;                 // 04 bytes
    bytes payload = 4;                   // 04 bytes + len(payload)
    uint64 locktime = 5;                 // 08 bytes
    uint32 threshold = 6;                // 04 bytes
    repeated bytes addresses = 7;        // 04 bytes + 20 bytes * len(addresses)
}
```

### **NFT 传输操作示例**

我们进行一个NFT传输操作:

* **`TypeID`**: `13`
* **`AddressIndices`**:
* `0x00000007`
* `0x00000003`
* **`GroupID`**: `12345`
* **`Payload`**: `0x431100`
* **`Locktime`**: `54321`
* **`Threshold`**: `1`
* **`Addresses`**:
* `0xc3344128e060128ede3523a24a461c8943ab0859`
* `0x51025c61fbcfc078f69334f834be6dd26d55a955`

```text
[
    TypeID         <- 0x0000000d
    AddressIndices <- [
        0x00000007,
        0x00000003,
    ]
    GroupID        <- 0x00003039
    Payload        <- 0x431100
    Locktime       <- 0x000000000000d431
    Threshold      <- 00000001
    Addresses      <- [
        0x51025c61fbcfc078f69334f834be6dd26d55a955,
        0xc3344128e060128ede3523a24a461c8943ab0859,
    ]
]
=
[
    // Type ID
    0x00, 0x00, 0x00, 0x0d,
    // number of address indices:
    0x00, 0x00, 0x00, 0x02,
    // address index 0:
    0x00, 0x00, 0x00, 0x07,
    // address index 1:
    0x00, 0x00, 0x00, 0x03,
    // groupID:
    0x00, 0x00, 0x30, 0x39,
    // length of payload:
    0x00, 0x00, 0x00, 0x03,
    // payload:
    0x43, 0x11, 0x00,
    // locktime:
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xd4, 0x31,
    // threshold:
    0x00, 0x00, 0x00, 0x01,
    // number of addresses:
    0x00, 0x00, 0x00, 0x02,
    // addrs[0]:
    0x51, 0x02, 0x5c, 0x61, 0xfb, 0xcf, 0xc0, 0x78,
    0xf6, 0x93, 0x34, 0xf8, 0x34, 0xbe, 0x6d, 0xd2,
    0x6d, 0x55, 0xa9, 0x55,
    // addrs[1]:
    0xc3, 0x34, 0x41, 0x28, 0xe0, 0x60, 0x12, 0x8e,
    0xde, 0x35, 0x23, 0xa2, 0x4a, 0x46, 0x1c, 0x89,
    0x43, 0xab, 0x08, 0x59,
]
```

## 初始状态

初始状态描述创建资产时的初始状态。它包含资产使用的特性扩展的ID，以及一个可变长度的输出数组，该输出数组表示资产的起源UTXO集。

### 初始状态包含什么

初始状态包含 `FxID` 和一个数组。

* **`FxID`** 是一个整数，定义此状态属于哪个特性扩展。对于SECP256K1资产，它是`0x00000000`。对于NFT 资产，它是`0x00000001`。
* **`Outputs`** 是一个可变长度的[outputs]数组(avm-transaction-serialization.md#outputs)，如上所定义。

### Gantt 初始状态规范

```text
+---------------+----------+-------------------------------+
| fx_id         : int      |                       4 bytes |
+---------------+----------+-------------------------------+
| outputs       : []Output |       4 + size(outputs) bytes |
+---------------+----------+-------------------------------+
                           |       8 + size(outputs) bytes |
                           +-------------------------------+
```

### Proto 初始状态规范

```text
message InitialState {
    uint32 fx_id = 1;                  // 04 bytes
    repeated Output outputs = 2;       // 04 + size(outputs) bytes
}
```

### 初始状态示例

我们来进行一个初始状态:

* `FxID`: `0x00000000`
* `InitialState`: `["Example SECP256K1 Transfer Output from above"]`

```text
[
    FxID <- 0x00000000
    InitialState  <- [
        0x000000070000000000003039000000000000d431000000010000000251025c61fbcfc078f69334f834be6dd26d55a955c3344128e060128ede3523a24a461c8943ab0859,
    ]
]
=
[
    // fxID:
    0x00, 0x00, 0x00, 0x00,
    // num outputs:
    0x00, 0x00, 0x00, 0x01,
    // output:
    0x00, 0x00, 0x00, 0x07, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x30, 0x39, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0xd4, 0x31, 0x00, 0x00, 0x00, 0x01,
    0x00, 0x00, 0x00, 0x02, 0x51, 0x02, 0x5c, 0x61,
    0xfb, 0xcf, 0xc0, 0x78, 0xf6, 0x93, 0x34, 0xf8,
    0x34, 0xbe, 0x6d, 0xd2, 0x6d, 0x55, 0xa9, 0x55,
    0xc3, 0x34, 0x41, 0x28, 0xe0, 0x60, 0x12, 0x8e,
    0xde, 0x35, 0x23, 0xa2, 0x4a, 0x46, 0x1c, 0x89,
    0x43, 0xab, 0x08, 0x59,
]
```

## 凭据

凭据有两种可能的类型:`SECP256K1Credential`和`NFTCredential`。每个凭据都与输入或操作配对。凭据的顺序与输入或操作的顺序相匹配。

## SECP256K1 凭据

一个[secp256k1](cryptographic-primitives.md#secp-256-k1-addresses) 凭据包含一个65个字节的可恢复签名的列表。 

### **SECP256K1凭据包含什么**

* **`TypeID`** 是此类型的ID, 它是 `0x00000009`。
* **`Signatures`** 是一个65个字节的可恢复签名的数组。签名的顺序必须与输入的签名索引匹配。

### **Gantt SECP256K1 凭据规范**

```text
+------------------------------+---------------------------------+
| type_id         : int        |                         4 bytes |
+-----------------+------------+---------------------------------+
| signatures      : [][65]byte |  4 + 65 * len(signatures) bytes |
+-----------------+------------+---------------------------------+
                               |  8 + 65 * len(signatures) bytes |
                               +---------------------------------+
```

### **Proto SECP256K1 凭据规范**

```text
message SECP256K1Credential {
    uint32 typeID = 1;             // 4 bytes
    repeated bytes signatures = 2; // 4 bytes + 65 bytes * len(signatures)
}
```

### **SECP256K1 凭据示例**

我们来进行一个支付输入:

* **`TypeID`**: `9`
* **`signatures`**:
* `0x000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1e1d1f202122232425262728292a2b2c2e2d2f303132333435363738393a3b3c3d3e3f00`
* `0x404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5e5d5f606162636465666768696a6b6c6e6d6f707172737475767778797a7b7c7d7e7f00`

```text
[
    TypeID         <- 0x00000009
    Signatures <- [
        0x000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1e1d1f202122232425262728292a2b2c2e2d2f303132333435363738393a3b3c3d3e3f00,
        0x404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5e5d5f606162636465666768696a6b6c6e6d6f707172737475767778797a7b7c7d7e7f00,
    ]
]
=
[
    // Type ID
    0x00, 0x00, 0x00, 0x09,
    // length:
    0x00, 0x00, 0x00, 0x02,
    // sig[0]
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
    0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
    0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
    0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1e, 0x1d, 0x1f,
    0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27,
    0x28, 0x29, 0x2a, 0x2b, 0x2c, 0x2e, 0x2d, 0x2f,
    0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37,
    0x38, 0x39, 0x3a, 0x3b, 0x3c, 0x3d, 0x3e, 0x3f,
    0x00,
    // sig[1]
    0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47,
    0x48, 0x49, 0x4a, 0x4b, 0x4c, 0x4d, 0x4e, 0x4f,
    0x50, 0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57,
    0x58, 0x59, 0x5a, 0x5b, 0x5c, 0x5e, 0x5d, 0x5f,
    0x60, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67,
    0x68, 0x69, 0x6a, 0x6b, 0x6c, 0x6e, 0x6d, 0x6f,
    0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77,
    0x78, 0x79, 0x7a, 0x7b, 0x7c, 0x7d, 0x7e, 0x7f,
    0x00,
]
```

## NFT 凭据
NFT凭据与[secp256k1凭据](avm-transaction-serialization.md#secp256k1-credential)相同，但具有不同的TypeID。NFT凭据的TypeID是`0x0000000e`。

## 未签名的交易

未签名的交易包含交易的全部内容，只缺少签名。无签名交易有四种可能的类型:[`CreateAssetTx`](avm-transaction-serialization.md#what-unsigned-create-asset-tx-contains), [`OperationTx`](avm-transaction-serialization.md#what-unsigned-operation-tx-contains), [`ImportTx`](avm-transaction-serialization.md#what-unsigned-import-tx-contains)和[`ExportTx`](avm-transaction-serialization.md#what-unsigned-export-tx-contains), 它们都嵌入[' BaseTx '](avm-transaction-serialization.md#what-base-tx-contains)，其中包含常见字段和操作。

### Base Tx 包含什么

Base Tx 包含 `TypeID`, `NetworkID`, `BlockchainID`, `Outputs`, `Inputs` 和`Memo`。

* **`TypeID`** 是此类型的ID, 它是 `0x00000000`。
* **`NetworkID`** 是一个整数，它定义了这个交易要发送到哪个网络。这个值意味着支持交易路由，不是为防止反复攻击而设计的。
* **`BlockchainID`** 是一个32字节的数组，它定义了这个交易被发送到哪个区块链。这用于防止可能跨网络或区块链有效的交易的反复攻击。 
* **`Outputs`** 是一个[可转移输出对象](avm-transaction-serialization.md#transferable-output)的数组。输出必须根据它们的序列化表示按字典顺序排序。在这些产出中创造的资产总量必须小于或等于投入中消耗的每项资产的总量减去交易费用。
* **`Inputs`** 是一个[可转移输入对象](avm-transaction-serialization.md#transferable-input)的数组。输入必须是有序且唯一的。输入首先以** ' TxID ' **的字典顺序排序，然后按** ' UTXOIndex ' **从低到高排序。如果有相同的** ' TxID ' **和** ' UTXOIndex ' **的输入，则该交易无效，因为这将导致双重花费。
* **`Memo`** 备注字段包含任意字节，最多256字节。
* 
### Gantt Base Tx 规范

```text
+--------------------------------------+-----------------------------------------+
| type_id       : int                  |                                 4 bytes |
+---------------+----------------------+-----------------------------------------+
| network_id    : int                  |                                 4 bytes |
+---------------+----------------------+-----------------------------------------+
| blockchain_id : [32]byte             |                                32 bytes |
+---------------+----------------------+-----------------------------------------+
| outputs       : []TransferableOutput |                 4 + size(outputs) bytes |
+---------------+----------------------+-----------------------------------------+
| inputs        : []TransferableInput  |                  4 + size(inputs) bytes |
+---------------+----------------------+-----------------------------------------+
| memo          : [256]byte            |                    4 + size(memo) bytes |
+---------------+----------------------+-----------------------------------------+
                          | 52 + size(outputs) + size(inputs) + size(memo) bytes |
                          +------------------------------------------------------+
```

### Proto Base Tx 规范

```text
message BaseTx {
    uint32 typeID = 1;           // 04 bytes
    uint32 network_id = 2;       // 04 bytes
    bytes blockchain_id = 3;     // 32 bytes
    repeated Output outputs = 4; // 04 bytes + size(outs)
    repeated Input inputs = 5;   // 04 bytes + size(ins)
    bytes memo = 6;              // 04 bytes + size(memo)
}
```

### Base Tx 示例

让我们创建一个base tx，它使用前面例子中的输入和输出:

* **`TypeID`**: `0`
* **`NetworkID`**: `4`
* **`BlockchainID`**: `0xffffffffeeeeeeeeddddddddcccccccbbbbbbbbaaaaaaaa9999999988888888`
* **`Outputs`**:
  * `"Example Transferable Output as defined above"`
* **`Inputs`**:
  * `"Example Transferable Input as defined above"`
* **`Memo`**: `0x00010203`

```text
[
    TypeID       <- 0x00000000
    NetworkID    <- 0x00000004
    BlockchainID <- 0xffffffffeeeeeeeeddddddddcccccccbbbbbbbbaaaaaaaa9999999988888888
    Outputs      <- [
        0x000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f000000070000000000003039000000000000d431000000010000000251025c61fbcfc078f69334f834be6dd26d55a955c3344128e060128ede3523a24a461c8943ab0859
    ]
    Inputs       <- [
        0xf1e1d1c1b1a191817161514131211101f0e0d0c0b0a09080706050403020100000000005000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f0000000500000000075bcd15000000020000000700000003
    ]
    Memo <- 0x00010203
]
=
[
    // typeID
    0x00, 0x00, 0x00, 0x00,
    // networkID:
    0x00, 0x00, 0x00, 0x04,
    // blockchainID:
    0xff, 0xff, 0xff, 0xff, 0xee, 0xee, 0xee, 0xee,
    0xdd, 0xdd, 0xdd, 0xdd, 0xcc, 0xcc, 0xcc, 0xcc,
    0xbb, 0xbb, 0xbb, 0xbb, 0xaa, 0xaa, 0xaa, 0xaa,
    0x99, 0x99, 0x99, 0x99, 0x88, 0x88, 0x88, 0x88,
    // number of outputs:
    0x00, 0x00, 0x00, 0x01,
    // transferable output:
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
    0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
    0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
    0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
    0x00, 0x00, 0x00, 0x07, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x30, 0x39, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0xd4, 0x31, 0x00, 0x00, 0x00, 0x01,
    0x00, 0x00, 0x00, 0x02, 0x51, 0x02, 0x5c, 0x61,
    0xfb, 0xcf, 0xc0, 0x78, 0xf6, 0x93, 0x34, 0xf8,
    0x34, 0xbe, 0x6d, 0xd2, 0x6d, 0x55, 0xa9, 0x55,
    0xc3, 0x34, 0x41, 0x28, 0xe0, 0x60, 0x12, 0x8e,
    0xde, 0x35, 0x23, 0xa2, 0x4a, 0x46, 0x1c, 0x89,
    0x43, 0xab, 0x08, 0x59,
    // number of inputs:
    0x00, 0x00, 0x00, 0x01,
    // transferable input:
    0xf1, 0xe1, 0xd1, 0xc1, 0xb1, 0xa1, 0x91, 0x81,
    0x71, 0x61, 0x51, 0x41, 0x31, 0x21, 0x11, 0x01,
    0xf0, 0xe0, 0xd0, 0xc0, 0xb0, 0xa0, 0x90, 0x80,
    0x70, 0x60, 0x50, 0x40, 0x30, 0x20, 0x10, 0x00,
    0x00, 0x00, 0x00, 0x05, 0x00, 0x01, 0x02, 0x03,
    0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b,
    0x0c, 0x0d, 0x0e, 0x0f, 0x10, 0x11, 0x12, 0x13,
    0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b,
    0x1c, 0x1d, 0x1e, 0x1f, 0x00, 0x00, 0x00, 0x05,
    0x00, 0x00, 0x00, 0x00, 0x07, 0x5b, 0xcd, 0x15,
    0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x07,
    0x00, 0x00, 0x00, 0x03,
    // Memo length:
    0x00, 0x00, 0x00, 0x04,
    // Memo:
    0x00, 0x01, 0x02, 0x03,
]
```

### 未签名创建资产Tx包含什么

未签名创建资产Tx包含`BaseTx`, `Name`, `Symbol`, `Denomination`和`InitialStates`, 这个`TypeID` 是`0x00000001`。

* **`BaseTx`**
* **`Name`** 是一个可读的字符串，它定义了此交易将创建的资产的名称。名称不能保证是唯一的。名称必须只包含可打印的ASCII字符，且不能超过128个字符。
* **`Symbol`** 是一个可读的字符串，它定义了此交易将创建的资产的符号。符号不能保证是唯一的。该符号必须仅由可打印的ASCII字符组成，且不能超过4个字符。
* **`Denomination`** 是一个字节，它定义了该交易将创建的资产的可整除性。例如，AVAX代币可分为十亿分之一。因此，AVAX代币的面额为9, 最多不能超过32。
* **`InitialStates`** 是一个可变长度的数组，它定义了该资产支持的特性扩展，以及这些特性扩展的[初始状态](avm-transaction-serialization.md#initial-state)。

### Gantt Unsigned Create Asset Tx Specification

```text
+----------------+----------------+--------------------------------------+
| base_tx        : BaseTx         |                  size(base_tx) bytes |
+----------------+----------------+--------------------------------------+
| name           : string         |                  2 + len(name) bytes |
+----------------+----------------+--------------------------------------+
| symbol         : string         |                2 + len(symbol) bytes |
+----------------+----------------+--------------------------------------+
| denomination   : byte           |                              1 bytes |
+----------------+----------------+--------------------------------------+
| initial_states : []InitialState |       4 + size(initial_states) bytes |
+----------------+----------------+--------------------------------------+
                                  | size(base_tx) + size(initial_states) |
                                  |  + 9 + len(name) + len(symbol) bytes |
                                  +--------------------------------------+
```

### Proto 未签名创建资产Tx 规范

```text
message CreateAssetTx {
    BaseTx base_tx = 1;                       // size(base_tx)
    string name = 2;                          // 2 bytes + len(name)
    name symbol = 3;                          // 2 bytes + len(symbol)
    uint8 denomination = 4;                   // 1 bytes
    repeated InitialState initial_states = 5; // 4 bytes + size(initial_states)
}
```

### 未签名创建资产Tx示例

让我们创建一个未签名base tx，它使用前面例子中的输入和输出:

* `BaseTx`: `"Example BaseTx as defined above with ID set to 1"`
* `Name`: `Volatility Index`
* `Symbol`: `VIX`
* `Denomination`: `2`
* **`InitialStates`**:
* `"Example Initial State as defined above"`

```text
[
    BaseTx        <- 0x0000000100000004ffffffffeeeeeeeeddddddddccccccccbbbbbbbbaaaaaaaa999999998888888800000001000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f000000070000000000003039000000000000d431000000010000000251025c61fbcfc078f69334f834be6dd26d55a955c3344128e060128ede3523a24a461c8943ab085900000001f1e1d1c1b1a191817161514131211101f0e0d0c0b0a09080706050403020100000000005000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f0000000500000000075bcd150000000200000007000000030000000400010203
    Name          <- 0x0010566f6c6174696c69747920496e646578
    Symbol        <- 0x0003564958
    Denomination  <- 0x02
    InitialStates <- [
        0x0000000000000001000000070000000000003039000000000000d431000000010000000251025c61fbcfc078f69334f834be6dd26d55a955c3344128e060128ede3523a24a461c8943ab0859,
    ]
]
=
[
    // base tx:
    0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x04, 
    0xff, 0xff, 0xff, 0xff, 0xee, 0xee, 0xee, 0xee, 
    0xdd, 0xdd, 0xdd, 0xdd, 
    0xcc, 0xcc, 0xcc, 0xcc, 0xbb, 0xbb, 0xbb, 0xbb, 
    0xaa, 0xaa, 0xaa, 0xaa, 0x99, 0x99, 0x99, 0x99, 
    0x88, 0x88, 0x88, 0x88, 0x00, 0x00, 0x00, 0x01, 
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
    0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
    0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 
    0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f, 
    0x00, 0x00, 0x00, 0x07, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x30, 0x39, 0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0xd4, 0x31, 0x00, 0x00, 0x00, 0x01,
    0x00, 0x00, 0x00, 0x02, 0x51, 0x02, 0x5c, 0x61, 
    0xfb, 0xcf, 0xc0, 0x78, 0xf6, 0x93, 0x34, 0xf8, 
    0x34, 0xbe, 0x6d, 0xd2, 0x6d, 0x55, 0xa9, 0x55, 
    0xc3, 0x34, 0x41, 0x28, 0xe0, 0x60, 0x12, 0x8e,
    0xde, 0x35, 0x23, 0xa2, 0x4a, 0x46, 0x1c, 0x89,
    0x43, 0xab, 0x08, 0x59, 0x00, 0x00, 0x00, 0x01,
    0xf1, 0xe1, 0xd1, 0xc1, 0xb1, 0xa1, 0x91, 0x81,
    0x71, 0x61, 0x51, 0x41, 0x31, 0x21, 0x11, 0x01,
    0xf0, 0xe0, 0xd0, 0xc0, 0xb0, 0xa0, 0x90, 0x80,
    0x70, 0x60, 0x50, 0x40, 0x30, 0x20, 0x10, 0x00,
    0x00, 0x00, 0x00, 0x05, 0x00, 0x01, 0x02, 0x03,
    0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b,
    0x0c, 0x0d, 0x0e, 0x0f, 0x10, 0x11, 0x12, 0x13,
    0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b,
    0x1c, 0x1d, 0x1e, 0x1f, 0x00, 0x00, 0x00, 0x05,
    0x00, 0x00, 0x00, 0x00, 0x07, 0x5b, 0xcd, 0x15,
    0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x07,
    0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x04,
    0x00, 0x01, 0x02, 0x03
    // name:
    0x00, 0x10, 0x56, 0x6f, 0x6c, 0x61, 0x74, 0x69,
    0x6c, 0x69, 0x74, 0x79, 0x20, 0x49, 0x6e, 0x64,
    0x65, 0x78,
    // symbol length:
    0x00, 0x03,
    // symbol:
    0x56, 0x49, 0x58,
    // denomination:
    0x02,
    // number of InitialStates:
    0x00, 0x00, 0x00, 0x01,
    // InitialStates[0]:
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01,
    0x00, 0x00, 0x00, 0x07, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x30, 0x39, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0xd4, 0x31, 0x00, 0x00, 0x00, 0x01,
    0x00, 0x00, 0x00, 0x02, 0x51, 0x02, 0x5c, 0x61,
    0xfb, 0xcf, 0xc0, 0x78, 0xf6, 0x93, 0x34, 0xf8,
    0x34, 0xbe, 0x6d, 0xd2, 0x6d, 0x55, 0xa9, 0x55,
    0xc3, 0x34, 0x41, 0x28, 0xe0, 0x60, 0x12, 0x8e,
    0xde, 0x35, 0x23, 0xa2, 0x4a, 0x46, 0x1c, 0x89,
    0x43, 0xab, 0x08, 0x59,
]
```

### 未签名操作Tx包含什么

未签名操作Tx包含`BaseTx`和 `Ops`. 这个类型的 `TypeID`是 `0x00000002`。

* **`BaseTx`**
* **`Ops`** 是一个可变长度的 [Transferable Ops](avm-transaction-serialization.md#transferable-ops)数组。


### Gantt 未签名操作Tx 规范

```text
+---------+--------------+-------------------------------------+
| base_tx : BaseTx       |                 size(base_tx) bytes |
+---------+--------------+-------------------------------------+
| ops     : []TransferOp |                 4 + size(ops) bytes |
+---------+--------------+-------------------------------------+
                         | 4 + size(ops) + size(base_tx) bytes |
                         +-------------------------------------+
```

### Proto 未签名操作Tx 规范

```text
message OperationTx {
    BaseTx base_tx = 1;          // size(base_tx)
    repeated TransferOp ops = 2; // 4 bytes + size(ops)
}
```

### 未签名操作Tx 示例

让我们来进行一个未签名操作tx，它使用前面例子中的输入和输出:

* `BaseTx`: `"Example BaseTx above" with TypeID set to 2`
* **`Ops`**: \[`"Example Transfer Op as defined above"`\]

```text
[
    BaseTx <- 0x0000000200000004ffffffffeeeeeeeeddddddddccccccccbbbbbbbbaaaaaaaa999999998888888800000001000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f000000070000000000003039000000000000d431000000010000000251025c61fbcfc078f69334f834be6dd26d55a955c3344128e060128ede3523a24a461c8943ab085900000001f1e1d1c1b1a191817161514131211101f0e0d0c0b0a09080706050403020100000000005000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f0000000500000000075bcd150000000200000007000000030000000400010203
    Ops <- [
        0x000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f00000001f1e1d1c1b1a191817161514131211101f0e0d0c0b0a090807060504030201000000000050000000d0000000200000003000000070000303900000003431100000000010000000251025c61fbcfc078f69334f834be6dd26d55a955c3344128e060128ede3523a24a461c8943ab0859,
    ]
]
=
[
    // base tx:
    0x00, 0x00, 0x00, 0x02,
    0x00, 0x00, 0x00, 0x04, 0xff, 0xff, 0xff, 0xff,
    0xee, 0xee, 0xee, 0xee, 0xdd, 0xdd, 0xdd, 0xdd,
    0xcc, 0xcc, 0xcc, 0xcc, 0xbb, 0xbb, 0xbb, 0xbb,
    0xaa, 0xaa, 0xaa, 0xaa, 0x99, 0x99, 0x99, 0x99,
    0x88, 0x88, 0x88, 0x88, 0x00, 0x00, 0x00, 0x01,
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
    0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
    0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
    0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
    0x00, 0x00, 0x00, 0x07, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x30, 0x39, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0xd4, 0x31, 0x00, 0x00, 0x00, 0x01,
    0x00, 0x00, 0x00, 0x02, 0x51, 0x02, 0x5c, 0x61,
    0xfb, 0xcf, 0xc0, 0x78, 0xf6, 0x93, 0x34, 0xf8,
    0x34, 0xbe, 0x6d, 0xd2, 0x6d, 0x55, 0xa9, 0x55,
    0xc3, 0x34, 0x41, 0x28, 0xe0, 0x60, 0x12, 0x8e,
    0xde, 0x35, 0x23, 0xa2, 0x4a, 0x46, 0x1c, 0x89,
    0x43, 0xab, 0x08, 0x59, 0x00, 0x00, 0x00, 0x01,
    0xf1, 0xe1, 0xd1, 0xc1, 0xb1, 0xa1, 0x91, 0x81,
    0x71, 0x61, 0x51, 0x41, 0x31, 0x21, 0x11, 0x01,
    0xf0, 0xe0, 0xd0, 0xc0, 0xb0, 0xa0, 0x90, 0x80,
    0x70, 0x60, 0x50, 0x40, 0x30, 0x20, 0x10, 0x00,
    0x00, 0x00, 0x00, 0x05, 0x00, 0x01, 0x02, 0x03,
    0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b,
    0x0c, 0x0d, 0x0e, 0x0f, 0x10, 0x11, 0x12, 0x13,
    0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b,
    0x1c, 0x1d, 0x1e, 0x1f, 0x00, 0x00, 0x00, 0x05,
    0x00, 0x00, 0x00, 0x00, 0x07, 0x5b, 0xcd, 0x15,
    0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x07,
    0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x04,
    0x00, 0x01, 0x02, 0x03
    // number of operations:
    0x00, 0x00, 0x00, 0x01,
    // transfer operation:
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
    0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
    0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
    0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
    0x00, 0x00, 0x00, 0x01, 0xf1, 0xe1, 0xd1, 0xc1,
    0xb1, 0xa1, 0x91, 0x81, 0x71, 0x61, 0x51, 0x41,
    0x31, 0x21, 0x11, 0x01, 0xf0, 0xe0, 0xd0, 0xc0,
    0xb0, 0xa0, 0x90, 0x80, 0x70, 0x60, 0x50, 0x40,
    0x30, 0x20, 0x10, 0x00, 0x00, 0x00, 0x00, 0x05,
    0x00, 0x00, 0x00, 0x0d, 0x00, 0x00, 0x00, 0x02,
    0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x07,
    0x00, 0x00, 0x30, 0x39, 0x00, 0x00, 0x00, 0x03,
    0x43, 0x11, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00,
    0x00, 0x00, 0x02, 0x51, 0x02, 0x5c, 0x61, 0xfb,
    0xcf, 0xc0, 0x78, 0xf6, 0x93, 0x34, 0xf8, 0x34,
    0xbe, 0x6d, 0xd2, 0x6d, 0x55, 0xa9, 0x55, 0xc3,
    0x34, 0x41, 0x28, 0xe0, 0x60, 0x12, 0x8e, 0xde,
    0x35, 0x23, 0xa2, 0x4a, 0x46, 0x1c, 0x89, 0x43,
    0xab, 0x08, 0x59,
]
```

### 未签名输入Tx 包含什么

未签名输入Tx 包含 `BaseTx`, `SourceChain` 和`Ins`, 这个类型的 `TypeID`是`0x00000003`。

* **`BaseTx`**
* **`SourceChain`** 是32字节的源区块链ID。
* **`Ins`** 是一个可变长度的[可转移输入](avm-transaction-serialization.md#transferable-input)数组。

### Gantt 未签名输入Tx 规范

```text
+---------+----------------------+-----------------------------+
| base_tx : BaseTx               |         size(base_tx) bytes |
+-----------------+--------------+-----------------------------+
| source_chain    : [32]byte     |                    32 bytes |
+---------+----------------------+-----------------------------+
| ins     : []TransferIn         |         4 + size(ins) bytes |
+---------+----------------------+-----------------------------+
                        | 36 + size(ins) + size(base_tx) bytes |
                        +--------------------------------------+
```

### Proto 未签名输入Tx 规范

```text
message ImportTx {
    BaseTx base_tx = 1;          // size(base_tx)
    bytes source_chain = 2;      // 32 bytes
    repeated TransferIn ins = 3; // 4 bytes + size(ins)
}
```

### 未签名输入Tx 示例

让我们进行一个未签名导入tx，使用前面例子中的输入:

* `BaseTx`: `“Example BaseTx as defined above”`, but with `TypeID` set to `3`
* `SourceChain`: `0x0000000000000000000000000000000000000000000000000000000000000000`
* `Ins`: `“Example SECP256K1 Transfer Input as defined above”`

```text
[
    BaseTx        <- 0x0000000300000004ffffffffeeeeeeeeddddddddccccccccbbbbbbbbaaaaaaaa999999998888888800000001000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f000000070000000000003039000000000000d431000000010000000251025c61fbcfc078f69334f834be6dd26d55a955c3344128e060128ede3523a24a461c8943ab085900000001f1e1d1c1b1a191817161514131211101f0e0d0c0b0a09080706050403020100000000005000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f0000000500000000075bcd150000000200000007000000030000000400010203
    SourceChain <- 0x0000000000000000000000000000000000000000000000000000000000000000
    Ins <- [
        f1e1d1c1b1a191817161514131211101f0e0d0c0b0a09080706050403020100000000005000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f0000000500000000075bcd15000000020000000300000007,
    ]
]
=
[
    // base tx:
    0x00, 0x00, 0x00, 0x03,
    0x00, 0x00, 0x00, 0x04, 0xff, 0xff, 0xff, 0xff,
    0xee, 0xee, 0xee, 0xee, 0xdd, 0xdd, 0xdd, 0xdd,
    0xcc, 0xcc, 0xcc, 0xcc, 0xbb, 0xbb, 0xbb, 0xbb,
    0xaa, 0xaa, 0xaa, 0xaa, 0x99, 0x99, 0x99, 0x99,
    0x88, 0x88, 0x88, 0x88, 0x00, 0x00, 0x00, 0x01,
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
    0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
    0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
    0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
    0x00, 0x00, 0x00, 0x07, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x30, 0x39, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0xd4, 0x31, 0x00, 0x00, 0x00, 0x01,
    0x00, 0x00, 0x00, 0x02, 0x51, 0x02, 0x5c, 0x61,
    0xfb, 0xcf, 0xc0, 0x78, 0xf6, 0x93, 0x34, 0xf8,
    0x34, 0xbe, 0x6d, 0xd2, 0x6d, 0x55, 0xa9, 0x55,
    0xc3, 0x34, 0x41, 0x28, 0xe0, 0x60, 0x12, 0x8e,
    0xde, 0x35, 0x23, 0xa2, 0x4a, 0x46, 0x1c, 0x89,
    0x43, 0xab, 0x08, 0x59, 0x00, 0x00, 0x00, 0x01,
    0xf1, 0xe1, 0xd1, 0xc1, 0xb1, 0xa1, 0x91, 0x81,
    0x71, 0x61, 0x51, 0x41, 0x31, 0x21, 0x11, 0x01,
    0xf0, 0xe0, 0xd0, 0xc0, 0xb0, 0xa0, 0x90, 0x80,
    0x70, 0x60, 0x50, 0x40, 0x30, 0x20, 0x10, 0x00,
    0x00, 0x00, 0x00, 0x05, 0x00, 0x01, 0x02, 0x03,
    0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b,
    0x0c, 0x0d, 0x0e, 0x0f, 0x10, 0x11, 0x12, 0x13,
    0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b,
    0x1c, 0x1d, 0x1e, 0x1f, 0x00, 0x00, 0x00, 0x05,
    0x00, 0x00, 0x00, 0x00, 0x07, 0x5b, 0xcd, 0x15,
    0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x07,
    0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x04,
    0x00, 0x01, 0x02, 0x03
    // source chain:
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    // input count:
    0x00, 0x00, 0x00, 0x01,
    // txID:
    0xf1, 0xe1, 0xd1, 0xc1, 0xb1, 0xa1, 0x91, 0x81,
    0x71, 0x61, 0x51, 0x41, 0x31, 0x21, 0x11, 0x01,
    0xf0, 0xe0, 0xd0, 0xc0, 0xb0, 0xa0, 0x90, 0x80,
    0x70, 0x60, 0x50, 0x40, 0x30, 0x20, 0x10, 0x00,
    // utxoIndex:
    0x00, 0x00, 0x00, 0x05,
    // assetID:
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
    0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
    0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
    0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
    // input:
    0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00, 0x00,
    0x07, 0x5b, 0xcd, 0x15, 0x00, 0x00, 0x00, 0x02,
    0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x07,
]
```

### 未签名输出Tx 包含什么

未签名输出Tx 包含`BaseTx`, `DestinationChain`和 `Outs`, 这个类型的`TypeID` 是 `0x00000004`。

* **`DestinationChain`** 是资金被导出到的32字节ID的链。
* **`Outs`** 是一个可变长度的[可转移输出](avm-transaction-serialization.md#transferable-output)数组。

### Gantt 未签名输出Tx规范

```text
+-------------------+---------------+--------------------------------------+
| base_tx           : BaseTx        |                  size(base_tx) bytes |
+-------------------+---------------+--------------------------------------+
| destination_chain : [32]byte      |                             32 bytes |
+-------------------+---------------+--------------------------------------+
| outs              : []TransferOut |                 4 + size(outs) bytes |
+-------------------+---------------+--------------------------------------+
                          | 36 + size(outs) + size(base_tx) bytes |
                          +---------------------------------------+
```

### Proto 未签名输出Tx规范

```text
message ExportTx {
    BaseTx base_tx = 1;            // size(base_tx)
    bytes destination_chain = 2;   // 32 bytes
    repeated TransferOut outs = 3; // 4 bytes + size(outs)
}
```

### 未签名输出Tx示例

Let’s make an unsigned export tx that uses the outputs from the previous examples:

* `BaseTx`: `“Example BaseTx as defined above”`, but with `TypeID` set to `4`
* `DestinationChain`: `0x0000000000000000000000000000000000000000000000000000000000000000`
* `Outs`: `“Example SECP256K1 Transfer Output as defined above”`

```text
[
    BaseTx           <- 0x0000000400000004ffffffffeeeeeeeeddddddddccccccccbbbbbbbbaaaaaaaa999999998888888800000001000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f000000070000000000003039000000000000d431000000010000000251025c61fbcfc078f69334f834be6dd26d55a955c3344128e060128ede3523a24a461c8943ab085900000001f1e1d1c1b1a191817161514131211101f0e0d0c0b0a09080706050403020100000000005000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f0000000500000000075bcd150000000200000007000000030000000400010203
    DestinationChain <- 0x0000000000000000000000000000000000000000000000000000000000000000
    Outs <- [
        000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f000000070000000000003039000000000000d431000000010000000251025c61fbcfc078f69334f834be6dd26d55a955c3344128e060128ede3523a24a461c8943ab0859,
    ]
]
=
[
    // base tx:
    0x00, 0x00, 0x00, 0x04
    0x00, 0x00, 0x00, 0x04, 0xff, 0xff, 0xff, 0xff,
    0xee, 0xee, 0xee, 0xee, 0xdd, 0xdd, 0xdd, 0xdd,
    0xcc, 0xcc, 0xcc, 0xcc, 0xbb, 0xbb, 0xbb, 0xbb,
    0xaa, 0xaa, 0xaa, 0xaa, 0x99, 0x99, 0x99, 0x99,
    0x88, 0x88, 0x88, 0x88, 0x00, 0x00, 0x00, 0x01,
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
    0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
    0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
    0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
    0x00, 0x00, 0x00, 0x07, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x30, 0x39, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0xd4, 0x31, 0x00, 0x00, 0x00, 0x01,
    0x00, 0x00, 0x00, 0x02, 0x51, 0x02, 0x5c, 0x61,
    0xfb, 0xcf, 0xc0, 0x78, 0xf6, 0x93, 0x34, 0xf8,
    0x34, 0xbe, 0x6d, 0xd2, 0x6d, 0x55, 0xa9, 0x55,
    0xc3, 0x34, 0x41, 0x28, 0xe0, 0x60, 0x12, 0x8e,
    0xde, 0x35, 0x23, 0xa2, 0x4a, 0x46, 0x1c, 0x89,
    0x43, 0xab, 0x08, 0x59, 0x00, 0x00, 0x00, 0x01,
    0xf1, 0xe1, 0xd1, 0xc1, 0xb1, 0xa1, 0x91, 0x81,
    0x71, 0x61, 0x51, 0x41, 0x31, 0x21, 0x11, 0x01,
    0xf0, 0xe0, 0xd0, 0xc0, 0xb0, 0xa0, 0x90, 0x80,
    0x70, 0x60, 0x50, 0x40, 0x30, 0x20, 0x10, 0x00,
    0x00, 0x00, 0x00, 0x05, 0x00, 0x01, 0x02, 0x03,
    0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b,
    0x0c, 0x0d, 0x0e, 0x0f, 0x10, 0x11, 0x12, 0x13,
    0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b,
    0x1c, 0x1d, 0x1e, 0x1f, 0x00, 0x00, 0x00, 0x05,
    0x00, 0x00, 0x00, 0x00, 0x07, 0x5b, 0xcd, 0x15,
    0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x07,
    0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x04,
    0x00, 0x01, 0x02, 0x03
    // destination_chain:
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    // outs[] count:
    0x00, 0x00, 0x00, 0x01,
    // assetID:
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
    0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
    0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
    0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
    // output:
    0x00, 0x00, 0x00, 0x07,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x30, 0x39,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xd4, 0x31,
    0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x02,
    0x51, 0x02, 0x5c, 0x61, 0xfb, 0xcf, 0xc0, 0x78,
    0xf6, 0x93, 0x34, 0xf8, 0x34, 0xbe, 0x6d, 0xd2,
    0x6d, 0x55, 0xa9, 0x55, 0xc3, 0x34, 0x41, 0x28,
    0xe0, 0x60, 0x12, 0x8e, 0xde, 0x35, 0x23, 0xa2,
    0x4a, 0x46, 0x1c, 0x89, 0x43, 0xab, 0x08, 0x59,
]
```

## Signed Transaction

A signed transaction is an unsigned transaction with the addition of an array of [credentials](avm-transaction-serialization.md#credentials).

### What Signed Transaction Contains

A signed transaction contains a `CodecID`, `UnsignedTx`, and `Credentials`.

* **`CodecID`** The only current valid codec id is `00 00`.
* **`UnsignedTx`** is an unsigned transaction, as described above.
* **`Credentials`** is an array of [credentials](avm-transaction-serialization.md#credentials). Each credential will be paired with the input in the same index at this credential.

### Gantt Signed Transaction Specification

```text
+---------------------+--------------+------------------------------------------------+
| codec_id            : uint16       |                                        2 bytes |
+---------------------+--------------+------------------------------------------------+
| unsigned_tx         : UnsignedTx   |                        size(unsigned_tx) bytes |
+---------------------+--------------+------------------------------------------------+
| credentials         : []Credential |                    4 + size(credentials) bytes |
+---------------------+--------------+------------------------------------------------+
                                     | 6 + size(unsigned_tx) + len(credentials) bytes |
                                     +------------------------------------------------+
```

### Proto Signed Transaction Specification

```text
message Tx {
    uint16 codec_id = 1;                 // 2 bytes
    UnsignedTx unsigned_tx = 2;          // size(unsigned_tx)
    repeated Credential credentials = 3; // 4 bytes + size(credentials)
}
```

### Signed Transaction Example

Let’s make a signed transaction that uses the unsigned transaction and credentials from the previous examples.

* **`CodecID`**: `0`
* **`UnsignedTx`**: `0x0000000100000004ffffffffeeeeeeeeddddddddccccccccbbbbbbbbaaaaaaaa999999998888888800000001000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f000000070000000000003039000000000000d431000000010000000251025c61fbcfc078f69334f834be6dd26d55a955c3344128e060128ede3523a24a461c8943ab085900000001f1e1d1c1b1a191817161514131211101f0e0d0c0b0a09080706050403020100000000005000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f0000000500000000075bcd150000000200000007000000030000000400010203`
* **`Credentials`** `0x0000000900000002000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1e1d1f202122232425262728292a2b2c2e2d2f303132333435363738393a3b3c3d3e3f00404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5e5d5f606162636465666768696a6b6c6e6d6f707172737475767778797a7b7c7d7e7f00`

```text
[
    CodecID     <- 0x0000
    UnsignedTx  <- 0x0000000100000004ffffffffeeeeeeeeddddddddccccccccbbbbbbbbaaaaaaaa999999998888888800000001000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f000000070000000000003039000000000000d431000000010000000251025c61fbcfc078f69334f834be6dd26d55a955c3344128e060128ede3523a24a461c8943ab085900000001f1e1d1c1b1a191817161514131211101f0e0d0c0b0a09080706050403020100000000005000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f0000000500000000075bcd150000000200000007000000030000000400010203
    Credentials <- [
        0x0000000900000002000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1e1d1f202122232425262728292a2b2c2e2d2f303132333435363738393a3b3c3d3e3f00404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5e5d5f606162636465666768696a6b6c6e6d6f707172737475767778797a7b7c7d7e7f00,
    ]
]
=
[
    // Codec ID
    0x00, 0x00,
    // unsigned transaction:
    0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x04, 
    0xff, 0xff, 0xff, 0xff, 0xee, 0xee, 0xee, 0xee,
    0xdd, 0xdd, 0xdd, 0xdd, 0xcc, 0xcc, 0xcc, 0xcc,
    0xbb, 0xbb, 0xbb, 0xbb, 0xaa, 0xaa, 0xaa, 0xaa, 
    0x99, 0x99, 0x99, 0x99, 0x88, 0x88, 0x88, 0x88,
    0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x02, 0x03, 
    0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b,
    0x0c, 0x0d, 0x0e, 0x0f, 0x10, 0x11, 0x12, 0x13,
    0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b,
    0x1c, 0x1d, 0x1e, 0x1f, 0x00, 0x00, 0x00, 0x07,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x30, 0x39,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xd4, 0x31,
    0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x02,
    0x51, 0x02, 0x5c, 0x61, 0xfb, 0xcf, 0xc0, 0x78, 
    0xf6, 0x93, 0x34, 0xf8, 0x34, 0xbe, 0x6d, 0xd2,
    0x6d, 0x55, 0xa9, 0x55, 0xc3, 0x34, 0x41, 0x28,
    0xe0, 0x60, 0x12, 0x8e, 0xde, 0x35, 0x23, 0xa2,
    0x4a, 0x46, 0x1c, 0x89, 0x43, 0xab, 0x08, 0x59,
    0x00, 0x00, 0x00, 0x01, 0xf1, 0xe1, 0xd1, 0xc1,
    0xb1, 0xa1, 0x91, 0x81, 0x71, 0x61, 0x51, 0x41,
    0x31, 0x21, 0x11, 0x01, 0xf0, 0xe0, 0xd0, 0xc0,
    0xb0, 0xa0, 0x90, 0x80, 0x70, 0x60, 0x50, 0x40,
    0x30, 0x20, 0x10, 0x00, 0x00, 0x00, 0x00, 0x05,
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
    0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
    0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
    0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
    0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00, 0x00,
    0x07, 0x5b, 0xcd, 0x15, 0x00, 0x00, 0x00, 0x02,
    0x00, 0x00, 0x00, 0x07, 0x00, 0x00, 0x00, 0x03,
    0x00, 0x00, 0x00, 0x04, 0x00, 0x01, 0x02, 0x03
    // number of credentials:
    0x00, 0x00, 0x00, 0x01,
    // credential[0]:
    0x00, 0x00, 0x00, 0x09, 0x00, 0x00, 0x00, 0x02,
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
    0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
    0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
    0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1e, 0x1d, 0x1f,
    0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27,
    0x28, 0x29, 0x2a, 0x2b, 0x2c, 0x2e, 0x2d, 0x2f,
    0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37,
    0x38, 0x39, 0x3a, 0x3b, 0x3c, 0x3d, 0x3e, 0x3f,
    0x00, 0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46,
    0x47, 0x48, 0x49, 0x4a, 0x4b, 0x4c, 0x4d, 0x4e,
    0x4f, 0x50, 0x51, 0x52, 0x53, 0x54, 0x55, 0x56,
    0x57, 0x58, 0x59, 0x5a, 0x5b, 0x5c, 0x5e, 0x5d,
    0x5f, 0x60, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66,
    0x67, 0x68, 0x69, 0x6a, 0x6b, 0x6c, 0x6e, 0x6d,
    0x6f, 0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76,
    0x77, 0x78, 0x79, 0x7a, 0x7b, 0x7c, 0x7d, 0x7e,
    0x7f, 0x00,
```

## UTXO

A UTXO is a standalone representation of a transaction output.

### What UTXO Contains

A UTXO contains a `CodecID`, `TxID`, `UTXOIndex`, `AssetID`, and `Output`.

* **`CodecID`** The only valid `CodecID` is `00 00`
* **`TxID`** is a 32-byte transaction ID. Transaction IDs are calculated by taking sha256 of the bytes of the signed transaction.
* **`UTXOIndex`** is an int that specifies which output in the transaction specified by **`TxID`** that this utxo was created by.
* **`AssetID`** is a 32-byte array that defines which asset this utxo references.
* **`Output`** is the [output](avm-transaction-serialization.md#transferable-output) object that created this utxo. The serialization of Outputs was defined above.

### Gantt UTXO Specification

```text
+--------------+----------+-------------------------+
| codec_id     : uint16   |                 2 bytes |
+--------------+----------+-------------------------+
| tx_id        : [32]byte |                32 bytes |
+--------------+----------+-------------------------+
| output_index : int      |                 4 bytes |
+--------------+----------+-------------------------+
| asset_id     : [32]byte |                32 bytes |
+--------------+----------+-------------------------+
| output       : Output   |      size(output) bytes |
+--------------+----------+-------------------------+
                          | 70 + size(output) bytes |
                          +-------------------------+
```

### Proto UTXO Specification

```text
message Utxo {
    uint16 codec_id = 1;     // 02 bytes
    bytes tx_id = 2;         // 32 bytes
    uint32 output_index = 3; // 04 bytes
    bytes asset_id = 4;      // 32 bytes
    Output output = 5;       // size(output)
}
```

### UTXO Example

Let’s make a UTXO from the signed transaction created above:

* **`CodecID`**: `0`
* **`TxID`**: `0xf966750f438867c3c9828ddcdbe660e21ccdbb36a9276958f011ba472f75d4e7`
* **`UTXOIndex`**: `0` = `0x00000000`
* **`AssetID`**: `0x000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f`
* **`Output`**: `"Example SECP256K1 Transferable Output as defined above"`

```text
[
    CodecID   <- 0x0000
    TxID      <- 0xf966750f438867c3c9828ddcdbe660e21ccdbb36a9276958f011ba472f75d4e7
    UTXOIndex <- 0x00000000
    AssetID   <- 0x000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f
    Output    <-     0x000000070000000000003039000000000000d431000000010000000251025c61fbcfc078f69334f834be6dd26d55a955c3344128e060128ede3523a24a461c8943ab0859
]
=
[
    // Codec ID:
    0x00, 0x00,
    // txID:
    0xf9, 0x66, 0x75, 0x0f, 0x43, 0x88, 0x67, 0xc3,
    0xc9, 0x82, 0x8d, 0xdc, 0xdb, 0xe6, 0x60, 0xe2,
    0x1c, 0xcd, 0xbb, 0x36, 0xa9, 0x27, 0x69, 0x58,
    0xf0, 0x11, 0xba, 0x47, 0x2f, 0x75, 0xd4, 0xe7,
    // utxo index:
    0x00, 0x00, 0x00, 0x00,
    // assetID:
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
    0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
    0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
    0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
    // output:
    0x00, 0x00, 0x00, 0x07, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x30, 0x39, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0xd4, 0x31, 0x00, 0x00, 0x00, 0x01,
    0x00, 0x00, 0x00, 0x02, 0x00, 0x01, 0x02, 0x03,
    0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b,
    0x0c, 0x0d, 0x0e, 0x0f, 0x10, 0x11, 0x12, 0x13,
    0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b,
    0x1c, 0x1d, 0x1e, 0x1f, 0x20, 0x21, 0x22, 0x23,
    0x24, 0x25, 0x26, 0x27,
]
```

<!--stackedit_data:
eyJoaXN0b3J5IjpbODQwNjgxMzQ3LDEzMDk5MDc5MzgsMTU0MD
k1Mjk2OCw1NjU5ODc1ODgsLTE2NDAxMTE1MDgsMTU3MjkyNTQ4
NSw2NjcxNDQ3MTUsNzA4NjM0ODUyLDEwNDc2NjgzMzYsLTEyOT
Y3MDY1MDcsMjA0NTYwNDA3MywtMTA0OTcxNjExMywtNTQ4NzU5
NDEwLC00MjM4MjQ3NTcsLTEwODE3MjA1NjAsNDE3MTI1MjA2LC
0yMDgyNDI5NDk2LDE4MjQ3NDA5NzEsLTE2MzM1OTUwNzIsMTA1
NTAzNzc3OF19
-->