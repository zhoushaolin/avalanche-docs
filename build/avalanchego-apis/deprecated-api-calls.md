---
说明: >-
此页面列出了已弃用的API方法、参数和响应,

将在未来的版本中删除或修改。
---

# Deprecated API Calls

## P-Chain API

### `getCurrentValidators`

In v1.0.0, the signature was:

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

In later versions, the signature was as follows. Note that each validator contains a list of its delegators. Please see the next note for current behavior.

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

Since v1.0.6, top level `delegators` field is removed. The signature is now:

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

Before v1.0.4, the signature was:

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
eyJoaXN0b3J5IjpbLTE1ODA1OTQ4MTZdfQ==
-->