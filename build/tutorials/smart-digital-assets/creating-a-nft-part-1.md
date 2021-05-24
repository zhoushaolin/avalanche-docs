# 创建NFT \(第1部分\)

## 简介

在Avalanche上，数字商品用代币表示。有些代币是**同质化的**，这意味着一个代币可以与任何其他代币进行互换。例如，现实世界的货币是可替代的;一张5美元纸币被当作和其他5美元纸币一样对待。

Avalanche还支持非同质化代币(NFT)。根据定义，每个 NFT都是唯一的，不能与其他 NFT完全互换。例如，可能存在代表现实世界艺术品的NFT;每一件艺术品，就像每一个NFT一样，都是独一无二的。NFT代表数字稀缺，可能被证明比传统的同质化代币具有更大的实用性。

在本教程中，我们将使用AvalancheGo的API创建和发送NFT。在未来的教程中，我们将使用[AvalancheJS](.. ./../tools/ AvalancheJS /)创建一个自定义NFT家族，并更详细地探索NFT。

## 要求

你已经完成节点运行[Run an Avalanche Node](../../get-started.md) 熟悉Avalanche架构[Avalanche's architecture](../../../learn/platform-overview/)。 在本教程中, 我们使用 [Avalanche’s Postman collection](https://github.com/ava-labs/avalanche-postman-collection)来进行API调用。

## 创建NFT家族

每个NFT都归属一个**家族**，这个家族有名称和符号。每个家族由许多的**组**构成。家族中的组数量在创建家族时已经指定。我们的NFT将存在于X链上，因此要创建我们的NFT家族，我们将调用[`avm.createNFTAsset`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-createnftasset)，这是[X-Chain’s API](../../avalanchego-apis/exchange-chain-x-chain-api.md)的一个方法。

这个方法的签名是:

```cpp
avm.createNFTAsset({
    name: string,
    symbol: string,
    minterSets []{
        minters: []string,
        threshold: int
    },
    from: []string,
    changeAddr: string,
    username: string,
    password: string
}) ->
{
    assetID: string,
    changeAddr: string,
}
```

### **方法**

* [`avm.createNFTAsset`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-createnftasset)

**参数**

* `name` 是我们NFT家族的可读的名字。不一定是独一无二的。0到128个字符。
* `symbol` 是这个非功能性语言家族的一个速记符号。0到4个字符之间。不一定是独一无二的。可以省略。
* `minterSets` 是一个列表，其中每个元素指定`minters` 中地址的`threshold`可以通过签名铸造操作一起铸造更多的资产。
* 在X链上进行交易需要用AVAX支付交易费用。`username`和`password`表示支付费用的用户。
* `from` 是您要用于此操作的地址。如果省略，根据需要使用您的任何地址。
* `changeAddr` 是有任何变化都会发送到的地址。如果省略，更改将发送到您的任何地址。

### **响应**

* `assetID` 是我们将要创建的新资产的ID。
* `changeAddr` 结果是发送任何更改的地址。

在本例的后面，我们将创建一个NFT，因此一定要用用户控制的地址替换铸造器集中的至少一个地址。

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avm.createNFTAsset",
    "params" :{
        "name":"Family",
        "symbol":"FAM",
        "minterSets":[
            {
                "minters": [
                    "X-avax1ghstjukrtw8935lryqtnh643xe9a94u3tc75c7"
                ],
                "threshold": 1
            }
        ],
        "username":"USERNAME GOES HERE",
        "password":"PASSWORD GOES HERE"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

这个响应当如下:

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "assetID":"2X1YV4jpGpqezvj2khQdj1yEiXU1dCwsJ7DmNhQRyZZ7j9oYBp",
        "changeAddr":"X-avax1ghstjukrtw8935lryqtnh643xe9a94u3tc75c7"
    }
}
```

需要注意以下几点: 首先，除了创建一个NFT家族，AvalancheGo的[`avm.createNFTAsset`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-createnftasset) 也为每个被传递进来的'`minterSets`创建一个组。例如，如果`minterSets`有3个元素，NFT家族就有3个组。其次，注意响应中返回的`assetID`。这是新创建的NFT家族的`assetID`，稍后您将需要它来发布NFT。

你可能想知道为什么我们指定_sets_的地址，可以创造更多的单位的资产，而不是一个单一的地址。原因如下:
You may be wondering why we specify _sets_ of addresses that can mint more units of the asset rather than a single address. Here's why:

* **Security:** if only one address can mint more of the asset, and the private key for that address is lost, no more units can ever be minted. Similarly, if only one address can mint more of the asset, nothing stops the holder of that address from unilaterally minting as much as they want.
* **Flexibility:** it’s nice to be able to encode logic like, “Alice can unilaterally mint more units of this asset, or 2 of Dinesh, Ellin, and Jamie can together mint more.”

## Get UTXOs for NFT

NFT outputs don’t show up in calls to [`avm.getBalance`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-getbalance) or [`avm.getAllBalances`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-getallbalances). To see your NFTs, you have to call [`avm.getUTXOs`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-getutxos) and then parse the utxo to check for the type ID. NFT Mint Outputs have a type id of `00 00 00 0a` in hexidecimal \(`10` in decimal\) and NFT Transfer Outputs have a type id of `00 00 00 0b` in hexdecimal \(`11` in decimal\).

### **Method**

* [`avm.getUTXOs`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-getutxos)

### **Parameters**

* `addresses` are the addresses to fetch UTXOs for.

**Response:**

* `numFetched` is the total number of UTXOs in the response.
* `utxos` is an array of CB58 encoded strings.
* `endIndex` This method supports pagination. `endIndex` denotes the last UTXO returned.

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     : 1,
    "method" :"avm.getUTXOs",
    "params" :{
        "addresses":["X-avax1ghstjukrtw8935lryqtnh643xe9a94u3tc75c7"]
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

The response contains a list of UTXOs:

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "numFetched": "2",
        "utxos": [
            "116VhGCxiSL4GrMPKHkk9Z92WCn2i4qk8qdN3gQkFz6FMEbHo82Lgg8nkMCPJcZgpVXZLQU6MfYuqRWfzHrojmcjKWbfwqzZoZZmvSjdD3KJFsW3PDs5oL3XpCHq4vkfFy3q1wxVY8qRc6VrTZaExfHKSQXX1KnC",
            "11cxRVipJgtuHy1ZJ6qM7moAf3GveBD9PjHeZMkhk7kjizdGUu5RxZqhViaWh8dJa9jT9sS62xy73FubMAxAy8b542v3k8frTnVitUagW9YhTMLmZ6nE48Z9qXB2V9HHzCuFH1xMvUEj33eNWv5wsP3JvmywkwkQW9WLM"
        ],
        "endIndex": {
            "address": "X-avax1ghstjukrtw8935lryqtnh643xe9a94u3tc75c7",
            "utxo": "2iyUVo8XautXpZwVfp5vhSh4ASWbo67zmHbtx7SUJg2Qa8BHtr"
        }
    }
}
```

[`avm.getUTXOs`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-getutxos) returns 2 UTXOs. Let’s take the first one and decode it to confirm that it’s an [NFT Mint Output.](../../references/avm-transaction-serialization.md#nft-mint-output) First, we convert the Base58Check encoded string which is returned from [`avm.getUTXOs`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-getutxos) in to hex. The following [CB58](http://support.avalabs.org/en/articles/4587395-what-is-cb58) string:

```cpp
116VhGCxiSL4GrMPKHkk9Z92WCn2i4qk8qdN3gQkFz6FMEbHo82Lgg8nkMCPJcZgpVXZLQU6MfYuqRWfzHrojmcjKWbfwqzZoZZmvSjdD3KJFsW3PDs5oL3XpCHq4vkfFy3q1wxVY8qRc6VrTZaExfHKSQXX1KnC
```

is expressed in hexadecimal as:

```cpp
00 00 04 78 f2 39 8d d2 16 3c 34 13 2c e7 af a3 1f 0a c5 03 01 7f 86 3b f4 db 87 ea 55 53 c5 2d 7b 57 00 00 00 01 04 78 f2 39 8d d2 16 3c 34 13 2c e7 af a3 1f 0a c5 03 01 7f 86 3b f4 db 87 ea 55 53 c5 2d 7b 57 00 00 00 0a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 00 00 00 01 3c b7 d3 84 2e 8c ee 6a 0e bd 09 f1 fe 88 4f 68 61 e1 b2 9c
```

Now, we can decompose the hex into the UTXO’s individual components by referring to the [transaction serialization format](../../references/avm-transaction-serialization.md):

```cpp
NFT Mint Output

CodecID: 00 00
TXID: 04 78 f2 39 8d d2 16 3c 34 13 2c e7 af a3 1f 0a c5 03 01 7f 86 3b f4 db 87 ea 55 53 c5 2d 7b 57
Output Index: 00 00 00 01
AssetID: 04 78 f2 39 8d d2 16 3c 34 13 2c e7 af a3 1f 0a c5 03 01 7f 86 3b f4 db 87 ea 55 53 c5 2d 7b 57
TypeID: 00 00 00 0a
GroupID: 00 00 00 00
Locktime: 00 00 00 00 00 00 00 00
Threshold: 00 00 00 01
Address Count: 00 00 00 01
Addresses[0]: 3c b7 d3 84 2e 8c ee 6a 0e bd 09 f1 fe 88 4f 68 61 e1 b2 9c
```

Note that the `TypeID` is `00 00 00 0a` which is the correct type ID for an NFT Mint Output. Also note that the `GroupID` is `00 00 00 00`. This `GroupID` was created based on the number of `MinterSets` which I passed in to `avm.createNFTAsset`.

## Mint the Asset

Now that we have an NFT family and a group for the single `MinterSet` we’re able to create NFTs belonging to this group. To do that we call [`avm.mintNFT`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-mintnft):

### **Method**

* [`avm.mintNFT`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-mintnft)

### **Parameters**

* `assetID` is the ID of the NFT family.
* `payload` is an arbitrary CB58 encoded payload of up to 1024 bytes. In Part 2 \(**COMING SOON**\) we’ll explore creating a protocol around the NFT payload. For this tutorial, the payload is the string “AVA Labs”.
* `to` is the address that will receive the newly minted NFT. Replace `to` with an address your user controls so that later you’ll be able to send some of the newly minted NFT.
* `username` must be a user that holds keys giving it permission to mint more of this NFT. That is, it controls at least _threshold_ keys for one of the minter sets we specified above.
* `password` is the valid password for `username`

### **Response**

* `txID` is the transaction ID.
* `changeAddr` in the result is the address where any change was sent.

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     : 1,
    "method" :"avm.mintNFT",
    "params" :{
        "assetID":"2X1YV4jpGpqezvj2khQdj1yEiXU1dCwsJ7DmNhQRyZZ7j9oYBp",
        "payload":"2EWh72jYQvEJF9NLk",
        "to":"X-avax1a202a8pu5w4vnerwzp84j68yknm6lf47drfsdv",
        "username":"USERNAME GOES HERE",
        "password":"PASSWORD GOES HERE"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

The response contains the transaction’s ID:

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "txID":"x4fKx95KirTvqWCeiPZfnjB4xFdrTduymRKMouXTioXojdnUm",
        "changeAddr": "X-avax1a202a8pu5w4vnerwzp84j68yknm6lf47drfsdv"
    }
}
```

Similar to the previous step, we can now confirm that an NFT was minted by calling [`avm.getUTXOs`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-getutxos) and parsing the UTXO to confirm that we now have an [NFT Transfer Output](../../references/avm-transaction-serialization.md#nft-transfer-output).

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     : 1,
    "method" :"avm.getUTXOs",
    "params" :{
        "addresses":["X-avax1a202a8pu5w4vnerwzp84j68yknm6lf47drfsdv"]
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

This should give:

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "numFetched": "2",
        "utxos": [
            "11Do4RK6FchGXeoycKujR7atm3tvBz3qc64uoipCc5J74Sj1U4orM6vbBGSES8hnjgjZava9oPgmnbHxh2mBKjeXdvAqTRtYMHEacrveSzKgk7F8h8xi8JB9CddoiX8nbjZMYt1keGo5Rvpjh8dGymDWwRbV1FdnG5uDiiyU8uidc3P24",
            "11JL98R9yVoCaekrzP2PoCKJfCTin6vhTWU4h9TxqevEUnhiMo2j7F4DHxRpHq6BnFnHGAajhmiXgrdfUbbNd1izmdLVMwqe3UCTJWWLaJ6XUZ46R243T8NdhKXXJWC9GvcjFYMyiKRWvVnvFt7duzq8P8D53uhv1QfdQ9"
        ],
        "endIndex": {
            "address": "X-avax1a202a8pu5w4vnerwzp84j68yknm6lf47drfsdv",
            "utxo": "2qs3A1sBhVjFcXqRADJ7AorvoawVgMkNdgJi8eYNPABMKmdBYq"
        }
    },
    "id": 1
}
```

As in the previous step, we can now decode the CB58 encoded UTXO to hexidecimal and then decompose it to its individual components to confirm that we have the correct UTXO and type.

First, we convert the Base58Check encoded string which is returned from [`avm.getUTXOs`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-getutxos) in to hex. The following CB58 string:

```cpp
11Do4RK6FchGXeoycKujR7atm3tvBz3qc64uoipCc5J74Sj1U4orM6vbBGSES8hnjgjZava9oPgmnbHxh2mBKjeXdvAqTRtYMHEacrveSzKgk7F8h8xi8JB9CddoiX8nbjZMYt1keGo5Rvpjh8dGymDWwRbV1FdnG5uDiiyU8uidc3P24
```

is expressed in hexadecimal as:

```cpp
00 00 7d 07 0d 1e fe a6 4e 45 09 05 c6 11 ee b1 cf 61 9f 21 22 eb 17 db aa ea 9a fe 2d ff 17 be 27 6b 00 00 00 01 04 78 f2 39 8d d2 16 3c 34 13 2c e7 af a3 1f 0a c5 03 01 7f 86 3b f4 db 87 ea 55 53 c5 2d 7b 57 00 00 00 0b 00 00 00 00 00 00 00 08 41 56 41 20 4c 61 62 73 00 00 00 00 00 00 00 00 00 00 00 01 00 00 00 01 3c b7 d3 84 2e 8c ee 6a 0e bd 09 f1 fe 88 4f 68 61 e1 b2 9c
```

Now, we can decompose the hex into the UTXO’s individual components:

```cpp
NFT Mint Output

CodecID: 00 00
TXID: 7d 07 0d 1e fe a6 4e 45 09 05 c6 11 ee b1 cf 61 9f 21 22 eb 17 db aa ea 9a fe 2d ff 17 be 27 6b
Output Index: 00 00 00 01
AssetID: 04 78 f2 39 8d d2 16 3c 34 13 2c e7 af a3 1f 0a c5 03 01 7f 86 3b f4 db 87 ea 55 53 c5 2d 7b 57
TypeID: 00 00 00 0b
GroupID: 00 00 00 00
Payload Length: 00 00 00 08
Payload: 41 56 41 20 4c 61 62 73
Locktime: 00 00 00 00 00 00 00 00
Threshold: 00 00 00 01
Address Count: 00 00 00 01
Addresses[0]: 3c b7 d3 84 2e 8c ee 6a 0e bd 09 f1 fe 88 4f 68 61 e1 b2 9c
```

Note that the `TypeID` is `00 00 00 0b` which is the correct type id for an [NFT Transfer Output](../../references/avm-transaction-serialization.md#nft-transfer-output). Also, note that the Payload is included.

## Send the NFT

Now, you can send the NFT to anyone. To do that, use AvalancheGo’s [`avm.sendNFT`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-sendnft) API method.

**Method**

* [`avm.sendNFT`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-sendnft)

**Parameters**

* `assetID` is the ID of the NFT we’re sending.
* `to` is the address that will receive the newly minted NFT.
* `groupID` is the NFT group from which to send the NFT.
* `username` is the user that controls the NFT.
* `password` is the valid password for `username`

**Response**

* `txID` is the transaction ID.
* `changeAddr` in the result is the address where any change was sent.

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avm.sendNFT",
    "params" :{
        "assetID" :"2X1YV4jpGpqezvj2khQdj1yEiXU1dCwsJ7DmNhQRyZZ7j9oYBp",
        "to"      :"X-avax1ghstjukrtw8935lryqtnh643xe9a94u3tc75c7",
        "groupID" : 0,
        "username":"USERNAME GOES HERE",
        "password":"PASSWORD GOES HERE"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

The response confirms that our NFT Transfer Operation was successful:

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "txID": "txtzxcrzPx1sn38HWKU9PB52EpbpXCegbdHNxPNAYd9ZvezJq",
        "changeAddr": "X-avax1a202a8pu5w4vnerwzp84j68yknm6lf47drfsdv"0
    }
}
```

You can call [`avm.getUTXOs`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-getutxos) for the address which you sent the NFT to and decompose the returned UTXO, after converting from CB58 to hex, to confirm that there is a UTXO with type id `00 00 00 0b` in hex or `11` in decimal.

## Wrapping up

Blockchain technology and tokenomics represent a radical new way of representing digital assets. Non-fungible tokens allow scarce assets to be tokenized. In this tutorial, we:

* Used `createNFTAsset` to create a non-fungible asset family and group.
* Used `mintNFT` to mint units of an NFT to the group.
* Used `getUTXOs` to fetch UTXOs for an address. We then converted the CB58 encoded UTXO to hex and decomposed it to its individual components.
* Used `sendNFT` to transfer NFTs between addresses.

In Part 2 of this series, we’ll go more in-depth by using AvalancheJS to create a protocol for our NFT payload by issuing it to multiple groups.

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE0MzE3MjM5MDBdfQ==
-->