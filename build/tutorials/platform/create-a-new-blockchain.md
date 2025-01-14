# 创建区块链

## 简介

Avalanche的核心特征之一就是创建新区块链的能力。Avalanche目前支持创建Avalanche虚拟机[Avalanche Virtual Machine \(AVM\)](../../avalanchego-apis/exchange-chain-x-chain-api.md)和Timestamp VM(时间戳虚拟机)的新实例。

在本教程中，我们将通过创建一个新的AVM实例来创建一个区块链。

### 先决条件

你需要一个正在运行的节点、该节点上的用户，以及由该用户控制的地址中的一些AVAX。全部教程可参见[Run an Avalanche Node](../../get-started.md)。

接下来，您需要让您的节点成为主网[Primary Network](http://support.avalabs.org/en/articles/4135650-what-is-the-primary-network)上的验证程序。教程参见[Add a Validator](../nodes-and-staking/add-a-validator.md)。建议通过API调用[with API calls](../nodes-and-staking/add-a-validator.md#add-a-validator-with-api-calls)进行此操作，因为在本教程的其余部分中，您将以这种方式与节点进行交互。

## 创建子网

每个区块链都仅通过一个子网[subnet](../../../learn/platform-overview/#subnets)进行验证。创建区块链之前，您需要一个子网来对它进行验证。如果有足够的控制密钥，也可以使用既有的子网。

创建子网
{% page-ref page="create-a-subnet.md" %}

### 向子网添加验证程序

子网需要验证程序来验证区块链。

确保用于验证区块链的子网中至少含有 `snow-sample-size`的验证程序。\(`snow-sample-size`是启动节点时的命令行参数[command-line arguments](../../references/command-line-interface.md)之一。默认值为20。\)

### 创建初始数据

每个区块链在创建时都有一些初始状态。每个虚拟机都有一个名为`buildGenesis`的静态API方法，该方法接收区块链初始状态的JSON形式，并返回该状态的字节形式。\(某些虚拟机并非如此，比如Platform VM，因为我们不允许创建新实例。\)

[AVM’s documentation](../../avalanchego-apis/exchange-chain-x-chain-api.md)指定了[`avm.buildGenesis`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-buildgenesis) 的参数，如下所示：

```cpp
{
"genesisData":
    {
        "assetAlias1": {               // Each object defines an asset
            "name": "human readable name",
            "symbol":"AVAL",           // Symbol is between 0 and 4 characters
            "initialState": {
                "fixedCap" : [         // Choose the asset type.
                    {                  // Can be "fixedCap", "variableCap"
                        "amount":1000, // At genesis, address A has
                        "address":"A"  // 1000 units of asset
                    },
                    {
                        "amount":5000, // At genesis, address B has
                        "address":"B"  // 1000 units of asset
                    },
                    ...                // Can have many initial holders
                ]
            }
        },
        "assetAliasCanBeAnythingUnique": { // Asset alias can be used in place of assetID in calls
            "name": "human readable name", // names need not be unique
            "symbol": "AVAL",              // symbols need not be unique
            "initialState": {
                "variableCap" : [          // No units of the asset exist at genesis
                    {
                        "minters": [       // The signature of A or B can mint more of
                            "A",           // the asset.
                            "B"
                        ],
                        "threshold":1
                    },
                    {
                        "minters": [       // The signatures of 2 of A, B and C can mint
                            "A",           // more of the asset
                            "B",
                            "C"
                        ],
                        "threshold":2
                    },
                    ...                    // Can have many minter sets
                ]
            }
        },
        ...                                // Can list more assets
    }
}
```

要创建初始状态的字节形式，请调用[`avm.buildGenesis`](../../avalanchego-apis/exchange-chain-x-chain-api.md#avm-buildgenesis)。调用示例如下。注意，这个调用的对象是AVM的静态API端点`/ext/vm/avm`。

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "id"     : 1,
    "method" : "avm.buildGenesis",
    "params" : {
        "genesisData": {
            "asset1": {
                "name": "myFixedCapAsset",
                "symbol":"MFCA",
                "initialState": {
                    "fixedCap" : [
                        {
                            "amount":100000,
                            "address": "8UeduLccQuSmYiY3fGQEyotM9uXxoHoQQ"
                        },
                        {
                            "amount":100000,
                            "address": "AgVkHvvDShLumJrzXzkwuHa7rYpewj9Kg"
                        },
                        {
                            "amount":50000,
                            "address": "AwBDGsUwNdXgVc8XG2E8A8dL3bkoVbkL9"
                        },
                        {
                            "amount":50000,
                            "address": "AATN8YjgmFjC2jQRq45sEeGcBFXNYPcM8"
                        }
                    ]
                }
            },
            "asset2": {
                "name": "myVarCapAsset",
                "symbol":"MVCA",
                "initialState": {
                    "variableCap" : [
                        {
                            "minters": [
                                "AATN8YjgmFjC2jQRq45sEeGcBFXNYPcM8",
                                "FNqMDYafoDVYQ2o4a7Zd9maJAxcUEieQb"
                            ],
                            "threshold":1
                        },
                        {
                            "minters": [
                                "JJSiKQfha9Z2TiMxBZ8XdW9F6KFw8aKS4",
                                "7jJHY1vZL6AAbCFb97KMLY8nqMQVyd5JG",
                                "58pM5cEf1wMSncPdCwtQ8tbHs2xdMA4eo"
                            ],
                            "threshold":2
                        }
                    ]
                }
            }
        }
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/vm/avm
```

返回区块链初始状态的字节形式：

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "bytes": "111TNWzUtHKoSvxohjyfEwE2X228ZDGBngZ4mdMUVMnVnjtnawW1b1zbAhzyAM1v6d7ECNj6DXsT7qDmhSEf3DWgXRj7ECwBX36ZXFc9tWVB2qHURoUfdDvFsBeSRqatCmj76eZQMGZDgBFRNijRhPNKUap7bCeKpHDtuCZc4YpPkd4mR84dLL2AL1b4K46eirWKMaFVjA5btYS4DnyUx5cLpAq3d35kEdNdU5zH3rTU18S4TxYV8voMPcLCTZ3h4zRsM5jW1cUzjWVvKg7uYS2oR9qXRFcgy1gwNTFZGstySuvSF7MZeZF4zSdNgC4rbY9H94RVhqe8rW7MXqMSZB6vBTB2BpgF6tNFehmYxEXwjaKRrimX91utvZe9YjgGbDr8XHsXCnXXg4ZDCjapCy4HmmRUtUoAduGNBdGVMiwE9WvVbpMFFcNfgDXGz9NiatgSnkxQALTHvGXXm8bn4CoLFzKnAtq3KwiWqHmV3GjFYeUm3m8Zee9VDfZAvDsha51acxfto1htstxYu66DWpT36YT18WSbxibZcKXa7gZrrsCwyzid8CCWw79DbaLCUiq9u47VqofG1kgxwuuyHb8NVnTgRTkQASSbj232fyG7YeX4mAvZY7a7K7yfSyzJaXdUdR7aLeCdLP6mbFDqUMrN6YEkU2X8d4Ck3T"
    },
    "id": 1
}
```

## 创建区块链

现在，让我们创建一个新的区块链。为此，调用[`platform.createBlockchain`](../../avalanchego-apis/platform-chain-p-chain-api.md#platform-createblockchain)。调用示例如下。必须更改用于验证区块链的子网的`subnetID`，并提供一个控制着足够子网控制密钥的用户名`username`。提醒一下，您可以通过调用[`platform.getSubnets`](../../avalanchego-apis/platform-chain-p-chain-api.md#platform-getsubnets)来确定子网的阈值和控制密钥。

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "platform.createBlockchain",
    "params" : {
        "subnetID": "KL1e8io1Zi2kr8cTXxvi321pAzfQuUa8tmBfadqpf9K2dc2TT",
        "vmID":"avm",
        "name":"My new AVM",
        "genesisData": "111TNWzUtHKoSvxohjyfEwE2X228ZDGBngZ4mdMUVMnVnjtnawW1b1zbAhzyAM1v6d7ECNj6DXsT7qDmhSEf3DWgXRj7ECwBX36ZXFc9tWVB2qHURoUfdDvFsBeSRqatCmj76eZQMGZDgBFRNijRhPNKUap7bCeKpHDtuCZc4YpPkd4mR84dLL2AL1b4K46eirWKMaFVjA5btYS4DnyUx5cLpAq3d35kEdNdU5zH3rTU18S4TxYV8voMPcLCTZ3h4zRsM5jW1cUzjWVvKg7uYS2oR9qXRFcgy1gwNTFZGstySuvSF7MZeZF4zSdNgC4rbY9H94RVhqe8rW7MXqMSZB6vBTB2BpgF6tNFehmYxEXwjaKRrimX91utvZe9YjgGbDr8XHsXCnXXg4ZDCjapCy4HmmRUtUoAduGNBdGVMiwE9WvVbpMFFcNfgDXGz9NiatgSnkxQALTHvGXXm8bn4CoLFzKnAtq3KwiWqHmV3GjFYeUm3m8Zee9VDfZAvDsha51acxfto1htstxYu66DWpT36YT18WSbxibZcKXa7gZrrsCwyzid8CCWw79DbaLCUiq9u47VqofG1kgxwuuyHb8NVnTgRTkQASSbj232fyG7YeX4mAvZY7a7K7yfSyzJaXdUdR7aLeCdLP6mbFDqUMrN6YEkU2X8d4Ck3T",
        "username":"USERNAME",
        "password":"PASSWORD"
    },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

响应包含交易ID:

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "txID": "xAd5n5PQFV6RRo8UgH54Gf5tJs8oQdctQS2ygp5F2dKZDckYH",
        "changeAddr": "P-avax103y30cxeulkjfe3kwfnpt432ylmnxux8r73r8u"
    },
    "id": 1
}
```

### 验证成功

几秒种后，创建区块链的交易就会被接受，区块链创建成功\(假设请求格式正确，等等\)。

调用[`platform.getBlockchains`](../../avalanchego-apis/platform-chain-p-chain-api.md#platform-getblockchains)进行查看。这将转到一个所有现有区块链的列表。

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"platform.getBlockchains",
    "params" :{}
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/P
```

这一响应确认区块链已创建：

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "blockchains": [
            {
                "id": "AXerNQX7voY2AABaRdTAyXcawBURBR6thPRJp43LtPpZZi6Qz",
                "name": "X-Chain",
                "subnetID": "11111111111111111111111111111111LpoYY",
                "vmID": "jvYyfQTxGMJLuGWa55kdP2p2zSUYsQ5Raupu4TW34ZAUBAbtq"
            },
            {
                "id": "tZGm6RCkeGpVETUTp11DW3UYFZmm69zfqxchpHrSF7wgy8rmw",
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
                "id": "zpFTwJwzPh3b9N6Ahccy4fXdJFHJJdhGah5z731J6ZspcYKpK",
                "name": "My new AVM",
                "subnetID": "KL1e8io1Zi2kr8cTXxvi321pAzfQuUa8tmBfadqpf9K2dc2TT",
                "vmID": "jvYyfQTxGMJLuGWa55kdP2p2zSUYsQ5Raupu4TW34ZAUBAbtq"
            }
        ]
    },
    "id": 1
}
```

### 与新区块链进行交互

您可以与这个新的 AVM 实例进行交互，就像与[X-Chain](../../../learn/platform-overview/#exchange-chain-x-chain)进行交互一样。但有两个细微差别：

* 区块链的API端点为`127.0.0.1:9650/ext/bc/zpFTwJwzPh3b9N6Ahccy4fXdJFHJJdhGah5z731J6ZspcYKpK`.
* 地址前缀是`zpFTwJwzPh3b9N6Ahccy4fXdJFHJJdhGah5z731J6ZspcYKpK-` 而不是 `X-`.

在初始数据中，我们指定地址`8UeduLccQuSmYiY3fGQEyotM9uXxoHoQQ`有100,000单位的资产，别名`asset1`。我们来验证一下：

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avm.getBalance",
    "params" :{
        "address":"zpFTwJwzPh3b9N6Ahccy4fXdJFHJJdhGah5z731J6ZspcYKpK-8UeduLccQuSmYiY3fGQEyotM9uXxoHoQQ",
        "assetID":"asset1"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/zpFTwJwzPh3b9N6Ahccy4fXdJFHJJdhGah5z731J6ZspcYKpK

```json
{
    "jsonrpc": "2.0",
    "result": {
        "balance": "100000"
    },
    "id": 1
}
```

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE0ODI5Njk4NDMsMTA4ODM5MjgwMiwxNT
kwNDI4ODM2XX0=
-->