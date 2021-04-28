# 使用Avalanche钱包创建NFT

## Avalanche上的不可替换的代币

除了本地AVAX代币以外，Avalanche平台[Avalanche platform](../platform/) 在本机上支持创建其他类型的数字资产：固定资本资产、可变资本资产和不可替换代币（NFT）。

与可兑换（替换）的常规代币不同，意即每种代币都是相同的，每种不可替换代币在网络上都是独一无二的，不同的ID使之区分于任何其他代币。因此，使用可兑换代币无法成功的案例也变得可行，例如唯一资产的所有权证明。

## Avalanche钱包上的NFT工作室

为了使创建和交换NFT的体验更方便，我们在Avalanche钱包[Avalanche Wallet](https://wallet.avax.network/)中搭建了NFT工作室**NFT Studio**，您可以用它创建NFT，以作为所谓“藏品”的资产。藏品可以是带图片和说明的通用NFT，也可以是带有包含JSON、自定义URL或UTF-8数据的有效负载自定义NFT。您可以通过一个简单的点击界面进行创建，借此，您可以在几分钟内将NFT发送给您的朋友。无需技术知识。

如需访问**NFT Studio**，请登录您的Avalanche钱包，并选择左侧的**Studio**：

![NFT Studio](../../../.gitbook/assets/nft-studio-01-select.png)

打开NFT工作室。然后会有两个选项：**New Family**——创建新NFT，**Mint Collectible**——在现有藏品中创建新NFT资产。如果需要创建我们的首个NFT族，请点击**New Family**。

### 创建NFT家族

您需要输入您的NFT藏品家族的名称以及标志\(ticker\)。名称可以重复。

![Create new family](../../../.gitbook/assets/nft-studio-02-family.png)

除了名称和股票代码，您还需要输入**组的数量**，即新创建的家族将持有多少个不同的藏品。由于一旦创建，藏品家族的参数就无法更改，因此请谨慎选择。

当您决定名称、股票代码和组的数量时，请按下**Create**，以实际创建藏品家族。交易费用将从您的钱包余额中扣除。完成创建，您会看到交易ID（TxID）和藏品家族的参数。您可以使用TxID在浏览器[the explorer](https://explorer.avax.network/)中查找交易，但无需将之写下来。

请按下**Back to Studio**返回，我们已经准备好创建首个藏品了。请按下**Mint Collectible**。

### 铸造NFT

按下**Mint Collectible**后，您会看到一份所有藏品家族的清单，其中包括尚未创建的藏品组。

![Select a family](../../../.gitbook/assets/nft-studio-03-select-family.png)

选择我们刚刚创建的族。您会收到一份表格，请填写新藏品的参数：

![Mint a Collectible](../../../.gitbook/assets/nft-studio-04-mint.png)

默认情况下，系统会选择一种**Generic**类型的藏品。这是包含**Title**、图像**URL**和**Description**的NFT。请输入所需数据和**数量**，以决定将创建多少份藏品，并因此能够发送多少份。与之前一样，请谨慎输入数据，一旦铸造了藏品，您将无法进行任何更改。您会看到一份数据预览，其中您可以查看您的藏品是什么样子。

如果您想拥有图片藏品以外的其他内容，请选择**Custom**。

![Custom Collectible](../../../.gitbook/assets/nft-studio-05-custom.png)

自定义藏品可包含一个**UTF-8**编码字符串、**URL**或**JSON**有效载荷。数据规模不得超过1024个字节。

您输入并检查数据后，请按下**Mint**来创建藏品。交易费用将从您的钱包中扣除，您的钱包中会收到新创建的藏品。

### 查看您的藏品

您可以在屏幕顶端查看您的藏品概况和余额。

![Overview](../../../.gitbook/assets/nft-studio-06-overview.png)

如需详细查看藏品，请选择左侧菜单的**Portfolio**。您会看到一个显示您所有资产的界面，并默认选择代币。单击相应选项卡，将选项更改为**Collectibles**。

![Collectibles list](../../../.gitbook/assets/nft-studio-07-collectibles.png)

图片会显示每个普通藏品及其标题和数量, 这个数量代表的是你拥有的藏品数量。将鼠标指针悬停在收集品上即可显示详细说明：

![Collectible details](../../../.gitbook/assets/nft-studio-08-detail.png)

如果您单击选中一个藏品，您会看到它所属的组、数量以及**Send**发送按钮。


## 发送NFT

如需将您的收集品发送给某人，您可以点击组合中所选收集品的**Send**按钮，或导航至左侧菜单的**Send**选项并单击**Add Collectible**：

![Choosing the collectibles](../../../.gitbook/assets/nft-studio-09-send.png)

您会看到一个菜单，可以从中选择您想要发送的收集品。

![Multiple collectibles](../../../.gitbook/assets/nft-studio-10-multiple.png)

您可以在单次交易中发送多个藏品。单击藏品上的标签，您可以编辑您想要发送的复制品数量。您可以在单次交易中发送多个藏品家族和藏品类型。

当你输入了目的地址，并选择输入了备忘录文本，按**Confirm**启动交易。


![Transaction](../../../.gitbook/assets/nft-studio-11-send-transaction.png)

按下**Send Transaction**后，网络上会公布该交易，交易费用会从您的余额中扣除。不久后收集品会保存至目标地址。

## 总结

现在，您应该已经知道如何创建NFT藏品家族、铸造NFT组并将其发送至其他地址了。请务必在我们的社交媒体频道[social media channels](https://www.avalabs.org/social)上与我们分享您的作品！

如果您想了解NFT在Avalanche网络上工作的技术背景，或者想要使用NFT来创建产品，请查阅NFT教程[NFT tutorial](creating-a-nft-part-1.md)。如果您有任何技术问题，请通过Discord平台[Discord](https://chat.avalabs.org/) 联系我们。

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTQ2MTc4MTg0NCwtNDQyNDk3MzA4LDE4Nj
U1NDAzMjcsLTE2MjU5NTYyNDMsLTgzNTkyNDMyNiwxNjc4MjE3
NjE3XX0=
-->