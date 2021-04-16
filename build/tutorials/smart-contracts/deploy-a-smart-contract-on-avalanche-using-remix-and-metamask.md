# 使用Remix 和MetaMask在Avalanche 上部署智能合约

## 简介

![Primary Network](../../../.gitbook/assets/image%20%2821%29.png)
Avalanche的主网是一个包含三条链的子网：P链、X链和C链。C链是Avalanche雪人共识协议驱动以太坊虚拟机的一个实例。通过使用以太坊标准RPC调用，[C-Chain RPC](../../avalanchego-apis/contract-chain-c-chain-api.md) 能做到以太坊客户端能实现的一切。使用C链而非以太坊, 可以体验到Avalanche的所有好处。Avalanche的特性能够大幅提高DApps的性能和用户体验。

今天，我们来使用Remix 和MetaMask在Avalanche上部署并测试智能合约。

## 第1步：设置元掩码**MetaMask

Log in to MetaMask -&gt; Click the Network drop-down -&gt; Select Custom RPC

![metamask network dropdown](../../../.gitbook/assets/image%20%2860%29.png)

#### **Avalanche Mainnet Settings:**

* **Network Name**: Avalanche Mainnet C-Chain
* **New RPC URL**: [https://api.avax.network/ext/bc/C/rpc](https://api.avax.network/ext/bc/C/rpc)
* **ChainID**: `0xa86a`
* **Symbol**: `AVAX`
* **Explorer**: [https://cchain.explorer.avax.network/](https://cchain.explorer.avax.network/)

#### **FUJI Testnet Settings:**

* **Network Name**: Avalanche FUJI C-Chain
* **New RPC URL**: [https://api.avax-test.network/ext/bc/C/rpc](https://api.avax-test.network/ext/bc/C/rpc)
* **ChainID**: `0xa869`
* **Symbol**: `AVAX`
* **Explorer**: [https://cchain.explorer.avax-test.network](https://cchain.explorer.avax-test.network/)

#### **Local Testnet \(AVASH\) Settings:**

* **Network Name**: Avalanche Local
* **New RPC URL**:[ ](http://localhost:9650/ext/bc/C/rpc)[http://localhost:9650/ext/bc/C/rpc](http://localhost:9650/ext/bc/C/rpc)
* **ChainID**: `0xa868`
* **Symbol**: `AVAX`
* **Explorer**: N/A

## Step 2: Funding your C-Chain address

### **Using Avalanche Wallet**

On the main net, you can use the [Avalanche Wallet](https://wallet.avax.network/) to transfer funds from the X-Chain to your C-Chain address. The process is simple, as explained in this [tutorial](../platform/transfer-avax-between-x-chain-and-c-chain.md). Wallet can be used on test and local networks, too.

### **Using Test Network Faucet**

For funding on the test network, you can also use the Test Network Faucet. Navigate to [https://faucet.avax-test.network/](https://faucet.avax-test.network/) and paste your C-AVAX address. All you need to do is add a “C-” prefix and the faucet will switch from AVAX to C-AVAX.

### Funding on local testnet

On a local network, you can easily fund your addresses by deploying your own faucet. [Tutorial](https://medium.com/avalabs/the-ava-platform-tools-pt-2-the-ava-faucet-48f28da57146)

## Step 3: Connect MetaMask and deploy a smart contract using Remix

Open [Remix](https://remix.ethereum.org/) -&gt; Select Solidity

![remix file explorer](../../../.gitbook/assets/remix-file-explorer.png)

Load or create the smart contracts that we want to compile and deploy using Remix file explorer.

For this example, we will deploy an ERC20 contract from [OpenZeppelin](https://openzeppelin.com/contracts).

![ERC20 Contract](../../../.gitbook/assets/erc20-contract.png)

Navigate to Deploy Tab -&gt; Open the “ENVIRONMENT” drop-down and select Injected Web3 \(make sure MetaMask is loaded\)

![Deploy and run transactions](../../../.gitbook/assets/deploy-and-run-transactions.png)

Once we injected the web3-&gt; Go back to the compiler, and compile the selected contract -&gt; Navigate to Deploy Tab

![Solidity compiler](../../../.gitbook/assets/solidity-compiler.png)

Now, the smart contract is compiled, MetaMask is injected, and we are ready to deploy our ERC20. Click “Deploy.”

![Deploy erc20](../../../.gitbook/assets/deploy-erc20.png)

Confirm the transaction on the MetaMask pop up.

![Confirm ERC20](../../../.gitbook/assets/confirm-erc20.png)

Our contract is successfully deployed!

![Published metadata](../../../.gitbook/assets/published-metadata.png)

Now, we can expand it by selecting it from the “Deployed Contracts” tab and test it out.

![Interact with contract](../../../.gitbook/assets/interact-with-contract.png)

The contract ABI and Bytecode are available on the compiler tab.

![ABI bytecode](../../../.gitbook/assets/abi-bytecode.png)

If you had any difficulties following this tutorial or simply want to discuss Avalanche with us, you can join our community at [Discord](https://chat.avalabs.org/)!

<!--stackedit_data:
eyJoaXN0b3J5IjpbMTA1ODg1OTcwNCwtMTgzMDEzMDIzN119
-->