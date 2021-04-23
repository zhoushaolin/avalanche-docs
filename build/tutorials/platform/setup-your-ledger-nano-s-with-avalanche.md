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

首先，进入钱包，把Ledger插到您的电脑上，如果需要的话，输入密码。

![PIN code screen](https://miro.medium.com/max/1852/1*A_1VgMMLeJCYzNst6tdq9A.jpeg)

接下来，如果您看到文本“Pending Ledger review”，点击设备顶部的两个按钮跳过该界面。

![](https://miro.medium.com/max/1820/1*OxLbAWq5hzjC6P1SmiCqmg.jpeg)

最后，您将进入“Avalanche”应用程序界面上，在那里您可以确认该应用程序是0.2.1版本。

![](https://miro.medium.com/max/1802/1*Qevjy6nhw5UM0ufvxIL_qg.jpeg)

确认Avalanche应用程序运行后，点击钱包主页上的“Access Wallet”按钮。

![Access wallet button](https://miro.medium.com/max/2364/1*SC1uM5xFybz3lfPiKwOHUw.png)

在接下来的“How do you want to access your wallet?”提问中，点击“Ledger”按钮。

![Ledger Access](../../../.gitbook/assets/ledger-access.png)

然后系统将提示您在您的Ledger设备上进行确认。通过设备上的提示单击右键，并在最后一个界面上按下两个按钮进行确认。

![](https://miro.medium.com/max/3828/1*xpNt2ajcTdEivDr4xEedQQ.png)

如果成功，您将登录到钱包，并看到之前的所有余额。

![Web Wallet Portfolio Tab](../../../.gitbook/assets/web-wallet-portfolio-tab.png)

要转账，进入“Send”选项卡，并将X地址粘贴到“To Address”字段中。设定一个金额，并可选择性地添加转账说明。按“Confirm”然后按“Send Transaction”按钮。

![Send Transaction](../../../.gitbook/assets/send-transaction.png)

系统会提示您在Ledger确认此操作。检查网络钱包中显示的哈希值与您Ledger上显示的是否相符。如果核对无误，按下最后一个界面上的两个按钮确认发送交易。

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
eyJoaXN0b3J5IjpbLTEwOTMwMDg1NDhdfQ==
-->