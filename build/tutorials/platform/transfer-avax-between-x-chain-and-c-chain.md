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

### Step 6 - Done!

A cross-chain transfer is a two step process: first a transaction to export the funds from the X-Chain, and another to import it to the C-Chain. The wallet will do both and show its the progress while doing so.

![Image for post](../../../.gitbook/assets/wallet-x2c-03-done.png)

That's it! You've transferred AVAX from the X-Chain to C-Chain! Now you can use them to deploy smart contracts on C-Chain.

### Transfer from the C-Chain to X-chain

To return the AVAX back to the X-Chain, you need to do the transfer in the opposite direction.

Swap source and destination chain, by selecting them from the **Source** and **Destination** dropdown menu. The rest of the process is the same: enter the amount, confirm and transfer.

## Transferring from the X-Chain to C-Chain with API Calls

If you're building an application on the Avalanche network, you may want to do the transfer programmatically as part of some broader functionality. You can do that by calling the appropriate APIs on an AvalancheGo node. The rest of the tutorial assumes you have access to an AvalancheGo node, AVAX tokens on the X-Chain, and user credentials [created](../../avalanchego-apis/keystore-api.md#keystorecreateuser) and stored in the node's keystore.

All the example API calls below assume the node is running locally \(that is, listening on `127.0.0.1`\). The node can be connected to the main network, a test network or a local network. In each case, the API calls and responses should be the same, except for the address formats. The node need not be local; you can make calls to a node hosted elsewhere.

As you may have noticed while transferring AVAX using the Avalanche Wallet, a cross-chain transfer is a two transaction operation:

* Export AVAX from the X-Chain
* Import AVAX to the C-Chain

Before we can do the transfer, we need to set up the address on the C-Chain, along with the controlling key.

### Set Up Address and Key on the C-Chain

The X-Chain uses [Bech32](http://support.avalabs.org/en/articles/4587392-what-is-bech32) addresses and the C-Chain uses hex Ethereum Virtual Machine \(EVM\) addresses. There is no way to convert the address from one format to the other since they are both derived from a private key using a one-way cryptographic function.

In order to get around this, you can export a private key from the X-Chain and then import it to the C-Chain. This way, you can use the X-Chain address and change the X- prefix to a C- prefix in order to get the correct Bech32 address to use for the C-Chain.

First, export a private key from the X-Chain:

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

Response:

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "privateKey":"PrivateKey-2w4XiXxPfQK4TypYqnohRL8DRNTz9cGiGmwQ1zmgEqD9c9KWLq"
    }
}
```

Now, import the same private key to the C-Chain:

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

The response contains a hex-encoded EVM address:

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "address": "0x5Bf544EF123FE41B262295dBA41c5a9CFA8efDB4"
    },
    "id": 1
}
```

Now we have everything we need to transfer the tokens.

### Transfer from the X-Chain to C-Chain

Use the address corresponding to the private key you exported and switch to using the C- prefix in the [`avm.exportAVAX`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-exportavax) call:

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
eyJoaXN0b3J5IjpbMTk4MDEwNzgzOV19
-->