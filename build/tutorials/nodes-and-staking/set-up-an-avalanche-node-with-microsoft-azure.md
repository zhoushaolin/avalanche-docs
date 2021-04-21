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
First you will need a Microsoft Account, if you don’t have one already you will see an option to create one at the following link. If you already have one, make sure to set up 2 Factor authentication to secure your node by going to the following link and then selecting “Two-step verification” and following the steps provided.

[https://account.microsoft.com/security](https://account.microsoft.com/security)

![Image for post](https://miro.medium.com/max/1135/1*tr3rEcrvI4rEpC7KPYqg6g.png)

Once two factor has been configured log into the Azure portal by going to [https://portal.azure.com](https://portal.azure.com/) and signing in with your Microsoft account. When you login you won’t have a subscription, so we need to create one first. Select “Subscriptions” as highlighted below:

![Image for post](https://miro.medium.com/max/648/1*5Jp8oXzczaEND-z9_QZaQA.png)

Then select “+ Add” to add a new subscription

![Image for post](https://miro.medium.com/max/374/1*Lw3HklSSC8NDN2ftQEVgYA.png)

If you want to use Spot Instance VM Pricing \(which will be considerably cheaper\) you can’t use a Free Trial account \(and you will receive an error upon validation\), so **make sure to select Pay-As-You-Go.**

![Image for post](https://miro.medium.com/max/789/1*TO5Uh07OkH_QdwludEgapg.png)

Enter your billing details and confirm identity as part of the sign-up process, when you get to Add technical support select the without support option \(unless you want to pay extra for support\) and press Next.

![Image for post](https://miro.medium.com/max/783/1*5KJOATvu3giAr6ygO3rF6Q.png)

## Create a Virtual Machine <a id="41ac"></a>

Now that we have a subscription, we can create the Ubuntu Virtual Machine for our Avalanche Node. Select the Icon in the top left for the Menu and choose “+ Create a resource”.

![Image for post](https://miro.medium.com/max/565/1*3nSPwgEM3oIgrIlIo-TS1w.png)

Select Ubuntu Server 18.04 LTS \(this will normally be under the popular section or alternatively search for it in the marketplace\)

![Image for post](https://miro.medium.com/max/605/1*Y0iZEZExC36c7FXqPlrPuw.png)

This will take you to the Create a virtual machine page as shown below:

![Image for post](https://miro.medium.com/max/775/1*cv0z0mt6Uavx5MkiazpiUA.png)

First, enter a virtual machine a name, this can be anything but in my example, I have called it Avalanche \(This will also automatically change the resource group name to match\)

Then select a region from the drop-down list. Select one of the recommended ones in a region that you prefer as these tend to be the larger ones with most features enabled and cheaper prices. In this example I have selected North Europe.

![Image for post](https://miro.medium.com/max/769/1*XOpa22qSdNI-0PW5oIyUhQ.png)

You have the option of using spot pricing to save significant amounts on running costs. Spot instances use a supply-and-demand market price structure. As demand for instances goes up, the price for the spot instance goes up. If there is insufficient capacity, then your VM will be turned off. The chances of this happening are incredibly low though, especially if you select the Capacity only option. Even in the unlikely event it does get turned off temporarily you only need to maintain at least 60% up time to receive the staking rewards and there is no slashing implemented in Avalanche.

Select Yes for Azure Spot instance, select Eviction type to Capacity Only and **make sure to set the eviction policy to Stop / Deallocate — This is very important otherwise the VM will be deleted**

![Image for post](https://miro.medium.com/max/756/1*zWWiYhloPdnKEXGhZJA3dQ.png)

Choose “Select size” to change the Virtual Machine size, and from the menu select D2s\_v4 under the D-Series v4 selection \(This size has 2 Cores, 8 GB Memory and enables Premium SSDs\). You can use F2s\_v2 instances instead, with are 2 Cores, 4 GB Memory and enables Premium SSDs\) but the spot price actually works out cheaper for the larger VM currently with spot instance prices. You can use [this link](https://azure.microsoft.com/en-us/pricing/details/virtual-machines/linux/) to view the prices across the different regions.

![Image for post](https://miro.medium.com/max/957/1*JzebwGho6qDFbzlqCJSN9w.png)

Once you have selected the size of the Virtual Machine, select “View pricing history and compare prices in nearby regions” to see how the spot price has changed over the last 3 months, and whether it’s cheaper to use a nearby region which may have more spare capacity.

![Image for post](https://miro.medium.com/max/763/1*UQYmhtL8JMhrOkaWk8cloA.png)

At the time of this article, spot pricing for D2s\_v4 in North Europe costs $0.07975 per hour, or around $698.61 a year. With spot pricing, the price falls to $0.01295 per hour, which works out at about $113.44 a year, **a saving of 83.76%!**

There are some regions which are even cheaper, East US for example is $0.01060 per hour or around $92.86 a year!

![Image for post](https://miro.medium.com/max/677/1*Th5aDwLS6_IoM0LidRbH6g.png)

Below you can see the price history of the VM over the last 3 months for North Europe and regions nearby.![Image for post](https://miro.medium.com/max/30/1*OJ4monpMy8DhWw_HWycMjg.png?q=20)

![Image for post](https://miro.medium.com/max/968/1*OJ4monpMy8DhWw_HWycMjg.png)

### Cheaper than Amazon AWS <a id="45e9"></a>

As a comparison a c5.large instance costs $0.085 USD per hour on AWS. This totals ~$745 USD per year. Spot instances can save 62%, bringing that total down to $462.

The next step is to change the username for the VM, to align with other Avalanche tutorials change the username to ubuntu. Otherwise you will need to change several commands later in this article and swap out ubuntu with your new username.

![Image for post](https://miro.medium.com/max/780/1*CNmFTz056EUmahfi5zG3JQ.png)

### Disks <a id="ed2e"></a>

Select Next: Disks to then configure the disks for the instance. There are 2 choices for disks, either Premium SSD which offer greater performance with a 64 GB disk costs around $10 a month, or there is the standard SSD which offers lower performance and is around $5 a month. You also have to pay $0.002 per 10,000 transaction units \(reads / writes and deletes\) with the Standard SSD, whereas with Premium SSDs everything is included. Personally, I chose the Premium SSD for greater performance, but also because the disks are likely to be heavily used and so may even work out cheaper in the long run.

Select Next: Networking to move onto the network configuration

![Image for post](https://miro.medium.com/max/763/1*Oqv9nA8KoSIyq95DuPDN4g.png)

### Network Config <a id="bc5d"></a>

You want to use a Static IP so that the public IP assigned to the node doesn’t change in the event it stops. Under Public IP select “Create new”

![Image for post](https://miro.medium.com/max/774/1*2wsz1_OG7DpLA7jmTJfm0A.png)

Then select “Static” as the Assignment type

![Image for post](https://miro.medium.com/max/347/1*y-JbYlRNN3GNNXtZDP-UXQ.png)

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
eyJoaXN0b3J5IjpbMjAwMjUzMjAyMCwtODU4MDc1MDIxXX0=
-->