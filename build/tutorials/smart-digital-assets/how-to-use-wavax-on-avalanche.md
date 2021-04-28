# 在Avalanche上使用包装过的AVAX代币（WAVAX）

## 什么是WAVAX？

[AVAX](../../../#avalanche-avax-token)是Avalanche平台[Avalanche platform](../../../learn/platform-overview/)上的本地代币。合约链C链[Contract Chain \(C-Chain\)](../../../learn/platform-overview/#contract-chain-c-chain)上的很多智能约（即以太坊虚拟机实例）的设计目的是与以太坊ERC-20代币协作。为了在此类合约中使用AVAX，您必须使用与ERC-20兼容的包装过的AVAX（WAVAX）。

## 概述

若要将AVAX转化为WAVAX，你需将AVAX存入一个智能合约，它会锁住该AVAX然后发给你WAVAX。若要将WAVAX转化为AVAX，你需将该WAVAX归还给该智能合约，该智能合约会销毁WAVAX，并返还你的AVAX。

在这一教程中，你需要：

* 将MetaMask连接到 Avalanche 上
* 充值你的MetaMask账户 
* 将WAVAX合约上传至Remix
* 连接到预部署的WAVAX合约
* 将AVAX转化为WAVAX，再转回
* 将WAVAX作为一个自定义代币添加至MetaMask

## 连接 Metamask

[Metamask](https://metamask.io/)是一款流行的浏览器扩展插件，有了它，可以快捷地与以太坊和兼容的区块链（比如 Avalanche 的C链）交互。设置MetaMask并在其上创建一个账户不在本教程的范围内，但是网上有许多相关资源。

登录你的MetaMask账户后，连接上Avalanche的网络。点击“Network”的下拉项->选择**Custom RPC**：

![metamask network dropdown](../../../.gitbook/assets/image%20%2860%29.png)

输入所选网络的信息：

### Avalanche 主网设置:

* **网络名Network Name**: Avalanche Mainnet C-Chain
* **New RPC URL**: [https://api.avax.network/ext/bc/C/rpc](https://api.avax.network/ext/bc/C/rpc)
* **ChainID**: `0xa86a`
* **标志Symbol**: `AVAX`
* **浏览器Explorer**: [https://cchain.explorer.avax.network/](https://cchain.explorer.avax.network/)

### 富士测试网设置：

* **网络名Network Name**: Avalanche Fuji C-Chain
* **New RPC URL**: [https://api.avax-test.network/ext/bc/C/rpc](https://api.avax-test.network/ext/bc/C/rpc)
* **ChainID**: `0xa869`
* **标志Symbol**: `AVAX`
* **浏览器Explorer**: [https://cchain.explorer.avax-test.network](https://cchain.explorer.avax-test.network/)

保存更改后，选择你刚刚指定的Avalanche网络。你应该会看到你的AVAX余额，它将可能是0。

## 充值您的C链账户

你需要在你的账户中放一些AVAX。

### **使用Avalanche钱包**

如果你已经有些AVAX，你可以使用你的Avalanche钱包[Avalanche Wallet](https://wallet.avax.network/)，将其汇入你的MetaMask账户。通过选择钱包面板中“**show breakdown**, 可以看到你的资金在哪, 查看你的余额。如果你的C链中还没有资金，你需要进行一次交叉链转移[Cross Chain Transfer](../platform/transfer-avax-between-x-chain-and-c-chain.md)，以将你的AVAX从X链转入C链。

你的C链中有资金后，在钱包面板的左边菜单中选择“**Send**”，然后将源链切换成在“**C Contract**”。在“**To Address**”区，粘贴你的MetaMask地址。输入要发送的金额，点击“**Confirm**”，然后点击“**Send**”。

![Send to Metamask](../../../.gitbook/assets/wavax2avax-01-send-to-metamask.png)

应该不久就能在你的MetaMask账户上看到资金。

### **使用测试网络接口**

如果你连接的是测试网络，你可以使用测试网络接口充值你的MetaMask账户。浏览[the faucet](https://faucet.avax-test.network/) ，然后粘贴你的以太坊地址（它显示在Metamask中账户名的下方, 如`0xDd1749831fbF70d88AB7bB07ef7CD9c53D054a57`）。当你点击账户名时，账户名会被复制到剪贴板。

![Faucet funding](../../../.gitbook/assets/wavax2avax-02-faucet.png)

将该地址粘入“接口”区，证明你不是机器人，然后请求测试AVAX，应该很快就能在你的MetaMask账户中看到。

## 将WAVAX合约载入Remix

Remix是一款流行的基于浏览器的编写、部署智能合约并与其交互的工具。浏览[Remix's website](https://remix.ethereum.org/)。向下滚动，直到你看见输入合约选项。

![Import from GitHub](../../../.gitbook/assets/wavax2avax-03-remix-import.png)

选择**GitHub**，在输入区粘贴`https://raw.githubusercontent.com/ava-labs/wrapped-assets/main/WAVAX.sol`，然后选择“**OK**”。这样就将合约载入Remix了。

![File Explorer](../../../.gitbook/assets/wavax2avax-04-contract.png)

在左边切换至文件资源管理器标签，然后选择`WAVAX.sol`，即我们刚刚载入的合约。

在左侧菜单中，切换到Compile选项卡:

![Compile](../../../.gitbook/assets/wavax2avax-05-compile.png)

检查该编译器是否与所示合约兼容。长按“**Compile WAVAX.sol**”按钮，检查WAVAX合约是否已经出现在下面的`CONTRACT` 区。现在，你可以准备连接WAVAX合约了，该合约已在Avalanche网络中部署好了。

## #连接WAVAX合约

Switch to the **Deploy & Run Tranasactions** tab on the left side.

![Connect](../../../.gitbook/assets/wavax2avax-06-deploy.png)

Make sure you're logged in to your Metamask. In the **Environment** dropdown menu, select `Injected Web3`. Metamask will pop up and ask you to select the account. Choose the one connected to Avalanche and allow it to connect. This will pre-fill the **Account** field. Make sure the **Contract** field is set to the `WAVAX` contract. Now we can connect to the contract, which has already published on Avalanche. In the **At Address** edit field, copy:

* For Mainnet: `0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7`
* For Fuji Testnet: `0xd00ae08403B9bbb9124bB305C09058E32C39A48c`

After pasting the address, press the **At Address** button.

Remix should find the deployed contract:

![Connect](../../../.gitbook/assets/wavax2avax-07-avalanche-contract.png)

We are now ready to interact with the contract. Open the contract interface by pressing the highlighted arrow.

## Issue Commands to the WAVAX Contract

Let's wrap some AVAX!

Since ETH is denominated in 10^18 smaller units \(wei\), and AVAX is denominated in 10^9, switch the value selector from `wei` to `gwei` \(gigawei\). 1 gwei = 10^9 wei = 1 nAVAX.

![Interaction](../../../.gitbook/assets/wavax2avax-08-interact.png)

### Wrap AVAX to Create WAVAX

To wrap 10 AVAX, enter `10000000000` \(10^10\) gwei in the **Value** field. To initiate the wrapping, click **Deposit**. You will be presented with a prompt by Remix to confirm the transaction. When you press **Confirm** Metamask will pop up, also asking for confirmation. Press **Confirm** in Metamask, too. You should notice your AVAX balance lowered by 10, plus the fee amount. Skip to the next section to see your WAVAX in Metamask.

## Add WAVAX to Metamask

To see your WAVAX balance, you must add WAVAX as a custom token to Metamask. In Metamask, select the three dots next to your account name and select `Expand View`. This opens a new browser tab. Scroll down and select **Add token**. Switch to the **Custom Token** tab.

![Custom Token](../../../.gitbook/assets/wavax2avax-10-add-token.png)

In the **Token Contract Address** paste the same contract address we used before:

* For main net: `0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7`
* For Fuji test net: `0xd00ae08403B9bbb9124bB305C09058E32C39A48c`

Click **Next** and **Add Tokens**. Your WAVAX should now be visible in under your account in Metmask.

### Unwrap WAVAX to AVAX

To unwrap WAVAX, expand the arrow next to **Withdraw** button:

![Withdraw](../../../.gitbook/assets/wavax2avax-09-withdraw.png)

Unfortunately, the withdraw field is denominated in wei, so 10 AVAX is represented as `10000000000000000000` \(10^19\) for the withdraw amount. Pressing **Transact** will trigger the same confirmation first in Remix, then in Metamask. Your AVAX should be back in the account, minus the fee amount.

## Conclusion

You can now interact with smart contracts on Avalanche's C-Chain with WAVAX, the ERC-20 version of AVAX. In the future, converting between AVAX and WAVAX will be significantly simpler, with built-in support from the Wallet and exchanges, but in the meantime, you can still access DEXes, bridges and other Solidity-based contracts on the Avalanche Platform.

<!--stackedit_data:
eyJoaXN0b3J5IjpbMTg1MTM5Mjc4LC0xNzg5NjM5MTUxLDE4MT
c0OTM2MDVdfQ==
-->