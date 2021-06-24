# 在X链上创建资产

本例在X链上创建一个资产，并将其发布到Avalanche平台。这个过程的第一步是创建一个连接到我们所选择的Avalanche平台端点的AvalancheJS实例。

```text
import {
    Avalanche,
    BinTools,
    Buffer,
    BN
  } from "avalanche" 
import {
    InitialStates,
    SECPTransferOutput
  } from "avalanche/dist/apis/avm"

let myNetworkID = 12345; //default is 3, we want to override that for our local network
let myBlockchainID = "GJABrZ9A6UQFpwjPU8MDxDd8vuyRoDVeDAXc694wJ5t3zEkhU"; // The X-Chain blockchainID on this network
let avax = new Avalanche("localhost", 9650, "http", myNetworkID, myBlockchainID);
let xchain = avax.XChain(); //returns a reference to the X-Chain used by AvalancheJS
```

## 描述新资产

使用AvalancheJS创建新资产的第一步是确定资产的质量。我们将给资产一个名称，一个ticker符号，以及一个面额。

```text
// Name our new coin and give it a symbol
let name = "Rickcoin is the most intelligent coin";
let symbol = "RICK";

// Where is the decimal point indicate what 1 asset is and where fractional assets begin
// Ex: 1 AVAX is denomination 9, so the smallest unit of AVAX is nanoAVAX (nAVAX) at 10^-9 AVAX
let denomination = 9;
```

## 创建初始状态

我们想要铸造一个资产，有400个硬币到我们所有的托管密钥，500到我们知道的第二个地址，600到第二个和第三个地址。这将设置将由创建资产产生的状态。

_Note:这个例子假设我们已经在X链的Keychain中管理了密钥_

```text
let addresses = xchain.keyChain().getAddresses();

// Create outputs for the asset's initial state
let secpOutput1 = new SECPTransferOutput(new BN(400), new BN(400), 1, addresses);
let secpOutput2 = new SECPTransferOutput(new BN(500), new BN(400), 1, [addresses[1]]);
let secpOutput3 = new SECPTransferOutput(new BN(600), new BN(400), 1, [addresses[1], addresses[2]]);

// Populate the initialStates with the outputs
let initialState = new InitialStates();
initialState.addOutput(secpOutput1);
initialState.addOutput(secpOutput2);
initialState.addOutput(secpOutput3);
```

## 创建签名交易

现在我们知道了我们想要的资产的样子，我们创建一个输出发送到网络。有一个AVM助手函数`buildCreateAssetTx()` 就是这样做的。

```text
// Fetch the UTXOSet for our addresses
let utxos = await xchain.getUTXOs(addresses);

// Make an unsigned Create Asset transaction from the data compiled earlier
let unsigned = await xchain.buildCreateAssetTx(
  utxos, // the UTXOSet containing the UTXOs we're going to spend
  addresses, // the addresses which will pay the fees
  addresses, // the addresses which recieve the change from the spent UTXOs
  initialState, // the initial state to be created for this new asset 
  name, // the full name of the asset
  symbol, // a short ticker symbol for the asset
  denomination // the asse's denomination 
);

let signed = xchain.keyChain().signTx(unsigned); //returns a Tx class
```

## 发布已签名的交易

现在我们已经有了一个可以发送到网络的已签名事务，让我们发布它吧!

使用AvalancheJS X-Chain API，我们将调用issueTx函数。这个函数可以接受上一步返回的Tx类、事务的[CB58](http://support.avalabs.org/en/articles/4587395-what-is-cb58)表示，或者带有事务数据的原始Buffer类。以下是它们各自的例子:

Using the AvalancheJS X-Chain API, we going to call the issueTx function. This function can take either the Tx class returned in the previous step, a [CB58](http://support.avalabs.org/en/articles/4587395-what-is-cb58) representation of the transaction, or a raw Buffer class with the data for the transaction. Examples of each are below:

```text
// using the Tx class
let txid = await xchain.issueTx(signed); //returns a CB58 serialized string for the TxID
```

```text
// using the base-58 representation
let txid = await xchain.issueTx(signed.toString()); //returns a CB58 serialized string for the TxID
```

```text
// using the transaction Buffer
let txid = await xchain.issueTx(signed.toBuffer()); //returns a CB58 serialized string for the TxID
```

We assume ONE of those methods is used to issue the transaction.

## Get the status of the transaction <a id="get-the-status-of-the-transaction"></a>

Now that we sent the transaction to the network, it takes a few seconds to determine if the transaction has gone through. We can get an updated status on the transaction using the TxID through the AVM API.

```text
// returns one of: "Accepted", "Processing", "Unknown", and "Rejected"
let status = await xchain.getTxStatus(txid);
```

The statuses can be one of “Accepted”, “Processing”, “Unknown”, and “Rejected”:

* “Accepted” indicates that the transaction has been accepted as valid by the network and executed
* “Processing” indicates that the transaction is being voted on.
* “Unknown” indicates that node knows nothing about the transaction, indicating the node doesn’t have it
* “Rejected” indicates the node knows about the transaction, but it conflicted with an accepted transaction

## Identifying the newly created asset <a id="identifying-the-newly-created-asset"></a>

The X-Chain uses the TxID of the transaction which created the asset as the unique identifier for the asset. This unique identifier is henceforth known as the “AssetID” of the asset. When assets are traded around the X-Chain, they always reference the AssetID that they represent.

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE5NjU1NjY2MTIsMjA5OTQ4MDY0Nl19
-->