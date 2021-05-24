# 以编程方式将Avalanche网络添加到Metamask

对于技术不熟练的人来说，向Metamask添加新网络并不是一项简单的任务，而且很容易出错。为了帮助用户更容易地使用您的应用程序，尽可能地简化这个过程是很有用的。本教程将展示如何在前端应用程序中构建一个简单的按钮，该按钮将自动将Avalanche网络添加到MetaMask。

## EIP-3038 & MetaMask

[EIP-3038](https://eips.ethereum.org/EIPS/eip-3085)是一个[以太坊改进提议](https://eips.ethereum.org/)，它定义了一个RPC方法，用于将以太坊兼容的链添加到钱包应用程序。

自2021年3月以来，Metamask已经实现将EIP作为其Metamask[自定义网络API](https://consensys.net/blog/metamask/connect-users-to-layer-2-networks-with-the-metamask-custom-networks-api/)的一部分。

让我们看看它是如何工作的。

## 数据结构

要将Avalanche网络添加到Metamask，我们需要准备包含所有必要数据的数据结构。

主要的网络数据:

```javascript
export const AVALANCHE_MAINNET_PARAMS = {
    chainId: '0xa86a', // A 0x-prefixed hexadecimal chainId
    chainName: 'Avalanche Mainnet C-Chain',
    nativeCurrency: {
        name: 'Avalanche',
        symbol: 'AVAX',
        decimals: 18
    },
    rpcUrls: ['https://api.avax.network/ext/bc/C/rpc'],
    blockExplorerUrls: ['https://cchain.explorer.avax.network/']
}
```

测试网数据:

```javascript
export const AVALANCHE_TESTNET_PARAMS = {
    chainId: '0xa869', // A 0x-prefixed hexadecimal chainId
    chainName: 'Avalanche Testnet C-Chain',
    nativeCurrency: {
        name: 'Avalanche',
        symbol: 'AVAX',
        decimals: 18
    },
    rpcUrls: ['https://api.avax-test.network/ext/bc/C/rpc'],
    blockExplorerUrls: ['https://cchain.explorer.avax-test.network/']
}
```

## 添加到网络

要将网络添加到MetaMask，我们需要调用`wallet_addEthereumChain` 方法，该方法由web3提供程序公开。

```javascript
  function addAvalancheNetwork() {
    injected.getProvider().then(provider => {
      provider
        .request({
          method: 'wallet_addEthereumChain',
          params: [AVALANCHE_MAINNET_PARAMS]
        })
        .catch((error: any) => {
          console.log(error)
        })
    })
  }
```
这里`injected`被初始化为`web3-react/injected-connector`，用于与MetaMask API接口。其他流行的web框架也有类似的用法。如果要添加测试网络，请将`AVALANCHE_MAINNET_PARAMS` 替换为`AVALANCHE_TESTNET_PARAMS`。

典型的使用模式是，如果在试图建立到MetaMask的连接时出现`Wrong Network`或`Error connecting` 错误，则公开一个调用该方法的按钮。

## 用户体验

当用户第一次来到你的dapp网站，他们需要批准连接到MetaMask。之后，如果你没有检测到成功的web3网络连接，你可以跟他们对话，要求他们确认切换到一个新的网络:

![wrong network](../../../.github/add-avalanche-to-metamask-01-wrong-network.png)

如果他们按下按钮，会看到一个来自MetaMask的对话框，请求批准添加新的网络:

![add a network](../../../.github/add-avalanche-to-metamask-02-add-network.png)

如果他们批准，你的应用程序将连接到Avalanche网络。非常简单，不需要任何数据输入，没有错误数据输入的机会。就这样，用户已经准备好与您的dapp交互了!

## 结论

Dapps用户通常在技术上不是很复杂，他们需要尽可能无缝和简单。手动添加一个新的网络到MetaMask是一个障碍，有一定比例的潜在用户将无法跨越。删除要求是一个简单的步骤，这将提升他们的体验，并使更多的用户真正使用你的dapp。

如果你有任何疑问、问题或关于如何改进的想法，或者只是想加入我们的开发者社区，你可以通过我们的[Discord](https://chat.avalabs.org/)服务器联系我们。

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTEyNzcwOTIwNDZdfQ==
-->