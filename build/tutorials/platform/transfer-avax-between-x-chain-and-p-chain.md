# 在X链和P链之间转移AVAX

## 简介

AVAX代币存在于X链、P链和C链上，在X链上可以进行交易，在P链上可以在验证主网时作为权益质押，在C链上可以用于智能合约或支付天然气费用。Avalanche支持AVAX在这些链之间转移，将来，Avalanche将支持它们在各链之间进行更普遍的原子交换。在本教程中，我们将在X链和P链之间发送AVAX代币。

## 要求

您已完成入门指南[Getting Started](../../get-started.md)并且熟悉[Avalanche's architecture](../../../learn/platform-overview/)。

要想发送AVAX，你首先得有AVAX！您可以在交易所购买真正的AVAX，或者可以从[AVAX Test Faucet](https://faucet.avax-test.network)获得测试网络AVAX，这是一个免费试玩Avalanche的简易方法。

## 使用网络钱包转移AVAX

在各链之间转移AVAX最简单的方法是使用[Avalanche钱包](https://wallet.avax.network/)，这是一种安全获得和转移AVAX的非托管方式。

Avalanche钱包的源代码请参见[here](https://github.com/ava-labs/avalanche-wallet).

### 第一步 - 打开Avalanche钱包

![Image for post](../../../.gitbook/assets/wallet-x2p-01-login.png)

选择**Access Wallet**进入您的钱包。如果要将钱包连接到Avalanche主网以外的网络，请选择**Mainnet**，并选择要连接的网络。

### 第二步 - 登录您的钱包

您可以使用私人密钥、助记密钥口令、密钥库文件或Ledger Nano S登录您的钱包。

![Image for post](../../../.gitbook/assets/wallet-x2p-02-access.png)

登录成功后，您将看到您的余额、资产组合和各种其他信息。

### 第三步 - 进入跨链选项卡

![Image for post](../../../.gitbook/assets/wallet-x2p-03-earn.png)

在各链之间转移代币的功能在**Cross Chain**选项卡上。

### 第四步 - 输入转账金额

您将看到**Source Chain**和**Destination Chain**的选项。分别选择X链和P链。您将看到您的X链和P链余额，以及一个输入字段，用于输入要从源链转移到目的链的金额。

![Image for post](../../../.gitbook/assets/wallet-x2p-05-x-p.png)

输入您希望从X链转移到P链的金额。

### 第五步 - 确认交易

![Image for post](../../../.gitbook/assets/wallet-x2p-06-confirm.png)

点击**Confirm**、**Transfer**开始转账。

### 第六步 – 完成！

跨链转账分两个步骤：一个是从X链导出资金的交易，另一个是将资金导入P链的交易。钱包将同时执行这两项操作并显示其进度。

![Image for post](../../../.gitbook/assets/wallet-x2p-07-transfer.png)

就这样！您就成功把 AVAX 从X链转移到P链了！现在，您可以使用它们在Avalanche网络上进行验证或委托。

### 从P链转账到X链

要将AVAX转回X链，只需反向操作。

在**Source**和**Destination**下拉菜单中进行选择，将源链和目的链对调。其余步骤都是一样的：输入金额、确认和转账。

## 通过API调用从 X 链转账到P链

如果要在Avalanche网络上构建应用程序，您可能希望以编程方式进行转账，作为拓展功能的一部分。您可以通过在AvalancheGo节点上调用适当的应用程序接口来实现这一点。本教程的其余部分假设您可以访问AvalancheGo节点、X链上的AVAX代币，以及[created](../../avalanchego-apis/keystore-api.md#keystorecreateuser) 并存储在节点密钥库中的用户凭证。

下面的所有示例应用程序接口调用都假定节点在本地运行\（即侦听`127.0.0.1` \）。该节点可以连接到主网、测试网络或本地网络。在每种情况下，除了地址格式之外，应用程序接口调用和响应应该是相同的。该节点不需要是本地节点；您可以调用托管在其他地方的节点。

您可能已经注意到了，在使用Avalanche钱包转移AVAX时，跨链转账是一个双交易操作：

* 从X链导出AVAX
* 将AVAX导入P链

### 第一步 – 将AVAX导出X链

要导出AVAX，需调用X链的[`avm.exportAVAX`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-exportavax) 方法。

响应如下：

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avm.exportAVAX",
    "params" :{
        "to":"P-avax1wkmfja9ve3lt3n9ye4qp3l3gj9k2mz7ep45j7q",
        "destinationChain": "P",
        "amount": 5000000,
        "changeAddr": "X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8",
        "username":"myUsername",
        "password":"myPassword"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

其中`to`是用户控制的P链地址，`changeAddr`是发送变更的地址。您可以将`changeAddr`留空；如果留空，则变更将返回到用户控制的地址（有关创建新的P链地址的说明，请参见[here](../../avalanchego-apis/platform-chain-p-chain-api.md#platform-createaddress) ）。

请注意，导入和导出操作都需支付交易费。在本实例中，我们假设交易费用为`.001`AVAX。那么，上述导出实际上花费了`.006`AVAX；`.005` 进入P链，`.001`为交易费销毁。

确保您的导出金额大于交易费。否则，当您在P链上导入AVAX时，会不够支付交易费，最终您将在P链上获得_负的_ AVAX。

响应如下：

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "txID": "MqEaeWc4rfkw9fhRMuMTN7KUTNpFmh9Fd7KSre1ZqTsTQG73h",
        "changeAddr": "X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8",
    },
    "id": 1
}
```

我们可以通过调用[`avm.getTxStatus`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-gettxstatus)来验证该交易是否已被接受：

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "avm.getTxStatus",
    "params":{
        "txID":"MqEaeWc4rfkw9fhRMuMTN7KUTNpFmh9Fd7KSre1ZqTsTQG73h"
    },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

这表明我们的交易已被接受：

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "status": "Accepted"
    },
    "id": 1
}
```

我们也可以调用[`avm.getBalance`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-getbalance)来查看AVAX是否已从用户持有的地址中扣除:

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avm.getBalance",
    "params" :{
        "address":"X-ADDRESSGOESHERE",
        "assetID":"AVAX"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

扣除的金额是导出金额\(在本实例中为`.005` AVAX \)加上交易费。如果您的用户控制了多个 X链地址，AVAX可能是从它们的任意组合发出的。

### 第二步 - 将AVAX导入P链

转账还未完成。我们需要调用P链的 [`platform.importAVAX`](../../avalanchego-apis/platform-chain-p-chain-api.md#platform-importavax) 方法来完成转账。

调用如下：

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.importAVAX",
    "params": {
        "to":"P-avax1wkmfja9ve3lt3n9ye4qp3l3gj9k2mz7ep45j7q",
        "sourceChain":"X",
        "changeAddr":"P-avax103y30cxeulkjfe3kwfnpt432ylmnxux8r73r8u",
        "username":"myUsername",
        "password":"myPassword",
    },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/P
```

这将返回交易ID：

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "txID": "2sxo3ySETZ4xzXqAtgsUvZ5pdkqG4SML4c7Z7NoKLZcp77YNXC",
        "changeAddr":"P-avax103y30cxeulkjfe3kwfnpt432ylmnxux8r73r8u"
    },
    "id": 1
}
```

我们可以通过以下方式确认交易是否已被接受：

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avm.getTxStatus",
    "params" :{
        "txID":"2sxo3ySETZ4xzXqAtgsUvZ5pdkqG4SML4c7Z7NoKLZcp77YNXC"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

此处应该是`Committed`，表示转账已完成。我们也可以通过以下方式查看地址余额：

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.getBalance",
    "params":{
        "address":"P-avax1wkmfja9ve3lt3n9ye4qp3l3gj9k2mz7ep45j7q"
    },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/P
```

响应如下：

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "balance": "4000000",
        "utxoIDs": [
            {
                "txID": "2sxo3ySETZ4xzXqAtgsUvZ5pdkqG4SML4c7Z7NoKLZcp77YNXC",
                "outputIndex": 0
            }
        ]
    },
    "id": 1
}
```

请注意，我们看到的余额是从X链导出的金额\(`.004`AVAX\)减去交易费\(在本实例中为`.001`AVAX \)。现在，我们可以使用这个P链地址所持有的 AVAX 来提供质押，以验证主网。

## 以编程方式从P链转账到X链

现在，让我们把AVAX从P链转回X链。

同上，这也是一个双向交易操作。

* 从P链导出
* 导入X链

### 第一步 - 将AVAX 从P链导出

调用[`platform.exportAVAX`](../../avalanchego-apis/platform-chain-p-chain-api.md#platform-exportavax)完成这一操作：

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.exportAVAX",
    "params": {
        "to":"X-avax1fjn5rffqvny7uk3tjegjs6snwjs3hhgcpcxfax",
        "amount":3000000,
        "changeAddr":"P-avax103y30cxeulkjfe3kwfnpt432ylmnxux8r73r8u",
        "username":"myUsername",
        "password":"myPassword"
    },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

where `to` is the X-Chain address the AVAX is being sent to.

This returns the transaction ID, and we can check that the transaction was committed with another call to [`platform.getTxStatus`](../../avalanchego-apis/platform-chain-p-chain-api.md#platform-gettxstatus). Again, make sure that the amount you’re sending exceeds the transaction fee.

### Step 2 - Import AVAX to X-Chain

To finish our transfer from the P-Chain to the X-Chain, call [`avm.importAVAX`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-importavax):

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avm.importAVAX",
    "params" :{
        "to":"X-avax1fjn5rffqvny7uk3tjegjs6snwjs3hhgcpcxfax",
        "sourceChain":"P",
        "changeAddr": "X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8",
        "username":"myUsername",
        "password":"myPassword"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

Note that `to` is the same address specified in our call to [`platform.exportAVAX`](../../avalanchego-apis/platform-chain-p-chain-api.md#platform-exportavax).

Just as before, we can call [`avm.getBalance`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-getbalance) to verify the funds were received. The balance should have increased by `.003` AVAX minus the transaction fee.

## Wrapping Up

That’s it! Now, you can swap AVAX back and forth between the X-Chain and P-Chain, both by using the Avalanche Wallet, and by calling the appropriate API calls on an Avalanche node.

Now you can use the tokens on the P-Chain to [add a node as a validator](../nodes-and-staking/add-a-validator.md) on the Primary Network.

<!--stackedit_data:
eyJoaXN0b3J5IjpbMTAwOTkwMDUxOSwtODAwMjE4MzQ3XX0=
-->