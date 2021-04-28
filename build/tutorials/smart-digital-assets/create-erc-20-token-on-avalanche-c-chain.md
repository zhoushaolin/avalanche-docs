---
描述: 由社区成员Murat Çeliktepe提供

---

# 创建ERC-20代币

ERC-20代币是以太坊中最基础和必要的概念。随着Avalanche社区和生态系统的成长，在以太坊或不同链上运行的新用例和项目将在Avalanche上实施。用于项目的代币标准并不固定，每个人都可以创建他们自己的标准和代币。

因此，我们会创建我们自己的可铸造ERC-20代币，并将其铸造至我们想要的任何地址。Avalanche C链上将生成代币，并可在该链上访问代币。

我们主要需要考虑的问题是，我们将为Avalanche部署一份由Solidity语言编写的智能合约。这就是Avalanche的特点——能够将任何智能合约部署到链中，而不需要特定于语言的新合约概念进行交互。来看看如何创建一个ERC-20合同，并将其部署到avalanche C链吧。

## 设置 Metamask

我们首先应该设置一个Metamask钱包。

![Image for post](https://miro.medium.com/max/408/0*0HGM4O_J5iF3943S)

点击浏览器上的MetaMask图标，并选择网络下拉列表菜单。我们应连接到C链。点击“Custom RPC”。

![Image for post](https://miro.medium.com/max/989/1*Y7O1bBeTWnuQBAqTnwmqUQ.png)

现在，我们需要为下列框设置正确的值。

* **网络名**: Avalanche C链
* * **新 RPC URL**:
  * **主网:** [https://api.avax.network/ext/bc/C/rpc](https://api.avax.network/ext/bc/C/rpc) 
  * **富士测试网:** [https://api.avax-test.network/ext/bc/C/rpc](https://api.avax-test.network/ext/bc/C/rpc)
  * **本地测试网:** [http://localhost:9650/ext/bc/C/rpc](http://localhost:9650/ext/bc/C/rpc) 
* **链**ID**:
  * **主网:** `0xa86a` 
  * **富士测试网:** `0xa869` 
  * **本地测试网:** `0xa868` 
* **标志**: C-AVAX
* **浏览器**:
  * **主网:** [https://cchain.explorer.avax.network](https://cchain.explorer.avax.network/) 
  * **富士测试网:** [https://cchain.explorer.avax-test.network](https://cchain.explorer.avax-test.network/)
  * **本地网:** n/a 

![Image for post](https://miro.medium.com/max/358/1*q0HIWcI3okakwYV2glos0A.png)

正确设置好所有参数后，我们应看到此页面。目前，我们拥有0个C-AVAX。“C”是指C链，我们需要获得一些C-AVAX来与网络互动。

## 为您的C链地址充值

基于所用网络，共有三种给您的C链地址充值的方式。

### 使用Avalanche钱包

在主网上，您可以使用Avalanche钱包[Avalanche Wallet](https://wallet.avax.network/)，将X链上的资金转账到您的C链地址。该过程十分简单，详情如本教程[tutorial](../platform/transfer-avax-between-x-chain-and-c-chain.md)所释。钱包也可用于测试和本地网络。

### 使用测试网接口

如需为测试网充值，您还可以使用测试网接口。导航至[https://faucet.avax-test.network/](https://faucet.avax-test.network/)，并粘贴您的C-AVAX地址。您只需要添加一个“C-”前缀，接口就会从AVAX切换为C-AVAX。

### 为本地测试网充值

在本地网上，通过部署您自己的接口，您可以轻松地为您的地址充值。教程[Tutorial](https://medium.com/avalabs/the-ava-platform-tools-pt-2-the-ava-faucet-48f28da57146)

访问[avax faucet](https://faucet.avax-test.network/) 并粘贴我们的地址，附上前缀“C-”。

例如，我的地址是“0xfe8886bec537252040Dff36448C0F104Be635650”, 我需要把我的账户地址粘贴为“C-0xfe8886bec537252040Dff36448C0F104Be635650”

![Image for post](https://miro.medium.com/max/422/1*okw3MKlyGcF4U9ibsq5v8w.png)

将地址复制粘贴至此后，点击请求2.0000 C-AVAX。此测试接口代币无价值，仅供开发。

然后请检查您的钱包余额，您的MetaMask中应该已有一些测试代币。

## 创建可铸造代币

现在我们可以在Remix上创建我们的可铸造代币了。打开您的浏览器上的Remix，或访问此链接[this link](https://remix.ethereum.org/#optimize=false&evmVersion=null&version=soljson-v0.6.6+commit.6c089d02.js)。

![Image for post](https://miro.medium.com/max/1910/1*FWHtbWNXr6FvjzPHH93wvw.png)

您应该查看此页面。此页面上，首先，单击“Featured Plugins”中的“SOLIDITY”，然后单击“New File”按钮。当您单击New File按钮时，您会看到一个弹窗，要求填写文件名。您可以选择一个文件名或选择默认。

由于我们将使用[OpenZeppelin](https://openzeppelin.com/contracts/)的ERC-20合约，因此只需粘贴此段至文件并保存即可。

```javascript
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";
```

![Image for post](https://miro.medium.com/max/1408/1*y1wpcCeB8PypnPfs-zhyBg.png)

保存文件后，我们会看到一堆导入到Remix的文件。通过该Remix特征，我们可以仅通过提供URL链接将GitHub合同库导入到Remix中。附导入说明。

![Image for post](https://miro.medium.com/max/1364/1*6pmdpKWiKj4RW-OcvMSijA.png)

我们在预设中拥有ERC20PresetMinterPauser.sol文件。该文件由OpenZeppelin根据附铸造功能的ERC20标准编写。部署此文件后，我们将成为合约所有者，进而有权限和能力来铸造代币。

![Image for post](https://miro.medium.com/max/1398/1*5UcrRfoSwjpD29NyuMrrbA.png)

## 部署合约

打开第二个选项“SOLIDITY COMPILER”，选择与文件“pragma SOLIDITY .....”中所写的SOLIDITY版本相匹配的SOLIDITY版本。其版本应该同于或高于该文件的版本。举例来说，在我的文件中，所写的版本是“pragma solidity ^0.6.0”，因此所需版本应是0.6.0或更高。如上所述，在编译器中，solidity版本是0.6.6，这是可行的。检查完solidity版本后，单击编译按钮。如果您并未更改文件中的任何东西或solidity版本无误，合约编译也应无误。

![Image for post](https://miro.medium.com/max/1388/1*2jkDckFUJ4z3gMoLYZ_-PQ.png)

然后，跳到第三个选项，即DEPLOY & RUN TRANSACTION。部署我们的合约之前，我们应更改环境。单击ENVIROMENT，并选择“Injected Web3”。如果跳出一个弹窗，要求您连接账户，请单击以连接。然后，您应该在“ACCOUNT”文本框中看到账户地址。

在进行部署过程前, 最后一件事是设置将部署为代币的合约。部署按钮(Deploy)上方有一个下拉菜单，您可以选择合约。选择名为“ERC20PresetMinterPauser.sol”的合约。

![Image for post](https://miro.medium.com/max/383/1*s9LtZu4hSuPcVwVZsweZJA.png)

现在，在此输入您的代币的名称和标志。我将其命名为“test”，标志为“tst”。您可以给它并单击交易按钮。

![Image for post](https://miro.medium.com/max/593/1*ZKDEv_h_Pqfd3b7PAosXQw.png)

单击按钮后，会跳出一个弹窗，点击Confirm即可。

![Image for post](https://miro.medium.com/max/353/1*yOOQYZvESjSKx2qec5pYgA.png)

然后会出现另一个弹窗，MetaMask确认出现。点击Confirm即可。

确认所有此类弹窗后，我们就把代币部署到avalanche C链了。所以我们能够开始与它互动。

## 与代币互动

通过此C链浏览器[c-chain explorer](https://cchain.explorer.avax-test.network/)，我们可以看到部署在avalanche C链上的交易。

但首先，让我们看看Remix控制台中的交易队列。

![Image for post](https://miro.medium.com/max/1469/1*WTHSIfrDe9R_hk-C5GNq0g.png)

部署完合同后，我们应看到Remix控制台中的日志。当您单击箭头并展开它时，一个交易队列就会出现。复制它。

![Image for post](https://miro.medium.com/max/1909/1*NBXgtkYv2VfBkZx1OsBm7A.png)

将交易队列粘贴至我上文分享的浏览器[explorer](https://cchain.explorer.avax-test.network/)，并按输入键。

![Image for post](https://miro.medium.com/max/1907/1*6GhQaa_UaDvtk3Kvimi3aA.png)

在此我们可以看到交易和代币合约的所有详情。

![Image for post](https://miro.medium.com/max/764/1*tTFQUn3fStbv-TW9kExyUg.png)

首先是创建代币的钱包地址，其次是我的代币合约地址，其名为“test”。现在，让我们给我们自己的地址铸造一些代币吧。

![Image for post](https://miro.medium.com/max/607/1*K9eBNTQFkvUYjjmvegDZtQ.png)

返回Remix，部署后，您应该能在“Deployed Contracts”部分看到合约。

在此，我们有一系列可用于与我们的代币合约互动的功能。您可以检查OpenZeppelin文档的所有此类方法，以了解如何使用它们。但是我们只会使用铸造法。

点击铸造方法旁边的箭头，并阅读。

![Image for post](https://miro.medium.com/max/577/1*GrxG6rsklrYN4xN1eF_ckw.png)

输入您的地址和WEI中的金额。例如，我准备铸造1000tst代币，所以我输入了“1000000000000000000000”。

![Image for post](https://miro.medium.com/max/354/1*FM-PMUY7au61ejHJzBIsfg.png)

## 将代币添加至Metamask

现在，我们为合约铸造了1000个代币，但是您应该无法看到您的MetaMask钱包中的代币。为了查看我们自己的代币，我们必须添加它。在MetaMask上，单击“Add Token”按钮并选择“Custom Token”选项。

在此输入您可以从浏览器中看到的代币地址，如上所示。将其复制并粘贴于此。然后单击下一步(Next)按钮，您应该在您的MetaMask钱包中看到您命名的1000个代币。同样，您可以通过Remix或MetaMask将其发送到另一个账户。


<!--stackedit_data:
eyJoaXN0b3J5IjpbLTExMDk1ODQzODMsLTEyMzg2MDcyNCwxOT
UxNzU4MDkyLC0xOTI5MjM1MjQzXX0=
-->