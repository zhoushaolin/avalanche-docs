# 添加验证程序

## 简介

主网络[Primary Network](https://avalanche.gitbook.io/avalanche/build/tutorials/platform/add-a-validator#introduction) 是Avalanche平台固有的, 它可以验证平台上的内置区块链[built-in blockchains](https://avalanche.gitbook.io/avalanche/learn/platform-overview)。在本教程中, 我们将向主网添加一个节点, 并在Avalanche平台上添加一个子网[subnet](https://avalanche.gitbook.io/avalanche/learn/platform-overview#subnets)。

P链管理着Avalanche上的元数据, 可以追踪哪些节点位于哪些子网中、存在哪些区块链以及哪些子网正在验证哪些区块链。如需添加一个验证程序，我们将向P链发起交易[transactions](http://support.avalabs.org/en/articles/4587384-what-is-a-transaction)。

请注意，一旦您发起交易来将一个节点作为验证程序加入时，参数是无法更改的。**您无法提前移除质押或更改质押金额、节点ID或收益地址**。 请确保您在以下API调用中使用了正确的值, 如果您不确定, 请浏览[Developer FAQ's](http://support.avalabs.org/en/collections/2618154-developer-faq) 或在[Discord](https://chat.avalabs.org/)
上来寻求帮助。

## 要求

您已完成运行一个Avalanche节点 [Run an Avalanche Node](../../get-started.md), 并且熟悉Avalanche 的架构[Avalanche's architecture](../../../learn/platform-overview/)。在本教程中, 我们将使用[Avalanche’s Postman collection](https://github.com/ava-labs/avalanche-postman-collection)来帮助我们进行API调用。

为了确保您连好了您的节点，请确保您的节点能够在锁定端口上收到并发送TCP流量\(默认端口`9651`\)，并且您使用命令行参数`--public-ip=[YOUR NODE'S PUBLIC IP HERE]`启动了节点, 如未做到这一点，您的质押收益可能会受到影响。

## Avalanche钱包添加验证程序

首先, 我们将向您展示如何使用[Avalanche Wallet](https://wallet.avax.network), 将节点作为验证程序添加进来。 

通过调用[`info.getNodeID`](https://avalanche.gitbook.io/avalanche/build/apis/info-api#info-getnodeid), 获取您的节点ID:

![getNodeID postman](../../../.gitbook/assets/getNodeID-postman.png)

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"info.getNodeID"
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/info
```

The response has your node’s ID:

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "nodeID": "NodeID-5mb46qkSBj81k9g9e4VFjGGSbaaSLFRzD"
    },
    "id": 1
}
```

打开钱包[the wallet](https://wallet.avax.network/), 并进入赚钱`Earn`选项, 选择添加验证程序`Add Validator`。

![Web wallet earn tab](../../../.gitbook/assets/web-wallet-earn-tab.png)

填写质押参数。下面将进行更详细的讲解。当您填写完所有质押参数并复查后，请点击确认`Confirm`。请确认质押期至少2周，委托费率至少是2%，至少质押2000AVAX。

{% page-ref page="../../../learn/platform-overview/staking.md" %}

![Earn validate](../../../.gitbook/assets/earn-validate.png)

您会看交易成功的信息，并且余额也更新了。

![Your validation transaction is sent](../../../.gitbook/assets/your-validation-transaction-is-sent.png)

调用[`platform.getPendingValidators`](https://avalanche.gitbook.io/avalanche/build/apis/platform-chain-p-chain-api#platform-getpendingvalidators) 核实我们的交易已接受。

![getPendingValidators postman](../../../.gitbook/assets/getPendingValidators-postman.png)

返回赚钱`Earn`选项, 并点击预计收益`Estimated Rewards`.

![Earn, validate, delegate](../../../.gitbook/assets/earn-validate-delegate.png)

一旦验证程序开始时间一到，您就会看到它可能赚取的收益、开始时间、结束时间, 以及验证期已过的百分比。

![Estimated rewards](../../../.gitbook/assets/estimated-rewards.png)


## 调用API 添加验证程序

通过向节点进行API调用，可以向验证程序集合添加一个节点。要将节点添加到主网，我们将调用 [`platform.addValidator`](https://avalanche.gitbook.io/avalanche/build/apis/platform-chain-p-chain-api#platform-addvalidator).

此方法的明显特征是：

```cpp
platform.addValidator(
    {
        nodeID: string,
        startTime: int,
        endTime: int,
        stakeAmount: int,
        rewardAddress: string,
        changeAddr: string, (optional)
        delegationFeeRate: float,
        username: string,
        password: string
    }
) -> {txID: string}
```

让我们看看这些要点。

节点ID`nodeID`

T这是添加的验证程序的节点ID ,  如需获取您的节点ID, 请调用[`info.getNodeID`](https://avalanche.gitbook.io/avalanche/build/apis/info-api#info-getnodeid):

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "info.getNodeID",
    "params":{},
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/info
```

响应中包含您的节点ID：

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "nodeID": "NodeID-LMUue2dBBRWdDbPL4Yx47Ps31noeewJji"
    },
    "id": 1
}
```

开始时间`startTime` 和 结束时间`endTime`

当一个人发起一项交易，并加入主网时，即确定了进入时间 \(开始验证\)和离开时间\(结束验证\), 验证主网的最短时间为24小时，最长时间为一年。离开后可以重新进入主网，但最长持续时间是一年。开始时间`startTime` 和结束时间`endTime`分别是您的验证程序启动和停止验证主网的Unix次数, 开始时间`startTime`必须是在交易发起时间之后。

质押金额`stakeAmount`

为了验证主网，您必须质押AVAX。该参数确定了质押的AVAX金额。

收益地址`rewardAddress`

当验证程序停止验证主网时，如果它们验证主网时响应充分且正确，则它们会获得收益。上述代币会发送到收益地址`rewardAddress`。原始质押会发送回用户名`username`控制的一个地址。

无论如何，验证程序的质押永远不会大幅削减；完成验证后，质押金额将被发送回去。

更改地址`changeAddr`

任何关于此交易的更改都会发送到此地址。您可以将此区域留白；这样的话，更改会发送到您的用户名下的一个地址。

委托费率`delegationFeeRate`

通过Avalanche，可以进行质押委托。该参数是其他人将质押委托给验证程序时，验证程序收取的百分比费用。例如，如果委托费率`delegationFeeRate`为1.2345，并且有人向验证程序提出委托时，则委托期结束时，1.2345%的收益会分配给验证程序，其余部分则会分配给委托方。

用户名`username` and 密码`password`

这些参数是支付交易费用、提供质押AVAX和回收质押AVAX的用户的用户名与密码。

现在让我们发起交易吧。我们使用shell命令“date”计算未来10分钟和30天的Unix时间，分别作为开始时间`startTime`和结束时间`endTime`的值。\(注意:如果你用的是Mac电脑，请将`$(date`替换为`$(gdate`, 如果你没有安装`gdate`, 请使用`brew install coreutils`)。在这个例子中，我们质押了2000 AVAX\(2 x 1012 nAVAX\)。

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.addValidator",
    "params": {
        "nodeID":"NodeID-LMUue2dBBRWdDbPL4Yx47Ps31noeewJji",
        "startTime":'$(date --date="10 minutes" +%s)',
        "endTime":'$(date --date="30 days" +%s)',
        "stakeAmount":2000000000000,
        "rewardAddress":"P-avax1d4wfwrfgu4dkkyq7dlhx0lt69y2hjkjeejnhca",
        "changeAddr": "P-avax103y30cxeulkjfe3kwfnpt432ylmnxux8r73r8u",
        "delegationFeeRate":10,
        "username":"USERNAME",
        "password":"PASSWORD"
    },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

响应包含交易ID和收到更改的地址。

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

我们可以通过调用[`platform.getTxStatus`](https://avalanche.gitbook.io/avalanche/build/apis/platform-chain-p-chain-api#platform-gettxstatus)来查看交易状态:

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.getTxStatus",
    "params": {
        "txID":"6pb3mthunogehapzqmubmx6n38ii3lzytvdrxumovwkqftzls"
    },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

状态应是已提交`Committed`, 即交易成功, 我们可以调用[`platform.getPendingValidators`](https://avalanche.gitbook.io/avalanche/build/apis/platform-chain-p-chain-api#platform-getpendingvalidators), 并查看该节点目前正处于主网的待定验证程序集合中:

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.getPendingValidators",
    "params": {},
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

响应包括我们刚刚添加的节点：

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "validators": [
            {
                "nodeID": "NodeID-LMUue2dBBRWdDbPL4Yx47Ps31noeewJji",
                "startTime": "1584021450",
                "endtime": "1584121156",
                "stakeAmount": "2000000000000",
            }
        ] 
    },
    "id": 1
}
```

当时间达到`1584021450`时，该节点将开始验证主网。当时间达到`1584121156`，该节点将停止验证主网。质押的AVAX会退还至用户名`username`控制的地址，如有收益, 则会发送到收益地址`rewardAddress`。

## 添加子网验证程序

### 发起子网验证程序交易

现在让我们把同一个节点添加到子网中。如果您已经完成了子网创建教程[tutorial on creating a Subnet](https://avalanche.gitbook.io/avalanche/build/tutorials/platform/create-a-subnet)，那么下文就会更清楚。现在，您只能通过API调用将验证程序添加到子网中，通过Avalanche钱包是行不通的。

假如子网的ID是 `nTd2Q2nTLp8M9qv2VKHMdvYhtNWX7aTPa4SMEK7x7yJHbcWvr`, 阈值是 2, 则用户名`username`至少持有2个密钥。

如需添加验证程序, 我们将调用API的方法 [`platform.addSubnetValidator`](https://avalanche.gitbook.io/avalanche/build/apis/platform-chain-p-chain-api#platform-addsubnetvalidator), 其特征是:

```cpp
platform.addSubnetValidator(
    {
        nodeID: string,
        subnetID: string,
        startTime: int,
        endTime: int,
        weight: int,
        changeAddr: string, (optional)
        username: string,
        password: string
    }
) -> {txID: string}
```

让我们来检查一下参数：

节点ID`nodeID`

这是添加到子网的验证程序的节点ID。**此验证程序必须在其验证此子网的全程中验证主网。**

子网ID`subnetID`

这是我们即将添加验证程序的子网的ID。

开始时间`startTime` 与 结束时间`endTime`

与上文类似，这是验证程序将开始和停止验证子网的Unix次数。开始时间`startTime`必须在验证程序开始验证主网的同时或之后，而结束时间`endTime`必须在验证程序停止验证主网的同时或之前。

权重`weight`

这是为达成共识的验证程序的采样权重。如果验证程序的权重是1，且子网中所有验证程序的累计权重是100，则达成共识期间，每100个样本中就有1个包含该验证程序。

更改地址`changeAddr`

关于此交易的任何更改都会发送到此地址。您可以留空此区域；如果您留空了，更改会发送到您的用户控制的一个地址。
Any change resulting from this transaction will be sent to this address. You can leave this field empty; if you do, change will be sent to one of the addresses your user controls.

`username` and `password`

These parameters are the username and password of the user that pays the transaction fee. This user must hold a sufficient number of this Subnet’s control keys in order to add a validator to this Subnet.

We use the shell command `date` to compute the Unix time 10 minutes and 30 days in the future to use as the values of `startTime` and `endTime`, respectively. \(Note: If you’re on a Mac, replace `$(date` with `$(gdate`. If you don’t have `gdate` installed, do `brew install coreutils`.\)

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.addSubnetValidator",
    "params": {
        "nodeID":"NodeID-LMUue2dBBRWdDbPL4Yx47Ps31noeewJji",
        "subnetID":"nTd2Q2nTLp8M9qv2VKHMdvYhtNWX7aTPa4SMEK7x7yJHbcWvr",
        "startTime":'$(date --date="10 minutes" +%s)',
        "endTime":'$(date --date="30 days" +%s)',
        "weight":1,
        "changeAddr": "P-avax103y30cxeulkjfe3kwfnpt432ylmnxux8r73r8u",
        "username":"USERNAME",
        "password":"PASSWORD"
    },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

The response has the transaction ID, as well as the address the change went to.

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "txID": "2exafyvRNSE5ehwjhafBVt6CTntot7DFjsZNcZ54GSxBbVLcCm",
        "changeAddr": "P-avax103y30cxeulkjfe3kwfnpt432ylmnxux8r73r8u"
    },
    "id": 1
}
```

We can check the transaction’s status by calling [`platform.getTxStatus`](https://avalanche.gitbook.io/avalanche/build/apis/platform-chain-p-chain-api#platform-gettxstatus):

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.getTxStatus",
    "params": {
        "txID":"2exafyvRNSE5ehwjhafBVt6CTntot7DFjsZNcZ54GSxBbVLcCm"
    },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

The status should be `Committed`, meaning the transaction was successful. We can call [`platform.getPendingValidators`](https://avalanche.gitbook.io/avalanche/build/apis/platform-chain-p-chain-api#platform-getpendingvalidators) and see that the node is now in the pending validator set for the Primary Network. This time, we specify the subnet ID:

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.getPendingValidators",
    "params": {"subnetID":"nTd2Q2nTLp8M9qv2VKHMdvYhtNWX7aTPa4SMEK7x7yJHbcWvr"},
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

The response should include the node we just added:

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "validators": [
            {
                "nodeID": "NodeID-LMUue2dBBRWdDbPL4Yx47Ps31noeewJji",
                "startTime":1584042912,
                "endTime":1584121156,
                "weight": "1"
            }
        ]
    },
    "id": 1
}
```

When the time reaches `1584042912`, this node will start validating this Subnet. When it reaches `1584121156`, this node will stop validating this Subnet.

### Whitelisting the Subnet

Now that the node has been added as a validator of the subnet, let’s add it to the whitelist of subnets. The whitelist prevents the node from validating a subnet unintentionally.

To whitelist the subnet, restart the node and add the parameter `--whitelisted-subnets` with a comma separated list of subnets to whitelist.

The full command is:

`./build/avalanchego --whitelisted-subnets=nTd2Q2nTLp8M9qv2VKHMdvYhtNWX7aTPa4SMEK7x7yJHbcWvr`

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTk3MTEzNjAyMywxNDU2NDc5MTg5LC0xND
MwMDQ3MzEzLDQwNTEzNDMwNSwtOTYxMTQxOTMyLDIxNDk0OTAx
MywxMjc1NDU4MDcxLDkxODE2MDUyNCwyMDkyMDg5MjA4LC0zMz
A1NDM1OTMsLTI2MDkzNzE1MCwtMTc1MjAzNjM1Myw3OTM5OTY3
NTQsNjM2NTM1NDUwXX0=
-->