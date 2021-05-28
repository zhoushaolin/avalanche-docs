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

如果一个节点对一个交易得到α多数响应，那么你给这个交易一张**票据**，这是一个布尔值，表示“当我向网络查询这个交易时，α多数表示他们更喜欢它。” 在我们的示例中，事务Y获得一张票据。 

还有一个**置信度**的概念，它是一个顶点的话单加上它的后代话单的和。 例如，交易**V**有一个凭证。 它也有三个后代有一个单张，因此它的信心从' 3 '增加到' 4 '。 类似地，事务**W**和**X**都有一个凭证，它们都有一个凭证的后代，所以它们都有信心' 2 '。 

There is also a notion of **confidence**, which is the sum of a vertex's chit plus the sum of its descendants' chits. For example, transaction **V** has a chit. It also has three descendants which have a chit so its confidence is increased from `3` to `4`. Similarly, transactions **W** and **X** both have a chit and they both have a descendant with a chit, so they each have confidence `2`. Transaction Y has confidence `1`.

**Consecutive successes** are the same as in Snowball. It's the number of times that a transaction, or a descendant of the transaction, received a successful α majority query response. Previously, transaction V had `3` consecutive successes, itself and its two children, and now it has `4` consecutive successes with transaction Y. Similarly for transactions W and X.

![Working example 3](../../.gitbook/assets/example-3.png)

In this example we the acceptance threshold, β, is `4`. Transaction V has `4` consecutive success so it's **accepted**. This node is sure that every other correct node will eventually accept this transaction.

![Working example 4](../../.gitbook/assets/example-4.png)

Now suppose the node learns about transaction **Y'** which conflicts with transaction Y. It follows the same steps as before and subsamples _k_ \(`4`\) validators and asks if they prefer transaction Y'. In this case, two of them say that they prefer Y' and two of them say that they do not prefer Y'. This time there is no α majority response, and the DAG is updated accordingly.

![Working example 5](../../.gitbook/assets/example-5.png)

Transactions Y and Y' are in a conflict set; only one of them can ultimately get accepted. Transaction Y' doesn't get a chit because it didn't get an α majority response. It has confidence `0` because it doesn't have a chit and it doesn't have any descendants with a chit. It has `0` consecutive successes because the previous query didn't get an α majority response. W's consecutive success counter goes from `2` to `0`. Its confidence is still `2`.

When a node is asked whether it prefers a given transaction, it replies yes if that transaction has the highest confidence of any transaction in the transaction's conflict set. In this example, transaction Y has confidence `1` and transaction Y' has confidence `0` so the node prefer transaction Y to transaction Y'.

![Working example 6](../../.gitbook/assets/example-6.png)

Now the node learns about a new transaction, **Z**, and it does the same thing as before. It queries _k_ nodes, gets back an α majority response, and updates the DAG.

![Working example 7](../../.gitbook/assets/example-7.png)

Transaction Z gets a chit. It also has a confidence of `1` and `1` consecutive success. The processing ancestors are updated, too. No transactions have `4` consecutive successes so no ancestors are accepted.

## Vertices

Everything discussed to this point is how Avalanche is described in [the Avalanche whitepaper](https://assets-global.website-files.com/5d80307810123f5ffbb34d6e/6009805681b416f34dcae012_Avalanche%20Consensus%20Whitepaper.pdf). The implementation of the Avalanche consensus protocol by Ava Labs \(namely in AvalancheGo\) has some optimizations for latency and throughput. The most important optimization is the use of **vertices**. A vertex is like a block in a linear blockchain. It contains the hashes of its parents, and it contains a list of transactions. Vertices allow transactions to be batched and voted on in groups rather than one by one. The DAG is composed of vertices, and the protocol works very similar to how it's described above.

If a node receives a vote for a vertex, it counts as a vote for all the transactions in a vertex, and votes are applied transitively upward. A vertex is accepted when all the transactions which are in it are accepted. If a vertex contains a rejected transaction then it is rejected and all of its descendants are rejected. If a vertex is rejected, any valid transactions are re-issued into a new vertex which is not the child of a rejected vertex. New vertices are appended to preferred vertices.

## Finality

Avalanche consensus is probabilistically safe up to a safety threshold. That is, the probability that a correct node accepts a transaction that another correct node rejects can be made arbitrarily low by adjusting system parameters. In Nakamoto consensus protocol \(as used in Bitcoin and Ethereum, for example\), a block may be included in the chain but then be removed and not end up in the canonical chain. This means waiting an hour for transaction settlement. In Avalanche, acceptance/rejection are **final and irreversible** and take a few seconds.

## Optimizations

It's not efficient for nodes to just ask, "Do you prefer this vertex?" when they query validators. In Ava Labs' implementation, during a query a node asks, "Given that this vertex exists, which vertices do you prefer?" Instead of getting back a binary yes/no, the node receives the other node's preferred vertex set.

Nodes don't only query upon hearing of a new transaction. They repeatedly query until there are no virtuous vertices processing. A virtuous vertex is one that has no conflicts.

Nodes don't need to wait until they get all _k_ query responses before registering the outcome of a poll. If no transaction can get an α majority then there's no need to wait for the rest of the responses.

## Validators

If it were free to become a validator on the Avalanche network, that would be problematic because a malicious actor could start many, many nodes which would get queried very frequently. The malicious actor could make the node act badly and cause a safety or liveness failure. The validators, the nodes which are queried as part of consensus, have influence over the network. They have to pay for that influence with real-world value in order to prevent this kind of ballot stuffing. This idea of using real-world value to buy influence over the network is called Proof of Stake.

To become a validator, a node must **bond** \(stake\) something valuable \(**AVAX**\). The more AVAX a node bonds, the more often that node is queried by other nodes. When a node samples the network it's not uniformly random. Rather, it's weighted by stake amount. Nodes are incentivized to be validators because they get a reward if, while they validate, they're sufficiently correct and responsive.

Avalanche doesn't have slashing. If a node doesn't behave well while validating, such as giving incorrect responses or perhaps not responding at all, its stake is still returned in whole, but with no reward. As long as a sufficient portion of the bonded AVAX is held by correct nodes, then the network is safe, and is live for virtuous transactions.

## Big Ideas

Two big ideas in Avalanche are **subsampling** and **transitive voting**. Subsampling has low message overhead. It doesn't matter if there are twenty validators or two thousand validators; the number of consensus messages a node sends during a query remains constant.

![Working example 8](../../.gitbook/assets/example-8.png)

Transitive voting, where a vote for a vertex is a vote for all it's ancestors, helps with transaction throughput. Each vote is actually many votes in one. For example, in the above diagram, if a node gets a vote for vertex **D**, that implies a vote for all it's ancestors; a vote for **D** is also a vote for **A**, **B**, and **C**.

## Loose Ends

Transactions are created by users which call an API on the [AvalancheGo](https://github.com/ava-labs/avalanchego) full node or create them using a library such as [AvalancheJS](https://github.com/ava-labs/avalanchejs). Vertices are created when nodes batch incoming transactions together or when accepted transactions from a rejected vertex get reissued and added to the DAG. A vertex's parents are chosen from the virtuous frontier, which are the nodes at the tip of the DAG with no conflicts. It's important to build on virtuous vertices because if we built on non-virtuous vertices there would be a higher chance that the node would get rejected which means there's a higher chance it's ancestors get rejected and we would make less progress.

## Other Observations

Conflicting transactions are not guaranteed to be live. That's not really a problem because if you don't want your transaction to not be live then don't issue a conflicting transaction.

Avalanche works for linear chains too. The protocol is largely the same as above, but each vertex has only have one parent. This gives a total ordering of vertices. This is useful for certain applications where one needs to know if a transaction came before another transaction, such as with smart contracts. Snowman is the name of Ava Labs' implementation of the Avalanche consensus protocol for linear chains.

If there are no undecided transactions, the Avalanche consensus protocol _quiesces_. That is, it does nothing if there is no work to be done. Avalanche is more sustainable than Proof-of-work where nodes need to constantly do work.

Avalanche has no leader. Any node can propose a transaction and any node that has staked AVAX can vote on every transaction, which makes the network more robust and decentralized.

## Why Do We Care?

Avalanche is a general consensus engine. It doesn't matter what type of application is put on top of it. The protocol allows the decoupling of the application layer from the consensus layer. If you're building a Dapp on Avalanche then you just need to define a few things, like how conflicts are defined and what is in a transaction. You don't need to worry about how nodes come to an agreement. The consensus protocol is a black box that put something into it and it comes back as accepted or rejected.

Avalanche can be used for all kinds of applications, not just P2P payment networks. Avalanche's Primary Network has an instance of the Ethereum Virtual Machine, which is backward compatible with existing Ethereum Dapps and dev tooling. The Ethereum consensus protocol has been replaced with Avalanche consensus to enable lower block latency and higher throughput.

Avalanche is very performant. It can process thousands of transactions per second with one to two second acceptance latency.

## Summary

Avalanche consensus is a radical breakthrough in distributed systems. It represents as large a leap forward as the classical and Nakamoto consensus protocols that came before it. Now that you have a better understanding of how it works, check out other [documentation](https://docs.avax.network) for building game-changing Dapps and financial instruments on Avalanche.

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE0OTU3NzYzOCw3MTA4OTU4OTUsMTEzNz
c3NTY4NSwxMTg1MjEzOTUzLDg2NTc3MzcwOSwxMDg3ODU5NTQ3
LC02MjY3NDQ4ODQsMTMyNDgzNTQ4MCwtMTMwOTQ2NjE4NSwtNz
g3NjI3NTAyLDc4Njg2NTQ1NywtMTQyMTc1MjU1NywyMTA3MjI0
OTk0LDEzNjkzNzM1OTUsLTU0MDYxMzkyMSwtNTk2NDUwNjMwXX
0=
-->