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


### 运行验证器<a id="running-a-validator"></a>

如果您正在运行一个验证器，那么确保您的节点连接良好，以确保您接收奖励是很重要的。 详见[这里](http://support.avalabs.org/en/articles/4594192-networking-setup)。 

When you issue the transaction to add a validator, the staked tokens and transaction fee are deducted from the addresses you control. When you are done validating, the staked funds are returned to the addresses they came from. If you earned a reward, it is sent to the address you specified when you added yourself as a validator.

#### Allow API calls <a id="allow-api-calls"></a>

To make API calls to your node from remote machines, allow traffic on the API port \(`9650` by default\), and run your node with argument `--http-host=`

You should disable all APIs you will not use via command-line arguments. You should configure your network to only allow access to the API port from trusted machines \(e.g., your personal computer.\)

#### Why is my uptime low? <a id="why-is-my-uptime-low"></a>

Every validator on Avalanche keeps track of the uptime of other validators. You can see the connections a node has by calling `info.peers`, as well as the uptime of each connection. **This is only one node’s point of view**. Other nodes may perceive the uptime of your node differently. Just because one node perceives your uptime as being low does not mean that you will not receive staking rewards.

The likely reason that your node is not connected to another node is that NAT traversal failed, and you did not start your node with `--public-ip=[NODE'S PUBLIC IP]`. In the future, we will add better monitoring to make it easier to verify that your node is well-connected.

#### Secret Management <a id="secret-management"></a>

The only secret that you need on your validating node is its Staking Key, the TLS key that determines your node’s ID. The first time you start a node, the Staking Key is created and put in `$HOME/.avalanchego/staking/staker.key`. You should back up this file \(and `staker.crt`\) somewhere secure. Losing your Staking Key could jeopardize your validation reward, as your node will have a new ID.

You do not need to have AVAX funds on your validating node. In fact, it's best practice to **not** have a lot of funds on your node. Almost all of your funds should be in “cold" addresses whose private key is not on any computer.

#### Monitoring <a id="monitoring"></a>

Follow this tutorial to learn how to monitor your node's uptime, general health, etc.

{% page-ref page="../../build/tutorials/nodes-and-staking/setting-up-node-monitoring.md" %}

## Delegators

A delegator is a token holder, who wants to participate in staking, but chooses to trust an existing validating node through delegation.

When you delegate stake to a validator, you specify:

* The ID of the node you’re delegating to
* When you want to start/stop delegating stake \(must be while the validator is validating\)
* How many AVAX you are staking
* The address to send any rewards to

{% hint style="info" %}
The minimum amount that a delegator must delegate is 25 AVAX.
{% endhint %}

{% hint style="danger" %}
Note that once you issue the transaction to add your stake to a delegator, there is no way to change the parameters. **You can’t remove your stake early or change the stake amount, node ID, or reward address.** If you’re not sure, ask for help on [Discord](https://chat.avax.network) or browse our [Developer FAQs](http://support.avalabs.org/en/collections/2618154-developer-faq).
{% endhint %}

### Delegator rewards <a id="delegator-rewards"></a>

If the validator that you delegate tokens to is sufficiently correct and responsive, you will receive a reward when you are done delegating. Delegators are rewarded according to the same function as validators. However, the validator that you delegate to keeps a portion of your reward–specified by the validator’s delegation fee rate.

When you issue the transaction to delegate tokens, the staked tokens and transaction fee are deducted from the addresses you control. When you are done delegating, the staked tokens are returned to your address. If you earned a reward, it is sent to the address you specified when you delegated tokens.

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTIwNDkxODAyMzIsLTE4NjY4OTY0ODgsLT
Q4NTE4MDg5MiwtMTg2NDA1MzkzNiwyMDM5MDU0MjIzLDgzNjQw
ODg3MSwxMzEwODIxNjgsMTQ1NjA4MTMyNiwtMzU1NTU1ODM0LD
c2OTUwMTYzOF19
-->