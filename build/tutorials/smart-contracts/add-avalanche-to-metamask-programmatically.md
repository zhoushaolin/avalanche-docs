# 以编程方式将Avalanche网络添加到Metamask

对于技术不熟练的人来说，向Metamask添加新网络并不是一项简单的任务，而且很容易出错。为了帮助用户更容易地使用您的应用程序，尽可能地简化这个过程是很有用的。本教程将展示如何在前端应用程序中构建一个简单的按钮，该按钮将自动将Avalanche网络添加到MetaMask。

## EIP-3038 & MetaMask

[EIP-3038](https://eips.ethereum.org/EIPS/eip-3085)是一个[以太坊改进提议](https://eips.ethereum.org/)，它定义了一个RPC方法，用于将以太坊兼容的链添加到钱包应用程序。

自2021年3月以来，Metamask已经实现将EIP作为其Metamask[自定义网络API](https://consensys.net/blog/metamask/connect-users-to-layer-2-networks-with-the-metamask-custom-networks-api/)的一部分。

让我们看看它是如何工作的。

## 数据结构

要将Avalanche网络添加到Metamask，我们需要准备包含所有必要数据的数据结构。
To add the Avalanche network to Metamask, we need to prepare the data structures that will be contain all the necessary data.

Main network data:

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

Test network data:

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

## Adding the network

To add the network to MetaMask, we need to call the `wallet_addEthereumChain` method, exposed by the web3 provider. 

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
Where `injected` is initialized as a `web3-react/injected-connector` used to interface with MetaMask APIs. Usage for other popular web frameworks is similar. Replace `AVALANCHE_MAINNET_PARAMS` with `AVALANCHE_TESTNET_PARAMS` if you want to add the test network.

Typical usage pattern would be to expose a button calling that method if you get `Wrong Network` or `Error connecting` errors when attempting to establish a connection to MetaMask.

## User experience

When users first come to your dapp's website they need to approve connection to MetaMask. After they do that, if you don't detect successful web3 network connection, you can present them with a dialog asking them to confirm switch to a new network:

![wrong network](../../../.github/add-avalanche-to-metamask-01-wrong-network.png)

If they press the button, they are shown a dialog from MetaMask asking for approval to add the new network:

![add a network](../../../.github/add-avalanche-to-metamask-02-add-network.png)

If they approve, your app will be connected to the Avalanche network. Very easy, no need for any data entry, no chance of wrong data entry. And that's it, users are ready to interacy with your dapp!

## Conclusion

Dapps users are often not very technically sophisticated and onboarding them needs to be as seamless and easy as possible. Manually adding a new network to MetaMask is a hurdle than a certain percentage of your potential users will not be able to clear. Removing that requirement is a simple step that will enhance their experience and enable more users to get to actually use your dapp.

If you have any questions, problems, or ideas on how to improve, or simply want to join our developer community, you can contact us on our [Discord](https://chat.avalabs.org/) server.
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTgwMzMwNjA5N119
-->