# 创建可变资本

## 简介

本教程说明了如何创建一项可变资本可替代资产。资产初始化时，不存在资产，但可能铸造更多的资产单位。创建资产时，我们明确了哪些地址集合可能铸造更多单位。
本教程演示了如何创建可变上限的可替代资产。资产初始化资产为零，但可以铸造更多的资产。在创建资产时，我们会指定可以创建更多单位资产的地址集。

您可能好奇为什么我们要明确哪些地址集能够铸造更多单位的资产，而非单个地址。原因如下：

* **安全性:** 如果仅有一个地址能够铸造更多资产且该地址的私人密钥遗失，则无法再铸造更多单位资产。类似地，如果只有一个地址可以铸造更多的资产，没有什么可以阻止该地址的持有者单方面铸造尽可能多的资产。

* **灵活性:** 能够编码这样的逻辑很好，“Alice可以单方面铸造更多单位的资产，或者Dinesh, Ellin和Jamie其中两个人可以一起铸造更多单位的资产。”

假设我们想要发行代表公司股份的一项资产。开始时不存在股份，但随后可能创建更多股份。那就来创建这么一项资产吧。

## 要求

您已经完成了运行Avalanche节点[Run an Avalanche Node](../../get-started.md) 并且熟悉Avalanche的架构 [Avalanche's architecture](../../../learn/platform-overview/).

## 创建资产

资产都存放在X链上, 因此, 要创建资产, 我们要调用[X-Chain’s API](../../avalanchego-apis/exchange-chain-x-chain-api.md)的方法[`avm.createVariableCapAsset`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-createvariablecapasset)。

该方法的签名为：

```cpp
avm.createVariableCapAsset({
    name: string,
    symbol: string,
    denomination: int,
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

### 参数

* `name` is a human-readable name for our asset. Not necessarily unique. Between 0 and 128 characters.
* `symbol` is a shorthand symbol for this asset. Between 0 and 4 characters. Not necessarily unique. May be omitted.
* `denomination` determines how balances of this asset are displayed by user interfaces. If denomination is 0, 100 units of this asset are displayed as 100. If denomination is 1, 100 units of this asset are displayed as 10.0. If denomination is 2, 100 units of this asset are displays as .100, etc.
* `minterSets` is a list where each element specifies that `threshold` of the addresses in `minters` may together mint more of the asset by signing a minting transaction.
* Performing a transaction on the X-Chain requires a transaction fee paid in AVAX. `username` and `password` denote the user paying the fee.
* `from` are the addresses that you want to use for this operation. If omitted, uses any of your addresses as needed.
* `changeAddr` is the address any change will be sent to. If omitted, change is sent to one of the addresses controlled by the user.

### Response

* `assetID` is the ID of the new asset.
* `changeAddr` in the result is the address where any change was sent.

Later in this example, we’ll mint more shares, so be sure to replace at least 2 addresses in the second minter set with addresses your user controls.

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     : 1,
    "method" :"avm.createVariableCapAsset",
    "params" :{
        "name":"Corp. Shares",
        "symbol":"CS",
        "minterSets":[
            {
                "minters": [
                    "X-avax1ghstjukrtw8935lryqtnh643xe9a94u3tc75c7"
                ],
                "threshold": 1
            },
            {
                "minters": [
                    "X-avax1k4nr26c80jaquzm9369j5a4shmwcjn0vmemcjz",
                    "X-avax1yell3e4nln0m39cfpdhgqprsd87jkh4qnakklx",
                    "X-avax1ztkzsrjnkn0cek5ryvhqswdtcg23nhge3nnr5e"
                ],
                "threshold": 2
            }
        ],
        "from":["X-avax1s65kep4smpr9cnf6uh9cuuud4ndm2z4jguj3gp"],
        "changeAddr":"X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8",
        "username":"USERNAME GOES HERE",
        "password":"PASSWORD GOES HERE"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

The response should look like this:

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "assetID":"i1EqsthjiFTxunrj8WD2xFSrQ5p2siEKQacmCCB5qBFVqfSL2",
        "changeAddr":"X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8"
    }
}
```

## Mint the Asset

Right now 0 shares exist. Let’s mint 10M shares.

### Create the Unsigned Transaction

We’ll use [`avm.mint`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-mint) to mint the shares.

* `amount` is the number of shares that will be created.
* `assetID` is the ID of the asset we’re creating more of.
* `to` is the address that will receive the newly minted shares. Replace `to` with an address your user controls so that later you’ll be able to send some of the newly minted shares.
* `username` must be a user that holds keys giving it permission to mint more of this asset. That is, it controls at least _threshold_ keys for one of the minter sets we specified above.

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     : 1,
    "method" :"avm.mint",
    "params" :{
        "amount":10000000,
        "assetID":"i1EqsthjiFTxunrj8WD2xFSrQ5p2siEKQacmCCB5qBFVqfSL2",
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
        "txID":"E1gqPbkziu8AutqccRa9ioPWyEF3Vd7eMjDJ3UshjQPpLoREZ",
        "changeAddr": "X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8"
    }
}
```

We can check the status of the transaction we’ve just sent to the network using [`avm.getTxStatus`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-gettxstatus):

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     : 1,
    "method" :"avm.getTxStatus",
    "params" :{
        "txID":"E1gqPbkziu8AutqccRa9ioPWyEF3Vd7eMjDJ3UshjQPpLoREZ"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

This should give:

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "status": "Accepted"
    },
    "id": 1
}
```

## Trade the Asset

### Check a Balance

All 10M shares are controlled by the `to` address we specified in `mint`. To verify this, we’ll use [`avm.getBalance`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-getbalance):

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avm.getBalance",
    "params" :{
        "address":"X-avax1a202a8pu5w4vnerwzp84j68yknm6lf47drfsdv",
        "assetID":"i1EqsthjiFTxunrj8WD2xFSrQ5p2siEKQacmCCB5qBFVqfSL2"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

The response confirms that our asset creation was successful and that the expected address holds all 10,000,000 shares:

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "balance":10000000
    }
}
```

### Send the Asset

Let’s send 100 shares to another address by using [`avm.send`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-send). To do so:

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avm.send",
    "params" :{
        "username":"USERNAME GOES HERE",
        "password":"PASSWORD GOES HERE",
        "assetID" :"i1EqsthjiFTxunrj8WD2xFSrQ5p2siEKQacmCCB5qBFVqfSL2",
        "amount"  :100,
        "to"      :"X-avax1qwnlpknmdkkl22rhmad0dcn80wfasp2y3yg3x0"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

Let’s check the balances of the `to` address:

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avm.getBalance",
    "params" :{
        "address":"X-avax1qwnlpknmdkkl22rhmad0dcn80wfasp2y3yg3x0",
        "assetID":"i1EqsthjiFTxunrj8WD2xFSrQ5p2siEKQacmCCB5qBFVqfSL2"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

The response should be:

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "balance":100
    }
}
```

## Wrapping up

In this tutorial, we:

* Used `createVariableCapAsset` to create a variable-cap asset that represents shares.
* Used `mint` to mint more units of an asset.
* Used `getBalance` to check address balances.
* Used `send` to transfer shares.

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTEzMDU1MzU1MTMsMTc4OTU3MDY0NywtMT
kyNDI3MDE0MV19
-->