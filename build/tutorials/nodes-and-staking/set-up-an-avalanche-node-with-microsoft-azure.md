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

然后我们需要配置网络安全组来控制对Avalanche节点的入站访问。NIC网络安全组类型选择“高级”，然后选择“新建”。
Then we need to configure the network security group to control access inbound to the Avalanche node. Select “Advanced” as the NIC network security group type and select “Create new”

![Image for post](https://miro.medium.com/max/763/1*e5Y-mHGkn42A-mJx6o3J0g.png)

For security purposes you want to restrict who is able to remotely connect to your node. To do this you will first want to find out what your existing public IP is. This can be done by going to google and searching for “what’s my ip”.

![Image for post](https://miro.medium.com/max/450/1*-aV-AdrABCUmludxXUPV6Q.png)

It’s likely that you have been assigned a dynamic public IP for your home, unless you have specifically requested it, and so your assigned public IP may change in the future. It’s still recommended to restrict access to your current IP though, and then in the event your home IP changes and you are no longer able to remotely connect to the VM, you can just update the network security rules with your new public IP so you are able to connect again.

NOTE: If you need to change the network security group rules after deployment if your home IP has changed, search for “avalanche-nsg” and you can modify the rule for SSH and Port 9650 with the new IP. **Port 9651 needs to remain open to everyone** though as that’s how it communicates with other Avalanche nodes.

![Image for post](https://miro.medium.com/max/481/1*fR6SrKhTSTQ4cS3PoFrQfQ.png)

Now that you have your public IP select the default allow ssh rule on the left under inbound rules to modify it. Change Source from “Any” to “IP Addresses” and then enter in your Public IP address that you found from google in the Source IP address field. Change the Priority towards the bottom to 100 and then press Save.

![Image for post](https://miro.medium.com/max/1039/1*iLP9gUH4weTfsPcmeUbXLw.png)

Then select “+ Add an inbound rule” to add another rule for RPC access, this should also be restricted to only your IP. Change Source to “IP Addresses” and enter in your public IP returned from google into the Source IP field. This time change the “Destination port ranges” field to 9650 and select “TCP” as the protocol. Change the priority to 110 and give it a name of “Avalanche\_RPC” and press Add.

![Image for post](https://miro.medium.com/max/914/1*Zg9mHCkU7G5BoinN0EWZAg.png)

Select “+ Add an inbound rule” to add a final rule for the Avalanche Protocol so that other nodes can communicate with your node. This rule needs to be open to everyone so keep “Source” set to “Any”. Change the Destination port range to “9651” and change the protocol to “TCP”. Enter a priority of 120 and a name of Avalanche\_Protocol and press Add.

![Image for post](https://miro.medium.com/max/662/1*tIMEp7O83NIUitWwlcHAxw.png)

The network security group should look like the below \(albeit your public IP address will be different\) and press OK.

![Image for post](https://miro.medium.com/max/363/1*7rAR3C_UrX94iXxL4sdV9g.png)

Leave the other settings as default and then press “Review + create” to create the Virtual machine.

![Image for post](https://miro.medium.com/max/828/1*01yGser7qYjiXDngemqClQ.png)

First it will perform a validation test. If you receive an error here, make sure you selected Pay-As-You-Go subscription model and you are not using the Free Trial subscription as Spot instances are not available. Verify everything looks correct and press “Create”

![Image for post](https://miro.medium.com/max/751/1*HyQP7HJCiVQPPiWodRj6aQ.png)

You should then receive a prompt asking you to generate a new key pair to connect your virtual machine. Select “Download private key and create resource” to download the private key to your PC.

![Image for post](https://miro.medium.com/max/456/1*FCAVco29fcianH4TjxVGzQ.png)

Once your deployment has finished, select “Go to resource”

![Image for post](https://miro.medium.com/max/608/1*dXl1RkH6xZvHkdI1d-XsOQ.png)

## Change the Provisioned Disk Size <a id="00dc"></a>

By default, the Ubuntu VM will be provisioned with a 30 GB Premium SSD, whilst this should be sufficient, I personally didn’t want the hassle of potentially needing to extend this later into the staking period. I have included the steps below if you want to increase it to 64 GB or if you ever need to increase it at a later date.

![Image for post](https://miro.medium.com/max/880/1*2uJoRLC586qLEhr1RNNeTg.png)

To change the Disk size, the VM needs to be stopped and deallocated. Select “Stop” and wait for the status to show deallocated. Then select “Disks” on the left.

![Image for post](https://miro.medium.com/max/976/1*eUCBMgyQtEukvCyi3pm48g.png)

Select the Disk name that’s current provisioned to modify it

![Image for post](https://miro.medium.com/max/696/1*faady6O9ZyS2AvKotRFFWA.png)

Select “Size + performance” on the left under settings and change the size to 64 GB and press “Resize”.

![Image for post](https://miro.medium.com/max/850/1*zZhh27myfdBcEhf3QMhs3A.png)

Doing this now will also extend the partition automatically within ubuntu. To go back to the virtual machine overview page, select Avalanche in the navigation setting.

![Image for post](https://miro.medium.com/max/946/1*RGlKMhmlZ1__6u3RjFSDMA.png)

Then start the VM

![Image for post](https://miro.medium.com/max/929/1*vgVR-3sRejyBcXrMn65v5g.png)

## Connect to the Avalanche Node <a id="8bb7"></a>

The following instructions show how to connect to the Virtual Machine from a Windows 10 machine. For instructions on how to connect from a ubuntu machine see the [AWS tutorial](setting-up-an-avalanche-node-with-amazon-web-services-aws.md).

On your local PC, create a folder on the root of the C: drive called Avalanche and then move the Avalanche\_key.pem file you downloaded before into the folder. Then right click the file and select Properties. Go to the security tab and select “Advanced” at the bottom

![Image for post](https://miro.medium.com/max/719/1*KlzhuVcn5Vt0imxDPblBtA.png)

Select “Disable inheritance” and then “Remove all inherited permissions from this object” to remove all existing permissions on that file.

![Image for post](https://miro.medium.com/max/740/1*VxuomVeWbhYquRynA8hP4Q.png)

Then select “Add” to add a new permission and choose “Select a principal” at the top. From the pop-up box enter in your user account that you use to log into your machine. In this example I log on with a local user called Seq, you may have a Microsoft account that you use to log in, so use whatever account you login to your PC with and press “Check Names” and it should underline it to verify and press OK.

![Image for post](https://miro.medium.com/max/758/1*sMxk7zaRHVTqA0UyHTKwzQ.png)

Then from the permissions section make sure only “Read & Execute” and “Read” are selected and press OK.

![Image for post](https://miro.medium.com/max/903/1*5Fkh3FJQuNeWQyEd0irjtA.png)

It should look something like the below, except with a different PC name / user account. This just means the key file can’t be modified or accessed by any other accounts on this machine for security purposes so they can’t access your Avalanche Node.

![Image for post](https://miro.medium.com/max/736/1*F-YK0xdB92cIweCQFGGRvA.png)

### Find your Avalanche Node Public IP <a id="4687"></a>

From the Azure Portal make a note of your static public IP address that has been assigned to your node.

![Image for post](https://miro.medium.com/max/1082/1*5cf1dAAO0G7Dzu2s0Xxh-Q.png)

To log onto the Avalanche node, open command prompt by searching for “cmd” and selecting “Command Prompt” on your Windows 10 machine.

![Image for post](https://miro.medium.com/max/384/1*NlYlg9of5O9fQtiroqMFZw.png)

Then use the following command and replace the EnterYourAzureIPHere with the static IP address shown on the Azure portal.

ssh -i C:\Avalanche\Avalanche\_key.pem ubuntu@EnterYourAzureIPHere

for my example its:

ssh -i C:\Avalanche\Avalanche\_key.pem ubuntu@13.74.10.81

The first time you connect you will receive a prompt asking to continue, enter yes.

![Image for post](https://miro.medium.com/max/651/1*Hp1AF-03TbO-eRUvuKvZcA.png)

You should now be connected to your Node.

![Image for post](https://miro.medium.com/max/967/1*Kc3rna-3SQV3tnMMLkMi6A.png)

The following section is taken from Colin’s excellent tutorial for [configuring an Avalanche Node on Amazon’s AWS](setting-up-an-avalanche-node-with-amazon-web-services-aws.md).

### Update Linux with security patches <a id="8a1c"></a>

Now that we are on our node, it’s a good idea to update it to the latest packages. To do this, run the following commands, one-at-a-time, in order:

```text
sudo apt update
sudo apt upgrade -y
sudo reboot
```

![Image for post](https://miro.medium.com/max/793/1*_2UmPN6vabjGe6aihX9KqA.png)

This will make our instance up to date with the latest security patches for our operating system. This will also reboot the node. We’ll give the node a minute or two to boot back up, then log in again, same as before.

### Set up the Avalanche Node <a id="5688"></a>

Now we’ll need to set up our Avalanche node. To do this, follow the [Set Up Avalanche Node With Installer](set-up-node-with-installer.md) tutorial which automates the installation process. You will need the “IPv4 Public IP” copied from the Azure Portal we set up earlier.

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
eyJoaXN0b3J5IjpbMTI1NjAwMTQ4MiwtMjE4MDEwOSwxNTk2OT
A0NzcyLDEyMzQ1MTI5MTAsLTg1ODA3NTAyMV19
-->