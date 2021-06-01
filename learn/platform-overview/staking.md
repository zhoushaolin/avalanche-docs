---
描述: 学习如何通过验证或委托在雪崩上质押
---

# 质押
质押是锁定代币以支持网络的过程，同时获得回报(奖励可以增加网络效用，金钱补偿等)。 下注的概念是由Peercoin的Sunny King和Scott纳达尔[首次正式引入](https://web.archive.org/web/20160306084128/https://peercoin.net/assets/paper/peercoin-paper.pdf)。 

### 权益证明是如何工作的? 

为了抵抗[sybil攻击](https://support.avalabs.org/en/articles/4064853-what-is-a-sybil-attack)，去中心化的网络必须要求用稀缺资源来支付网络影响力。 这使得攻击者要获得对网络的足够影响力, 以危害其安全的代价是非常昂贵的。 在工作量证明系统中，稀缺资源是计算能力。 在Avalanche上，稀缺资源是原生代币[AVAX](.. ../../# Avalanche - AVAX -token)。 要[validate](http://support.avalabs.org/en/articles/4064704-what-is-a-blockchain-validator)雪崩上的区块链, 必须质押AVAX。 

## Avalanche上的质押参数

当验证器完成对[主网](http://support.avalabs.org/en/articles/4135650-what-is-the-primary-network)的验证时，它将收到之前所质押的AVAX代币。 它可能会因为帮助保护网络而获得奖励。 验证器只有在验证期间响应充分且正确时才会收到[验证奖励](http://support.avalabs.org/en/articles/4587396-what-are-validator-staking-rewards)。 阅读[Avalanche 代币白皮书](https://files.avalabs.org/papers/token.pdf)来了解更多关于AVAX和质押机制。 

**只要满足所有这些参数**，质押奖励就会在锁定期限结束时发送到你的钱包地址。

* 验证器必须质押的最小金额为2,000 AVAX 
* 被委托者必须委托的最小数量是25 AVAX 
* 质押资金进行验证的最短时间是2周
* 质押资金进行验证的最长时间是1年 
* 委托质押资金的最短时间是2周 
* 委托质押资金进行验证的最长时间是1年 
* 最低的委托费率是2% 
* 一个验证器(他们自己的质押+委托给他们的质押)的最大权重是最小的3e6 AVAX, 5倍于验证器的质押金额。 例如，如果你质押2000个AVAX生成为一个验证器，那么只有8000个AVAX可以委托给你的节点\(不是每个委托者都可以委托这么多\)。 
* 为了获得奖励，验证者必须正确且在线的最短的时间是60%

## 验证器

**验证器** 确保雪崩的安全，创建新的块/顶点，并处理交易。 为了达成共识，验证者会反复对彼此进行抽样。 给定的验证者被采样的概率与其所质押的份额成正比。 

当您将一个节点添加到验证器集时，您可以指定: 

* 你的节点的ID
* 你想什么时候开始及停止验证
* 质押多少AVAX 
* 接收发送奖励的地址
* 你的委托费率\(见下文\)

验证器必须质押的最小金额为2,000 AVAX。 

请注意，一旦发布交易以添加节点作为验证器，就无法更改参数。 **您不能提前移除您的质押或更改质押金额、节点ID或奖励地址。 **请确保您在下面的API调用中使用了正确的值。 如果你不确定，可以在[Discord](https://chat.avax.network)上寻求帮助，或者浏览我们的[开发者常见问题解答](http://support.avalabs.org/en/collections/2618154-developer-faq)。 


### 运行验证器

如果您正在运行一个验证器，那么确保您的节点连接良好，以确保您接收奖励是很重要的。 详见[这里](http://support.avalabs.org/en/articles/4594192-networking-setup)。 

当您发布交易以添加验证器时，所质押的代币和交易费用将从您控制的地址中扣除。 当您完成验证后，质押资金将返回到它们原来的地址。 如果您获得了奖励，它将被发送到您添加为验证器时指定的地址。 

#### 允许API调用

要从远程机器对您的节点进行API调用，允许API端口上的通信\(默认为`9650` \)，并使用参数`--http-host=`运行您的节点。    

您应该禁用所有不会通过命令行参数使用的api。 你应该将你的网络配置为只允许从信任的机器访问API端口。 \(例如, 你的个人电脑。\) 

#### 为什么我的正常运行时间很短?  

Avalanche上的每个验证器都会跟踪其他验证器的正常运行时间。 你可以通过调用`info.peers`来查看节点的连接, 以及每个连接的正常运行时间。 **这只是一个节点的观点**。 其他节点可能会以不同的方式感知您的节点的正常运行时间。 仅仅因为一个节点认为您的正常运行时间较低，并不意味着您不会获得质押奖励。 

您的节点没有连接到另一个节点的可能原因是NAT穿越失败，并且您没有使用`--public-ip=[NODE'S PUBLIC IP]`启动您的节点。 将来，我们将添加更好的监控，以便更容易地验证您的节点是否连接良好。 

#### 保密管理 

您在验证节点上需要的唯一秘密是其质押密钥，即确定节点ID的TLS密钥。 当你第一次启动一个节点时，质押密钥就被创建并放入`$HOME/.avalanchego/staking/staker.key`中。 你应该在安全的地方备份这个文件\(和`staker.crt`\)。 丢失密钥可能会危及您的验证奖励，因为您的节点将拥有一个新的ID。 

您不需要在验证节点上拥有AVAX资金。 事实上，最好**不要**在您的节点上有太多资金。 几乎你所有的资金都应该在“冷”地址中，其私钥不在任何计算机上。 

#### 监测

跟着本教程了解如何监测节点的正常运行时间、常规运行状况等。 

{% page-ref page="../../build/tutorials/nodes-and-staking/setting-up-node-monitoring.md" %}

## 委托人 

委托者是代币持有者，他希望参与质押，但选择通过委托信任现有的验证节点。 

当你委托质押到一个验证器时，你指定: 

* 您正在委托的节点的ID 
* 当你想开始/停止委托质押时(必须在验证器正在验证的时候) 
* 你质押多少AVAX 
* 接收发送奖励的地址 

委托者必须委托的最小数量是25 AVAX。 

请注意，一旦您发布交易将您的质押添加到一个委托者，就不能再更改参数。 **您不能提前移除您的质押或更改质押金额、节点ID或奖励地址。**如果你不确定，可以在[Discord](https://chat.avax.network)上寻求帮助，或者浏览我们的[开发者常见问题解答](http://support.avalabs.org/en/collections/2618154-developer-faq)。 

### 委托奖励 

If the validator that you delegate tokens to is sufficiently correct and responsive, you will receive a reward when you are done delegating. Delegators are rewarded according to the same function as validators. However, the validator that you delegate to keeps a portion of your reward–specified by the validator’s delegation fee rate.

When you issue the transaction to delegate tokens, the staked tokens and transaction fee are deducted from the addresses you control. When you are done delegating, the staked tokens are returned to your address. If you earned a reward, it is sent to the address you specified when you delegated tokens.

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTIwMDQzOTQzNDEsLTE3MjIzNTE3MTEsOD
UwMDU0MzksLTE2MTU2NDA2NjgsMTg4NzYwODczMSwxMjkyMDg2
OTg0LC0xODY2ODk2NDg4LC00ODUxODA4OTIsLTE4NjQwNTM5Mz
YsMjAzOTA1NDIyMyw4MzY0MDg4NzEsMTMxMDgyMTY4LDE0NTYw
ODEzMjYsLTM1NTU1NTgzNCw3Njk1MDE2MzhdfQ==
-->