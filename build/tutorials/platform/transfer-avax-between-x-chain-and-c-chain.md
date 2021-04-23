# 在X链和C链之间转移AVAX

## 简介

AVAX代币存在于X链、P链和C链上，在X链上可以进行交易，在P链上可以在验证主网时作为权益质押，在C链上可以用于智能合约或支付天然气费用。在本教程中，我们将在X链和C链之间发送AVAX代币。

## 要求

您已完成[Run an Avalanche Node](../../get-started.md) and 并且熟悉[Avalanche's architecture](../../../learn/platform-overview/).

要想发送AVAX，你首先得有AVAX！您可以在交易所购买真正的AVAX，或者可以从[AVAX Test Faucet](https://faucet.avax-test.network)获得测试网络AVAX，这是一个免费试玩Avalanche的简易方法。

## 使用网络钱包转移AVAX

在各链之间转移AVAX最简单的方法是使用[the Avalanche Wallet](https://wallet.avax.network/) ，这是一种安全获得和转移AVAX的非托管方式。

Avalanche钱包的源代码请参见[here](https://github.com/ava-labs/avalanche-wallet)。

### 第一步 - 打开Avalanche钱包

![Image for post](../../../.gitbook/assets/wallet-x2p-01-login.png)

选择**Access Wallet**进入您的钱包。如果要将钱包连接到Avalanche主网以外的网络，请选择**Mainnet**，并选择要连接的网络。

### 第二步 - 登录您的钱包

您可以使用私人密钥、助记密钥口令、密钥库文件或Ledger Nano S登录您的钱包。目前还不支持通过Ledger进行C链转账。

![Image for post](../../../.gitbook/assets/wallet-x2p-02-access.png)

登录成功后，您将看到您的余额、资产组合和各种其他信息。

### 第三步 - 进入跨链选项卡

![Image for post](../../../.gitbook/assets/wallet-x2p-03-earn.png)

在各链之间转移代币的功能在**Cross Chain**选项卡上。

### 第四步 - 输入转账金额

您将看到**Source Chain**和**Destination Chain**的选项。分别选择X链和C链。您将看到您的X链和C链余额，以及一个输入字段，用于输入要从源链转移到目的链的金额。

![Image for post](../../../.gitbook/assets/wallet-x2c-01-x-c.png)

输入您希望从X链转移到C链的金额。

### 第五步 - 确认交易

![Image for post](../../../.gitbook/assets/wallet-x2c-02-trasnfer.png)

点击**Confirm**、**Transfer**开始转账。

### 第六步 – 完成！

跨链转账分两个步骤：一个是从X链导出资金的交易，另一个是将资金导入C链的交易。钱包将同时执行这两项操作并显示其进度。

![Image for post](../../../.gitbook/assets/wallet-x2c-03-done.png)

就这样！您就成功把 AVAX 从X链转移到C链了！现在您可以用它们在C链上部署智能合同。

### 从C链转账到X链

要将AVAX转回X链，只需反向操作。

在**Source**和**Destination**下拉菜单中进行选择，将源链和目的链对调。其余步骤都是一样的：输入金额、确认和转账。

## 通过API 调用从 X 链转账到C链

如果要在Avalanche网络上构建应用程序，您可能希望以编程方式进行转账，作为拓展功能的一部分。您可以通过在AvalancheGo节点上调用适当的应用程序接口来实现这一点。本教程的其余部分假设您可以访问AvalancheGo节点、X链上的AVAX代币，以及[created](../../avalanchego-apis/keystore-api.md#keystorecreateuser) 并存储在节点密钥库中的用户凭证。

下面的所有示例应用程序接口调用都假定节点在本地运行\（即侦听`127.0.0.1` \）。该节点可以连接到主网、测试网络或本地网络。在每种情况下，除了地址格式之外，应用程序接口调用和响应应该是相同的。该节点不需要是本地节点；您可以调用托管在其他地方的节点。

您可能已经注意到了，在使用Avalanche钱包转移AVAX时，跨链转账是一个双交易操作：

* 将AVAX导出X链
* 将AVAX导入C链

进行转账之前，我们需要在C链上创建地址，还有控制密钥。

### 在C链上创建地址和密钥

X链使用[Bech32](http://support.avalabs.org/en/articles/4587392-what-is-bech32) 地址，C链使用十六进制以太坊虚拟机\(EVM \)地址。由于两者都是通过单向加密函数从私人密钥派生而来的，因此无法互相转换。

为了解决这个问题，您可以从X链导出一个私钥，然后将其导入C链。这样，您可以使用X链地址并将X前缀更改为C前缀，以获得可用于C链的正确 Bech32地址。

首先，从X链导出一个私钥：

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avm.exportKey",
    "params" :{
        "username" :"myUsername",
        "password":"myPassword",
        "address": "X-avax1jggdngzc9l87rgurmfu0z0n0v4mxlqta0h3k6e"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

响应：

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "privateKey":"PrivateKey-2w4XiXxPfQK4TypYqnohRL8DRNTz9cGiGmwQ1zmgEqD9c9KWLq"
    }
}
```

现在，将相同的私钥导入到C链：

```cpp
curl -X POST --data '{  
    "jsonrpc":"2.0",    
    "id"     :1,    
    "method" :"avax.importKey", 
    "params" :{ 
        "username" :"myUsername",   
        "password":"myPassword",    
        "privateKey":"PrivateKey-2w4XiXxPfQK4TypYqnohRL8DRNTz9cGiGmwQ1zmgEqD9c9KWLq"    
    }   
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/C/avax
```

该响应包含一个十六进制编码的以太坊虚拟机地址：

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "address": "0x5Bf544EF123FE41B262295dBA41c5a9CFA8efDB4"
    },
    "id": 1
}
```

现在，转移代币所需的一切准备工作都已完成。

### 从X链转账到C链

使用与导出的私人密钥相对应的地址，并在[`avm.exportAVAX`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-exportavax)调用中转为使用C前缀：

```cpp
curl -X POST --data '{  
    "jsonrpc":"2.0",    
    "id"     :1,    
    "method" :"avm.exportAVAX", 
    "params" :{ 
        "to":"C-avax1jggdngzc9l87rgurmfu0z0n0v4mxlqta0h3k6e",   
        "destinationChain": "C",    
        "amount": 5000000,  
        "username":"myUsername",    
        "password":"myPassword" 
    }   
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

Since your keystore user owns the corresponding private key on the C-Chain, you can now import the AVAX to the address of your choice. It’s not necessary to import it to the same address that it was exported to, so can import the AVAX to an address that you own in MetaMask or another third-party service.

```cpp
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

where `to` is a hex-encoded EVM address of your choice.

The response looks like this:

```cpp
{   
    "jsonrpc": "2.0",   
    "result": { 
        "txID": "LWTRsiKnEUJC58y8ezAk6hhzmSMUCtemLvm3LZFw8fxDQpns3" 
    },  
    "id": 1 
}
```

Note: there is no transaction fee for import transactions to the C Chain.

Once your AVAX has been transferred to the C-Chain, you can use it to deploy and interact with smart contracts.

## Transfer from the C-Chain to X-Chain

Now, you can move AVAX back from the C-Chain to the X-Chain. First we need to export:

```cpp
curl -X POST --data '{  
    "jsonrpc":"2.0",    
    "id"     :1,    
    "method" :"avax.exportAVAX",
    "params" :{ 
        "to":"X-avax1wkmfja9ve3lt3n9ye4qp3l3gj9k2mz7ep45j7q",   
        "amount": 5000000,  
        "username":"myUsername",    
        "password":"myPassword" 
    }   
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/C/avax
```

where `to` is the bech32 encoded address of an X-Chain address you hold. Make sure that the amount you export exceeds the transaction fee because both the export and import transactions will charge a transaction fee.

The response should look like this:

```cpp
{   
    "jsonrpc": "2.0",   
    "result": { 
        "txID": "2ZDt3BNwzA8vm4CMP42pWD242VZy7TSWYUXEuBifkDh4BxbCvj"    
    },  
    "id": 1 
}
```

To finish the transfer, call [`avm.importAVAX`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-importavax).

```cpp
curl -X POST --data '{  
    "jsonrpc":"2.0",    
    "id"     :1,    
    "method": "avm.importAVAX", 
    "params": { 
        "username":"myUsername",    
        "password":"myPassword",    
        "sourceChain": "C", 
        "to":"X-avax1wkmfja9ve3lt3n9ye4qp3l3gj9k2mz7ep45j7q"    
    }   
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

where `to` is the bech32 encoded address the X-Chain address which you sent the funds to in the previous step.

The response should look like this:

```cpp
{   
    "jsonrpc": "2.0",   
    "result": { 
        "txID": "2kxwWpHvZPhMsJcSTmM7a3Da7sExB8pPyF7t4cr2NSwnYqNHni"    
    },  
    "id": 1 
}
```

## Wrapping Up

That’s it! Now, you can swap AVAX back and forth between the X-Chain and C-Chain, both by using the Avalanche Wallet, and by calling the appropriate API calls on an Avalanche node.

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE5MDYyNTY4OTJdfQ==
-->