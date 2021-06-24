# 在X链上发送资产

此示例将X链中的资产发送给单个接收者。这个过程的第一步是创建一个连接到我们所选择的Avalanche平台端点的Avalanche实例。

```text
import {
    Avalanche,
    BinTools,
    Buffer,
    BN
  } from "avalanche" 

let myNetworkID = 1; //default is 3, we want to override that for our local network
let myBlockchainID = "2oYMBNV4eNHyqk2fjjV5nVQLDbtmNJzq5s3qs3Lo6ftnC6FByM"; // The X-Chain blockchainID on this network
let avax = new avalanche.Avalanche("localhost", 9650, "http", myNetworkID, myBlockchainID);
let xchain = avax.XChain(); //returns a reference to the X-Chain used by AvalancheJS
```

我们还假设密钥存储库包含此交易中使用的地址列表。

## 获取UTXO集 

X链将所有可用余额存储在一个名为Unspent Transaction Outputs\(UTXOs\)的数据存储中。UTXO集是由交易产生的输出的唯一列表，可以使用这些输出的地址，以及其他变量，如锁定时间(在此之后可以使用输出的时间戳)和阈值(需要多少签名者使用输出)。

在本例中，我们将创建一个简单的交易，花费一定数量的可用硬币，并将其不受任何限制地发送到单个地址。UTXO的管理大部分将被抽象掉。

但是，我们确实需要为所管理的地址获取UTXO 集。

```text
let myAddresses = xchain.keyChain().getAddresses(); //returns an array of addresses the KeyChain manages
let addressStrings = xchain.keyChain().getAddressStrings(); //returns an array of addresses the KeyChain manages as strings
let utxos = (await xchain.getUTXOs(myAddresses)).utxos;
```

## 花费UTXO

`buildBaseTx()`助手函数发送一个资产类型。我们有一个特定的assetID，我们想将其硬币发送到一个接收地址。这是一个假想资产，我们认为它有400枚硬币。让我们验证一下是否有这笔交易可用的资金。

```text
let assetid = "23wKfz3viWLmjWo2UZ7xWegjvnZFenGAVkouwQCeB9ubPXodG6"; //avaSerialized string
let mybalance = utxos.getBalance(myAddresses, assetid); //returns 400 as a BN
```

我们有400枚硬币!我们现在要把100枚硬币发到我们朋友的地址。

```text
let sendAmount = new BN(100); //amounts are in BN format
let friendsAddress = "X-avax1k26jvfdzyukms95puxcceyzsa3lzwf5ftt0fjk"; // address format is Bech32

//The below returns a UnsignedTx
//Parameters sent are (in order of appearance):
//   * The UTXO Set
//   * The amount being sent as a BN
//   * An array of addresses to send the funds
//   * An array of addresses sending the funds
//   * An array of addresses any leftover funds are sent
//   * The AssetID of the funds being sent
let unsignedTx = await xchain.buildBaseTx(utxos, sendAmount, [friendsAddress], addressStrings, addressStrings, assetid);
let signedTx = unsignedTx.sign(myKeychain)
let txid = await xchain.issueTx(signedTx);
```

交易发送完毕!

## 获取交易的状态

现在我们将交易发送到网络，需要几秒钟来确定交易是否已经通过。我们可以通过X链使用TxID获取交易的更新状态。

```text
// returns one of: "Accepted", "Processing", "Unknown", and "Rejected"
let status = await xchain.getTxStatus(txid);
```

状态可以是“已接受”、“处理中”、“未知”和“拒绝”中的一种:

* “已接受”表示该交易已被网络接受为有效并已执行
* “处理中”表示正在对交易进行投票。
* “未知”表示节点不知道该交易，表示该节点没有该交易
* “拒绝”表示节点知道交易，但它与已接受的交易发生冲突

## 检查结果

事务最终返回为“Accepted”，现在让我们更新UTXO集并验证交易余额是否如预期的那样。

_注意:在真实的网络中，不保证余额匹配这个场景。交易费用或额外支出可能会改变余额。就本例而言，我们假设这两种情况都不存在_

```text
let updatedUTXOs = await xchain.getUTXOs();
let newBalance = updatedUTXOs.getBalance(myAddresses, assetid);
if(newBalance.toNumber() != mybalance.sub(sendAmount).toNumber()){
    throw Error("heyyy these should equal!");
}
```

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTUwNjI1NDg0NCwtOTEyNTc0MTgxLDE5OD
c1MjM0ODgsLTEwMjg0MDQ0MjIsLTMyNDc1MzA3N119
-->