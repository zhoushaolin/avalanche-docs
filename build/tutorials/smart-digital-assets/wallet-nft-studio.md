# 使用Avalanche钱包创建NFT

## Non-Fungible Tokens on Avalanche

Besides the native AVAX token, [Avalanche platform](../platform/) natively supports the creation of other types of digital assets: fixed-cap assets, variable-cap assets, and non-fungible tokens \(NFTs\).

As opposed to regular tokens, which are interchangeable \(fungible\), meaning that each one is the same, each non-fungible token is unique on the network, with a distinct ID making it different from any other. This enables many use cases that would be impossible with interchangeable tokens, like proof of ownership of a unique asset.

## NFT Studio on Avalanche Wallet

To make experimenting with the creation and exchange of NFTs easier, we have built **NFT Studio** into the [Avalanche Wallet](https://wallet.avax.network/), where you can use it to create NFTs as assets that we call Collectibles. Collectibles can be generic NFTs with a picture and a description, or custom NFTs with payloads containing JSON, custom URL, or UTF-8 data. You can create them using a simple point and click interface, enabling you to go from an idea of sending NFTs to your friends within minutes. No technical knowledge required.

To access the **NFT Studio**, log into your Avalanche Wallet, and on the left side select **Studio**:

![NFT Studio](../../../.gitbook/assets/nft-studio-01-select.png)

This will open the NFT Studio. There you have two options: **New Family**, for the creation of a new family of NFTs, and **Mint Collectible** for creating new assets in existing families. We need to create our first family of NFTs, so click **New Family**.

### Create NFT Family

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
eyJoaXN0b3J5IjpbLTQwMjEzNjY0N119
-->