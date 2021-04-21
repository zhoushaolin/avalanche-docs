# 使用Avalanche钱包，通过验证或委托来质押AVAX

## 简介

Avalanche钱包是一个网络应用程序，无中介软件或任何类型的服务器通信。Avalanche钱包是采用Vue JS编写的，既可以线上访问，也可以本地编译和运行。

Avalanche钱包可以从[here](https://wallet.avax.network/)访问。
Avalanche钱包源代码可以从[here](https://github.com/ava-labs/avalanche-wallet)找到。

**来质押吧！**

### 第1步——打开Avalanche钱包

![Image for post](https://miro.medium.com/max/1552/0*tpBIOjLdppuNKMjA)

您可以使用您的关键字、密钥库文件或Ledger Nano S\(即将推出!\)来访问您的钱包。

### 第2步——导航到“Earn”部分

![Image for post](https://miro.medium.com/max/1504/0*XTh3nZzBI1bkLbwO)

**如需质押，您需要在** [**Platform Chain \(P-Chain\)**](../../../learn/platform-overview/#platform-chain-p-chain)**上提供资金!如果您的资金处于** [**Exchange Chain \(X-Chain\)**](../../../learn/platform-overview/#exchange-chain-x-chain)**上, 我们将需要通过启动跨链转账将其转到P链上。如果您的代币已锁定，则您的代币已处于P链上，所以您不需要将资金从X链跨链转账到P链上。**

![Image for post](https://miro.medium.com/max/1522/0*xKAf0nXSzqIdmBDg)

输入您希望转账到P链上的金额，并通过点击下方“Transfer”按钮来完成转账。

![Image for post](https://miro.medium.com/max/1488/0*aremeYNYtKP5nGPx)

就是这！

![Image for post](https://miro.medium.com/max/1512/0*XP8f8CISy-LJ_Lc3)

现在，我们已经将资金准备好质押在P链上。下一步，您可以给您的钱包添加一个验证程序或委托程序。

### 第3步A：成为验证程序！

如需添加验证程序，我们需要保持一个节点处于运行中。 我们可以使用发布的[binaries](https://github.com/ava-labs/avalanchego/releases/)文件或从[AvalancheGo source code](https://github.com/ava-labs/avalanchego)中构建

使用二进制文件非常简单方便，只要4个步骤您就可以设置好一个验证程序：

* 在此[here](https://github.com/ava-labs/avalanchego/releases)下载最新版本 tar.gz \(zip for osx and windows\)
* 解压成我们选择的文件夹：

\* Linux系统：解压-xvf avalanchego-linux-&lt;VERSION&gt;.tar.gz

\* OSX系统：解压 avalanchego-macos-&lt;VERSION&gt;.zip

\* Windows系统：  解压 avalanchego-win-&lt;VERSION&gt;.zip

* 导航到二进制文件目录 cd avalanchego-&lt;VERSION&gt;
* 在Linux和OSX系统中运行二进制文件与/avalanchego, 在Windows系统中运行AvalancheGo。

我们会让我们的节点与网络的其他部分一同引导并同步，并且我们随时准备开始。

我们会需要节点ID。通过[info API](../../avalanchego-apis/info-api.md)，我们可以找到它!

如果您在设置您的节点时需要任何帮助， 请通过 [Discord](https://chat.avax.network/)加入我们。

![Image for post](https://miro.medium.com/max/1600/0*6hZSaT651Dd7R4bL)

填完字段并确认！

![Image for post](https://miro.medium.com/max/1600/0*cy61ZMDY5veMvCZj)

仔细检查细节，并再次点击“Confirm”！Carefully check the details, and click “Confirm” again!

![Image for post](https://miro.medium.com/max/1600/0*f3GlN03He6TFkOV7)

Congratulations. You are now validating the Avalanche Primary Network!

### **Step 3B: Add a Delegator!** <a id="59bd"></a>

![Image for post](https://miro.medium.com/max/1600/0*f-wXi2SiSm4eBmHt)

Select a validator you want to delegate your tokens with from the list of active network validators.

![Image for post](https://miro.medium.com/max/1600/0*uNnT2PtjCslRKFbF)

Specify your staking period and stake amount. Pay attention to the end time of the selected validator. Your delegation period cannot be set to end past the end date that the validator has set.

![Image for post](https://miro.medium.com/max/1600/0*M_6_7L9jtYuPTp-A)

Confirm the details!

![Image for post](https://miro.medium.com/max/1600/0*Silj8-uZTm5g9xSi)

Congratulations. You are now delegating the Avalanche Primary Network!

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTY4MTYwMDY3N119
-->