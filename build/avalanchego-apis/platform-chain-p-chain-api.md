# 平台链 \(P链\) API

这个API允许客户端与[P-Chain](../../learn/platform-overview/#platform-chain-p-chain)交互，它维护Avalanche的[validator](../../learn/platform-overview/staking.md#validators)设置和处理区块链的创建。

## 端点

```cpp
/ext/P
```

## 格式

这个API使用`json 2.0`RPC格式。

## 方法

### 添加委派器到平台

向主网络添加一个委派器。

委托者质押AVAX并指定一个验证者(被委托者)来代表他们进行验证。根据委托给他们的利益比例，被其他验证者抽样的可能性增加。

被委托者向委托者收取费用;前者会从委托者的验证奖励中获得一定比例的报酬(如果有的话)。委托所持有的交易不收取任何费用。

委托周期必须是被委托人验证主网络的子网周期。

请注意，一旦发出事务以添加节点作为委托，就无法更改参数。**你不能提前移除质押或改变质押的数量、节点ID、奖励地址。**请确保您使用的是正确的值。如果你不确定，可以查看我们的开发者常见问题解答[Developer FAQ](https://support.avalabs.org/en/collections/2618154-developer-faq) 或在[Discord.](https://chat.avalabs.org/)上寻求帮助。

#### **签名**

```cpp
platform.addDelegator(
    {
        nodeID: string,
        startTime: int,
        endTime: int,
        stakeAmount: int,
        rewardAddress: string,
        from: []string, //optional
        changeAddr: string, //optional
        username: string,
        password: string
    }
) -> 
{
    txID: string,
    changeAddr: string
}
```

* `nodeID` 是要委托的节点的ID。
* `startTime` 是委托器开始委托的Unix时间。
* `endTime` 是Unix时间时，委托器停止委托\(并且质押的AVAX已返回\)。
* `stakeAmount` 是委托方所质押的nAVAX的数量。
* `rewardAddress`是验证器的奖励地址(如果有的话)。
* `from` 是您要用于此操作的地址。如果省略，根据需要使用您的任何地址。
* `changeAddr` 是有任何变化都会发送到的地址。如果省略，更改将被发送到用户控制的地址之一。
* `username` 是支付交易费用的用户。
* `password` 是 `username`的密码。
* `txID` 是这个交易 ID。

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.addDelegator",
    "params": {
        "nodeID":"NodeID-MFrZFVCXPv5iCn6M9K6XduxGTYp891xXZ",
        "rewardAddress":"P-avax1gss39m5sx6jn7wlyzeqzm086yfq2l02xkvmecy",
        "startTime":1594102400,
        "endTime":1604102400,
        "stakeAmount":100000,
        "from": ["P-avax1gss39m5sx6jn7wlyzeqzm086yfq2l02xkvmecy"],
        "changeAddr": "P-avax103y30cxeulkjfe3kwfnpt432ylmnxux8r73r8u",
        "username":"myUsername",
        "password":"myPassword"
    },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

#### **响应示例**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "txID": "6pB3MtHUNogeHapZqMUBmx6N38ii3LzytVDrXuMovwKQFTZLs",
        "changeAddr": "P-avax103y30cxeulkjfe3kwfnpt432ylmnxux8r73r8u"
    },
    "id": 1
}
```

### 平台添加验证器

将验证器添加到主网络, 你必须质押AVAX。如果节点在验证时足够正确且响应良好，则在锁定周期结束时将获得奖励。在共识期间， 验证者被其他验证者抽样的概率与质押的AVAX的数量成正比。

验证器向委托方收取费用;前者会从委托方的授权奖励中获得一定比例的佣金(如果有的话)。最少的授权费用是2%。添加验证器是免费的。

验证有效期必须在2周到1年之间。

对验证器施加的总权重是最大的。这意味着没有哪个验证器比这个值拥有更多的AVAX。这个值最初将被设置为`min(5 * amount staked, 3M AVAX)`。一个验证器的总值是300万AVAX。

请注意，一旦发出事务以添加节点作为验证器，就无法更改参数。**您不能提前移除质押或更改质押金额、节点ID或奖励地址。**请确保您使用的是正确的值。如果你不确定，可以查看我们的开发者常见问题解答[Developer FAQ](https://support.avalabs.org/en/collections/2618154-developer-faq) 或在[Discord.](https://chat.avalabs.org/)上寻求帮助。

#### **签名**

```cpp
platform.addValidator(
    {
        nodeID: string,
        startTime: int,
        endTime: int,
        stakeAmount: int,
        rewardAddress: string,
        delegationFeeRate: float,
        from: []string, //optional
        changeAddr: string, //optional
        username: string,
        password: string
    }
) -> 
{
    txID: string,
    changeAddr: string
}
```

* `nodeID` 是添加的验证器的节点ID。
* `startTime` 是验证器开始验证主网络的Unix时间。
* `endTime` 是验证器停止验证主网络的Unix时间(并返回质押的AVAX)。
* `stakeAmount`是验证器所质押的nAVAX的数量。
* `rewardAddress` 是验证者奖励将到达的地址，如果有的话。
* `delegationFeeRate` 是该验证者在他人委托质押给他们时收取的费用百分比。最多允许小数点后4位数; 多余的小数点位将被忽略。必须在0和100之间，一切费用包括在内。例如，如果`delegationFeeRate`是`1.2345`，并且有人委托给了这个验证器，那么当委托周期结束时，1.2345%的奖励归验证器，剩下的归委托器。
* `from`是您要用于此操作的地址。如果省略，根据需要使用您的任何地址。 
* `changeAddr` 是有任何变化都会发送到的地址。如果省略，更改将被发送到用户控制的地址之一。
* `username` 是支付交易费用的用户。
* `password` 是 `username`的密码。
* `txID`是这个交易ID。

#### **调用示例**

在这个例子中，我们使用shell命令`date`来计算未来10分钟和2天的Unix时间。\(注意:如果你在Mac上，用`$(gdate`代替`$(date`)。如果你没有安装`gdate` ，请使用`brew install coreutils`。\)

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.addValidator",
    "params": {
        "nodeID":"NodeID-ARCLrphAHZ28xZEBfUL7SVAmzkTZNe1LK",
        "rewardAddress":"P-avax1gss39m5sx6jn7wlyzeqzm086yfq2l02xkvmecy",
        "from": ["P-avax1gss39m5sx6jn7wlyzeqzm086yfq2l02xkvmecy"],
        "changeAddr": "P-avax103y30cxeulkjfe3kwfnpt432ylmnxux8r73r8u",
        "startTime":'$(date --date="10 minutes" +%s)',
        "endTime":'$(date --date="2 days" +%s)',
        "stakeAmount":1000000,
        "delegationFeeRate":10,
        "username":"myUsername",
        "password":"myPassword"
    },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

#### **响应示例**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "txID": "6pb3mthunogehapzqmubmx6n38ii3lzytvdrxumovwkqftzls",
        "changeAddr": "P-avax103y30cxeulkjfe3kwfnpt432ylmnxux8r73r8u"
    },
    "id": 1
}
```

### 平台添加子网验证器

将验证器添加到主网络以外的子网中。验证器必须在验证此子网的整个期间内验证主网络。

#### **签名**

```cpp
platform.addSubnetValidator(
    {
        nodeID: string,
        subnetID: string,
        startTime: int,
        endTime: int,
        weight: int,
        from: []string, //optional
        changeAddr: string, //optional
        username: string,
        password: string
    }
) -> 
{
    txID: string,
    changeAddr: string,
}
```

* `nodeID` 是验证器的节点ID。
* `subnetID` 是要验证的子网。
* `startTime` 验证器开始验证子网的Unix时间。
* `endTime` 验证器停止验证子网的Unix时间。
* `weight` 是用于取样的验证器权重。
* `from` 是您要用于此操作的地址。如果省略，根据需要使用您的任何地址。
* `changeAddr` 是有任何变化都会发送到的地址。如果省略，更改将被发送到用户控制的地址之一。
* `username` 是支付交易费用的用户。
* `password` 是 `username`的密码。
* `txID` 是这个交易ID.

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.addSubnetvalidator",
    "params": {
        "nodeID":"NodeID-7xhw2mdxuds44j42tcb6u5579esbst3lg",
        "subnetID":"zbfoww1ffkpvrfywpj1cvqrfnyesepdfc61hmu2n9jnghduel",
        "startTime":1583524047,
        "endTime":1604102399,
        "weight":1,
        "from": ["P-avax1gss39m5sx6jn7wlyzeqzm086yfq2l02xkvmecy"],
        "changeAddr": "P-avax103y30cxeulkjfe3kwfnpt432ylmnxux8r73r8u",
        "username":"myUsername",
        "password":"myPassword"
    },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

#### **响应示例**

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "txID": "2exafyvRNSE5ehwjhafBVt6CTntot7DFjsZNcZ54GSxBbVLcCm",
        "changeAddr": "P-avax103y30cxeulkjfe3kwfnpt432ylmnxux8r73r8u"
    }
}
```

### 平台创建地址

创建一个由给定用户控制的新地址。

#### **签名**

```cpp
platform.createAddress({
    username: string,
    password: string
}) -> {address: string}
```

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.createAddress",
    "params": {
        "username":"myUsername",
        "password":"myPassword"
    },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/P
```

#### **响应示例**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "address": "P-avax12lqey27sfujqq6mc5a3jr5av56cjsu8hg2d3hx"
    },
    "id": 1
}
```

### 平台创建区块链

创建一个新的区块链, 目前只支持创建AVM和Timestamp VM的新实例。

#### **签名**

```cpp
platform.createBlockchain(
    {
        subnetID: string,
        vmID: string,
        name: string,
        genesisData: string,
        encoding: string, //optional
        from: []string, //optional
        changeAddr: string, //optional
        username: string,
        password: string
    }
) -> 
{
    txID: string,
    changeAddr: string
}
```

* `subnetID`是验证新区块链的子网ID, 子网必须存在，且不能是主网络。 
* `vmID` 为区块链运行的虚拟机ID, 也可以是虚拟机的别名。
* `name`是新区块链的可读名称, 不一定是独一无二的。
* `genesisData` 以`encoding`参数指定的格式编码的新区块链的起源状态的字节形式。
* `encoding` 指定`genesisData`使用的格式, 可以是“cb58”或“hex”。默认为“cb58”。虚拟机应该有一个名为`buildGenesis`的静态API方法，可以用来生成`genesisData`。
* `from` 是您要用于此操作的地址。如果省略，根据需要使用您的任何地址。
* `changeAddr` 是有任何变化都会发送到的地址。如果省略，更改将被发送到用户控制的地址之一。
* `username` 是支付交易费用的用户。此用户必须有足够数量的子网控制密钥。
* `password` 是 `username`的密码。
* `txID`是此交易ID。

#### **调用示例**

在这个例子中，我们创建了一个时间戳虚拟机的新实例。`genesisData`来自于调用`timestamp.buildGenesis`。

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.createBlockchain",
    "params" : {
        "vmID":"timestamp",
        "subnetID":"2bRCr6B4MiEfSjidDwxDpdCyviwnfUVqB2HGwhm947w9YYqb7r",
        "name":"My new timestamp",
        "genesisData": "45oj4CqFViNHUtBxJ55TZfqaVAXFwMRMj2XkHVqUYjJYoTaEM",
        "encoding": "cb58",
        "from": ["P-avax1gss39m5sx6jn7wlyzeqzm086yfq2l02xkvmecy"],
        "changeAddr": "P-avax103y30cxeulkjfe3kwfnpt432ylmnxux8r73r8u",
        "username":"myUsername",
        "password":"myPassword"
    },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

#### **响应示例**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "txID": "2TBnyFmST7TirNm6Y6z4863zusRVpWi5Cj1sKS9bXTUmu8GfeU",
        "changeAddr": "P-avax103y30cxeulkjfe3kwfnpt432ylmnxux8r73r8u"
    },
    "id": 1
}
```

### 平台创建子网

创建一个新子网。

子网的ID与该事务的ID相同。

#### **签名**

```cpp
platform.createSubnet(
    {
        controlKeys: []string,
        threshold: int,
        from: []string, //optional
        changeAddr: string, //optional
        username: string,
        password: string
    }
) -> 
{
    txID: string,
    changeAddr: string
}
```

* 为了向这个子网添加一个验证器，`controlKeys`中的地址需要`threshold`签名。
* `from` 是您要用于此操作的地址。如果省略，根据需要使用您的任何地址。
* `changeAddr` 是有任何变化都会发送到的地址。如果省略，更改将被发送到用户控制的地址之一。
* `username` 是支付交易费用的用户。
* `password` 是 `username`的密码。

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.createSubnet",
    "params": {
        "controlKeys":[
            "P-avax13xqjvp8r2entvw5m29jxxjhmp3hh6lz8laep9m",
            "P-avax165mp4efnel8rkdeqe5ztggspmw4v40j7pfjlhu"
        ],
        "threshold":2,
        "from": ["P-avax1gss39m5sx6jn7wlyzeqzm086yfq2l02xkvmecy"],
        "changeAddr": "P-avax103y30cxeulkjfe3kwfnpt432ylmnxux8r73r8u",
        "username":"myUsername",
        "password":"myPassword"
    },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

#### **响应示例**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "txID": "hJfC5xGhtjhCGBh1JWn3vZ51KJP696TZrsbadPHNbQG2Ve5yd"
    },
    "id": 1
}
```

### 平台导出AVAX

从P链上的地址发送AVAX到X链上的地址。在发布这个交易之后，你必须调用X链的[`avm.importAVAX`](exchange-chain-x-chain-api.md#avm-importavax)方法来完成交易。

#### **签名**

```cpp
platform.exportAVAX(
    {
        amount: int,
        from: []string, //optional
        to: string,
        changeAddr: string, //optional
        username: string,
        password: string
    }
) -> 
{
    txID: string,
    changeAddr: string
}
```

* `amount` 是要发送的nAVAX的数量。
* `to` 是要发送AVAX到的X链上的地址。
* `from` 是您要用于此操作的地址。如果省略，根据需要使用您的任何地址。
* `changeAddr` 是有任何变化都会发送到的地址。如果省略，更改将被发送到用户控制的地址之一。
* `username`是发送AVAX并支付交易费用的用户。
* `password` 是 `username`的密码。
* `txID` 是此交易ID。

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.exportAVAX",
    "params": {
        "to":"X-avax1yv8cwj9kq3527feemtmh5gkvezna5xys08mxet",
        "amount":1,
        "from": ["P-avax1gss39m5sx6jn7wlyzeqzm086yfq2l02xkvmecy"],
        "changeAddr": "P-avax103y30cxeulkjfe3kwfnpt432ylmnxux8r73r8u",
        "username":"myUsername",
        "password":"myPassword"
    },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

#### **响应示例**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "txID": "2Kz69TNBSeABuaVjKa6ZJCTLobbe5xo9c5eU8QwdUSvPo2dBk3",
        "changeAddr": "P-avax103y30cxeulkjfe3kwfnpt432ylmnxux8r73r8u"
    },
    "id": 1
}
```

### 平台导出密钥

获取控制给定地址的私钥。
返回的私钥可以通过[`platform.importKey`](platform-chain-p-chain-api.md#platform-importkey)添加到用户。

#### **签名**

```cpp
platform.exportKey({
    username: string,
    password: string,
    address: string
}) -> {privateKey: string}
```

* `username`是控制`address`的用户。
* `password` 是 `username`的密码。
* `privateKey`是控制`address`的私钥的字符串表现形式。

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"platform.exportKey",
    "params" :{
        "username" :"myUsername",
        "password": "myPassword",
        "address": "P-avax1zwp96clwehpwm57r9ftzdm7rnuslrunj68ua3r"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

#### **响应示例**

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "privateKey":"PrivateKey-Lf49kAJw3CbaL783vmbeAJvhscJqC7vi5yBYLxw2XfbzNS5RS"
    }
}
```

### 平台获取余额

获取由给定地址控制的AVAX的余额。

#### **签名**

```cpp
platform.getBalance({
    address:string
}) -> {
    balance: string,
    unlocked: string,
    lockedStakeable: string,
    lockedNotStakeable: string,
    utxoIDs: []{
        txID: string,
        outputIndex: int
    }
}
```

* `address` 是获取余额的地址。
* `balance` 是nAVAX的总余额。
* `unlocked` 是nAVAX的解锁的余额。
* `lockedStakeable`是锁定的质押中的nAVAX余额。
* `lockedNotStakeable` 是锁定未质押的余额。
* `utxoIDs` 是引用`address`的UTXO的ID。

#### **调用示例**

```cpp
curl -X POST --data '{
  "jsonrpc":"2.0",
  "id"     : 1,
  "method" :"platform.getBalance",
  "params" :{
      "address":"P-avax1m8wnvtqvthsxxlrrsu3f43kf9wgch5tyfx4nmf"
  }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/P
```

#### **响应示例**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "balance": "20000000000000000",
        "unlocked": "10000000000000000",
        "lockedStakeable": "10000000000000000",
        "lockedNotStakeable": "0",
        "utxoIDs": [
            {
                "txID": "11111111111111111111111111111111LpoYY",
                "outputIndex": 1
            },
            {
                "txID": "11111111111111111111111111111111LpoYY",
                "outputIndex": 0
            }
        ]
    },
    "id": 1
}
```

### 平台获取区块链

获取所有存在的区块链\(不包括P链\)。

#### **签名**

```cpp
platform.getBlockchains() ->
{
    blockchains: []{
        id: string,
        name:string,
        subnetID: string,
        vmID: string
    }
}
```

* `blockchains` 是存在于Avalanche网络上的所有区块链。
* `name` 是这个区块链的可读名称。
* `id` 是这个区块链的ID.
* `subnetID` 是验证这个区块链的子网的ID。
* `vmID` 是区块链运行的虚拟机ID。

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.getBlockchains",
    "params": {},
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

#### **响应示例**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "blockchains": [
            {
                "id": "2oYMBNV4eNHyqk2fjjV5nVQLDbtmNJzq5s3qs3Lo6ftnC6FByM",
                "name": "X-Chain",
                "subnetID": "11111111111111111111111111111111LpoYY",
                "vmID": "jvYyfQTxGMJLuGWa55kdP2p2zSUYsQ5Raupu4TW34ZAUBAbtq"
            },
            {
                "id": "2q9e4r6Mu3U68nU1fYjgbR6JvwrRx36CohpAX5UQxse55x1Q5",
                "name": "C-Chain",
                "subnetID": "11111111111111111111111111111111LpoYY",
                "vmID": "mgj786NP7uDwBCcq6YwThhaN8FLyybkCa4zBWTQbNgmK6k9A6"
            },
            {
                "id": "CqhF97NNugqYLiGaQJ2xckfmkEr8uNeGG5TQbyGcgnZ5ahQwa",
                "name": "Simple DAG Payments",
                "subnetID": "11111111111111111111111111111111LpoYY",
                "vmID": "sqjdyTKUSrQs1YmKDTUbdUhdstSdtRTGRbUn8sqK8B6pkZkz1"
            },
            {
                "id": "VcqKNBJsYanhVFxGyQE5CyNVYxL3ZFD7cnKptKWeVikJKQkjv",
                "name": "Simple Chain Payments",
                "subnetID": "11111111111111111111111111111111LpoYY",
                "vmID": "sqjchUjzDqDfBPGjfQq2tXW1UCwZTyvzAWHsNzF2cb1eVHt6w"
            },
            {
                "id": "2SMYrx4Dj6QqCEA3WjnUTYEFSnpqVTwyV3GPNgQqQZbBbFgoJX",
                "name": "Simple Timestamp Server",
                "subnetID": "11111111111111111111111111111111LpoYY",
                "vmID": "tGas3T58KzdjLHhBDMnH2TvrddhqTji5iZAMZ3RXs2NLpSnhH"
            },
            {
                "id": "KDYHHKjM4yTJTT8H8qPs5KXzE6gQH5TZrmP1qVr1P6qECj3XN",
                "name": "My new timestamp",
                "subnetID": "2bRCr6B4MiEfSjidDwxDpdCyviwnfUVqB2HGwhm947w9YYqb7r",
                "vmID": "tGas3T58KzdjLHhBDMnH2TvrddhqTji5iZAMZ3RXs2NLpSnhH"
            },
            {
                "id": "2TtHFqEAAJ6b33dromYMqfgavGPF3iCpdG3hwNMiart2aB5QHi",
                "name": "My new AVM",
                "subnetID": "2bRCr6B4MiEfSjidDwxDpdCyviwnfUVqB2HGwhm947w9YYqb7r",
                "vmID": "jvYyfQTxGMJLuGWa55kdP2p2zSUYsQ5Raupu4TW34ZAUBAbtq"
            }
        ]
    },
    "id": 1
}
```

### 平台获取区块链状态

获取区块链状态。

#### **签名**

```cpp
platform.getBlockchainStatus(
    {
        blockchainID: string
    }
) -> {status: string}
```

`status` 是以下情况之一:

* `Validating`: 该节点正在验证区块链。
* `Created`: 区块链存在，但该节点没有验证它。
* `Preferred`: 区块链被提议创建，而且很可能被创建，但交易尚未被接受。
* `Unknown`: 区块链要么没有被提议，要么创建它的提议不受欢迎。提案可以重新提交。

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.getBlockchainStatus",
    "params":{
        "blockchainID":"2NbS4dwGaf2p1MaXb65PrkZdXRwmSX4ZzGnUu7jm3aykgThuZE"
    },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

#### **响应示例**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "status": "Created"
    },
    "id": 1
}
```

### 平台获取当前供应

返回存在的AVAX数量的上限。 这是一个上限，因为它不考虑已销毁的代币，包括交易费。

#### **签名**

```cpp
platform.getCurrentSupply() -> {supply: int}
```

* `supply` 是存在的AVAX数量的上限，以nAVAX表示。

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.getCurrentSupply",
    "params": {},
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

#### **响应示例**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "supply": "365865167637779183"
    },
    "id": 1
}
```

此示例中的响应表明AVAX的供应量最多为3,865.65万。

### 平台获取当前验证器

列出给定子网的当前验证器。

从v1.0.1开始，顶级字段`delegators`已不推荐使用[deprecated](deprecated-api-calls.md#getcurrentvalidators)，并已在v1.0.6中删除。 相反，`validators`的每个元素现在都包含该验证器的委托人列表。

#### **签名**

```cpp
platform.getCurrentValidators({
    subnetID: string //optional
}) -> {
    validators: []{
        txID: string,
        startTime: string,
        endTime: string,
        stakeAmount: string, //optional
        nodeID: string,
        weight: string, //optional
        rewardOwner: {
            locktime: string,
            threshold: string,
            addresses: string[]
        },
        potentialReward: string,
        delegationFee: string,
        uptime: string,
        connected: bool,
        delegators: []{
            txID: string,
            startTime: string,
            endTime: string,
            stakeAmount: string, //optional
            nodeID: string,
            rewardOwner: {
                locktime: string,
                threshold: string,
                addresses: string[]
            },
            potentialReward: string,
        }
    }
}
```

* `subnetID` 是返回其当前验证器的子网。 如果省略，则返回主网络的当前验证器。
* `validators`:
  * `txID` 是验证者交易。
  * `startTime` 是验证器开始验证子网的Unix时间。
  * `endTime` 是验证器停止验证子网的Unix时间。
  * `stakeAmount` 是此验证程序投入的nAVAX的数量。 如果`subnetID`不是主网络则省略。
  * `nodeID` 是验证者的节点ID。
  * `weight` 是在对验证者进行抽样时验证者的权重。 如果`subnetID`是主网络则省略。
  * `rewardOwner` 是 `OutputOwners` 的输出, 包括`locktime`、`threshold`, 以及大批`addresses`。
  * `potentialReward` 是从质押中获得的潜在报酬。
  * `delegationFeeRate` 是当其他人将质押委托给他们时，该验证程序收取的费用百分比。
  * `uptime` 是查询的节点将对等方报告为在线的时间的百分比。is the % of time the queried node has reported the peer as online.
  * `connected` is if the node is connected to the network
  * `delegators` is the list of delegators to this validator:
    * `txID` is the delegator transaction.
    * `startTime` is the Unix time when the delegator started.
    * `endTime` is the Unix time when the delegator stops.
    * `stakeAmount` is the amount of nAVAX this delegator staked. Omitted if `subnetID` is not the Primary Network.
    * `nodeID` is the validating node’s node ID.
    * `rewardOwner` is an `OutputOwners` output which includes `locktime`, `threshold` and array of `addresses`.
    * `potentialReward` is the potential reward earned from staking
* `delegators`: \(**deprecated as of v1.0.1. See note at top of method documentation.**\)

#### **Example Call**

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.getCurrentValidators",
    "params": {},
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

#### **Example Response**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "validators": [
            {
                "txID": "2NNkpYTGfTFLSGXJcHtVv6drwVU2cczhmjK2uhvwDyxwsjzZMm",
                "startTime": "1600368632",
                "endTime": "1602960455",
                "stakeAmount": "2000000000000",
                "nodeID": "NodeID-5mb46qkSBj81k9g9e4VFjGGSbaaSLFRzD",
                "rewardOwner": {
                    "locktime": "0",
                    "threshold": "1",
                    "addresses": [
                        "P-avax18jma8ppw3nhx5r4ap8clazz0dps7rv5u00z96u"
                    ]
                },
                "potentialReward": "117431493426",
                "delegationFee": "10.0000",
                "uptime": "0.0000",
                "connected": false,
                "delegators": [
                    {
                        "txID": "Bbai8nzGVcyn2VmeYcbS74zfjJLjDacGNVuzuvAQkHn1uWfoV",
                        "startTime": "1600368523",
                        "endTime": "1602960342",
                        "stakeAmount": "25000000000",
                        "nodeID": "NodeID-5mb46qkSBj81k9g9e4VFjGGSbaaSLFRzD",
                        "rewardOwner": {
                            "locktime": "0",
                            "threshold": "1",
                            "addresses": [
                                "P-avax18jma8ppw3nhx5r4ap8clazz0dps7rv5u00z96u"
                            ]
                        },
                        "potentialReward": "11743144774"
                    }
                ]
            }
        ]
    },
    "id": 1
}
```

### platform.getHeight

Returns the height of the last accepted block.

#### **Signature**

```cpp
platform.getHeight() ->
{
    height: int,
}
```

#### **Example Call**

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.getHeight",
    "params": {},
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

#### **Example Response**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "height": "56"
    },
    "id": 1
}
```

### platform.getMinStake

Get the minimum amount of AVAX required to validate the Primary Network and the minimum amount of AVAX that can be delegated.

#### **Signature**

```cpp
platform.getMinStake() -> 
{
    minValidatorStake : uint64,
    minDelegatorStake : uint64
}
```

#### **Example Call**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"platform.getMinStake"
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

#### **Example Response**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "minValidatorStake": "2000000000000",
        "minDelegatorStake": "25000000000"
    },
    "id": 1
}
```

### platform.getPendingValidators

List the validators in the pending validator set of the specified Subnet. Each validator is not currently validating the Subnet but will in the future.

#### **Signature**

```cpp
platform.getPendingValidators({
    subnetID: string //optional
}) -> {
    validators: []{
        txID: string,
        startTime: string,
        endTime: string,
        stakeAmount: string, //optional
        nodeID: string,
        delegationFee: string,
        connected: bool,
        weight: string, //optional
    },
    delegators: []{
        txID: string,
        startTime: string,
        endTime: string,
        stakeAmount: string,
        nodeID: string
    }
}
```

* `subnetID` is the subnet whose current validators are returned. If omitted, returns the current validators of the Primary Network.
* `validators`:
  * `txID` is the validator transaction.
  * `startTime` is the Unix time when the validator starts validating the Subnet.
  * `endTime` is the Unix time when the validator stops validating the Subnet.
  * `stakeAmount` is the amount of nAVAX this validator staked. Omitted if `subnetID` is not the Primary Network.
  * `nodeID` is the validator’s node ID.
  * `connected` if the node is connected.
  * `weight` is the validator’s weight when sampling validators. Omitted if `subnetID` is the Primary Network.
* `delegators`:
  * `txID` is the delegator transaction.
  * `startTime` is the Unix time when the delegator starts.
  * `endTime` is the Unix time when the delegator stops.
  * `stakeAmount` is the amount of nAVAX this delegator staked. Omitted if `subnetID` is not the Primary Network.
  * `nodeID` is the validating node’s node ID.

#### **Example Call**

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.getPendingValidators",
    "params": {},
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

#### **Example Response**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "validators": [
            {
                "txID": "2NNkpYTGfTFLSGXJcHtVv6drwVU2cczhmjK2uhvwDyxwsjzZMm",
                "startTime": "1600368632",
                "endTime": "1602960455",
                "stakeAmount": "200000000000",
                "nodeID": "NodeID-5mb46qkSBj81k9g9e4VFjGGSbaaSLFRzD",
                "delegationFee": "10.0000",
                "connected": false
            }
        ],
        "delegators": [
            {
                "txID": "Bbai8nzGVcyn2VmeYcbS74zfjJLjDacGNVuzuvAQkHn1uWfoV",
                "startTime": "1600368523",
                "endTime": "1602960342",
                "stakeAmount": "20000000000",
                "nodeID": "NodeID-7Xhw2mDxuDS44j42TCB6U5579esbSt3Lg"
            }
        ]
    },
    "id": 1
}
```

### platform.getStakingAssetID

Retrieve an assetID for a subnet’s staking asset. Currently, this only returns the Primary Network’s staking assetID.

#### **Signature**

```cpp
platform.getStakingAssetID({
    subnetID: string //optional
}) -> {
    assetID: string
}
```

* `subnetID` is the subnet whose assetID is requested.
* `assetID` is the assetID for a subnet’s staking asset.

#### **Example Call**

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.getStakingAssetID",
    "params": {
        "subnetID": "11111111111111111111111111111111LpoYY"
    },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

#### **Example Response**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "assetID": "2fombhL7aGPwj3KH4bfrmJwW6PVnMobf9Y2fn9GwxiAAJyFDbe"
    },
    "id": 1
}
```

### platform.getSubnets

Get info about the Subnets.

#### **Signature**

```cpp
platform.getSubnets(
    {ids: []string}
) ->
{
    subnets: []{
        id: string,
        controlKeys: []string,
        threshold: string
    }
}
```

* `ids` are the IDs of the subnets to get information about. If omitted, gets information about all subnets.
* `id` is the Subnet’s ID.  
* `threshold` signatures from addresses in `controlKeys` are needed to add a validator to the subnet.  

See [here](../tutorials/nodes-and-staking/add-a-validator.md) for information on adding a validator to a Subnet.

#### **Example Call**

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.getSubnets",
    "params": {"ids":["hW8Ma7dLMA7o4xmJf3AXBbo17bXzE7xnThUd3ypM4VAWo1sNJ"]},
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

#### **Example Response**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "subnets": [
            {
                "id": "hW8Ma7dLMA7o4xmJf3AXBbo17bXzE7xnThUd3ypM4VAWo1sNJ",
                "controlKeys": [
                    "KNjXsaA1sZsaKCD1cd85YXauDuxshTes2",
                    "Aiz4eEt5xv9t4NCnAWaQJFNz5ABqLtJkR"
                ],
                "threshold": "2"
            }
        ]
    },
    "id": 1
}'
```

### platform.getStake

Get the amount of nAVAX staked by a set of addresses. The amount returned does not include staking rewards.

#### **Signature**

```cpp
platform.getStake({addresses: []string}) -> {staked: int}
```

#### **Example Call**

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.getStake",
    "params": {
        "addresses": [
            "P-everest1g3ea9z5kmkzwnxp8vr8rpjh6lqw4r0ufec460d",
            "P-everest12un03rm579fewele99c4v53qnmymwu46dv3s5v"
        ]
    },
    "id": 1
}
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

#### **Example Response**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "staked": "5000000"
    },
    "id": 1
}
```

### platform.getTotalStake

Get the total amount of nAVAX staked on the Primary Network.

#### **Signature**

```cpp
platform.getTotalStake() -> {stake: int}
```

#### **Example Call**

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.getTotalStake",
    "params": {},
    "id": 1
}
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

#### **Example Response**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "stake": "279825917679866811"
    },
    "id": 1
}
```

### platform.getTx

Gets a transaction by its ID.

Optional `encoding` parameter to specify the format for the returned transaction. Can be either “cb58” or “hex”. Defaults to “cb58”.

#### **Signature**

```cpp
platform.getTx({
    txID: string,
    encoding: string //optional
}) -> {
    tx: string,
    encoding: string,
}
```

#### **Example Call**

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.getTx",
    "params": {
        "txID":"TAG9Ns1sa723mZy1GSoGqWipK6Mvpaj7CAswVJGM6MkVJDF9Q",
        "encoding": "cb58"
    },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

#### **Example Response**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "tx": "111117XV7Rm5EoKbwXFJp5WWWouAENJcF1zXGxPDPCfTbpiLfwkUXcoHKnfzdXz7sRgGYeaVtJkcD9MNgGuKGXsyWEWpTK2zAToEf64ezp7r7SyvyL7RqC5oqvNbRDShn5hm9pDV4JTCjZR5RzAxjBEJZ2V8eqtU6jvpsJMHxNBtCwL6Atc1t2Dt7s5nqf7wdbFUBvwKXppBb2Yps8wUvtTKQifssMUAPygc2Rv4rGd9LRANk4JTiT15qzUjXX7zSzz16pxdBXc4jp2Z2UJRWbdxZdaybL3mYCFj197bBnYieRYzRohaUEpEjGcohrmkSfHB8S2eD74o2r66sVGdpXYo95vkZeayQkrMRit6unwWBx8FJR7Sd7GysxS9A3CiMc8cL4oRmr7XyvcFCrnPbUZK7rnN1Gtq3MN8k4JVvX6DuiFAS7xe61jY3VKJAZM9Lg3BgU6TAU3gZ",
        "encoding": "cb58"
    },
    "id": 1
}
```

### platform.getTxStatus

Gets a transaction’s status by its ID. If the transaction was dropped, response will include a `reason` field with more information why the transaction was dropped.

See [here](deprecated-api-calls.md#gettxstatus) for notes on previous behavior.

#### **Signature**

```cpp
platform.getTxStatus({
    txID: string
}) -> {status: string}
```

#### **Example Call**

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.getTxStatus",
    "params": {
        "txID":"TAG9Ns1sa723mZy1GSoGqWipK6Mvpaj7CAswVJGM6MkVJDF9Q"
   },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

#### **Example Response**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "status": "Committed"
    },
    "id": 1
}
```

### platform.getUTXOs

Gets the UTXOs that reference a given set of addresses.

#### **Signature**

```cpp
platform.getUTXOs(
    {
        addresses: []string,
        limit: int, //optional
        startIndex: { //optional
            address: string,
            utxo: string
        },
        sourceChain: string, //optional
        encoding: string, //optional
    },
) -> 
{
    numFetched: int,
    utxos: []string,
    endIndex: {
        address: string,
        utxo: string
    },
    encoding: string,
}
```

* `utxos` is a list of UTXOs such that each UTXO references at least one address in `addresses`.
* At most `limit` UTXOs are returned. If `limit` is omitted or greater than 1024, it is set to 1024.
* This method supports pagination. `endIndex` denotes the last UTXO returned. To get the next set of UTXOs, use the value of `endIndex` as `startIndex` in the next call.
* If `startIndex` is omitted, will fetch all UTXOs up to `limit`.
* When using pagination \(ie when `startIndex` is provided\), UTXOs are not guaranteed to be unique across multiple calls. That is, a UTXO may appear in the result of the first call, and then again in the second call.
* When using pagination, consistency is not guaranteed across multiple calls. That is, the UTXO set of the addresses may have changed between calls.
* `encoding` specifies the format for the returned UTXOs. Can be either “cb58” or “hex” and defaults to “cb58”.

#### **Example**

Suppose we want all UTXOs that reference at least one of `P-avax1s994jad0rtwvlfpkpyg2yau9nxt60qqfv023qx` and `P-avax1fquvrjkj7ma5srtayfvx7kncu7um3ym73ztydr`.

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"platform.getUTXOs",
    "params" :{
        "addresses":["P-avax1s994jad0rtwvlfpkpyg2yau9nxt60qqfv023qx", "P-avax1fquvrjkj7ma5srtayfvx7kncu7um3ym73ztydr"],
        "limit":5,
        "encoding": "cb58"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/P
```

This gives response:

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "numFetched": "5",
        "utxos": [
            "11PQ1sNw9tcXjVki7261souJnr1TPFrdVCu5JGZC7Shedq3a7xvnTXkBQ162qMYxoerMdwzCM2iM1wEQPwTxZbtkPASf2tWvddnsxPEYndVSxLv8PDFMwBGp6UoL35gd9MQW3UitpfmFsLnAUCSAZHWCgqft2iHKnKRQRz",
            "11RCDVNLzFT8KmriEJN7W1in6vB2cPteTZHnwaQF6kt8B2UANfUkcroi8b8ZSEXJE74LzX1mmBvtU34K6VZPNAVxzF6KfEA8RbYT7xhraioTsHqxVr2DJhZHpR3wGWdjUnRrqSSeeKGE76HTiQQ8WXoABesvs8GkhVpXMK",
            "11GxS4Kj2od4bocNWMQiQhcBEHsC3ZgBP6edTgYbGY7iiXgRVjPKQGkhX5zj4NC62ZdYR3sZAgp6nUc75RJKwcvBKm4MGjHvje7GvegYFCt4RmwRbFDDvbeMYusEnfVwvpYwQycXQdPFMe12z4SP4jXjnueernYbRtC4qL",
            "11S1AL9rxocRf2NVzQkZ6bfaWxgCYch7Bp2mgzBT6f5ru3XEMiVZM6F8DufeaVvJZnvnHWtZqocoSRZPHT5GM6qqCmdbXuuqb44oqdSMRvLphzhircmMnUbNz4TjBxcChtks3ZiVFhdkCb7kBNLbBEmtuHcDxM7MkgPjHw",
            "11Cn3i2T9SMArCmamYUBt5xhNEsrdRCYKQsANw3EqBkeThbQgAKxVJomfc2DE4ViYcPtz4tcEfja38nY7kQV7gGb3Fq5gxvbLdb4yZatwCZE7u4mrEXT3bNZy46ByU8A3JnT91uJmfrhHPV1M3NUHYbt6Q3mJ3bFM1KQjE"
        ],
        "endIndex": {
            "address": "P-avax1fquvrjkj7ma5srtayfvx7kncu7um3ym73ztydr",
            "utxo": "kbUThAUfmBXUmRgTpgD6r3nLj7rJUGho6xyht5nouNNypH45j"
        },
        "encoding": "cb58"
    },
    "id": 1
}
```

Since `numFetched` is the same as `limit`, we can tell that there may be more UTXOs that were not fetched. We call the method again, this time with `startIndex`:

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"platform.getUTXOs",
    "params" :{
        "addresses":["P-avax1fquvrjkj7ma5srtayfvx7kncu7um3ym73ztydr"],
        "limit":5,
        "startIndex": {
            "address": "P-avax1fquvrjkj7ma5srtayfvx7kncu7um3ym73ztydr",
            "utxo": "kbUThAUfmBXUmRgTpgD6r3nLj7rJUGho6xyht5nouNNypH45j"
        },
        "encoding": "cb58"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/P
```

This gives response:

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "numFetched": "4",
        "utxos": [
            "115ZLnNqzCsyugMY5kbLnsyP2y4se4GJBbKHjyQnbPfRBitqLaxMizsaXbDMU61fHV2MDd7fGsDnkMzsTewULi94mcjk1bfvP7aHYUG2i3XELpV9guqsCtv7m3m3Kg4Ya1m6tAWqT7PhvAaW4D3fk8W1KnXu5JTWvYBqD2",
            "11QASUuhw9M1r52maTFUZ4fnuQby9inX77VYxePQoNavEyCPuHN5cCWPQnwf8fMrydFXVMPAcS4UJAcLjSFskNEmtVPDMY4UyHwh2MChBju6Y7V8yYf3JBmYt767NPsdS3EqgufYJMowpud8fNyH1to4pAdd6A9CYbD8KG",
            "11MHPUWT8CsdrtMWstYpFR3kobsvRrLB4W8tP9kDjhjgLkCJf9aaJQM832oPcvKBsRhCCxfKdWr2UWPztRCU9HEv4qXVwRhg9fknAXzY3a9rXXPk9HmArxMHLzGzRECkXpXb2dAeqaCsZ637MPMrJeWiovgeAG8c5dAw2q",
            "11K9kKhFg75JJQUFJEGiTmbdFm7r1Uw5zsyDLDY1uVc8zo42WNbgcpscNQhyNqNPKrgtavqtRppQNXSEHnBQxEEh5KbAEcb8SxVZjSCqhNxME8UTrconBkTETSA23SjUSk8AkbTRrLz5BAqB6jo9195xNmM3WLWt7mLJ24"
        ],
        "endIndex": {
            "address": "P-avax1fquvrjkj7ma5srtayfvx7kncu7um3ym73ztydr",
            "utxo": "21jG2RfqyHUUgkTLe2tUp6ETGLriSDTW3th8JXFbPRNiSZ11jK"
        },
        "encoding": "cb58"
    },
    "id": 1
}
```

Since `numFetched` is less than `limit`, we know that we are done fetching UTXOs and don’t need to call this method again.

Suppose we want to fetch the UTXOs exported from the X Chain to the P Chain in order to build an ImportTx. Then we need to call GetUTXOs with the sourceChain argument in order to retrieve the atomic UTXOs:

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"platform.getUTXOs",
    "params" :{
        "addresses":["P-avax1fquvrjkj7ma5srtayfvx7kncu7um3ym73ztydr"],
        "sourceChain": "X",
        "encoding": "cb58"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/P
```

This gives response:

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "numFetched": "1",
        "utxos": [
            "115P1k9aSVFBfi9siZZz135jkrBCdEMZMbZ82JaLLuML37cgVMvGwefFXr2EaH2FML6mZuCehMLDdXSVE5aBwc8ePn8WqtZgDv9W641JZoLQhWY8fmvitiBLrc3Zd1aJPDxPouUVXFmLEbmcUnQxfw1Hyz1jpPbWSioowb"
        ],
        "endIndex": {
            "address": "P-avax1fquvrjkj7ma5srtayfvx7kncu7um3ym73ztydr",
            "utxo": "S5UKgWoVpoGFyxfisebmmRf8WqC7ZwcmYwS7XaDVZqoaFcCwK"
        },
        "encoding": "cb58"
    },
    "id": 1
}
```

### platform.importAVAX

Complete a transfer of AVAX from the X-Chain to the P-Chain.

Before this method is called, you must call the X-Chain’s [`avm.exportAVAX`](exchange-chain-x-chain-api.md#avm-exportavax) method to initiate the transfer.

#### **Signature**

```cpp
platform.importAVAX(
    {
        from: []string, //optional
        to: string,
        changeAddr: string, //optional
        sourceChain: string,
        username: string,
        password: string
    }
) -> 
{
    tx: string,
    changeAddr: string
}
```

* `to` is the ID of the address the AVAX is imported to. This must be the same as the `to` argument in the corresponding call to the X-Chain’s `exportAVAX`.
* `sourceChain` is the ID or alias of the chain the AVAX is being imported from. To import funds from the X-Chain, use `"X"`.
* `from` are the addresses that you want to use for this operation. If omitted, uses any of your addresses as needed.
* `changeAddr` is the address any change will be sent to. If omitted, change is sent to one of the addresses controlled by the user.
* `username` is the user that controls the address specified in `to`.
* `password` is `username`‘s password.

#### **Example Call**

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.importAVAX",
    "params": {
        "sourceChain": "X",
        "to": "P-avax1apzq2zt0uaaatum3wdz83u4z7dv4st7l5m5n2a",
        "from": ["P-avax1gss39m5sx6jn7wlyzeqzm086yfq2l02xkvmecy"],
        "changeAddr": "P-avax103y30cxeulkjfe3kwfnpt432ylmnxux8r73r8u",
        "username": "myUsername",
        "password": "myPassword"
    },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

#### **Example Response**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "txID": "P63NjowXaQJXt5cmspqdoD3VcuQdXUPM5eoZE2Vcg63aVEx8R",
        "changeAddr": "P-avax103y30cxeulkjfe3kwfnpt432ylmnxux8r73r8u"
    },
    "id": 1
}
```

### platform.importKey

Give a user control over an address by providing the private key that controls the address.

#### **Signature**

```cpp
platform.importKey({
    username: string,
    password: string,
    privateKey:string
}) -> {address: string}
```

* Add `privateKey` to `username`‘s set of private keys. `address` is the address `username` now controls with the private key.

#### **Example Call**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"platform.importKey",
    "params" :{
        "username": "myUsername",
        "password": "myPassword",
        "privateKey": "PrivateKey-2w4XiXxPfQK4TypYqnohRL8DRNTz9cGiGmwQ1zmgEqD9c9KWLq"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

#### **Example Response**

```cpp
{
    "jsonrpc":"2.0",
    "id": 1,
    "result": {
        "address":"P-avax19hwpvkx2p5q99w87dlpfhqpt3czyh8ywasfaym"
    }
}
```

### platform.issueTx

Issue a transaction to the Platform Chain.

#### **Signature**

```cpp
platform.issueTx({
    tx: string,
    encoding: string, //optional
}) -> {txID: string}
```

* `tx` is the byte representation of a transaction.
* `encoding` specifies the encoding format for the transaction bytes. Can be either “cb58” or “hex”. Defaults to “cb58”.
* `txID` is the transaction’s ID.

#### **Example Call**

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.issueTx",
    "params": {
        "tx":"111Bit5JNASbJyTLrd2kWkYRoc96swEWoWdmEhuGAFK3rCAyTnTzomuFwgx1SCUdUE71KbtXPnqj93KGr3CeftpPN37kVyqBaAQ5xaDjr7wVBTUYi9iV7kYJnHF61yovViJF74mJJy7WWQKeRMDRTiPuii5gsd11gtNahCCsKbm9seJtk2h1wAPZn9M1eL84CGVPnLUiLP",
        "encoding": "cb58"
    },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

#### **Example Response**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "txID": "G3BuH6ytQ2averrLxJJugjWZHTRubzCrUZEXoheG5JMqL5ccY"
    },
    "id": 1
}
```

### platform.listAddresses

List addresses controlled by the given user.

#### **Signature**

```cpp
platform.listAddresses({
    username: string,
    password: string
}) -> {addresses: []string}
```

#### **Example Call**

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.listAddresses",
    "params": {
        "username":"myUsername",
        "password":"myPassword"
    },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/P
```

#### **Example Response**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "addresses": ["P-avax1ffksh2m592yjzwfp2xmdxe3z4ushln9s09z5p0"]
    },
    "id": 1
}
```

### platform.sampleValidators

Sample validators from the specified Subnet.

#### **Signature**

```cpp
platform.sampleValidators(
    {
        size: int,
        subnetID: string, //optional
    }
) ->
{
    validators: []string
}
```

* `size` is the number of validators to sample.
* `subnetID` is the Subnet to sampled from. If omitted, defaults to the Primary Network.
* Each element of `validators` is the ID of a validator.

#### **Example Call**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"platform.sampleValidators",
    "params" :{
        "size":2
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

#### **Example Response**

```cpp
{
    "jsonrpc": "2.0",
    "id": 1,
    "result": {
        "validators":[
            "NodeID-MFrZFVCXPv5iCn6M9K6XduxGTYp891xXZ",
            "NodeID-NFBbbJ4qCmNaCzeW7sxErhvWqvEQMnYcN"
        ]
    }
}
```

### platform.validatedBy

Get the Subnet that validates a given blockchain.

#### **Signature**

```cpp
platform.validatedBy(
    {
        blockchainID: string
    }
) -> {subnetID: string}
```

* `blockchainID` is the blockchain’s ID.
* `subnetID` is the ID of the Subnet that validates the blockchain.

#### **Example Call**

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.validatedBy",
    "params": {
        "blockchainID": "KDYHHKjM4yTJTT8H8qPs5KXzE6gQH5TZrmP1qVr1P6qECj3XN"
    },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

#### **Example Response**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "subnetID": "2bRCr6B4MiEfSjidDwxDpdCyviwnfUVqB2HGwhm947w9YYqb7r"
    },
    "id": 1
}
```

### platform.validates

Get the IDs of the blockchains a Subnet validates.

#### **Signature**

```cpp
platform.validates(
    {
        subnetID: string
    }
) -> {blockchainIDs: []string}
```

* `subnetID` is the Subnet’s ID.
* Each element of `blockchainIDs` is the ID of a blockchain the Subnet validates.

#### **Example Call**

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.validates",
    "params": {
        "subnetID":"2bRCr6B4MiEfSjidDwxDpdCyviwnfUVqB2HGwhm947w9YYqb7r"
    },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

#### **Example Response**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "blockchainIDs": [
            "KDYHHKjM4yTJTT8H8qPs5KXzE6gQH5TZrmP1qVr1P6qECj3XN",
            "2TtHFqEAAJ6b33dromYMqfgavGPF3iCpdG3hwNMiart2aB5QHi"
        ]
    },
    "id": 1
}
```

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE3NjIwODM3NzEsLTk4MjYwNTEzNCwtMT
U4OTIyNzc2NCwtMTExMDgzODMzOCwtOTA3MTM0MDIwLC0xNzg0
MjQ0NTI3LC05MTIyNzYxNTAsMTU0Nzc5NTM4NywtMjQwMzkwMz
IsNjQyMjc2MjMyLC02NjI0OTY1NTMsOTIxNjk5Mzk5XX0=
-->