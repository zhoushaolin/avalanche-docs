---
描述:深入Avalanche共识协议
---

# Avalanche共识

共识就是让一组计算机就一个决定达成一致。计算机可以通过一系列被称为共识协议的步骤来达成共识。Avalanche是一种新的共识协议，具有可扩展性、健壮性和去中心化。它具有低延迟和高吞吐量, 高效节能的，不需要特殊的计算机硬件。在敌对环境下表现良好，对“51%的攻击”具有弹性。本文档诠释了Avalanche共识协议, 白皮书在这里[here](https://www.avalabs.org/whitepapers)。

## 视频

{% embed url="https://www.youtube.com/watch?v=ZUF9sIu-D\_k" caption="" %}

## 直观认知

首先，让我们对协议建立一个直观的认识。想象一屋子人试图就午餐吃什么达成一致。假设披萨和烧烤二选一。有些人一开始可能更喜欢披萨，而有些人一开始更喜欢烧烤。不过，最终每个人的目标都是达成**共识**。

每个人都随机询问房间里的一组人他们对午餐的偏好。如果超过一半的人说披萨，这个人就会想，“好吧，看起来他们更倾向于披萨, 我现在更喜欢吃披萨。”也就是说，他们采纳了大多数人的偏好。同样，如果大多数人说烧烤，那么这个人就会选择烧烤。

每个人都重复这个过程。每一轮，越来越多的人有相同的偏好。这是因为人们越喜欢某个选项，就越有可能收到多数人的回复，并将该选项作为自己的偏好。经过足够多的回合后，他们达成共识，并决定一个选项，每个人都喜欢。

## Snowball

上面的直觉概述了雪球算法，它是Avalanche共识的一个构建区块。让我们回顾一下雪球算法。

### 参数

* _n_: 参与人数
* _k_ \(样本大小\): 1 到 _n_
* α \(quorum大小\): 1 到 _k_
* β \(决定阈值\): &gt;= 1

### 算法

```text
preference := pizza
consecutiveSuccesses := 0
while not decided:
  ask k random people their preference
  if >= α give the same response:
    preference := response with >= α
    if preference == old preference:
      consecutiveSuccesses++
    else:
      consecutiveSuccesses = 1
  else:
    consecutiveSuccesses = 0
  if consecutiveSuccesses > β:
    decide(preference)
```

### 算法的解释

每个人最初都偏爱披萨或烧烤。在某人做出决定之前，他们会询问人们_k_(样本量)，问他们喜欢什么。如果α或更多的人给出相同的反应，这个反应被采纳为新的偏好。α被称为quorum size_。如果新偏好与旧偏好相同，`consecutiveSuccesses` 计数器将递增。如果新的偏好与旧的不同，`consecutiveSuccesses` 计数器将变为`1`。如果没有响应获得quorum(相同响应的α多数)，则`1`计数器设置为`0`。

每个人都重复这个过程，直到他们连续β次得到相同的响应的法定人数。如果一个人决定吃披萨，那么其他所有遵循该协议的人最终也会决定吃披萨。

由随机抽样引起的随机偏好变化，会导致网络对某一选择的偏好，这就会导致更多的网络对该选择的偏好，直到它变得不可逆，然后节点就可以做出决定。

{% hint style="info" %}
为了更好的可视化，请查看Ava Labs的联合创始人Ted Yin的这个演示[this demo](https://tedyin.com/archive/snow-bft-demo/#/snow)。

我们的例子中，披萨和烧烤之间二选一，但是Snowball可以适应在许多可能的选择中达成决策共识。

活性和安全阈值是可参数化的。随着群体数量α的增加，安全阈值增加，活性阈值降低。这意味着网络可以容忍更多错综复杂的节点，并保持安全，这意味着所有节点最终都会同意接受或拒绝某些内容。活跃阈值是指在协议无法进展之前，可以容忍的恶意参与者的数量。

这些值是常量，在雪崩网络上非常小。样本量_k_为`20`。因此，当一个节点询问一组节点的意见时，它只询问整个网络中的 `20`个节点。quorum大小α为`14` 。因此，如果`14`或更多节点给出相同的响应，则该响应将作为查询节点的首选。决策阈值β为`20`。节点在收到`20`连续仲裁(α多数)响应后决定选择。

随着网络节点数量_n_的增加，Snowball的可扩展性非常强。无论网络中有多少参与者，发送的共识消息的数量都是相同的，因为在一个给定的查询中，即使网络中有数千个节点，一个节点也只访问`20`个节点。


## DAGs \(有向无环图\)

现在让我们介绍一种称为DAG或有向无环图(Directed Acyclic Graph)的数据结构。DAG给出决策的**部分排序**。例如, 找出这个图表中的DAG:

![Basic DAG](../../.gitbook/assets/basic-dag.png)

**a**在**b**之前。**b**在**d**之前。**d**在**e**之前。同样，我们可以说**a**出现在**e**之前。但是，由于这是部分排序: 对于某些元素，没有定义排序。例如，**b**和**c**都在**a**后面，但是**b**是在**c**之前还是在**c**之后没有概念。

另外两个DAG相关的概念是**祖先**和**后代**。祖先节点是DAG中可以与之连线的任何节点。例如,**d**的祖先是**a**, **b**和**c**。**e**的祖先是 **a**, **b**, **c**, 和**d**。后代与祖先相反。 **a**的后代 **b**, **c**, **d**, 和 **e**。**b**的后代是**d**和**e**。

例如，比特币和以太坊都有一个线性链，每个区块都有一个父区块和一个子区块。Avalanche使用DAG来存储数据，而不是线性链。DAG的每个元素可以有多个父元素。DAG中的父子关系并不意味着应用程序级依赖。

在共识协议中，关键在于防止将**冲突交易**纳入DAG。 冲突是应用程序定义的, 不同的应用程序对于两个事务冲突的含义有不同的概念。 例如，在P2P支付系统中，使用相同UTXO的交易([未使用的交易输出](https://en.wikipedia.org/wiki/Unspent_transaction_output)\)会发生冲突。 在Avalanche中，每个事务都属于一个由冲突事务组成的**冲突集**。 DAG中只能包含冲突集中的一个交易。 每个节点**偏好**冲突集中的一个交易。 

## 工作示例 

假设我们有一个使用以下参数运行的Avalanche网络。 样本大小_k_为 `4`。 quorum大小α为`3`。 连续成功的次数β是`4`。 

![Working example 1](../../.gitbook/assets/example-1.png)

一个节点发现一个新的交易**Y**。 根据上述参数查询网络。 它查询_k_ \(`4` \)验证器并询问，“您喜欢这个交易吗?” 它会得到回应，其中三个说**是**，一个说**否**。 quorum大小α是`3`，所以有α多数(quorum)回答是。 现在我们更新节点的DAG。 

![Working example 2](../../.gitbook/assets/example-2.png)

如果一个节点对一个交易得到α多数响应，那么你给这个交易一张**票据**，这是一个布尔值，表示“当我向网络查询这个交易时，α多数表示他们更喜欢它。” 在我们的示例中，交易Y获得一张票据。 

还有一个**置信度**的概念，它是一个顶点的话单加上它的后代话单的和。 例如，交易**V**有一个凭证。 它也有三个后代有一个单张，因此它的信心从`3`增加到`4`。 类似地，交易**W**和**X**都有一个凭证，它们都有一个凭证的后代，所以它们都有信心`2`, 交易Y有信心`1`。 

**连续成功**在雪球里都相同。 它是一个交易或交易的后代接收到成功的α多数查询响应的次数。 之前，交易V有`3`次连续成功，它自己和它的两个子交易，现在它有`4`次连续成功的事务Y, 类似的的还有交易W和X。

![Working example 3](../../.gitbook/assets/example-3.png)

在这个例子中，我们的接受阈值β是`4`。 交易V有`4`次连续成功，因此它被**接受**。该节点确保所有其他正确的节点最终都会接受该交易。

![Working example 4](../../.gitbook/assets/example-4.png)

现在假设节点知道交易**Y'**与交易Y冲突。它遵循前面的步骤，并对_k_ \(`4`\)验证器进行子采样，并询问它们是否喜欢事务Y'。 在这个例子中，两个人说他们更喜欢Y'，另外两个人说他们不喜欢Y'。 这一次没有α多数回应，DAG也相应更新。 

![Working example 5](../../.gitbook/assets/example-5.png)

交易Y和交易Y'在冲突集中; 他们中只有一个最终会被接受。 交易Y'没有得到单据，因为它没有得到α多数反应。 它有信心`0`因为它没有单据它的后代也没有任何有单据。 它有 `0`次连续成功，因为之前的查询没有得到α多数响应。 W的连续成功计数器从`2`到`0`。 它的置信度仍然是`2`。 

当询问节点是否更喜欢给定的交易时，如果该交易在交易冲突集中拥有最高的置信度，则节点回答是。 在这个例子中，交易Y置信度为`1`，交易Y'置信度为`0` ，所以节点更喜欢交易Y而不是交易Y'。 

![Working example 6](../../.gitbook/assets/example-6.png)

现在节点学习一个新的事务，**Z**，并执行与之前相同的操作。 它查询_k_节点，得到α多数响应，并更新DAG。 

![Working example 7](../../.gitbook/assets/example-7.png)

交易Z得到一张单据。 它的置信度为`1`, 并且有`1`次连续成功。 处理祖先也被更新。 没有`4` 次连续成功的事务，因此不接受祖先。 

## 顶点 

到目前为止所讨论的一切都是[Avalanche白皮书](https://assets-global.website-files.com/5d80307810123f5ffbb34d6e/6009805681b416f34dcae012_Avalanche%20Consensus%20Whitepaper.pdf)对Avalanche的描述。 Ava Labs \(即AvalancheGo\)实现的Avalanche共识协议对延迟和吞吐量进行了一些优化。 最重要的优化是**顶点**的使用。 顶点就像线性区块链中的块。 它包含其父节点的哈希值，并包含一个事务列表。 顶点允许对交易进行批处理和分组投票，而不是逐个投票。 DAG由顶点组成，协议的工作原理与上面描述的非常相似。 

如果一个节点收到一个投给某个顶点的票，它当作是对一个顶点中所有事务的投票，并且投票向上传递应用。 当顶点中的所有事务都被接受时，这个顶点就被接受了。 如果一个顶点包含一个被拒绝的事务，那么它也将被拒绝，它的所有后代也将被拒绝。 如果一个顶点被拒绝，所有有效的事务将重新发布到一个的新顶点中, 这个定点不是被拒绝的顶点的子顶点。新顶点被附加到首选顶点。  

## 出块时间

雪崩共识协议在概率上是安全的，这取决于一个安全阈值。 也就是说，通过调整系统参数，一个正确节点接受另一个正确节点拒绝的事务的概率可以任意降低。 在中本聪共识协议中(例如，在比特币和以太坊的应用中)，一个区块可能被包含在链中，但随后会被移除，而不会最终出现在规范链中。 这意味着要等待一个小时才能进行交易结算。 在Avalanche中，接受/拒绝是**最终且不可逆转的**，只需要几秒钟的时间。 

## 优化 

当节点查询验证器时，如果只问“您喜欢这个顶点吗?” 在Ava Labs的实现中，在一个查询过程中，节点会问:“如果这个顶点存在，您会选择哪个顶点?” 节点接收到的不是二进制的yes/no，而是另一个节点的首选顶点集。 

节点不会只在听到一个新的交易时进行查询。他们重复查询，直到没有良性顶点处理。良性顶点是没有冲突的顶点。

在注册投票结果之前，节点不需要等待所有_k_查询响应。 如果没有一个交易可以获得α多大数，那么就不需要等待其他响应。

## 验证器

如果它可以自由地成为Avalanche网络上的一个验证器，那就会有问题，因为一个恶意的参与者可能会启动很多很多节点，这些节点会被频繁地查询。 恶意的参与者可能使节点行为不良，并导致安全性或活性故障。 验证器，作为共识的一部分被查询的节点，会对网络产生影响。 他们必须以现实世界的价值为这种影响力付出代价，以防止这种填塞选票的行为。 这种利用真实世界的价值来购买对网络的影响力的想法被称为权益证明(POS)。 

要成为验证器，节点必须**绑定**\(质押\)一些有价值的东西\(**AVAX**\)。 节点绑定的AVAX越多，该节点被其他节点查询的频率就越高。 当一个节点对网络进行抽样时，它并不是均匀随机的。 相反，它是根据质押数量加权的。 节点被激励成为验证者，因为如果它们在验证的同时足够正确和响应，它们就会获得奖励。 

Avalanche没有削减功能。 如果一个节点在验证时表现不佳，比如给出了不正确的响应，或者可能根本没有响应，它的质押仍然会全部返回，但没有任何奖励。 只要被绑定的AVAX有足够的一部分被正确的节点持有，那么网络就是安全的，并且是为良性交易而存在的。 

## 大概念

Avalanche中的两大概念是**子抽样**和**传递投票**。 子采样的消息开销非常低廉。 不管是20个验证器还是2000个验证器; 查询期间，节点发送的共识消息数量保持不变。 

![Working example 8](../../.gitbook/assets/example-8.png)

传递性投票，即对一个顶点的投票就是对所有它的祖先的投票，有助于交易吞吐量。 每一票实际上是多票合一。 例如，在上图中，如果一个节点对顶点**D**进行投票，这意味着对它所有的祖先进行投票; 投票给**D **, 也即是投票给 **A**、**B**和**C**。 

## Loose Ends

交易是由用户调用[AvalancheGo](https://github.com/ava-labs/avalanchego)完整节点上的API或使用[AvalancheJS](https://github.com/ava-labs/avalanchejs)等库创建的。 当节点大批量进入交易时，或者当来自一个被拒绝的顶点的交易被接受, 重新发布并添加到DAG时，顶点就创建起来了。 一个顶点的父结点是从良性边界中选择的，即DAG顶端没有冲突的节点。 建立在良性顶点上很重要因为如果我们建立在非良性顶点上节点被拒绝的可能性会更高, 这意味着它的祖先被拒绝的可能性更大我们的进展会更少。 

## Other Observations

冲突交易不能保证是实时的。 这不是一个真正的问题，因为如果你希望你的交易是实时的，那么就不要发布一个冲突的交易。 

Avalanche也适用于线性链。 协议与上面的基本相同，但是每个顶点只有一个父结点。 这给出了顶点的总体排序。 这对于某些需要知道一个交易是否先于另一个交易的应用程序非常有用，例如使用智能合约。 “雪人”是Ava Labs实现线性链雪崩共识协议的名称。 

如果没有未决定的交易，雪崩共识协议_quiesces_。 也就是说，如果没有工作要做，它什么也做不了。 雪崩比工作量证明(Proof-of-work)更具有可持续性，因为节点需要不断地工作。 
If there are no undecided transactions, the Avalanche consensus protocol _quiesces_. That is, it does nothing if there is no work to be done. Avalanche is more sustainable than Proof-of-work where nodes need to constantly do work.

Avalanche has no leader. Any node can propose a transaction and any node that has staked AVAX can vote on every transaction, which makes the network more robust and decentralized.

## Why Do We Care?

Avalanche is a general consensus engine. It doesn't matter what type of application is put on top of it. The protocol allows the decoupling of the application layer from the consensus layer. If you're building a Dapp on Avalanche then you just need to define a few things, like how conflicts are defined and what is in a transaction. You don't need to worry about how nodes come to an agreement. The consensus protocol is a black box that put something into it and it comes back as accepted or rejected.

Avalanche can be used for all kinds of applications, not just P2P payment networks. Avalanche's Primary Network has an instance of the Ethereum Virtual Machine, which is backward compatible with existing Ethereum Dapps and dev tooling. The Ethereum consensus protocol has been replaced with Avalanche consensus to enable lower block latency and higher throughput.

Avalanche is very performant. It can process thousands of transactions per second with one to two second acceptance latency.

## Summary

Avalanche consensus is a radical breakthrough in distributed systems. It represents as large a leap forward as the classical and Nakamoto consensus protocols that came before it. Now that you have a better understanding of how it works, check out other [documentation](https://docs.avax.network) for building game-changing Dapps and financial instruments on Avalanche.

<!--stackedit_data:
eyJoaXN0b3J5IjpbNTE2OTU4ODQxLDE2Nzk3NjAyMjEsLTE0ND
EzMzcwNTIsLTE2OTI3NzQ1Miw0MDI5MDg1OTEsOTA0ODc3ODM3
LDE5NjkyNjQ3MzcsLTgyNzUyNjg4MCwxNDA2MTQzOTgzLDE1MT
kyODcxNDMsMTY1NDYxNTg5Myw3MTA4OTU4OTUsMTEzNzc3NTY4
NSwxMTg1MjEzOTUzLDg2NTc3MzcwOSwxMDg3ODU5NTQ3LC02Mj
Y3NDQ4ODQsMTMyNDgzNTQ4MCwtMTMwOTQ2NjE4NSwtNzg3NjI3
NTAyXX0=
-->