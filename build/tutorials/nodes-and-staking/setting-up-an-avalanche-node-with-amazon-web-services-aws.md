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

Go back to the EC2 Dashboard and select `Running Instances`.

![Go to your running instances.](https://miro.medium.com/max/672/1*CHJZQ7piTCl_nsuEAeWpDw.png)

Select the newly created EC2 instance. This opens a details panel with information about the instance.

![Details about your new instance.](https://miro.medium.com/max/1125/1*3DNT5ecS-Dbf33I_gxKMlg.png)

Copy the `IPv4 Public IP` field to use later. From now on we call this value `PUBLICIP`.

**Remember: the terminal commands below assume you're running Linux. Commands may differ for MacOS or other operating systems. When copy-pasting a command from a code block, copy and paste the entirety of the text in the block.**

Log into the AWS instance from your local machine. Open a terminal \(try shortcut `CTRL + ALT + T`\) and navigate to the directory containing the `.pem` file you downloaded earlier.

Move the `.pem` file to `$HOME/.ssh` \(where `.pem` files generally live\) with:

```bash
mv avalanche.pem ~/.ssh
```

Add it to the SSH agent so that we can use it to SSH into your EC2 instance, and mark it as read-only.

```bash
ssh-add ~/.ssh/avalanche.pem; chmod 400 ~/.ssh/avalanche.pem
```

SSH into the instance. \(Remember to replace `PUBLICIP` with the public IP field from earlier.\)

```text
ssh ubuntu@PUBLICIP
```

If the permissions are **not** set correctly, you will see the following error.

![Make sure you set the permissions correctly.](https://miro.medium.com/max/1065/1*Lfp8o3DTsGfoy2HOOLw3pg.png)

You are now logged into the EC2 instance.

![You&apos;re on the EC2 instance.](https://miro.medium.com/max/1030/1*XNdOvUznKbuuMF5pMf186w.png)

If you have not already done so, update the instance to make sure it has the latest operating system and security updates:

```text
sudo apt update; sudo apt upgrade -y; sudo reboot
```

This also reboots the instance. Wait 5 minutes, then log in again by running this command on your local machine:

```bash
ssh ubuntu@PUBLICIP
```

You're logged into the EC2 instance again. Now we’ll need to set up our Avalanche node. To do this, follow the [Set Up Avalanche Node With Installer](set-up-node-with-installer.md) tutorial which automates the installation process. You will need the `PUBLICIP` we set up earlier.

Your AvalancheGo node should now be running and in the process of bootstrapping, which can take a few hours. To check if it's done, you can issue an API call using `curl`. If you're making the request from the EC2 instance, the request is:

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

Once the node is finished bootstrapping, the response will be:

```text
{
    "jsonrpc": "2.0",
    "result": {
        "isBootstrapped": true
    },
    "id": 1
}
```

You can continue on, even if AvalancheGo isn't done bootstrapping.

In order to make your node a validator, you'll need its node ID. To get it, run:

```text
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"info.getNodeID"
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/info
```

The response contains the node ID.

```text
{"jsonrpc":"2.0","result":{"nodeID":"NodeID-DznHmm3o7RkmpLkWMn9NqafH66mqunXbM"},"id":1}
```

In the above example the node ID is`NodeID-DznHmm3o7RkmpLkWMn9NqafH66mqunXbM`. Copy your node ID for later. Your node ID is not a secret, so you can just paste it into a text editor.

AvalancheGo has other APIs, such as the [Health API](../../avalanchego-apis/health-api.md), that may be used to interact with the node. Some APIs are disabled by default. To enable such APIs, modify the ExecStart section of `/etc/systemd/system/avalanchego.service` \(created during the installation process\) to include flags that enable these endpoints. Don't manually enable any APIs unless you have a reason to.

![Some APIs are disabled by default.](https://miro.medium.com/max/881/1*Vm-Uh2yV0pDCVn8zqFw64A.png)

Back up the node's staking key and certificate in case the EC2 instance is corrupted or otherwise unavailable. The node's ID is derived from its staking key and certificate. If you lose your staking key or certificate then your node will get a new node ID, which could cause you to become ineligible for a staking reward if your node is a validator. **It is very strongly advised that you copy your node's staking key and certificate**. The first time you run a node, it will generate a new staking key/certificate pair and store them in directory `/home/ubuntu/.avalanchego/staking`.

Exit out of the SSH instance by running:

```bash
exit
```

Now you're no longer connected to the EC2 instance; you're back on your local machine.

To copy the staking key and certificate to your machine, run the following command. As always, replace `PUBLICIP`.

```text
scp -r ubuntu@PUBLICIP:/home/ubuntu/.avalanchego/staking ~/aws_avalanche_backup
```

Now your staking key and certificate are in directory `~/aws_avalanche_backup` . **The contents of this directory are secret.** You should hold this directory on storage not connected to the internet \(like an external hard drive.\)

### Upgrading Your Node <a id="9ac7"></a>

AvalancheGo is an ongoing project and there are regular version upgrades. Most upgrades are recommended but not required. Advance notice will be given for upgrades that are not backwards compatible. To update your node to the latest version, SSH into your AWS instance as before and run the installer script again.

```text
./avalanchego-installer.sh
```

Your machine is now running the newest AvalancheGo version. To see the status of the AvalancheGo service, run `sudo systemctl status avalanchego.`

## Wrap Up

That's it! You now have an AvalancheGo node running on an AWS EC2 instance. We recommend setting up [node monitoring ](setting-up-node-monitoring.md)for your AvalancheGo node. We also recommend setting up AWS billing alerts so you're not surprised when the bill arrives. If you have feedback on this tutorial, or anything else, send us a message on [Discord](https://chat.avalabs.org).

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE5Mzc1NTczNDMsNzEwMjAzNDU1LC02MD
A5MDE3MzIsLTY5OTkwMDkwM119
-->