---
说明: >-
  此页面列出了已弃用的API方法、参数和响应,将在未来的版本中删除或修改。
---

# 已弃用的API调用
## P链description: >-
  This page lists API methods, arguments and responses that are deprecated and
  will be removed or modified in a future release.
---

# Deprecated API Calls

## P-Chain API

### `getCurrentValidators`

在In v1.0.0版本中，签名为, the signature was:

```cpp
platform.getCurrentValidators({subnetID: string}) ->
{
    validators: []{
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
        connected: boolean
    },
    delegators: []{
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
```

在后来的版本中，签名如下。请注意，每个验证器都包含其委托器的列表。请查看下一个注释了解最新操作。In later versions, the signature was as follows. Note that each validator contains a list of its delegators. Please see the next note for current behavior.

```cpp
platform.getCurrentValidators({subnetID: string}) ->
{
    validators: []{
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
        connected: boolean,
        delegators: []{
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
    },
    delegators: []{
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
```

从1.0.6版本开始，顶部的`delegators`字段被删除了。现在的签名是Since v1.0.6, top level `delegators` field is removed. The signature is now:

```cpp
platform.getCurrentValidators({subnetID: string}) ->
{
    validators: []{
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
        connected: boolean,
        delegators: []{
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

### `getTxStatus`

在1.0.4版本之前, 签名为Before v1.0.4, the signature was:

```cpp
platform.getTxStatus({txID: string} -> status: string
```

v1.0.4版本添加了一个参数 added an argument `includeReason`。如果显示为. If `false`或未提供，该方法的响应与之前相同。如果显示为`true`，该方法的响应具有以下新格式 or not provided, this method's response was the same as before. If `true`, this method's response had this new format:

```cpp
{
  status: string,
  reason: string //optional
}
```

其中Where `reason`是丢弃事务的原因。`reason`只在 is the reason the transaction was dropped. `reason` is only present if `status`为 is `"Dropped"`时出现。

从1.0.6版本开始，`includeReason`参数被忽略，并且这个方法的响应总是以新的格式。
.

Since v1.0.6, the `includeReason` argument is ignored, and this method's response is always in the new format.

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTY5NjEwOTAwMSwtMTg0NDc3OTk0MSwtMT
UxNjUyNDQ1MV19
-->