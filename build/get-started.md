# 准备开始：运行Avalanche节点

想要了解Avalanche，最快的方式是运行一个节点并进行网络互动。

如何运行Avalanche节点, 请参考链接:
{% embed url="https://youtu.be/c\_SjtCiOFdg" %}

在本教程中 \(预计时间: 10 分钟\), 我们将:
* 安装并运行一个Avalanche节点
* 连接到Avalanche
*  发送Send AVAX
* 将节点添加到验证程序集合

如果您的问题在FAQ中未能解决, 请在[Avalanche Discord](https://chat.avax.network/)中寻求帮助！我们会帮助您解决一切难题。

如果您对使用第三方托管节点或运行验证器感兴趣, 您可以查看以下网站。
[https://docs.avax.network/learn/community#blockchain-infrastructure-and-node-services] 

本教程主要面向开发人员, 以及对如何运行Avalanche平台感兴趣的人士。如果您只是对设置质押节点感兴趣，您可以查询[Set Up Avalanche Node With Installer](https://github.com/ava-labs/avalanche-docs/blob/master/build/tutorials/nodes-and-staking/set-up-node-with-installer.md)这个教程。
安装程序会自动执行整个安装过程，并将其设置为一个系统服务，无需人为操作。 您也可以尝试先按照本教程进行操作，然后再使用安装程序作为永久解决方案来设置节点。

## 要求

Avalanche雪崩协议是非常轻量级的协议，因此对计算机的要求不高。
最低要求如下:
* 硬件: CPU &gt; 2 GHz, 运行内存 &gt; 4 GB, 储存容量 &gt; 10 GB free space
* 操作系统: Ubuntu 18.04/20.04 或 MacOS &gt;= Catalina

## 运行Avalanche节点和发送资金

安装 AvalancheGo（即Avalanche节点的GO安装启用）, 并连接到Avalanche公测网。

### 下载 AvalancheGo

该节点是一个二进制程序。您可以在下载源代码后构建二进制程序，也可以下载预构建的二进制程序。二者选其一即可。‘、

如果您只是想要运行您自己的节点并对其进行质押，则更推荐下载[pre-built binary](get-started.md#binary) 

如果您是一名想在Avalanche上进行实验和构建的开发人员，则推荐根据源代码构建节点。

#### **源代码**
如果您想根据源代码构建节点，您需要先安装Go 1.15.5或更新版本。请遵循指示, [点击此处](https://golang.org/doc/install)。


运行Go, 版本至少是1.15.5 或者更高, 运行`echo $GOPATH`, 不应空白。

下载AvalancheGo存储库:

```cpp
go get -v -d github.com/ava-labs/avalanchego/...
```
用户注意事项: AvalancheGo使用Go模块, 因此您可以将[AvalancheGo repository](https://github.com/ava-labs/avalanchego) 复制到GOPATH以外的其他位置。

切换到 `avalanchego` 目录:

```cpp
cd $GOPATH/src/github.com/ava-labs/avalanchego
```
构建 AvalancheGo:

```cpp
./scripts/build.sh
```

二进制程序`avalanchego 就在avalanchego/build目录下`.

#### **二进制**

如果您想要下载一个预构建的二进制程序，而不是自己构建，请访问[releases page](https://github.com/ava-labs/avalanchego/releases), 并选择您需要的版本\(可能是最新版本.\)

在“资产”目录下，请选择适当的文件。

如果是Mac操作系统:  
下载: `avalanchego-macos-<VERSION>.zip`  
解压: `unzip avalanchego-macos-<VERSION>.zip`  
生成的文件夹, `avalanchego-<VERSION>`, contains the binaries.

For Linux on PCs or cloud providers:  
Download: `avalanchego-linux-amd64-<VERSION>.tar.gz`  
Unzip: `tar -xvf avalanchego-linux-amd64-<VERSION>.tar.gz`  
The resulting folder, `avalanchego-<VERSION>-linux`, contains the binaries.

For Linux on RaspberryPi4 or similar Arm64-based computers:  
Download: `avalanchego-linux-arm64-<VERSION>.tar.gz`  
Unzip: `tar -xvf avalanchego-linux-arm64-<VERSION>.tar.gz`  
The resulting folder, `avalanchego-<VERSION>-linux`, contains the binaries.

### Start a Node, and Connect to Avalanche

If you built from source:

```cpp
./build/avalanchego
```

If you are using the pre-built binaries on MacOS:

```cpp
./avalanchego-<VERSION>/build/avalanchego
```

If you are using the pre-built binaries on Linux:

```cpp
./avalanchego-<VERSION>-linux/avalanchego
```

When the node starts, it has to bootstrap \(catch up with the rest of the network\). You will see logs about bootstrapping. When a given chain is done bootstrapping, it will print a log like this:

`INFO [06-07|19:54:06] <X Chain> /snow/engine/avalanche/transitive.go#80: bootstrapping finished with 1 vertices in the accepted frontier`

To check if a given chain is done bootstrapping, in another terminal window call [`info.isBootstrapped`](avalanchego-apis/info-api.md#info-isbootstrapped) by copying and pasting the following command:

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"info.isBootstrapped",
    "params": {
        "chain":"X"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/info
```

If this returns `true`, the chain is bootstrapped. If you make an API call to a chain that is not done bootstrapping, it will return `API call rejected because chain is not done bootstrapping`. If your node never finishes bootstrapping, follow [this FAQ](http://support.avalabs.org/en/articles/4593908-is-my-node-done-bootstrapping), if you are still experiencing issues please contact us on [Discord.](https://chat.avalabs.org/)

Your node is running and connected now. If you want to use your node as a validator on the main net, check out [this tutorial](tutorials/nodes-and-staking/add-a-validator.md#add-a-validator-with-avalanche-wallet) to find out how to add your node as a validator using the web wallet.

You can use `Ctrl + C` to kill the node.

If you want to experiment and play with your node, read on.

To be able to make API calls to your node from other machines, when starting up the node include argument `--http-host=` \(e.g. `./build/avalanchego --http-host=`\)

To connect to the Fuji Testnet instead of the main net, use argument `--network-id=fuji`. You can get funds on the Testnet from the [faucet.](https://faucet.avax-test.network/)

### Create a Keystore User

Avalanche nodes provide a built-in **Keystore.** The Keystore manages users and is a lot like a [wallet](http://support.avalabs.org/en/articles/4587108-what-is-a-blockchain-wallet). A user is a password-protected identity that a client can use when interacting with blockchains. **You should only create a keystore user on a node that you operate, as the node operator has access to your plaintext password.** To create a user, call [`keystore.createUser`](avalanchego-apis/keystore-api.md#keystore-createuser):

```cpp
curl -X POST --data '{
     "jsonrpc": "2.0",
     "id": 1,
     "method": "keystore.createUser",
     "params": {
         "username": "YOUR USERNAME HERE",
         "password": "YOUR PASSWORD HERE"
     }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/keystore
```

The response should be:

```cpp
{
     "jsonrpc":"2.0",
     "result":{"success":true},
     "id":1
}
```

Now, you have a user on this node. Keystore data exists at the node level. Users you create on one node’s Keystore do not exist on other nodes but you can import/export users to/from the Keystore. See the [Keystore API](avalanchego-apis/keystore-api.md) to see how.

{% hint style="danger" %}
**You should only keep a small amount of your funds on your node.** Most of your funds should be secured by a mnemonic that is not saved to any computer.
{% endhint %}

### Create an Address

Avalanche is a platform of heterogeneous blockchains, one of which is the [X-Chain](../learn/platform-overview/#exchange-chain-x-chain), which acts as a decentralized platform for creating and trading digital assets. We are now going to create an address to hold AVAX on our node.

To create a new address on the X-Chain, call [`avm.createAddress`](avalanchego-apis/exchange-chain-x-chain-api.md#avm-createaddress), a method of the [X-Chain’s API](avalanchego-apis/exchange-chain-x-chain-api.md):

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :2,
    "method" :"avm.createAddress",
    "params" :{
        "username":"YOUR USERNAME HERE",
        "password":"YOUR PASSWORD HERE"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

If your node isn’t finished bootstrapping, this call will return status `503` with message `API call rejected because chain is not done bootstrapping`.

Note that we make this request to `127.0.0.1:9650/ext/bc/X`. The `bc/X` portion signifies that the request is being sent to the blockchain whose ID \(or alias\) is `X` \(i.e., the X-Chain\).

The response should look like this:

```cpp
{
    "jsonrpc":"2.0",
    "id":2,
    "result" :{
        "address":"X-avax1xeaj0h9uy7c5jn6fxjp0rg4g39jeh0hl27vf75"
    }
}
```

Your user now controls the address `X-avax1xeaj0h9uy7c5jn6fxjp0rg4g39jeh0hl27vf75` on the X-Chain. To tell apart addresses on different chains, the Avalanche convention is for an address to include the ID or alias of the chain it exists on. Hence, this address begins `X-`, denoting that it exists on the X-Chain.

### Send Funds From Avalanche Wallet to Your Node

{% hint style="warning" %}
_**Note: the instructions below move real funds.**_
{% endhint %}

Let’s move funds from the Avalanche Wallet to your node.

Go to [Avalanche Wallet](https://wallet.avax.network). Click `Access Wallet`, then `Mnemonic Key Phrase`. Enter your mnemonic phrase.

Click the `Send` tab on the left. For amount, select, `.002` AVAX. Enter the address of your node, then click `Confirm`.

![web wallet send tab](../.gitbook/assets/web-wallet-send-tab%20%284%29%20%284%29%20%285%29%20%285%29%20%286%29%20%287%29%20%284%29%20%281%29%20%289%29.png)

We can check an address’s balance of a given asset by calling `avm.getBalance`, another method of the X-Chain’s API. Let’s check that the transfer went through:

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :3,
    "method" :"avm.getBalance",
    "params" :{
        "address":"X-avax1xeaj0h9uy7c5jn6fxjp0rg4g39jeh0hl27vf75",
        "assetID"  :"AVAX"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

Note that AVAX has the special ID `AVAX`. Usually an asset ID is an alphanumeric string.

The response should indicate that we have `2,000,000 nAVAX` or `0.002 AVAX`.

```cpp
{
    "jsonrpc":"2.0",
    "id"     :3,
    "result" :{
        "balance":2000000,
        "utxoIDs": [
            {
                "txID": "x6vR85YPNRf5phpLAEC7Sd6Tq2PXWRt3AAHAK4BpjxyjRyhtu",
                "outputIndex": 0
            }
        ]
    }
}
```

### Send AVAX

Now, let’s send some AVAX by making an API call to our node:

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :5,
    "method" :"avm.send",
    "params" :{
        "assetID"    :"AVAX",
        "amount"     :1000,
        "to"         :"X-avax1w4nt49gyv4e99ldqevy50l2kz55y9efghep0cs",
        "changeAddr" :"X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8",
        "username"   :"YOUR USERNAME HERE",
        "password"   :"YOUR PASSWORD HERE"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

`amount` specifies the number of nAVAX to send.

If you want to specify a particular address where change should go, you can specify it in `changeAddr`. You can leave this field empty; if you do, any change will go to one of the addresses your user controls.

In order to prevent spam, Avalanche requires the payment of a transaction fee. The transaction fee will be automatically deducted from an address controlled by your user when you issue a transaction. Keep that in mind when you’re checking balances below.

{% page-ref page="../learn/platform-overview/transaction-fees.md" %}

When you send this request, the node will authenticate you using your username and password. Then, it will look through all the [private keys](http://support.avalabs.org/en/articles/4587058-what-are-public-and-private-keys) controlled by your user until it finds enough AVAX to satisfy the request.

The response contains the transaction’s ID. It will be different for every invocation of `send`.

```cpp
{
    "jsonrpc":"2.0",
    "id"     :5,
    "result" :{
        "txID":"2QouvFWUbjuySRxeX5xMbNCuAaKWfbk5FeEa2JmoF85RKLk2dD",
        "changeAddr" :"X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8"
    }
}
```

#### Checking the Transaction Status

This transaction will only take a second or two to finalize. We can check its status with [`avm.getTxStatus`](avalanchego-apis/exchange-chain-x-chain-api.md#avm-gettxstatus):

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :6,
    "method" :"avm.getTxStatus",
    "params" :{
        "txID":"2QouvFWUbjuySRxeX5xMbNCuAaKWfbk5FeEa2JmoF85RKLk2dD"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

The response should indicate that the transaction was accepted:

```cpp
{
    "jsonrpc":"2.0",
    "id"     :6,
    "result" :{
        "status":"Accepted"
    }
}
```

You might also see that `status` is `Processing` if the network has not yet finalized the transaction.

Once you see that the transaction is `Accepted`, check the balance of the `to` address to see that it has the AVAX we sent:

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :7,
    "method" :"avm.getBalance",
    "params" :{
        "address":"X-avax1w4nt49gyv4e99ldqevy50l2kz55y9efghep0cs",
        "assetID"  :"AVAX"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

The response should be:

```cpp
{
    "jsonrpc":"2.0",
    "id"     :7,
    "result" :{
        "balance":1000
    }
}
```

In the same fashion, we could check `X-avax1xeaj0h9uy7c5jn6fxjp0rg4g39jeh0hl27vf75` to see that AVAX we sent was deducted from its balance, as well as the transaction fee.

{% page-ref page="tutorials/nodes-and-staking/add-a-validator.md" %}

{% page-ref page="tools/avalanchejs/create-an-asset-on-the-x-chain.md" %}

{% page-ref page="tutorials/platform/create-a-new-blockchain.md" %}

{% page-ref page="tutorials/platform/create-a-subnet.md" %}

{% page-ref page="avalanchego-apis/" %}

{% page-ref page="references/" %}

<!--stackedit_data:
eyJoaXN0b3J5IjpbMTI2MjgzNDU1OCwtMTc0ODgzNzUyNCwtOT
cxNzcxMjc1LC0xNTg2MTAxODMsMTEzOTI3OTY2MCwxODAyNjQz
MjM1LC02MzEzMjMxNjksLTE1MDU1OTE5NjAsMTY2MzUzNTA0OC
wtNzg2MDY0NDcwLDU5OTg1OTk5MywtMTI0MTI3NTYxNiwtNzAw
NTAzNjc1LC0zMzk5NzM2NTUsMTE3NzEwMjg2NCw5Mjg0MTMyNj
VdfQ==
-->