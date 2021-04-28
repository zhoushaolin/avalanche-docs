# 使用Avalanche钱包创建NFT

## Avalanche上的不可替换的代币

除了本地AVAX代币以外，Avalanche平台[Avalanche platform](../platform/) 在本机上支持创建其他类型的数字资产：固定资本资产、可变资本资产和不可替换代币（NFT）。

与可兑换（替换）的常规代币不同，意即每种代币都是相同的，每种不可替换代币在网络上都是独一无二的，不同的ID使之区分于任何其他代币。因此，使用可兑换代币无法成功的案例也变得可行，例如唯一资产的所有权证明。

## Avalanche钱包上的NFT工作室

为了使创建和交换NFT的体验更方便，我们在Avalanche钱包[Avalanche Wallet](https://wallet.avax.network/)中搭建了NFT工作室**NFT Studio**，您可以用它创建NFT，以作为所谓“收藏品”的资产。收藏品可以是带图片和说明的通用NFT，也可以是带有包含JSON、自定义URL或UTF-8数据的有效负载自定义NFT。您可以通过一个简单的点击界面进行创建，借此，您可以在几分钟内将NFT发送给您的朋友。无需技术知识。

如需访问**NFT Studio**，请登录您的Avalanche钱包，并选择左侧的**Studio**：

![NFT Studio](../../../.gitbook/assets/nft-studio-01-select.png)

打开NFT工作室。然后会有两个选项：**New Family**——创建新NFT，**Mint Collectible**——在现有收藏品中创建新NFT资产。如果需要创建我们的首个NFT族，请点击**New Family**。

### 创建NFT家族

There you will be asked to enter the name of your collectible family, as well as a symbol \(ticker\). Names do not have to be unique.

![Create new family](../../../.gitbook/assets/nft-studio-02-family.png)

Besides the name and the ticker, you will need to enter **Number of Groups**, that is, how many distinct collectibles will the newly created family hold. Choose carefully, because once created, the parameters of the collectible family cannot be changed.

When you decided upon the name, ticker, and number of groups, press **Create** to actually create the collectible family. The transaction fee will be deducted from your wallet's balance. When the family is created, you will see the transaction ID \(TxID\), as well as parameters for the family. You can use the TxID to look up the transaction in [the explorer](https://explorer.avax.network/), but it is not necessary to write it down.

Press **Back to Studio** to return, and we're ready to create our first collectibles. Press **Mint Collectible**.

### Mint NFTs

After pressing **Mint Collectible** you will be presented with a list of all the Collectible families that still have Collectible groups that have not been created yet.

![Select a family](../../../.gitbook/assets/nft-studio-03-select-family.png)

Select the family we have just created. You will be presented with a form to fill out with the parameters of the new collectible:

![Mint a Collectible](../../../.gitbook/assets/nft-studio-04-mint.png)

By default, a **Generic** type of collectible will be selected. That is an NFT that has a **Title**, **URL** for the image, and a **Description**. Enter the required data, as well as the **Quantity**, which will determine how many copies of the collectible will be created, and therefore, how many of them you will be able to send. As before, enter the data carefully, you won't be able to change anything once collectibles are minted. You will see a preview of the data where you can check how your collectible will look like.

If you would like to have something else besides a picture collectible, select **Custom**.

![Custom Collectible](../../../.gitbook/assets/nft-studio-05-custom.png)

A custom collectible can contain an **UTF-8** encoded string, an **URL**, or a **JSON** payload. Size of the data cannot exceed 1024 characters.

After you enter and check the data, press **Mint** to create the collectible. Transaction fees will be deducted from your wallet, and a newly created collectible will be placed in your wallet.

### See your collectibles

An overview of your collectibles is always visible in the top of the screen, along with your balances.

![Overview](../../../.gitbook/assets/nft-studio-06-overview.png)

To see your collectibles in more detail, select **Portfolio** from the left-hand side menu. You will be presented with a screen showing all of your assets, with tokens selected by default. Change the selection to **Collectibles** by clicking the corresponding tab.

![Collectibles list](../../../.gitbook/assets/nft-studio-07-collectibles.png)

For each Generic collectible, a picture will be shown, along with the title, and the number indicating how many copies of the collectible are in your portfolio. Hovering over the collectible with your pointer will show the detailed description:

![Collectible details](../../../.gitbook/assets/nft-studio-08-detail.png)

If you select a collectible by clicking on it, you will see which group it belongs to, its quantity, along with the **Send** button.

## Send NFTs

To send your collectible to someone, either click the **Send** button on the selected collectible in the Portfolio, or navigate to **Send** tab on the left-hand side menu, and click **Add Collectible**:

![Choosing the collectibles](../../../.gitbook/assets/nft-studio-09-send.png)

You will be presented with a menu to select a collectible you wish to send.

![Multiple collectibles](../../../.gitbook/assets/nft-studio-10-multiple.png)

You can send multiple collectibles in a single transaction. Clicking the label on the collectible will let you edit the number of copies you wish to send. You can send multiple families and collectible types in a single transaction.

When you have entered the destination address, and optionally entered the memo text, press **Confirm** to initiate the transaction.

![Transaction](../../../.gitbook/assets/nft-studio-11-send-transaction.png)

After pressing **Send Transaction** it will be published on the network, and the transaction fee will be deducted from your balance. Collectibles will be deposited into the destination address shortly after.

## Summary

Now, you should know how to create NFT families, mint NFT groups, and send them to other addresses. Have fun with it! Make sure to share your creations with us on our [social media channels](https://www.avalabs.org/social)!

If you would like to know the technical background of how NFTs work on the Avalanche network or would like to build products using NFTs, please check out the [NFT tutorial](creating-a-nft-part-1.md). If you have technical questions, reach out to us on our [Discord](https://chat.avalabs.org/) server.

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE4NzU5NzkxMzcsMTg2NTU0MDMyNywtMT
YyNTk1NjI0MywtODM1OTI0MzI2LDE2NzgyMTc2MTddfQ==
-->