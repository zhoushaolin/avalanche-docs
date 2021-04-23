# 通过Avalanche创建Ledger Nano S

安全保护加密数字货币的行业标准是硬件钱包，这是一种专用的设备，可以将您的电脑和私人密钥完全隔离。

如果要使用先前创建的Avalanche地址，则需要使用从Avalanche钱包中获得的助记词执行 [restore from recovery phrase](https://support.ledger.com/hc/en-us/articles/360005434914) 程序。若创建新的地址，只需遵循常规的[set up as new device](https://support.ledger.com/hc/en-us/articles/360000613793-Set-up-as-new-device)程序。

目前可在[Ledger Live](https://www.ledger.com/ledger-live) 上获取Avalanche Ledger钱包应用程序的试验模态。

## 如何在Ledger Live上创建Avalanche

首先，您需要安装[Ledger Live]([https://www.ledger.com/ledger-live](https://www.ledger.com/ledger-live))。MacOS、Windows、Linux、iOS和Android均可下载。

接下来，启动Ledger Live并点击“Settings” 按钮。

![Settings button on ledger live](https://miro.medium.com/max/3052/1*lMnVGJneUAqgRvZBIDv_rA.png)

进入设置，然后进入“Experimental features”选项卡。 

![](https://miro.medium.com/max/4072/1*HrSweaL-kelTl47QRt38iA.png)

下滑至“Developer mode”切换开关，并启用它。

![Toggle on developer mode](https://miro.medium.com/max/2908/1*qdte7MSvSZdfqfCIUMNp2Q.png)

启用“Developer mode”后，您可以进入“Manager”选项卡，搜索“Avalanche”。确认此Avalanche应用程序为0.2.1版本，然后单击“Install”按钮。

![Avalanche Ledger app install button](https://miro.medium.com/max/4040/1*rGFrSBEfxRlIkc-k7hS2Vg.png)

您可以进入“Apps installed”选项卡确认安装是否成功，您应该可以看到其中有Avalanche v0.2.1。

![](https://miro.medium.com/max/3020/1*qBSuxqY52-wxWfM-w1YR_w.png)

## 通过Ledger使用Avalanche钱包

Avalanche应用程序安装完成后，便可以通过Ledger与[Avalanche Wallet](https://wallet.avax.network/) 进行交互。包括在X-链<->P-链之间发送AVAX、代币、非同质化通证、跨链交易以及质押代币。

Once you have the Avalanche app installed then you’re able to interact with the [Avalanche Wallet](https://wallet.avax.network/) via the Ledger. This includes sending AVAX, tokens, NFTs, cross-chain swaps between the X-Chain&lt;-&gt;P-Chain as well as staking tokens.

First, to access the wallet, plug in the Ledger to your computer and if needed, enter your pin.

![PIN code screen](https://miro.medium.com/max/1852/1*A_1VgMMLeJCYzNst6tdq9A.jpeg)

Next, if you see the text “Pending Ledger review” then click both buttons on the top of the device to skip that screen.

![](https://miro.medium.com/max/1820/1*OxLbAWq5hzjC6P1SmiCqmg.jpeg)

Lastly, you should land on the “Avalanche” app screen where you can confirm that the app is version 0.2.1.

![](https://miro.medium.com/max/1802/1*Qevjy6nhw5UM0ufvxIL_qg.jpeg)

After you confirm that the Avalanche app is running then on the wallet homepage click the “Access Wallet” button.

![Access wallet button](https://miro.medium.com/max/2364/1*SC1uM5xFybz3lfPiKwOHUw.png)

On the subsequent “How do you want to access your wallet?”, click the “Ledger” button.

![Ledger Access](../../../.gitbook/assets/ledger-access.png)

You’ll now be prompted to confirm on your Ledger device. Click right button through the prompts on the device and on the last screen confirm by pressing both buttons.

![](https://miro.medium.com/max/3828/1*xpNt2ajcTdEivDr4xEedQQ.png)

If successful you will be signed into the wallet and any previous balances will be displayed.

![Web Wallet Portfolio Tab](../../../.gitbook/assets/web-wallet-portfolio-tab.png)

To transfer funds, go to the “Send” tab and paste an X-Address into the “To Address” field. Set an amount and optionally set a memo. Press "Confirm" and then the “Send Transaction” button.

![Send Transaction](../../../.gitbook/assets/send-transaction.png)

You’ll be prompted to confirm the action on your Ledger. Check that the hash which is displayed in the web wallet matches what is displayed on your Ledger. If everything matches then confirm by pressing both buttons on the last screen to send the transaction.

![](https://miro.medium.com/max/2932/1*XI8fzBRpDr0PXcuVQPHLvQ.png)

You can click the icon to refresh your balance and you should see it decrease per the amount which you just sent and the transaction fee.

![Refresh wallet balance](../../../.gitbook/assets/refresh-wallet-balance.png)

In the right-hand column, you will see your latest transaction. Clicking the magnifying glass icon will open the transaction in our explorer.

![Magnifying Glass](../../../.gitbook/assets/magnifying-glass.png)

Finally, you should be able to see the transaction details in our explorer. This lists everything about the transaction, including transaction ID, status, when the transaction occurred, and all of the information regarding inputs and outputs.

![Transaction details](../../../.gitbook/assets/transaction-details.png)

## More Tools to Come <a id="135b"></a>

Ava Labs is building the Internet of Finance. We’re developing solutions to create a frictionless world by redefining the way people build and use finance applications. A critical part of this infrastructure is a hardware wallet so users can be totally confident that their private keys and coins are completely isolated from any potentially malicious actors. Our newly released Ledger app does just this by following industry best practices to keep users and coins safe and secure.

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTEyMTYyNzIxNl19
-->