# 使用Remix 和MetaMask在Avalanche 上部署智能合约

## 简介

![Primary Network](../../../.gitbook/assets/image%20%2821%29.png)
Avalanche的主网是一个包含三条链的子网：P链、X链和C链。C链是Avalanche雪人共识协议驱动以太坊虚拟机的一个实例。通过使用以太坊标准RPC调用，[C-Chain RPC](../../avalanchego-apis/contract-chain-c-chain-api.md) 能做到以太坊客户端能实现的一切。使用C链而非以太坊, 可以体验到Avalanche的所有好处。Avalanche的特性能够大幅提高DApps的性能和用户体验。

今天，我们来使用Remix 和MetaMask在Avalanche上部署并测试智能合约。

## 第1步：设置MetaMask

登陆到 MetaMask -&gt; 点击网络下拉列表-&gt; 选择Custom RPC

![metamask network dropdown](../../../.gitbook/assets/image%20%2860%29.png)

#### **Avalanche主网设置:**

* **网络名**: Avalanche Mainnet C-Chain (Avalanche主网C链)
* **新 RPC URL**: [https://api.avax.network/ext/bc/C/rpc](https://api.avax.network/ext/bc/C/rpc)
* **链ID**: `0xa86a`
* **符号**: `AVAX`
* **浏览器**: [https://cchain.explorer.avax.network/](https://cchain.explorer.avax.network/)

#### **富士测试网设置：**

* **网络名**: Avalanche FUJI C-Chain (Avalanche富士C链)
* **新 RPC URL**: [https://api.avax-test.network/ext/bc/C/rpc](https://api.avax-test.network/ext/bc/C/rpc)
* **链ID**: `0xa869`
* **符号**: `AVAX`
* **浏览器**: [https://cchain.explorer.avax-test.network](https://cchain.explorer.avax-test.network/)

#### **本地测试网\(AVASH\) 设置:**

* **网络名**: Avalanche Local
* **新 RPC URL**:[ ](http://localhost:9650/ext/bc/C/rpc)[http://localhost:9650/ext/bc/C/rpc](http://localhost:9650/ext/bc/C/rpc)
* **链ID**: `0xa868`
* **符号**: `AVAX`
* **浏览器**: N/A

## ## 第2步：给C链地址充值

### **使用 Avalanche 钱包**

在主网上，您可以使用 [Avalanche Wallet](https://wallet.avax.network/) 将X链上的资金转到C链地址。方法很简单，教程[tutorial](../platform/transfer-avax-between-x-chain-and-c-chain.md)中有说明。测试网络和本地网络上均可使用该钱包。

### **使用测试网接口**

如需在测试网上充值，您还可以使用测试网接口。打开 [https://faucet.avax-test.network/](https://faucet.avax-test.network/) 粘贴C-AVAX地址。您只需添加一个“C-” 前缀 接口即会从AVAX切换为C-AVAX。

### 在本地测试网上充值

在本地网络上，通过配置您自己的接口，您可以很方便地给您的地址充值。[教程](https://medium.com/avalabs/the-ava-platform-tools-pt-2-the-ava-faucet-48f28da57146)

## Step 3: 连接MetaMask 并通过Remix部署智能合约

打开 [Remix](https://remix.ethereum.org/) -&gt; 选择Solidity

![remix file explorer](../../../.gitbook/assets/remix-file-explorer.png)

通过Remix文件资源浏览器，加载或创建我们想要编译并部署的智能合约。

本例中, 我们将从[OpenZeppelin](https://openzeppelin.com/contracts)部署一个ERC20 合约

![ERC20 Contract](../../../.gitbook/assets/erc20-contract.png)

导航到Deploy Tab -&gt; 打开 “ENVIRONMENT” 下拉列表并选择加入 Injected Web3 \(确保加载了MetaMask \)

![Deploy and run transactions](../../../.gitbook/assets/deploy-and-run-transactions.png)

一旦我们加入了web3-&gt; 返回编译器，并编译所选合约 -&gt; 导航至Deploy Tab

![Solidity compiler](../../../.gitbook/assets/solidity-compiler.png)

现在，智能合约已编译，MetaMask已加入，接着我们可以部署ERC20。点击“Deploy”。

![Deploy erc20](../../../.gitbook/assets/deploy-erc20.png)

确认MetaMask弹窗上的交易。
![Confirm ERC20](../../../.gitbook/assets/confirm-erc20.png)

我们的合约就部署成功了！

![Published metadata](../../../.gitbook/assets/published-metadata.png)

现在，我们可以在“Deployed Contracts”选项中选择ERC20，对其进行拓展。

![Interact with contract](../../../.gitbook/assets/interact-with-contract.png)

编译器选项上的合同ABI和Bytecode字节码均可用。
![ABI bytecode](../../../.gitbook/assets/abi-bytecode.png)

如果您在使用教程中有任何困难或是想和我们讨论Avalanche，您可以通过[Discord](https://chat.avalabs.org/)加入我们的社区！


<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE4OTc4NTM4MDIsMTAyNTY2OTM5LC0yMT
AzODMyMTgzLDE0MTgwODMyLC0xODMwMTMwMjM3XX0=
-->