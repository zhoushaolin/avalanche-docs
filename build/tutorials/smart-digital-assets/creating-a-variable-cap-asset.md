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

* `name` (名称) 是资产的可读名称。不一定是唯一的。字符数0到128之间.
* `symbol`(符号) 是资产的缩写符号, 0至4个字符。不一定是唯一的。可省略。
* `denomination` (面值) 确定了用户界面如何显示该资产的余额。如果面值为0，则100个单位的该资产即显示为100; 如果面值为1，则100个单位的该资产即显示为10.0;如果面值为2，则100个单位的该资产即显示为0.1，以此类推。
* `minterSets` ' minintersets '是一个列表，其中每个元素指定`minters`中的地址的`threshold`可以通过签署一个铸造交易来一起铸造更多的资产。
* 在X链上进行一项交易需要用AVAX支付交易费用。`username`(用户名)和`password`(密码)表示支付费用的用户。
* `from` (发出地址)是您用于此操作的地址。如果省略，请根据需要使用您的任何地址。
* `changeAddr` (更改地址)是发送任何更改要求的地址。如果省略，更改将发送至用户控制下的任一地址。

### 响应

* `assetID` (资产ID)是新资产的ID。
* `changeAddr` (更改地址)是结果中发送任何更改要求的地址。

随后本例中，我们将铸造更多股份，因此请确保第二铸造机集合中填入至少2个地址。

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

响应应如下所示：

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

## 铸造资产

当前共计0股股份。让我们铸造1000万股股份。

### 创建未签署交易

我们将使用[`avm.mint`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-mint) 来铸造股份。

* `amount` (数额)是即将创建的股份的数量。
* `assetID` (资产ID)是我们创建更多资产的ID
* `to` (到达地址 )是将接收新铸造股份的地址。用您的用户控制的一个地址填入，接下来可以发送新铸造的股份。
* `username` (用户名)必须是持有密钥的用户，该密钥允许其创建更多该资产。换言之，它至少控制上文指定的一个铸币机集合的阈值密钥。

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

响应中包含了交易ID：

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

通过[`avm.getTxStatus`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-gettxstatus), 我们能够查看刚刚发送的网络交易状态：:

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

它应如下所示：

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "status": "Accepted"
    },
    "id": 1
}
```

## 交易资产

### 查看余额

共计1000万股股份由我们在`mint`中指定的地址`to`控制。 需要验证, 我们可以使用[`avm.getBalance`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-getbalance):

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

响应确认，我们的资产创建成功，预期地址共持有1000万股股份:
```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "balance":10000000
    }
}
```

### 发送资产

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
eyJoaXN0b3J5IjpbLTI2NDk4NzMzOSwtMTE0NjcwMTExMiwtMT
czOTY0OTAwNywxNzg5NTcwNjQ3LC0xOTI0MjcwMTQxXX0=
-->