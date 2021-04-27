---
说明：

在Avalanche上创建。创建没有限制。在Avalanche上创建的开发人员能够轻松地创建功能强大、可靠且安全的应用程序。
---

# 开发人员文档

{% tabs %}
{% tab title="Coming From Ethereum?" %}
{% page-ref page="build/tutorials/smart-contracts/deploy-a-smart-contract-on-avalanche-using-remix-and-metamask.md" %}

{% page-ref page="build/tutorials/smart-contracts/using-truffle-with-the-avalanche-c-chain.md" %}
{% endtab %}

{% tab title="Avalanche Wallet" %}
{% page-ref page="build/tutorials/nodes-and-staking/staking-avax-by-validating-or-delegating-with-the-avalanche-wallet.md" %}

{% page-ref page="build/tutorials/platform/transfer-avax-between-x-chain-and-p-chain.md" %}

{% page-ref page="build/tutorials/platform/transfer-avax-between-x-chain-and-c-chain.md" %}
{% endtab %}

{% tab title="Staking" %}
{% page-ref page="build/get-started.md" %}

{% page-ref page="build/tutorials/nodes-and-staking/" %}
{% endtab %}

{% tab title="Advanced" %}
{% page-ref page="build/tutorials/platform/create-a-subnet.md" %}

{% page-ref page="build/tutorials/platform/create-a-new-blockchain.md" %}

{% page-ref page="build/tutorials/smart-digital-assets/create-a-fix-cap-asset.md" %}

{% page-ref page="build/tutorials/smart-digital-assets/creating-a-variable-cap-asset.md" %}

{% page-ref page="build/tutorials/smart-digital-assets/creating-a-nft-part-1.md" %}
{% endtab %}
{% endtabs %}

## Avalanche

[Avalanche](https://avax.network) 是一个用于启动去中心化应用程序[decentralized applications](https://support.avalabs.org/en/articles/4587146-what-is-a-decentralized-application-dapp)的开放源代码平台, 也是企业区块链[blockchain](http://support.avalabs.org/en/articles/4064677-what-is-a-blockchain) 部署一个互操作、高度可扩展的生态系统。雪崩是第一个智能合约平台，每秒可处理4500+个交易，并立即确认交易。以太坊开发人员可以快速在Avalanche上进行构建，因为他们对Solidity语言十分熟悉。

Avalanche和其他去中心化网络的一个关键差异在于共识协议。随着时间推移，人们误以为区块链必须是缓慢且不可扩展的。Avalanche协议采用了一种新方法来达成共识，从而实现其强大的安全保证、快速的最终性和高吞吐量，且不影响去中心化。

## Avalanche \(AVAX\)代币

Avalanche \(AVAX\)代币是Avalanche平台的原始代币，其作用是通过质押、点对点交易和付费来确保网络安全，它还是Avalanche平台上创建的多个子网之间的基本记账单位。`1 nAVAX`相当于`0.000000001 AVAX`。

## Avalanche共识协议

![Consensus Comparison](.gitbook/assets/image%20%2810%29%20%281%29.png)

Avalanche系列中的协议通过反复子抽样投票来运行。当确定是否应接受或拒绝一项[transaction](http://support.avalabs.org/en/articles/4587384-what-is-a-transaction)时，验证程序[validator](http://support.avalabs.org/en/articles/4064704-what-is-a-blockchain-validator) 会询问一小个随机子集的验证程序应该接受或拒绝该交易。如果面临询问的验证程序认为该交易无效并表示拒绝，或偏好另一项冲突交易，则该验证程序会回复其认为应拒绝该交易。否则, 会回复其认为应接受该交易。

如果足够多\(_alpha_ $$α$$\)的抽样验证程序回复其认为应接受该交易，则验证程序更愿意接受该交易。换言之，当将来该验证程序再次面临有关该交易的询问时，它会回复其认为应接受该交易。与之类似，如果足够多的验证程序回复其认为应拒绝该交易，则验证程序会倾向于拒绝该交易。

验证程序一直重复该抽样过程，直到被查询的验证程序中的_alpha_以相同的方式对_beta_ $$β$$连续几轮进行回答(接受或拒绝)。

通常情况下，当一项交易不存在冲突时，很快就能做出最终决定。当存在冲突时，诚实的验证程序会迅速集结到冲突交易周围，进入一个正反馈循环，直至所有正确的验证程序都对该交易表示偏好。因此最终会接受非冲突交易，拒绝冲突交易。

![How Avalanche Consensus Works](.gitbook/assets/howavalancheconsensusworks.png)

可以保证(基于系统参数的高概率)，如果任何诚实的验证程序接受或拒绝一项交易，所有诚实的验证程序都将接受或拒绝该交易。

想了解更多Avalanche共识协议的技术信息, 请阅读白皮书[whitepaper](https://arxiv.org/pdf/1906.08936.pdf)。

## Snowman共识协议

Snowman是一项链优化的共识协议——高吞吐量、高度有序化、十分适配智能合约。Snowman由Avalanche共识协议[Avalanche consensus protocol](./#avalanche-consensus-protocol)驱动, P链[P-Chain](learn/platform-overview/#platform-chain-p-chain)和C链[C-Chain](learn/platform-overview/#contract-chain-c-chain) 都实施Snowman共识协议

## 关键特征

### 速度

使用康奈尔大学计算机科学家团队开发的新型共识协议, 能够在不到1秒的时间内永久确认交易。

### 可扩展性

每秒可支持4500项交易——比现有区块链大一个数量级。

### 安全性

确保更高的安全性——高于其他网络51%的标准。

### 灵活性

轻松地创建自定义区块链和去中心化应用程序，其中包含几乎任何的任意逻辑。

### 可持续性

使用高能效的质押证明共识算法， 而非工作证明共识算法。

### 智能合约支持

支持Solidity智能合约和你最喜欢的以太坊工具（例如Remix、Metamask、 Truffle等）的创建。

### 私有和公共区块链

创建您的公共或私有区块链

### 为金融而设计

本机支持使用复杂的自定义规则集来轻松创建和交易数字智能资产。


<!--stackedit_data:
eyJoaXN0b3J5IjpbMTg3MjIxMDU1Ml19
-->