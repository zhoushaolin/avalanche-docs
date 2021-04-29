---
说明: >-
  此页面列出了已弃用的API方法、参数和响应,

将在未来的版本中删除或修改。
---

# 已弃用的API调用
## P链 API

### `getCurrentValidators`

在1.0.0版本中，签名为:

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

在后来的版本中，签名如下。请注意，每个验证器都包含其委托器的列表。请查看下一个注释了解最新操作。

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

从1.0.6版本开始，顶部的`delegators`字段被删除了。现在的签名是:

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

在1.0.4版本之前, 签名为:

```cpp
platform.getTxStatus({txID: string} -> status: string
```

v1.0.4 added an argument `includeReason`. If `false` or not provided, this method's response was the same as before. If `true`, this method's response had this new format:

```cpp
{
  status: string,
  reason: string //optional
}
```

Where `reason` is the reason the transaction was dropped. `reason` is only present if `status` is `"Dropped"`.

Since v1.0.6, the `includeReason` argument is ignored, and this method's response is always in the new format.

<!--stackedit_data:
eyJoaXN0b3J5IjpbMTg2NTQ4MTAzXX0=
-->