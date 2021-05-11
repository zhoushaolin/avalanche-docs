---
说明：Avalanche核心概念和结构简介
---

# 平台概况

Avalanche有3个内置区块链description: Learn the core concepts and architecture of Avalanche
---

# Platform Overview

Avalanche features 3 built-in blockchains: [**交换链Exchange Chain \(X-Chain\)**](./#exchange-chain-x-chain), [**平台链Platform Chain \(P-Chain\)**](./#platform-chain-p-chain), 和and [**合约链Contract Chain \(C-Chain**\)](./#contract-chain-c-chain)。这3个区块链均已验证. All 3 blockchains are [validated](http://support.avalabs.org/en/articles/4064704-what-is-a-blockchain-validator) 并受主网and secured by the [**Primary Network**](http://support.avalabs.org/en/articles/4135650-what-is-the-primary-network)保护。 主网是一个特殊的子网. The Primary Network is a special [subnet](http://support.avalabs.org/en/articles/4064861-what-is-a-subnetwork-subnet), 通过质押至少2and all members of all custom subnets must also be a member of the Primary Network by staking at least 2,000个 AVAX，所有自定义子网的成员也必须是主网的成员。

创建子网的教程.

Here are tutorials on [creating a subnet](../../build/tutorials/platform/create-a-subnet.md), 向子网添加验证程序的教程 and [adding validators](../../build/tutorials/nodes-and-staking/add-a-validator.md)。 to a subnet.

![Primary network](../../.gitbook/assets/image%20%2821%29.png)

## 子网

**子网**, 又名子网络，是一组动态的验证程序，该验证程序协同工作，从而就区块链集合的状态达成共识。每个区块链都仅通过一个子网进行验证。一个子网能够验证多个区块链。一个节点可能是多个子网的成员。

子网管理其各自成员，并可能要求其验证程序具有特定属性。这是非常有用的，我们将在下文中更深入地探讨其影响：

### 合规性

通过Avalanche的子网结构，监管合规性易于管理。如上所述，子网可能需要验证程序来满足一系列要求。

部分示例如下：

* 验证程序必须位于特定国家
* 验证程序必须通过KYC/AML核验
* 验证程序必须持有特定执照

### 对私有区块链的支持

您可以创建一个子网，其中只能加入部分预定义的验证程序，以及一个私有子网，其中区块链内容仅对上述验证程序可见。对于希望信息保密的组织来说，这一方式非常理想。

### 关注点分离

异构区块链网络中，由于部分验证程序对此类区块链毫无兴趣，因此它们并不想对此类区块链进行验证。通过子网模型，验证程序能够只关注其关注的区块链。从而减少了验证程序的负担。

### 应用程序的特定要求

基于区块链的不同应用程序可能需要验证程序具备特定属性。假设有一个应用程序需要大量的RAM或CPU功率。子网可能会要求验证程序满足特定硬件要求[hardware requirements](http://support.avalabs.org/en/articles/4064879-technical-requirements-for-running-a-validator-node-on-avalanche), 进而应用程序不会因验证程序速度慢而导致性能不佳。

## 虚拟机

**虚拟机** \(VM\)定义了区块链的应用程序级逻辑。从技术角度而言，虚拟机明确了区块链的状态、状态转换函数、交易和API，借此用户能够与区块链进行交互。Avalanche上的每个区块链都是VM的示例。

当您编写虚拟机时，您不需要考虑低水平逻辑，例如网络、共识和区块链结构。Avalanche是在后台进行这一进程的，因此您可以集中注意力创建您想要创建的。

将虚拟机想象成区块链的蓝图；您可以使用同一个虚拟机来创建多个区块链，每个区块链都遵循同一规则集合，但在逻辑上独立于其他区块链。

### 为什么选择虚拟机？

首先，区块链网络都有一个虚拟机(VM)，附有预定义的功能静态集合。这种僵化的一体式设计限制了人们可以在此类网络中运行哪些基于区块链的应用程序。

如果想要定制去中心化应用程序，则必须从零开始创建其全新区块链网络。这需要大量时间和精力，而安全性有限，且通常会导致脆弱的定制区块链永久无法启动。

为了解决这一问题，以太坊（Ethereum）通过智能合约迈出了一步。开发人员不需要担心网络和共识问题，但是创建去中心化应用程序仍然十分困难。以太坊虚拟机性能不佳，并限制了智能合约的开发人员。大多数程序员都对Solidity语言和其他几种以太坊智能合约编写语言感到陌生。

通过Subnets

A **subnet**, or subnetwork, is a dynamic set of validators working together to achieve consensus on the state of a set of blockchains. Each blockchain is validated by exactly one subnet. A subnet can validate many blockchains. A node may be a member of many subnets.

A subnet manages its own membership, and it may require that its constituent validators have certain properties. This is very useful, and we explore its ramifications in more depth below:

### Compliance

Avalanche’s subnet architecture makes regulatory compliance manageable. As mentioned above, a subnet may require validators to meet a set of requirements.

Some examples include:

* Validators must be located in a given country
* Validators must pass a KYC/AML checks
* Validators must hold a certain license

### Support for Private Blockchains

You can create a subnet where only certain pre-defined validators may join and create a private subnet where the contents of the blockchains would be visible only to those validators. This is ideal for organizations interested in keeping their information private.

### Separation of Concerns

In a heterogeneous network of blockchains, some validators will not want to validate certain blockchains because they simply have no interest in those blockchains. The subnet model allows validators to only concern themselves with blockchains that they care about. This reduces the burden on validators.

### Application-Specific Requirements

Different blockchain-based applications may require validators to have certain properties. Suppose there is an application that requires large amounts of RAM or CPU power. A Subnet could require that validators meet certain [hardware requirements](http://support.avalabs.org/en/articles/4064879-technical-requirements-for-running-a-validator-node-on-avalanche) so that the application doesn’t suffer from low performance due to slow validators.

## Virtual Machines

A **Virtual Machine** \(VM\) defines the application-level logic of a blockchain. In technical terms, it specifies the blockchain’s state, state transition function, transactions, and the API through which users can interact with the blockchain. Every blockchain on Avalanche is an instance of a VM.

When you write a VM, you don't need to concern yourself with lower-level logic like networking, consensus, and the structure of the blockchain. Avalanche does this behind the scenes so you can focus on the thing you would like to build.

Think of a VM as a blueprint for a blockchain; you can use the same VM to create many blockchains, each of which follows the same ruleset but is logically independent of other blockchains.

### Why Virtual Machines?

At first, blockchain networks had one Virtual Machine \(VM\) with a pre-defined, static set of functionality. This rigid, monolithic design limited what blockchain-based applications one could run on such networks.

People who wanted custom decentralized applications had to create their own, entirely new blockchain network from scratch. Doing so required a great deal of time and effort, offered limited security, and generally resulted in a bespoke, fragile blockchain that never got off the ground.

Ethereum made a step toward solving this problem with smart contracts. Developers didn’t need to worry about networking and consensus, but creating decentralized applications was still hard. The Ethereum VM has low performance and imposes restrictions on smart contract developers. Solidity and the other few languages for writing Ethereum smart contracts are unfamiliar to most programmers.

Avalanche虚拟机 VMs \(AVMs\)，使得定义基于区块链的去中心化应用程序变得十分简单。开发人员可以在 make it easy to define a blockchain-based decentralized application. Rather than new, limited languages like Solidity, developers can write VMs in Go \(以后将支持其他语言\)里编写VM，而无需使用像Solidity语言这样有限制的新语言。

### 创建您的区块链和虚拟机

Avalanche目前不支持创建新虚拟机\(VMs\)。目前Avalanche仅支持创建Avalanche虚拟机的新实例。

将来，通过Avalanche，您还可以定义并发行定制区块链，我们也会发行SDK来进行协助。

## 交换链\(X链\)

**X链**是创建和交易数字智能资产的去中心化平台、现实世界资产数字话的代表\(例如股票、债券\)，其中包含一系列管理其行为的规则，例如“明天才能开始交易”或“只能向美国公民发行。”

在X链上交易的一项资产就是AVAX。当您在Avalanche上向区块链发布一项交易时，您需要支付AVAX规定的费用。

X链是Avalanche虚拟机\(AVM\)的一个实例。通过[X-Chain API](../../build/avalanchego-apis/exchange-chain-x-chain-api.md)，客户能够在X链和其他AVM实例上创建并交易资产。

## 平台链\(P链\)

**P链**是Avalanche上的元数据区块链，它协调验证程序、追踪活跃子网并支持创建新子网。P链实现Snowman共识协议other languages will be supported in the future\).

### Creating Your Blockchain and Virtual Machine

Avalanche does not yet support the creation of new Virtual Machines \(VMs\). Presently, Avalanche only supports the creation of new instances of the Avalanche VM.

{% page-ref page="../../build/tutorials/platform/create-a-new-blockchain.md" %}

In the future, Avalanche will allow you to define and launch custom blockchains, and we’ll release SDKs to help you do so.

{% page-ref page="../../build/tutorials/platform/create-a-virtual-machine-vm.md" %}

## Exchange Chain \(X-Chain\)

The **X-Chain** acts as a decentralized platform for creating and trading digital smart assets, a representation of a real-world resource \(e.g., equity, bonds\) with a set of rules that govern its behavior, like “can’t be traded until tomorrow” or “can only be sent to US citizens.”

One asset traded on the X-Chain is AVAX. When you issue a transaction to a blockchain on Avalanche, you pay a fee denominated in AVAX.

The X-Chain is an instance of the Avalanche Virtual Machine \(AVM\). The [X-Chain API](../../build/avalanchego-apis/exchange-chain-x-chain-api.md) allows clients to create and trade assets on the X-Chain and other instances of the AVM.

{% page-ref page="../../build/tutorials/smart-digital-assets/create-a-fix-cap-asset.md" %}

## Platform Chain \(P-Chain\)

The **P-Chain** is the metadata blockchain on Avalanche and coordinates validators, keeps track of active subnets, and enables the creation of new subnets. The P-Chain implements the [Snowman consensus protocol](../../#snowman-consensus-protocol)。.

通过The [P-Chain API](../../build/avalanchego-apis/platform-chain-p-chain-api.md)，客户能够创建子网、将验证程序添加进子网并创建区块链。

## 合约链\(C链\)

通过**C链**，使用 allows clients to create subnets, add validators to subnets, and create blockchains.

## Contract Chain \(C-Chain\)

The **C-Chain** allows for the creation smart contracts using the [C-Chain’s API](../../build/avalanchego-apis/contract-chain-c-chain-api.md)即可创建智能合约。


C链是.

The C-Chain is an instance of the Ethereum Virtual Machine powered by [Avalanche](../../)驱动下以太坊虚拟机的一个实例。.

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE5OTkzOTEwNDksLTE3ODk4ODU4MzJdfQ
==
-->