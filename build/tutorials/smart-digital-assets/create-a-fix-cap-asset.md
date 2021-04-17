# 创建固定上限资产

## 简介

本教程说明了如何将Avalanche用于创建并交易一项固定资本可替代资产。资产初始化时创建特定数量的资产，然后不再创建。

假设存在一项1千万股的收入分享协议（ISA），且不再创建更多股份。那就创建一项资产，其中一个单位的资产代表ISA的一股。

## 要求

你已经完成了Avalanche节点运行[Run an Avalanche Node](../../get-started.md) 并熟悉Avalanche的架构[Avalanche's architecture](../../../learn/platform-overview/)。

## 创建资产

X链上存在资产，因此要创建资产，我们要调用X链API方法avm.createFixedCapAsset。

我们的资产将存放于X链上 [X-Chain](../../../learn/platform-overview/#exchange-chain-x-chain), 因此要创建资产, 我们要调用`avm.createFixedCapAsset`, 它是X链的一种方法 [X-Chain’s API](../../avalanchego-apis/exchange-chain-x-chain-api.md)。

该方法的签名为：


```cpp
avm.createFixedCapAsset({
    name: string,
    symbol: string,
    denomination: int,  
    initialHolders: []{
        address: string,
        amount: int
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

* `name`(名称) 是资产的可读名称。不一定是唯一的。                                                
* `symbol`(符号) 是资产的缩写符号, 0至4个字符。不一定是唯一的。可能省略。
* `denomination`(面值) 确定了用户界面如何显示该资产的余额。如果面值为0，则100个单位的该资产即显示为100; 如果面值为1，则100个单位的该资产即显示为10.0;如果面值为2，则100个单位的该资产即显示为0.1，以此类推。
* 在X链上进行一项交易需要用AVAX支付交易费用。用户需要登陆`username`(用户名和)`password`(密码)。
* `initialHolders`(初始持有人)中的每个元素都指定了这个`address`(地址)持有的初始`amount`(数量)单位。 地址在初始时持有的金额单位。
* `from`(出处)是您想用于此操作的地址。如果省略，请根据需要使用您的任何地址。
* `changeAddr`(更改地址)是发送任何更改要求的地方。如果省略，更改将发送至用户控制下的地址。

### 响应

* `assetID`(资产ID)是新资产的ID。
* `changeAddr`(更改地址)是发送任何更改要求的地址。 

现在，开始创建资产。您需要将您控制的地址填入`address` (地址)，然后您才能控制所有新创建的资产，并能够在本教程中进行发送。

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     : 1,
    "method" :"avm.createFixedCapAsset",
    "params" :{
        "name": "ISA Shares",
        "symbol":"ISAS",
        "denomination": 0,
        "initialHolders": [
            {
                "address": "X-avax10pvk9anjqrjfv2xudkdptza654695uwc8ecyg5",
                "amount": 10000000
            }
        ],
        "from":["X-avax1s65kep4smpr9cnf6uh9cuuud4ndm2z4jguj3gp"],
        "changeAddr":"X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8",
        "username":"USERNAME GOES HERE",
        "password":"PASSWORD GOES HERE"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

这个响应包含资产ID, 同样也是下面交易的ID:

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "assetID":"keMuoTQSGjqZbNVTCcbrwuNNNv9eEEZWBaRY3TapcgjkoZmQ1",
        "changeAddr":"X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8"
    }
}
```

## 资产交易

### 查看余额

共计10,000,000个单位的资产\(股份\) 存在于由`initialHolders`(初始持有人)所指定的地址中。

要验证这一点, 我们需要调用[`avm.getBalance`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-getbalance):

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avm.getBalance",
    "params" :{
        "address":"X-avax10pvk9anjqrjfv2xudkdptza654695uwc8ecyg5",
        "assetID":"keMuoTQSGjqZbNVTCcbrwuNNNv9eEEZWBaRY3TapcgjkoZmQ1"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

响应确认，我们的资产创建成功，预期地址共持有10000000股股份:

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

现在, 调用[`avm.send`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-send), 发送100股股份。

如需发送股份，我们需要验证发送股份的用户。
因此，我们需要填写`username`(用户名)和`password`(密码)。

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avm.send",
    "params" :{
        "username":"USERNAME GOES HERE",
        "password":"PASSWORD GOES HERE",
        "assetID" :"keMuoTQSGjqZbNVTCcbrwuNNNv9eEEZWBaRY3TapcgjkoZmQ1",
        "amount"  :100,
        "to"      :"X-avax1t8sl0knfzly3t3sherctxwezy533ega3sxww2k"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

### 查看交易状态

上述调用的响应应如下所示：

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "txID":"2EAgR1YbsaJrwFiU4DpwjUfTLkt97WrjQYYNQny13AheewnxSR",
        "changeAddr": "X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8"
    }
}
```

`txID`是我们发送至网络的send（发送）交易的ID。`txID` is the ID of the `send` transaction we sent to the network.

After a second or two, the transaction should be finalized. We can check the status of the transaction with [`avm.getTxStatus`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-gettxstatus):

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avm.getTxStatus",
    "params" :{
        "txID":"2EAgR1YbsaJrwFiU4DpwjUfTLkt97WrjQYYNQny13AheewnxSR"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

The response should look like this:

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "status":"Accepted"
    }
}
```

You might also see that `status` is `Pending` if the network has not yet finalized it yet.

Now let’s check the balance of the `to` address:

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avm.getBalance",
    "params" :{
        "address":"X-avax1t8sl0knfzly3t3sherctxwezy533ega3sxww2k",
        "assetID":"keMuoTQSGjqZbNVTCcbrwuNNNv9eEEZWBaRY3TapcgjkoZmQ1"
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

* Called `createFixedCapAsset` to create a fixed cap asset
* Called `getBalance` to check address balances
* Called `send` to transfer a quantity of our asset

<!--stackedit_data:
eyJoaXN0b3J5IjpbNzAxMjg3MTc3LDE4OTA4MzY1NzAsLTE4Nj
Y1NjkyMDYsMTk3MTU5MzczOCwtMTM2NjYwOTQ5OSwtNTY2MDI4
MDM1XX0=
-->