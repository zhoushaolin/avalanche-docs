---
说明: >-
  此页面列出了已弃用的API方法、参数和响应,将在未来的版本中删除或修改。
---

# 已弃用的API调用

## P链API

### `getCurrentValidators`

在In v1.0.0版本中，签名为:

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

v1.0.4版本添加了一个参数 `includeReason`。如果显示为`false`或未提供，该方法的响应与之前相同。如果显示为`true`，该方法的响应具有以下新格式:

```cpp
{
  status: string,
  reason: string //optional
}
```

其中Where `reason`是丢弃事务的原因。`reason`只在`status`为 `"Dropped"`时出现。

从1.0.6版本开始，`includeReason`参数被忽略，并且这个方法的响应总是以新的格式。

<!--stackedit_data:
eyJoaXN0b3J5IjpbMTQzNzEyMTg4NywtMjI2OTI0NTI3LC0xOD
Q0Nzc5OTQxLC0xNTE2NTI0NDUxXX0=
-->