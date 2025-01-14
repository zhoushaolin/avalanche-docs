---
描述:C链是以太坊虚拟机(EVM)的一个实例
---

# 合约链 \(C链\) API

_注意:以太坊有自己的`networkID`和 and `chainID`概念, 它们与Avalanche的networkID和chainID的概念没有关系，纯粹是在EVM内部的[_C链_](../../learn/platform-overview/#contract-chain-c-chain)上_。_在主网上，C链使用`1` 和`43114` 作为这些值。在富士测试网上，使用`1`和`43113`作为这些值。`networkID`和 and `chainID`也可以使用下面所示的`net_version`和`eth_chainId`方法获取_。

## 部署智能合约

## 以太坊API

### 以太坊API 端点

#### JSON-RPC 端点

通过JSON-RPC端点与C-Chain交互:

```cpp
/ext/bc/C/rpc
```

通过JSON-RPC端点与EVM的其他实例交互:

```cpp
/ext/bc/blockchainID/rpc
```

其中`blockchainID`是运行EVM的区块链的ID。

#### WebSocket 端点

通过Websocket端点与C-Chain交互:

```cpp
/ext/bc/C/ws
```

例如，要在localhost上通过websocket与C链的以太坊api交互，你可以使用:

```cpp
ws://127.0.0.1:9650/ext/bc/C/ws
```

通过websocket端点与其他EVM实例交互:

```cpp
/ext/bc/blockchainID/ws
```

其中where `blockchainID`是运行EVM的区块链的ID。

### 方法

#### 标准的以太坊API

Avalanche提供了一个与Geth相同的API接口，但它只支持以下服务:

* `web3_`
* `net_`
* `eth_`
* `personal_`
* `txpool_`

您可以以与Geth交互相同的方式与这些服务交互。请参阅[Ethereum Wiki’s JSON-RPC Documentation](https://eth.wiki/json-rpc/API) 和[Geth’s JSON-RPC Documentation](https://geth.ethereum.org/docs/rpc/server), 以获取这个API的完整描述。

#### 以太坊获取资产余额

除了标准的以太坊APIs, Avalanche还提供了`eth_getAssetBalance`来检索C链上的第一批Avalanche本地代币的余额\(不包括AVAX，它必须通过`eth_getBalance`才能获取\)。

**签名**

```cpp
eth_getAssetBalance({
    address: string,
    blk: BlkNrOrHash,
    assetID: string,
}) -> {balance: int}
```

* `address` 资产所有者
* `blk` 是要检索余额的块号或哈希
* `assetID` 要求余额的资产的Id

**调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "eth_getAssetBalance",
    "params": [
        "0x8723e5773847A4Eb5FeEDabD9320802c5c812F46",
        "latest",
        "3RvKBAmQnfYionFXMfW5P8TDZgZiogKbHjM8cjpu16LKAgF5T"
    ],
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/C/rpc
```

**响应示例**

```cpp
{
    "jsonrpc": "2.0",
    "id": 1,
    "result": "0x1388"
}
```

## Avalanche 特定的API

### Avalanche 特定的API 端点

要与C链上的`avax` 特定的RPC调用交互:

```cpp
/ext/bc/C/avax
```

要与EVM AVAX端点的其他实例交互:

```cpp
/ext/bc/blockchainID/avax
```

### avax 导出

将资产从C链导出到X链。调用此方法后，必须在X-Chain上调用[' avm.import '](exchange-chain- X-Chain -api.md#avm-import)来完成传输。

#### 签名

```cpp
avax.export({
    to: string,
    amount: int,
    assetID: string,
    username: string,
    password:string,
}) -> {txID: string}
```

* `to`资产被发送到的X-Chain地址。
* `amount` 是要发送的资产数量。
* `assetID` 为资产的ID。要导出AVAX, 使用 `"AVAX"`作为`assetID`。
* 资产是从由`username` 和and `password`控制的地址发送的。

#### 调用示例

```javascript
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avax.export",
    "params" :{
        "to":"X-avax1q9c6ltuxpsqz7ul8j0h0d0ha439qt70sr3x2m0",
        "amount": 500,
        "assetID": "2nzgmhZLuVq8jc7NNu2eahkKwoJcbFWXWJCxHBVWAJEZkhquoK",
        "username":"myUsername",
        "password":"myPassword"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/C/avax
```

#### 响应示例

```javascript
{
    "jsonrpc": "2.0",
    "result": {
        "txID": "2W5JuFENitZKTpJsy9igBpTcEeBKxBHHGAUkgsSUnkjVVGQ9i8"
    },
    "id": 1
}
```

### avax.导出AVAX

**弃用—请使用[**avax.export**](https://github.com/ava-labs/avalanche-docs/blob/master/build/avalanchego-apis/contract-chain-c-chain-api.md#avax-export)** 

将AVAX从C链发送到X链。调用此方法后，必须在X链上调用 [`avm.importAVAX`](exchange-chain-x-chain-api.md#avm-importavax)来完成传输。

#### 签名

```go
avax.exportAVAX({
    to: string,
    amount: int,
    destinationChain: string,
    from: []string, //optional
    changeAddr: string, //optional
    username: string,
    password:string,
}) -> {txID: string}
```

**要求**

* `from` 是发送AVAX的C链的地址, 是十六进制格式。
* `to`是AVAX发送到的C链的地址, 是bech32格式。
* `amount` 是要发送的nAVAX的数量。
* `destinationChain` 是AVAX被发送到的链。要将资金输出到X链，请使用`"X"`。
* `changeAddr` 是C链地址，任何更改都发送到此。它是十六进制格式。
* AVAX是由`username`控制的地址发送的。 

**响应**

* `txID` 是已完成导出的Tx的ID。

#### 调用示例

```javascript
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avax.exportAVAX",
    "params" :{
        "from": ["0x8db97C7cEcE249c2b98bDC0226Cc4C2A57BF52FC"],
        "to":"X-avax1q9c6ltuxpsqz7ul8j0h0d0ha439qt70sr3x2m0",
        "amount": 500,
        "destinationChain": "X",
        "changeAddr": "0x8db97C7cEcE249c2b98bDC0226Cc4C2A57BF52FC",
        "username":"myUsername",
        "password":"myPassword"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/C/avax
```

#### 响应示例

```javascript
{
    "jsonrpc": "2.0",
    "result": {
        "txID": "2ffcxdkiKXXA4JdyRoS38dd7zoThkapNPeZuGPmmLBbiuBBHDa"
    },
    "id": 1
}
```

### avax.导出密钥

获取控制给定地址的私人密钥。返回的私钥可以添加到具有 `avax.importKey`的用户。

#### 签名

```go
avax.exportKey({
    username: string,
    password:string,
    address:string
}) -> {privateKey: string}
```

**要求**

* `username` 必须控制`address`.
* `address` 是要为其导出相应私钥的地址。它应该是十六进制格式。

**响应**

* `privateKey` 是代表控制`address`的私钥的CB58端编码字符串。它有一个`PrivateKey-`前缀，可以用来通过`avax.importKey`导入一个密钥。.
* `privateKeyHex` 是代表控制`address`的私钥的十六进制字符串。它可以用于将帐户导入Metamask。

#### 调用示例

```javascript
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avax.exportKey",
    "params" :{
        "username" :"myUsername",
        "password":"myPassword",
        "address": "0xc876DF0F099b3eb32cBB78820d39F5813f73E18C"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/C/avax
```

#### 响应示例

```javascript
{
    "jsonrpc": "2.0",
    "result": {
        "privateKey": "PrivateKey-2o2uPgTSf3aR5nW6yLHjBEAiatAFKEhApvYzsjvAJKRXVWCYkE",
        "privateKeyHex": "0xec381fb8d32168be4cf7f8d4ce9d8ca892d77ba574264f3665ad5edb89710157"
    },
    "id": 1
}}
```

### avax获取UTXO

获取引用给定地址的UTXO。

#### **签名**

```cpp
avax.getUTXOs(
    {
        addresses: string,
        limit: int, //optional
        startIndex: { //optional
            address: string,
            utxo: string
        },
        sourceChain: string,
        encoding: string, //optional
    },
) -> 
{
    numFetched: int,
    utxos: []string,
    endIndex: {
        address: string,
        utxo: string
    }
}
```

* `utxos` 是一个UTXO列表，每个UTXO在`addresses`中至少引用一个地址。
* 最多返回`limit`限制上限的 UTXO。如果省略了`limit`或大于1024，则将其设置为1024。.
* 此方法支持分页。`endIndex`表示返回的最后一个UTXO。要获取下一组UTXO，在下一个调用中使用`endIndex`的值作`startIndex`。
* 如果省略`startIndex`，将获取`limit`以内的所有UTXO。
* 当使用分页时(即提供了`startIndex`)， UTXO不能保证在多个调用中是唯一的。也就是说，UTXO可能出现在第一次调用的结果中，然后在第二次调用中再次出现。
* 使用分页时，不能保证多个调用之间的一致性。也就是说，地址的UTXO集可能在调用过程中发生了变化。
* `encoding`设置返回UTXO的格式。可以是“cb58”或 or “hex”。默认为“cb58”。

#### **示例**

假设我们希望所有的UTXO至少引用一个 `C-avax1yzt57wd8me6xmy3t42lz8m5lg6yruy79m6whsf`。

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avax.getUTXOs",
    "params" :{
        "addresses":["C-avax1yzt57wd8me6xmy3t42lz8m5lg6yruy79m6whsf"],
        "sourceChain": "X",
        "startIndex": {
            "address": "C-avax1yzt57wd8me6xmy3t42lz8m5lg6yruy79m6whsf",
            "utxo": "22RXW7SWjBrrxu2vzDkd8uza7fuEmNpgbj58CxBob9UbP37HSB"
        },
        "encoding": "cb58"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/C/avax
```

响应如下:

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "numFetched": "3",
        "utxos": [
            "11QEQTor9xZ1TyCyq8aFVShdP7YjM1ug9KuPUuMpgvQVz5qjEzo244NbJomjciNUPqUr1cD455dXhVrVNopnMXTQrTFY5kqrEVAQ3Ng9AnapQrYVEYiWc32F5CQuD3N5sB1EhQmMdJr5pis1QLjMmRQmut7Maafwup1vEU",
            "11Eo6c9iUz3ERtmHbdUb3nzzMaqFffFQStshEsSTiFQP5xqfmeaeCFHCBajmoJUdQRHtkChGAmPucDfuCyBAEyGmmv2w8b7dX5sATxV7HxHZE4eak14GMGVEr7v3ij1B8mE82cymTJJz1X3PpRk2pTaxwEnLWfh1aAiTFC",
            "118mpEHsia5sYYvKUx4j56mA7i1yvmLNyynm7LcmehcJJwMVY65smT4kGQgyc9DULwuaLTrUcsqbQutCdajoJXBdPVqvHMkYBTYQKs7WSmTXH8v7iUVqZfphMnS7VxVjGU1zykeTnbuAoZt4cFMUJzd8JaZk5eC82zmLmT"
        ],
        "endIndex": {
            "address": "C-avax1yzt57wd8me6xmy3t42lz8m5lg6yruy79m6whsf",
            "utxo": "27q6nsuvtyT4mvXVnQQAXw1YKoTxCow5Qm91GZ678TU1SvUiC2"
        },
        "encoding": "cb58"
    },
    "id": 1
}
```

### avax.导入

将非AVAX或AVAX从X链转移到C链。在调用此方法之前，必须调用[`avm.export`](exchange-chain-x-chain-api.md#avm-export)方法来启动传输。

#### 签名

```go
avax.import({
    to: string,
    sourceChain: string,
    username: string,
    password:string,
}) -> {txID: string}
```

**要求**

* `to` 是资产被发送到的地址。这必须与对应C链`export`调用中的`to`参数相同。
* `sourceChain` 是要从其中导入资产的链的ID或别名。要从X链导入资金，请使用`"X"`。.
* `username` 是控制`to`的用户。

**响应**

* `txID` 是已完成导入的Tx的ID.

#### 调用示例

```javascript
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avax.import",
    "params" :{
        "to":"0x4b879aff6b3d24352Ac1985c1F45BA4c3493A398",
        "sourceChain":"X",
        "username":"myUsername",
        "password":"myPassword"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/C/avax
```

#### 响应示例

```javascript
{
    "jsonrpc": "2.0",
    "result": {
        "txID": "6bJq9dbqhiQvoshT3uSUbg9oB24n7Ei6MLnxvrdmao78oHR9t"
    },
    "id": 1
}
```

### avax.导入AVAX

**弃用—请使用**  [**avax.import**](https://github.com/ava-labs/avalanche-docs/blob/master/build/avalanchego-apis/contract-chain-c-chain-api.md#avax-import)

将AVAX从X链转移到C链。在调用此方法之前，必须调用[`avm.exportAVAX`](exchange-chain-x-chain-api.md#avm-exportavax) 方法来初始化传输。

#### 签名

```go
avax.importAVAX({
    to: string,
    sourceChain: string,
    username: string,
    password:string,
}) -> {txID: string}
```

**要求**

* `to` 是AVAX发送到的地址, 是十六进制格式。
* `sourceChain` 是从其中导入AVAX的链的ID或别名。要从X链导入资金，请使用`"X"`。.
* `username` 是控制`to`的用户.

**响应**

* `txID`是已完成输入的Tx的ID。.

#### 调用示例

```javascript
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avax.importAVAX",
    "params" :{
        "to":"0x4b879aff6b3d24352Ac1985c1F45BA4c3493A398",
        "sourceChain":"X",
        "username":"myUsername",
        "password":"myPassword"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/C/avax
```

#### 响应示例

```javascript
{
    "jsonrpc": "2.0",
    "result": {
        "txID": "LWTRsiKnEUJC58y8ezAk6hhzmSMUCtemLvm3LZFw8fxDQpns3"
    },
    "id": 1
}
```

### avax导入密钥

通过提供控制地址的私人密钥，让用户控制地址。

#### 签名

```go
avax.importKey({
    username: string,
    password:string,
    privateKey:string
}) -> {address: string}
```

**要求**

* 添加Add `privateKey` 到to `username`的私钥组。

**响应**

* `address`是`username`用私钥控制的地址。它将是十六进制格式。

#### 调用示例

```javascript
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avax.importKey",
    "params" :{
        "username" :"myUsername",
        "password":"myPassword",
        "privateKey":"PrivateKey-2o2uPgTSf3aR5nW6yLHjBEAiatAFKEhApvYzsjvAJKRXVWCYkE"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/C/avax
```

#### 响应示例

```javascript
{
    "jsonrpc": "2.0",
    "result": {
        "address": "0xc876DF0F099b3eb32cBB78820d39F5813f73E18C"
    },
    "id": 1
}
```

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTk4MjIzODQ5MCwtMTU5MjA4MzIyNiwtMT
c4NzMwMTA5MiwtNzg2MjYzNTc2LDEyMzc2MjMxNTQsMjA5NzYw
MDU3LC0xMTQ5NzMyMzgsLTE4ODk0NDc2MDAsLTM2MDAwOTc3MS
w1MDQ4MzkyNDksLTIwNDA2NjQzNTNdfQ==
-->