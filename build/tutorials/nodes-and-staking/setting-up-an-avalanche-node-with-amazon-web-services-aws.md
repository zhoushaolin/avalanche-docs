# 通过亚马逊网络服务\(AWS\)来运行Avalanche节点

## 简介

本教程将指导您在[Amazon Web Services \(AWS\)](https://aws.amazon.com/)上设置一个Avalanche节点。向AWS这样的云服务能够确保您的节点高度安全、可用且可访问。

如需启动，您需要：

* 一个AWS账户
* 一个连接到SSH的电脑终端
* 个安全存储并备份文件的地方

本教程需要您的本地计算机具有Unix终端。如果您使用的是Windows，则必须修改这里使用的一些命令。

## 登录AWS 

注册AWS不在本文讨论范围内，亚马逊有注册说明[here](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account)

强烈建议您在AWS根用户帐户上设置多重身份验证进行保护。亚马逊有相关文件介绍[here](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_enable_virtual.html#enable-virt-mfa-for-root)

您一旦设置了账户，就得创建一个新的EC2实例, EC2是AWS云端的虚拟机。请访问AWS管理控制台[AWS Management Console](https://console.aws.amazon.com/) , 进入到EC2指示板。

![AWS Management Console.png](../../../.gitbook/assets/image%20%2835%29.png)

如需登录EC2，您将需要在本地计算机上有一个密钥来授权对它的访问。首先，创建一个密钥，该密钥随后可与EC2匹配。在左侧栏，选择**网络&安全**下方的**关键配对**。
要登录到EC2实例，您需要本地计算机上的一个密钥来授予对实例的访问权。首先，创建一个密钥，然后将其分配给EC2实例。在左侧栏的**Network & Security**下，选择**Key Pairs**。

![Select &quot;Key Pairs&quot; under the &quot;Network &amp; Security&quot; drop-down.](../../../.gitbook/assets/image%20%2838%29.png)

选择**Create key pair** ，以启动密钥对创建向导。

![Select &quot;Create key pair.&quot;](https://miro.medium.com/max/847/1*UZ4L0DGUogCfBq-TZ5U3Kw.png)

将您的密钥命名为`avalanche`。如果您的本地计算机有MacOS或Linux系统，请选择`pem`文件格式。如果是Windows系统，则使用`ppk`文件格式。或者，您可以为密钥对添加标记，以便追踪。

![Create a key pair that will later be assigned to your EC2 instance.](https://miro.medium.com/max/827/1*Bo30BXjwPTGpgFtoU9VDBA.png)

点击`Create key pair`。 您应该看到一条成功消息，并且密钥文件已下载到本地计算机上。 没有该文件，您将无法访问EC2实例。 **复制此文件并将其单独存储（例如外部硬盘驱动器）上。 将此文件保密； 不要与他人分享。**

![Success message after creating a key pair.](https://miro.medium.com/max/534/1*RGpHRWWFjNKMZb7cQTyeWQ.png)

## 创建安全组

AWS安全组定义了哪些网络流量可以访问和退出您的EC2。您可以把它看做防火墙。通过选择**Network & Security** 下拉列表中的**Security Groups** ，创建一个新的安全组。

![Select &quot;Security Groups&quot; underneath &quot;Network &amp; Security.&quot;](https://miro.medium.com/max/214/1*pFOMpS0HhzcAYbl_VfyWlA.png)

这将打开安全组面板。点击安全组面板右上角的**Create security group** 。

![Select &quot;Create security group.&quot;](https://miro.medium.com/max/772/1*B0JSYoMBplAtCz2Yb2e1sA.png)

您需要指定允许的入站流量, 允许来自您IP地址的SSH流量，以便您可以登录到EC2实例。\(每次ISP更改IP地址时，您都需要修改此规则。如果ISP定期更改，则可以允许来自任何地方的SSH流量，以避免不得不频繁修改此规则。\) 允许端口9651上的TCP流量, 您的节点可以与网络上的其他节点通信。 允许您的IP在端口9650上进行TCP通信，以便您可以对节点进行API调用。 **仅允许来自您的IP的该端口上的流量非常重要**。如果您允许来自任何地方的传入流量，则可能被当作拒绝服务而攻击的载体。 最后，允许所有出站流量。

![Your inbound and outbound rules should look like this.](../../../.gitbook/assets/inbound-rules.png)

给新安全组添加一个标记，其密钥为`Name`，值为`Avalanche Security Group`。当我们在安全组列表中看到这个安全组时，我们就能一下看出。

![Tag the security group so you can identify it later.](https://miro.medium.com/max/961/1*QehD3uyplkb4RPxddP1qkg.png)

点击`Create security group`。您应在安全组列表中看到新的安全组。

## 启动 EC2 实例

现在您准备启动EC2实例, 访问CE2指示板, 选择**Launch instance**。

![Select &quot;Launch Instance.&quot;](https://miro.medium.com/max/813/1*zsawPDMBFlonC_7kg060wQ.png)

为操作系统选择**Ubuntu 20.04 LTS \(HVM\), SSD Volume Type**。

![Select Ubuntu 20.04 LTS.](https://miro.medium.com/max/1591/1*u438irkY1UoRGHO6v76jRw.png)

下一步，选择您的实例类型。这定义了云实例的硬件规范。本教程中，我们设置了**c5.large**。因为Avalanche是一项轻量级共识协议，因此这已经足够用了。要创建a c5.large实例, 请在下拉菜单中选择**Compute-optimized**选项。

![Filter by compute optimized.](https://miro.medium.com/max/595/1*tLVhk8BUXVShgm8XHOzmCQ.png)

选择表格中所示的c5.large旁边的复选框。


![Select c5.large.](https://miro.medium.com/max/883/1*YSmQYAGvwJmKEFg0iA60aQ.png)

点击右下角**Next: Configure Instance Details**。

![](https://miro.medium.com/max/575/1*LdOFvctYF3HkFxmyNGDGSg.png)

实例详情可保留为默认值。

### 选项: 使用Spot 实例或者 Reserved实例

默认情况下，如果您运行EC2实例，则会按小时计费。共有两种方法可以帮您减少购买EC2的成本。

第一种方法：将EC2作为**Spot 实例**启动。spot实例并不保证总是启动，但其平均成本低于永久实例。spot实例使用的是供需市场价格结构。随着实例需求的上升，spot实例的价格也有所上升。如果您愿为spot实例付钱，您可以设置一个最高价格。如果价格上涨，则您的EC2实例可能会停止，那么您就可以省下很大一笔钱。在选择这个选项之前，先做一些研究，以确定以最高价格计算的中断频率证明节省成本是合理的。如果您选择使用spot实例，请确保将中断行为设置为**Stop**，而不是**Terminate，**并检查**Persistent Request**选项。

另一种省钱的方法是使用**Reserved Instance**。使用这个实例，您得提前支付一整年的EC2使用费，并按较低的每小时费率换取锁定。如果您想要长时间运行一个节点，且不想冒服务中断的风险，那么这是一个很好的省钱选项。同样，做选择前，请事先自行调研。

### 添加存储、标记、安全组

点击屏幕右下角的**Next: Add Storage**按钮。

您需要给您的实例磁盘增加空间。本例中我们使用了100GB作为示范。Avalanche数据库会不断扩大，直至实现精简。因此更安全的做法是分配一个更大的硬盘。

![Select 100 GB for the disk size.](../../../.gitbook/assets/add-storage.png)

点击屏幕右下角的 **Next: Add Tags**来给实例添加标签。通过标签，我们可以将元数据与我们的实例联系起来。添加一个密钥为`Name`和值为`My Avalanche Node`的标签。这将使您清楚地知道这个实例在EC2实例列表中的位置。

![Add a tag with key &quot;Name&quot; and value &quot;My Avalanche Node.&quot;](https://miro.medium.com/max/1295/1*Ov1MfCZuHRzWl7YATKYDwg.png)

现在，把之前创建的安全组分配给该实例。选择**Select an existing security group** , 并选择之前创建的安全组。

![Choose the security group created earlier.](../../../.gitbook/assets/configure-security-group.png)

最后，点击右下角的**Review and Launch**。查看页面上会显示您将要启动的实例的详情。查看后，如果一切运行良好，则点击屏幕右下角的蓝色 **Launch**按钮。

您得为此实例选择一个密钥对。选择**Choose an existing key pair**，然后选择您之前在教程中创建的`avalanche` 密钥对。勾选方框确认你有权限访问之前创建的`.pem`或`.ppk`文件(请确保您已备份！)。然后点击**Launch Instances**。

![Use the key pair created earlier.](https://miro.medium.com/max/700/1*isN2Z7Y39JgoBAaDZ75x-g.png)

您应该会看到一个新的弹出窗口，以确认实例正在启动！

![Your instance is launching!](https://miro.medium.com/max/727/1*QEmh9Kpn1RbHmoKLHRpTPQ.png)

### 分配一个弹性IP

默认情况下，您的实例并没有固定IP。让我们通过AWS的弹性IP服务给您一个固定IP。返回EC2指示板。在**Network & Security**项下，选择**Elastic IPs**。

![Select &quot;Elastic IPs&quot; under &quot;Network &amp; Security.&quot;](https://miro.medium.com/max/192/1*BGm6pR_LV9QnZxoWJ7TgJw.png)

选择**Allocate Elastic IP address**.

![Select &quot;Allocate Elastic IP address.&quot;](https://miro.medium.com/max/503/1*pjDWA9ybZBKnEr1JTg_Mmw.png)

选择实例运行所在的区域，并选择使用亚马逊的IPv4地址库。点击**Allocate**。

![Settings for the Elastic IP.](https://miro.medium.com/max/840/1*hL5TtBcD_kR71OGYLQnyBg.png)

选择您刚从弹性IP管理器中创建的弹性IP。在**Actions**下拉列表中，选择**Associate Elastic IP address**。


![Under &quot;Actions&quot;, select &quot;Associate Elastic IP address.&quot;](https://miro.medium.com/max/490/1*Mj6N7CllYVJDl_-zcCl-gw.png)

选择您刚刚创建的实例。从而关联新的弹性IP与实例，并赋予其一个固定的公共IP地址。

![Assign the Elastic IP to your EC2 instance.](https://miro.medium.com/max/834/1*NW-S4LzL3EC1q2_4AkIPUg.png)

## 设置AvalancheGo 

返回EC2指示板，并选择`Running Instances`。

![Go to your running instances.](https://miro.medium.com/max/672/1*CHJZQ7piTCl_nsuEAeWpDw.png)

选择新创建的EC2实例。打开详情面板，查看实例信息。

![Details about your new instance.](https://miro.medium.com/max/1125/1*3DNT5ecS-Dbf33I_gxKMlg.png)

复制 `IPv4 Public IP` 字段，供以后使用。自此，我们称该值为`PUBLICIP`。

**请记住：以下终端命令假设您正在运行的是Linux系统。Mac或其他操作系统的命令可能有所不同。当从代码区复制粘贴命令时，请复制并粘贴区域中的全部文本。**

从您的本地计算机登录AWS实例。打开终端\(快捷键`CTRL + ALT + T`\)，并导航至包含您之前下载的`.pem`文件的目录。

将`.pem`文件移动到`$HOME/.ssh` \(通常放置`.pem` 文件的地方\)：

```bash
mv avalanche.pem ~/.ssh
```

将`.pem`文件添加至SSH代理中，以便我们将其用到您的EC2实例中的SSH，并将其标记为只读。

```bash
ssh-add ~/.ssh/avalanche.pem; chmod 400 ~/.ssh/avalanche.pem
```

SSH进入实例。\(请记得用之前复制的公共IP字段填入`PUBLICIP`\)

```text
ssh ubuntu@PUBLICIP
```

如果权限设置**不**正确，则会出现以下错误。

![Make sure you set the permissions correctly.](https://miro.medium.com/max/1065/1*Lfp8o3DTsGfoy2HOOLw3pg.png)

现在，您已登录到EC2实例。

![You&apos;re on the EC2 instance.](https://miro.medium.com/max/1030/1*XNdOvUznKbuuMF5pMf186w.png)

如果尚未登录，请更新实例，以确保其拥有最新的操作系统和安全状态：

```text
sudo apt update; sudo apt upgrade -y; sudo reboot
```

这也会重启实例。等待5分钟，然后在本地计算机上运行以下命令来重新登录：

```bash
ssh ubuntu@PUBLICIP
```

您再次登录到EC2实例。现在我们需要设置Avalanche节点。为此，请按照[Set Up Avalanche Node With Installer](set-up-node-with-installer.md)教程，全程自动安装。您需要用到我们之前设置的`PUBLICIP`。

您的AvalancheGo节点现在应正在运行, 并处于引导过程中，这可能需要几个小时。如需检查这一过程是否已完成，您可以使用`curl`来进行API调用。如果您是从EC2实例发出请求，则请求是：

```text
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"info.isBootstrapped",
    "params": {
        "chain":"X"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/info
```

一旦节点完成引导，则回应将是：

```text
{
    "jsonrpc": "2.0",
    "result": {
        "isBootstrapped": true
    },
    "id": 1
}
```

即使AvalancheGo并未完成引导，您也可以继续。

为了使您的节点成为验证程序，您将需要其节点ID。如需获得它，请运行：

```text
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"info.getNodeID"
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/info
```

回应中包含节点ID。

```text
{"jsonrpc":"2.0","result":{"nodeID":"NodeID-DznHmm3o7RkmpLkWMn9NqafH66mqunXbM"},"id":1}
```

上述例子中，节点ID是`NodeID-DznHmm3o7RkmpLkWMn9NqafH66mqunXbM`。复制您的节点ID，供以后使用。您的节点ID并不保密，因此您可以把它粘贴到文本编辑器中。

AvalancheGo还有其他API，例如可用于与节点互动的[Health API](../../avalanchego-apis/health-api.md), 默认情况下，部分API是禁用的。如需启用上述API，修改`/etc/systemd/system/avalanchego.service`\(在安装过程中创建\)的ExecStart部分，以纳入启用上述终结点的标志。如无理由，请勿手动启用任何API。

![Some APIs are disabled by default.](https://miro.medium.com/max/881/1*Vm-Uh2yV0pDCVn8zqFw64A.png)

备份节点的质押密钥和证书，以防EC2实例损坏或不可用。节点ID衍生自其质押密钥和证书。如果您丢失了质押密钥或证书，那么您的节点将获得一个新的节点ID，但如果您的节点是验证程序，那么您可能没有资格获得质押奖励。**强烈建议您复制节点的质押密钥和证书**。第一次运行节点时，它将生成一个新的质押密钥/证书对，并存储于`/home/ubuntu/.avalanchego/staking`目录中。

通过运行以下命令退出SSH实例：

```bash
exit
```

现在，您已经断开了EC2实例的连接；返回了您的本地计算机。

如果要将质押密钥和证书复制到您的计算机上，请运行以下命令。与之前一样，替换`PUBLICIP`。

```text
scp -r ubuntu@PUBLICIP:/home/ubuntu/.avalanchego/staking ~/aws_avalanche_backup
```

现在，您的质押密钥和证书位于`~/aws_avalanche_backup`目录中, **该目录的内容保密。**您应将此目录保存在未连接到互联网的存储器上\(例如外部硬盘\)

### 升级节点

AvalancheGo是一个正在进行中的项目，有定期的版本升级。大多数升级都只是推荐的，而不是必须的。如果升级不兼容，则会有提前通知。如果要把您的节点更新到最新版本，则需像之前一样SSH进入您的AWS实例并再次运行安装程序脚本。

```text
./avalanchego-installer.sh
```

您的计算机现在正在运行AvalancheGo的最新版本。如需查看AvalancheGo服务的状态，请运行 `sudo systemctl status avalanchego`。

## 总结

就是这样！现在您已经在AWS EC2实例上运行AvalancheGo节点了。我们推荐为您的AvalancheGo节点设置节点监测[node monitoring ](setting-up-node-monitoring.md)。我们也推荐设置AWS账单提醒，当有账单到达时，您不会觉得意外。如果您对本教程有任何反馈或其他意见，请在[Discord](https://chat.avalabs.org)上给我们发送信息。


<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE0MTA0ODY0NTUsNzEwMjAzNDU1LC02MD
A5MDE3MzIsLTY5OTkwMDkwM119
-->