---
描述:C-Chain是以太坊虚拟机(EVM)的一个实例
---

# 合约链 \(C-Chain\) API

_注意:以太坊有自己的`networkID`和`chainID`概念。这些与Avalanche的networkID和chainID没有关系，纯粹是EVM内部的_ [_C-Chain_](../../learn/platform-overview/#contract-chain-c-chain)_。在主网上，C-Chain使用`1` 和`43114` 作为这些值。在富士测试网中，它使用`1`和`43113`作为这些值。`networkID`和`chainID`也可以使用下面所示的`net_version`和`eth_chainId`方法获取_。

## 部署智能合约

## Ethereum APIs

### Ethereum API 端点

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

通过websocket端点与C-Chain交互:

```cpp
/ext/bc/C/ws
```

例如，要在localhost上通过websocket与C-Chain的以太坊api交互，你可以使用:

```cpp
ws://127.0.0.1:9650/ext/bc/C/ws
```

通过websocket端点与其他EVM实例交互:

```cpp
/ext/bc/blockchainID/ws
```

其中`blockchainID`是运行EVM的区块链的ID。

### 方法

#### 标准的Ethereum APIs

Avalanche提供了一个与Geth相同的API接口，但它只支持以下服务:

* `web3_`
* `net_`
* `eth_`
* `personal_`
* `txpool_`

您可以以与Geth交互相同的方式与这些服务交互。请参阅[Ethereum Wiki’s JSON-RPC Documentation](https://eth.wiki/json-rpc/API)和[Geth’s JSON-RPC Documentation](https://geth.ethereum.org/docs/rpc/server)了解此API的完整描述。

#### eth\_getAssetBalance

除了标准的以太坊api, Avalanche还提供了`eth_getAssetBalance`来检索C-Chain上第一类Avalanche原生令牌的余额\(不包括AVAX，它必须通过`eth_getBalance`获取\)。

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

## Avalanche 特定 APIs

### Avalanche 特定 API 端点

要与C链上的`avax` 特定的RPC调用交互:

```cpp
/ext/bc/C/avax
```

要与EVM AVAX端点的其他实例交互:

```cpp
/ext/bc/blockchainID/avax
```

### avax 输出

将资产从C链输出到X链。调用此方法后，必须在X-Chain上调用[' avm.import '](exchange-chain- X-Chain -api.md#avm-import)来完成传输。

Export an asset from the C-Chain to the X-Chain. After calling this method, you must call [`avm.import`](exchange-chain-x-chain-api.md#avm-import) on the X-Chain to complete the transfer.

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
* `assetID` 为资产的ID。要导出AVAX, 使用`"AVAX"`作为' `assetID`。
* 资产是从由`username` 和`password`控制的地址发送的。
* 
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

### avax.exportAVAX

**弃用—请使用** [**avax.export**](contract-chain-c-chain-api.md#avax-export).

将AVAX从C链发送到X链。调用此方法后，必须在X-Chain上调用[`avm.importAVAX`](exchange-chain-x-chain-api.md#avm-importavax)来完成传输。

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

* `txID` 是已完成的ExportTx的txid。

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

### avax.exportKey

获取控制给定地址的私钥。返回的私钥可以添加到具有' `avax.importKey`的用户。

#### 签名

```go
avax.exportKey({
    username: string,
    password:string,
    address:string
}) -> {privateKey: string}
```

**要求**

* `username` 必须控制 `address`.
* `address` 是要为其导出相应私钥的地址。它应该是十六进制格式。

**响应**

* `privateKey` 是代表控制`address`的私钥的CB58端编码字符串。它有一个`PrivateKey-`前缀，可以用来通过`avax.importKey`导入一个密钥。
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

### avax.getUTXOs

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
* 最多返回`limit`限制的UTXO。如果省略了`limit`或大于1024，则将其设置为1024。
* 此方法支持分页。`endIndex`表示返回的最后一个UTXO。要获取下一组UTXO，在下一个调用中使用`endIndex`的值作为`startIndex`。
* 如果省略`startIndex`，将获取`limit`以内的所有UTXO。
* 当使用分页时(即提供了`startIndex`)， UTXO不能保证在多个调用中是唯一的。也就是说，UTXO可能出现在第一次调用的结果中，然后在第二次调用中再次出现。
* 使用分页时，不能保证多个调用之间的一致性。也就是说，地址的UTXO集可能在调用过程中发生了变化。
* `encoding`设置返回UTXO的格式。可以是“cb58”或“hex”。默认为“cb58”。

#### **示例**

Suppose we want all UTXOs that reference at least one of `C-avax1yzt57wd8me6xmy3t42lz8m5lg6yruy79m6whsf`.

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

This gives response:

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

### avax.import

Finalize the transfer of a non-AVAX or AVAX from the X-Chain to the C-Chain. Before this method is called, you must call the X-Chain's [`avm.export`](exchange-chain-x-chain-api.md#avm-export) method to initiate the transfer.

#### Signature

```go
avax.import({
    to: string,
    sourceChain: string,
    username: string,
    password:string,
}) -> {txID: string}
```

**Request**

* `to` is the address the asset is sent to. This must be the same as the `to` argument in the corresponding call to the C-Chain's `export`.
* `sourceChain` is the ID or alias of the chain the asset is being imported from. To import funds from the X-Chain, use `"X"`.
* `username` is the user that controls `to`.

**Response**

* `txID` is the ID of the completed ImportTx.

#### Example Call

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

#### Example Response

```javascript
{
    "jsonrpc": "2.0",
    "result": {
        "txID": "6bJq9dbqhiQvoshT3uSUbg9oB24n7Ei6MLnxvrdmao78oHR9t"
    },
    "id": 1
}
```

### avax.importAVAX

**DEPRECATED—instead use** [**avax.import**](contract-chain-c-chain-api.md#avax-import)

Finalize a transfer of AVAX from the X-Chain to the C-Chain. Before this method is called, you must call the X-Chain's [`avm.exportAVAX`](exchange-chain-x-chain-api.md#avm-exportavax) method to initiate the transfer.

#### Signature

```go
avax.importAVAX({
    to: string,
    sourceChain: string,
    username: string,
    password:string,
}) -> {txID: string}
```

**Request**

* `to` is the address the AVAX is sent to. It should be in hex format.
* `sourceChain` is the ID or alias of the chain the AVAX is being imported from. To import funds from the X-Chain, use `"X"`.
* `username` is the user that controls `to`.

**Response**

* `txID` is the ID of the completed ImportTx.

#### Example Call

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

#### Example Response

```javascript
{
    "jsonrpc": "2.0",
    "result": {
        "txID": "LWTRsiKnEUJC58y8ezAk6hhzmSMUCtemLvm3LZFw8fxDQpns3"
    },
    "id": 1
}
```

### avax.importKey

Give a user control over an address by providing the private key that controls the address.

#### Signature

```go
avax.importKey({
    username: string,
    password:string,
    privateKey:string
}) -> {address: string}
```

**Request**

* Add `privateKey` to `username`'s set of private keys.

**Response**

* `address` is the address `username` now controls with the private key. It will be in hex format.

#### Example Call

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

#### Example Response

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
eyJoaXN0b3J5IjpbMTMzNDE3MTIwNiw1MDQ4MzkyNDksLTIwND
A2NjQzNTNdfQ==
-->