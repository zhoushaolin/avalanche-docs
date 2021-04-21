---
说明：“社区成员Seq生成的教程”
---

# 用Microsoft Azure运行Avalanche节点

运行验证程序和通过Avalanche进行权益质押可产生极具竞争力的报酬，报酬范围在9.69%至11.54%之间，取决于您权益质押的时间长短。费率最高为一年期费率，最低为14天费率。不存在削减，所以不必担心客户端硬件故障或漏洞导致您损失部分或全部质押权益。相反，在Avalanche平台，您只需要保证在线时间达到60%就可以获得报酬。如果您没有达到这个要求，您不会被削减，但也无法得到报酬。**您也不需要将密钥放到节点上来启动验证**。即使有人侵入了你的云环境，获得了节点的访问权限，他们最多也只能关闭该节点。

运行验证程序节点不仅可以让您获得AVAX报酬，之后您还可以验证生态系统中的其他子网，并获得该子网的本地代币。

运行验证程序只需要2个CPU内核、4GB内存和40GB固态硬盘，而且不会消耗大量能源。Avalanche颠覆性的共识机制[revolutionary consensus mechanism](https://medium.com/ava-hub/avalanche-consensus-the-biggest-breakthrough-since-nakamoto-66e9917fd656)能够同时扩展到数百万个参与共识的验证程序，达到空前的去中心化。

目前，成为验证方所需的最低质押金额是2000AVAX\(随着价格的上涨，这个数字会随着时间的推移而减少\)。或者，验证方也可以收取少许费用，让用户将他们的权益委托给他们，以帮助降低运行成本。您可以使用计算器[here](https://vscout.io/)查看与委托相比运行一个节点能获得多少报酬。

建议每个人尽可能运行自己的验证程序，但对于那些不满足最低质押金额并希望委托的人，可以使用我现在运行的这一节点，详见[here](https://avascan.info/staking/validator/NodeID-MGrikMRTmooL1j7uawPHjaMS1cXkbewdb)。

在本文中，我们将逐步讲解在Microsoft Azure上配置节点的过程。本教程假设您之前没有使用Microsoft Azure的经验，并且将尽可能简单的讲解每个步骤。

在本文撰写之时，一个2核8GB内存的虚拟机的现货定价仅为每小时0.01060美元，相当于每年113.44美元，**比现收现付制价格节省了83.76%。**相比之下，一个2核4GB内存的AWS虚拟机的现货定价大约为每年462美元。

## 初始订阅配置

### 设定2个因素

首先，您需要一个微软账户，如果还没有，您可以在下面的链接中看到创建账户的选项。如果您有账号，请访问以下链接，然后选择“两步认证”并按照提示的步骤设定2个因素认证来保护你的节点。
[https://account.microsoft.com/security](https://account.microsoft.com/security)

![Image for post](https://miro.medium.com/max/1135/1*tr3rEcrvI4rEpC7KPYqg6g.png)

配置好2个因素后，您就可以访问[https://portal.azure.com](https://portal.azure.com/)并使用微软账号登录到Azure门户。登录后没有订阅，因此我们需要先创建一个。选择下面标出的“Subscriptions”：

![Image for post](https://miro.medium.com/max/648/1*5Jp8oXzczaEND-z9_QZaQA.png)

然后选择“+Add”, 添加一个新的订阅。

![Image for post](https://miro.medium.com/max/374/1*Lw3HklSSC8NDN2ftQEVgYA.png)

如果您想使用Spot Instance VM现货定价\(这个价格会便宜很多\)，您不能使用免费试用账户Free Trial account\(验证时会收到错误\)，所以**务必选择现收现付Pay-As-You-Go。**

![Image for post](https://miro.medium.com/max/789/1*TO5Uh07OkH_QdwludEgapg.png)

注册过程中，您需要输入给您开具账单的详细信息并确认身份，在添加技术支持“Add technical support ”一栏，选择“No technical support ”选项,（除非您想支付额外的支持费用），然后点“Next”。

![Image for post](https://miro.medium.com/max/783/1*5KJOATvu3giAr6ygO3rF6Q.png)

## 创建一个虚拟机

现在我们有了订阅，就可以为Avalanche节点创建Ubuntu虚拟机了。选择左上角的菜单图标，然后选择“+ Create a resource”。

![Image for post](https://miro.medium.com/max/565/1*3nSPwgEM3oIgrIlIo-TS1w.png)

选择Ubuntu 18.04 LTS服务器\(通常在市场热门位置，或者搜索栏搜索\)。

![Image for post](https://miro.medium.com/max/605/1*Y0iZEZExC36c7FXqPlrPuw.png)

接下来将进入创建虚拟机Create a virtual machine页面，如下所示：

![Image for post](https://miro.medium.com/max/775/1*cv0z0mt6Uavx5MkiazpiUA.png)

首先，为虚拟机输入一个名字，可以是任何名字，在本实例中，我将其称为Avalanche\(这个名字也将自动更改资源组名称进行匹配\)。

然后从下拉列表中选择一个区域。从您喜欢的区域中选择一个推荐的服务器，因为这些推荐的往往比较大，功能比较齐全，价格也比较便宜。在本实例中，我选择了北欧。

![Image for post](https://miro.medium.com/max/769/1*XOpa22qSdNI-0PW5oIyUhQ.png)

您可以选择使用Spot instance(点实例)定价来节省大量的运行成本。Spot instance采用供求市场价格结构。随着实例需求的增加，Spot instance的价格也会随之上涨。如果产能不足，那么您的虚拟机将被关闭。这种情况发生的可能性非常低，特别是如果您选择了Capacity only(仅产能)选项。即使在极少数情况下，它确实被暂时关闭了，您只需要保证在线时间达到60%就可以获得质押报酬，并且在Avalanche中不会出现削减。

在Azure Spot instance选项选择“Yes”，将“Eviction type”选择为“Capacity Only”，并**确保将逐出策略设置为“Stop / Deallocate”——这点非常重要，否则VM将被删除**。

![Image for post](https://miro.medium.com/max/756/1*zWWiYhloPdnKEXGhZJA3dQ.png)

选择“Select size”来更改虚拟机大小，然后选择D-Series v4选项下的D2s\_v4\(这个大小有2个内核，8GB内存，并启用Premium SSDs\)。您也可以使用F2s\_v2实例，它有2个内核、4 GB内存，并启用Premium SSDs，但对于目前采用spot instance价格的更大型的VM来说，价格实际上更便宜。您可以点击[this link](https://azure.microsoft.com/en-us/pricing/details/virtual-machines/linux/)查看不同地区的价格。

![Image for post](https://miro.medium.com/max/957/1*JzebwGho6qDFbzlqCJSN9w.png)

选好虚拟机的大小后，选择“View pricing history and compare prices in nearby regions”(查看定价历史和比较附近地区的价格)查看现货价格在过去3个月中的变化，以及使用附近可能具有更多闲置产能的地区是否更便宜。

![Image for post](https://miro.medium.com/max/763/1*UQYmhtL8JMhrOkaWk8cloA.png)

在本文撰写之时，北欧D2s\_v4的spot instance定价为每小时0.07975美元，每年大约698.61美元。采用spot instance定价，价格降至每小时0.01295美元，约合每年113.44美元，**节省83.76%！**

有些地区甚至更便宜，例如东美每小时0.01060美元，每年大约92.86美元！

![Image for post](https://miro.medium.com/max/677/1*Th5aDwLS6_IoM0LidRbH6g.png)

下面您可以看到北欧和附近地区的虚拟机过去3个月的历史价格。
![Image for post](https://miro.medium.com/max/30/1*OJ4monpMy8DhWw_HWycMjg.png?q=20)

![Image for post](https://miro.medium.com/max/968/1*OJ4monpMy8DhWw_HWycMjg.png)

### 比亚马逊AWS便宜

相比之下，一个c5.large实例在AWS上每小时花费为0.085美元。每年总计约745美元。现货实例可以节省62%，总费用降低至462美元。

下一步是更改虚拟机的用户名，以便与其他Avalanche教程保持一致，将用户名更改为ubuntu。否则，您将需要在本文后面更改一些命令，并使用您的新用户名替换ubuntu。

![Image for post](https://miro.medium.com/max/780/1*CNmFTz056EUmahfi5zG3JQ.png)

### 磁盘

选择下一步：“Disks”，然后为实例配置磁盘。磁盘有两种选择，一种是高级固态硬盘，性能更好，64GB磁盘，每月10美元左右，另一种是标准固态硬盘，性能较差，每月5美元左右。对于标准固态硬盘，每10000个交易（读/写和删除）还需支付0.002美元，而高级固态硬盘已经把一切费用都包括在内了。就我个人而言，我选择高级固态硬盘，一是为了更好的性能，二是因为磁盘可能会被频繁使用，所以从长远来看甚至可能会更便宜。

选择“Next: Networking”转到网络配置

![Image for post](https://miro.medium.com/max/763/1*Oqv9nA8KoSIyq95DuPDN4g.png)

### 网络配置

您需要使用静态IP，这样分配给节点的公共IP在节点停止时也不会改变。在“Public IP ”下选择“Create new”。

![Image for post](https://miro.medium.com/max/774/1*2wsz1_OG7DpLA7jmTJfm0A.png)

然后选择 “Static” 作为分配类型。

![Image for post](https://miro.medium.com/max/347/1*y-JbYlRNN3GNNXtZDP-UXQ.png)

然后我们需要配置网络安全组来控制对Avalanche节点的入站访问。NIC网络安全组类型选择“Advanced”，然后选择“Create new”。

![Image for post](https://miro.medium.com/max/763/1*e5Y-mHGkn42A-mJx6o3J0g.png)

为了安全起见，您需要限定哪些人可以远程连接到您的节点。为此，您首先需要知道您现有的公共IP是什么。可以在谷歌搜索“what’s my ip”。

![Image for post](https://miro.medium.com/max/450/1*-aV-AdrABCUmludxXUPV6Q.png)

除非您特别要求，否则系统很可能已经为您的主页分配了动态公共IP，因此您分配到的公共IP将来可能会发生变化。不过还是建议限制对您当前IP的访问，如果主IP发生变化，无法远程连接到虚拟机，只需用新的公共IP更新网络安全规则，就可以重新连接。

注意：如果您的主IP发生变化，需要在部署后更改网络安全组规则，请搜索“avalanche-nsg”，然后可以使用新IP修改安全外壳协议和端口9650规则。**9651端口需要对所有人保持开放**尽管这是它与其他Avalanche节点通信的方式。

![Image for post](https://miro.medium.com/max/481/1*fR6SrKhTSTQ4cS3PoFrQfQ.png)

现在您已经拥有了公共IP，请在入站规则下选择“default allow ssh”以对其进行修改。将来源从“Any”更改为“IP Addresses”，然后在Source IP地址字段中输入您从谷歌搜索到的公共IP地址。将底部的Priority改为100，然后点击Save。

![Image for post](https://miro.medium.com/max/1039/1*iLP9gUH4weTfsPcmeUbXLw.png)

然后选择“+ Add an inbound rule”，为RPC访问添加另一个规则，仅限于您的IP。将Source更改为“IP Addresses”，并在Source IP 字段中输入从谷歌搜索到的公共IP。这次将“Destination port ranges”字段更改为9650，协议选择“TCP”。将优先级priority改为110，并为其命名为“Avalanche\_RPC”，然后点击Add。

![Image for post](https://miro.medium.com/max/914/1*Zg9mHCkU7G5BoinN0EWZAg.png)

选择“+ Add an inbound rule”为Avalanche协议添加最后一个规则，以便其他节点可以与您的节点通信。这条规则需要对所有人开放，所以请将“Source”设置为“Any”。将目标端口范围更改为“9651”并将协议更改为“TCP”。将priority改为120，并把协议命名为“Avalanche\_Protocol”，然后点击Add。

![Image for post](https://miro.medium.com/max/662/1*tIMEp7O83NIUitWwlcHAxw.png)

网络安全组应该像下面这样\(除了你的公共IP地址不同\)，然后按OK。

![Image for post](https://miro.medium.com/max/363/1*7rAR3C_UrX94iXxL4sdV9g.png)

其他设置保持默认，然后点击“Review + create”来创建虚拟机。

![Image for post](https://miro.medium.com/max/828/1*01yGser7qYjiXDngemqClQ.png)

首先，执行验证测试。如果您在此处收到错误，请确保您选择了Pay-As-You-Go(现收现付)订阅模式，没有使用Free Trial(免费试用)订阅，因为Spot instance不可用。确认一切正确无误，然后点“Create”。

![Image for post](https://miro.medium.com/max/751/1*HyQP7HJCiVQPPiWodRj6aQ.png)

然后，您应该会收到一个提示，要求您生成一个新的密钥对来连接您的虚拟机。选择“Download private key and create resource”将私人密钥下载到你的个人电脑。

![Image for post](https://miro.medium.com/max/456/1*FCAVco29fcianH4TjxVGzQ.png)

完成部署后，选择 “Go to resource”

![Image for post](https://miro.medium.com/max/608/1*dXl1RkH6xZvHkdI1d-XsOQ.png)

## 修改配置磁盘的大小

默认情况下，Ubuntu虚拟机将配置一个30GB的高级固态硬盘，虽然这应该已经足够了，但我个人不希望出现质押期间还要为其扩容的麻烦。如果您想将其增加到64GB，或者以后需要增加，可以参照以下步骤。

![Image for post](https://miro.medium.com/max/880/1*2uJoRLC586qLEhr1RNNeTg.png)

要更改磁盘大小，需要将虚拟机停止并解除配置。选择“Stop”并等待状态显示为解除配置。然后选定左侧的“Disks”。

![Image for post](https://miro.medium.com/max/976/1*eUCBMgyQtEukvCyi3pm48g.png)

选定当前配置的磁盘名进行修改。

![Image for post](https://miro.medium.com/max/696/1*faady6O9ZyS2AvKotRFFWA.png)

选定左侧设置中的“Size + performance”，将大小更改为64GB，然后点“Resize”。

![Image for post](https://miro.medium.com/max/850/1*zZhh27myfdBcEhf3QMhs3A.png)

现在这样做也可以在ubuntu中自动扩展分区。在导航设置中选定Avalanche回到虚拟机概览页面。

![Image for post](https://miro.medium.com/max/946/1*RGlKMhmlZ1__6u3RjFSDMA.png)

然后启动虚拟机。

![Image for post](https://miro.medium.com/max/929/1*vgVR-3sRejyBcXrMn65v5g.png)

## 连接到Avalanche节点

下面的说明介绍了如何将一台Windows 10设备连接到虚拟机。有关如何将一台ubuntu设备连接到虚拟机的说明，请参阅[AWS tutorial](https://stackedit.io/setting-up-an-avalanche-node-with-amazon-web-services-aws.md)。

在本地个人计算机C盘根目录中创建一个名为Avalanche的文件夹，然后将之前下载的 Avalanche\_key.pem文件移动到该文件夹中。然后右击该文件，选择属性。转到安全选项卡，在底部选择“Advanced”。

![Image for post](https://miro.medium.com/max/719/1*KlzhuVcn5Vt0imxDPblBtA.png)

选择“Disable inheritance”，然后点击“Remove all inherited permissions from this object”以删除该文件上的所有现有权限。

![Image for post](https://miro.medium.com/max/740/1*VxuomVeWbhYquRynA8hP4Q.png)

然后选择“Add”添加一个新的权限，并在顶部选择“Select a principal”。在弹出的对话框中输入您用于登录计算机的用户名。在本实例中，我以本地用户Seq的身份登录，您可能有用于登录的微软账号，因此，使用您登录个人电脑的账号，点“Check Names”，账号下面应该加上下划线以进行验证，然后点击OK。

![Image for post](https://miro.medium.com/max/758/1*sMxk7zaRHVTqA0UyHTKwzQ.png)

然后确保在权限部分仅选择“Read & Execute”和“Read”，然后点击OK。

![Image for post](https://miro.medium.com/max/903/1*5Fkh3FJQuNeWQyEd0irjtA.png)

应该像下面这样，除了个人电脑名称/用户名不同。这只意味着，为了安全起见，密钥文件不能被其他账户修改或访问，所以他们不能访问您的Avalanche节点。

![Image for post](https://miro.medium.com/max/736/1*F-YK0xdB92cIweCQFGGRvA.png)

### 找到您的Avalanche节点公共IP

在Azure门户中，记录分配给节点的静态公共IP地址。

![Image for post](https://miro.medium.com/max/1082/1*5cf1dAAO0G7Dzu2s0Xxh-Q.png)

要登录到Avalanche节点，需要在Windows 10设备上搜索“cmd”并选定“Command Prompt”来打开命令提示符。

![Image for post](https://miro.medium.com/max/384/1*NlYlg9of5O9fQtiroqMFZw.png)

然后使用以下命令，将“EnterYourAzureIPHere”替换为Azure门户上显示的静态IP地址。

ssh -i C:\Avalanche\Avalanche\_key.pem ubuntu@EnterYourAzureIPHere

在本实例中就是：

ssh -i C:\Avalanche\Avalanche\_key.pem ubuntu@13.74.10.81

第一次连接时，您会收到一个请求继续的提示，输入“yes”。

![Image for post](https://miro.medium.com/max/651/1*Hp1AF-03TbO-eRUvuKvZcA.png)

现在您应该已经连接到您的节点了。

![Image for post](https://miro.medium.com/max/967/1*Kc3rna-3SQV3tnMMLkMi6A.png)

以下部分摘自Colin关于[在Amazon的AWS上配置Avalanche节点](setting-up-an-avalanche-node-with-amazon-web-services-aws.md)的优秀教程。

### 使用安全补丁更新Linux系统

我们正在处理节点，建议将其更新至最新安装包。如需更新，请按顺序逐个运行以下命令：

```text
sudo apt update
sudo apt upgrade -y
sudo reboot
```

![Image for post](https://miro.medium.com/max/793/1*_2UmPN6vabjGe6aihX9KqA.png)

借此，我们可以为操作系统将实例与最新安全补丁同步。这还会重新启动节点。我们将给节点一到两分钟的时间重新启动，然后像之前一样再次登录。

### 设置Avalanche节点

现在，我们需要设置我们的Avalanche节点。为此，请按照[Set Up Avalanche Node With Installer](set-up-node-with-installer.md)教程，安装过程自动进行。您需要从我们之前设置的Azure端口复制的“IPv4 Public IP”。

一旦完成安装，我们的节点应处于引导中！我们可以运行以下命令来查看avalanchego节点的最新状态：
Once the installation is complete, our node should now be bootstrapping! We can run the following command to take a peek at the latest status of the avalanchego node:

```text
sudo systemctl status avalanchego
```

To check the status of the bootstrap, we’ll need to make a request to the local RPC using “curl”. This request is as follows:

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

The node can take some time \(upward of an hour at this moment writing\) to bootstrap. Bootstrapping means that the node downloads and verifies the history of the chains. Give this some time. Once the node is finished bootstrapping, the response will be:

```text
{
    "jsonrpc": "2.0",
    "result": {
        "isBootstrapped": true
    },
    "id": 1
}
```

We can always use “sudo systemctl status avalanchego” to peek at the latest status of our service as before, as well.

### Get your NodeID <a id="20a7"></a>

We absolutely must get our NodeID if we plan to do any validating on this node. This is retrieved from the RPC as well. We call the following curl command to get our NodeID.

```text
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"info.getNodeID"
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/info
```

If all is well, the response should look something like:

```text
{"jsonrpc":"2.0","result":{"nodeID":"NodeID-Lve2PzuCvXZrqn8Stqwy9vWZux6VyGUCR"},"id":1}
```

That portion that says, “NodeID-Lve2PzuCvXZrqn8Stqwy9vWZux6VyGUCR” is our NodeID, the entire thing. Copy that and keep that in our notes. There’s nothing confidential or secure about this value, but it’s an absolute must for when we submit this node to be a validator.

### Backup your Staking Keys <a id="ef3e"></a>

The last thing that should be done is backing up our staking keys in the untimely event that our instance is corrupted or terminated. It’s just good practice for us to keep these keys. To back them up, we use the following command:

```text
scp -i C:\Avalanche\avalanche_key.pem -r ubuntu@EnterYourAzureIPHere:/home/ubuntu/.avalanchego/staking C:\Avalanche
```

As before, we’ll need to replace “EnterYourAzureIPHere” with the appropriate value that we retrieved. This backs up our staking key and staking certificate into the C:\Avalanche folder we created before.

![Image for post](https://miro.medium.com/max/358/1*nqsjJAv2fkcLKPri5idN-Q.png)

<!--stackedit_data:
eyJoaXN0b3J5IjpbMjE0NTY1ODQ3OCwtNTQxMTI1Mzk5LC0xNz
E0Nzg2NzU2LDEyNTYwMDE0ODIsLTIxODAxMDksMTU5NjkwNDc3
MiwxMjM0NTEyOTEwLC04NTgwNzUwMjFdfQ==
-->