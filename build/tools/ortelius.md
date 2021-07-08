---

描述:“这个API允许客户端与Ortelius雪崩索引器进行交互。”  
---

# Ortelius API

## Ortelius API

### 格式

该API通过使用URL查询参数来使用GET HTTP请求，并返回JSON数据。

### 版本控制

从版本2开始，API路径将以版本标记作为前缀，例如。`http://localhost:8080/v2`。

该API的当前版本是版本2。[Legacy API](ortelius.md#legacy-api)文档中有关于使用v1 API的信息。

### 数据类型

除了整数、字符串和布尔值外，整个API还使用了以下数据类型:

| 名称 | 描述 | 示例 |
| :--- | :--- | :--- |
| `id` | 一种CB58编码的对象标识符，如链、交易或资产ID | `2oYMBNV4eNHyqk2fjjV5nVQLDbtmNJzq5s3qs3Lo6ftnC6FByM` |
| `address` | 一个bech-32编码的地址 | `fuji1wycv8n7d2fg9aq6unp23pnj4q0arv03ysya8jw` |
| `datetime` |Unix时间戳整数形式或RFC3339格式化字符串形式 | `1599696000`, `2020-09-10T00:00:00Z` |

### 参数列表

列出资源的所有端点都接受以下参数:

| 名称 | 类型 | 描述 | 默认值 | 最大值 |
| :--- | :--- | :--- | :--- | :--- |
| `limit` | `int` | 要返回的项目的最大数目 | `500` | `500` |
| `offset` | `int` | 要跳过的项目数 | `0` | 没有 |
| `query` | `string` | 用于过滤项的ID前缀| 没有 | 没有 |
| `startTime` | `datetime` | 对在给定时间或之后创建的项目的限制 | `0` | 现在 |
| `endTime` | `datetime` | 对在给定时间或之前创建的项目的限制| 现在 | 现在 |

## 可用端点

### 概述

API的根给出了被索引的活动Avalanche网络的常量的概述。

**参数个数**

没有

**示例调用**

```text
curl "http://localhost:8080/v2"
```

**示例响应**

```javascript
{
  "network_id": 1,
  "chains": {
    "11111111111111111111111111111111LpoYY": {
      "chainID": "11111111111111111111111111111111LpoYY",
      "chainAlias": "p",
      "vm": "pvm",
      "avaxAssetID": "FvwEAhmxKfeiG8SnEvq42hc6whRyY3EFYAvebMqDNDGCgxN5Z",
      "networkID": 1
    },
    "2oYMBNV4eNHyqk2fjjV5nVQLDbtmNJzq5s3qs3Lo6ftnC6FByM": {
      "chainID": "2oYMBNV4eNHyqk2fjjV5nVQLDbtmNJzq5s3qs3Lo6ftnC6FByM",
      "chainAlias": "x",
      "vm": "avm",
      "avaxAssetID": "FvwEAhmxKfeiG8SnEvq42hc6whRyY3EFYAvebMqDNDGCgxN5Z",
      "networkID": 1
    }
  }
}
```

### 搜索

通过其ID找到一个地址或交易。

**参数个数**

| 名称 | 类型 | 描述 | 默认值 | 最大值 |
| :--- | :--- | :--- | :--- | :--- |
| `query` | `string` | 用于过滤项的ID前缀| 没有 | 没有 |

**示例调用**

```text
curl "http://localhost:8080/v2/search?query=2jEugPDFN89KXLEXtf5"
```

**示例响应**

```javascript
{
  "count": 1,
  "results": [
    {
      "type": "transaction",
      "data": {
        "id": "2jEugPDFN89KXLEXtf5oKp5spsJawTht2zP4kKJjkQwwRsDdLX",
        "chainID": "11111111111111111111111111111111LpoYY",
        "type": "add_validator",
        "inputs": [
          {
            "output": {
              "id": "G2Jq9fj6atW1jvJDTXJKHSkMhRWdrsFuafPpR98DK3izZdfqT",
              "transactionID": "11111111111111111111111111111111LpoYY",
              "outputIndex": 14025,
              "assetID": "FvwEAhmxKfeiG8SnEvq42hc6whRyY3EFYAvebMqDNDGCgxN5Z",
              "outputType": 7,
              "amount": "2000000000000",
              "locktime": 0,
              "threshold": 1,
              "addresses": [
                "avax14q43wu6wp8fs745dt6y5s0a02vx57ypq4xc5s3"
              ],
              "timestamp": "2020-09-10T00:00:00Z",
              "redeemingTransactionID": "2jEugPDFN89KXLEXtf5oKp5spsJawTht2zP4kKJjkQwwRsDdLX"
            },
            "credentials": [
              {
                "address": "avax14q43wu6wp8fs745dt6y5s0a02vx57ypq4xc5s3",
                "public_key": "AgSmTeCLGsNhKvSbRIi01jswlr2fV+C/tv3v86Ty4eDQ",
                "signature": "Ms5KquahoTfLGeIl5s6iP5r1fj15lm5MmrMahu8X7L0m5UTyRBRmcXnniURFaJP6X8dCL9f46t8zYawXscdgkQE="
              }
            ]
          }
        ],
        "outputs": [
          {
            "id": "U7M4jk3y7KGWPmSoeS4WhBX6qNHGtkDtQ5dSzYiaw4rmZ92yE",
            "transactionID": "2jEugPDFN89KXLEXtf5oKp5spsJawTht2zP4kKJjkQwwRsDdLX",
            "outputIndex": 0,
            "assetID": "FvwEAhmxKfeiG8SnEvq42hc6whRyY3EFYAvebMqDNDGCgxN5Z",
            "outputType": 7,
            "amount": "2000000000000",
            "locktime": 0,
            "threshold": 1,
            "addresses": [
              "avax14q43wu6wp8fs745dt6y5s0a02vx57ypq4xc5s3"
            ],
            "timestamp": "2020-10-10T07:09:44Z",
            "redeemingTransactionID": ""
          }
        ],
        "memo": "AAAAAA==",
        "inputTotals": {
          "FvwEAhmxKfeiG8SnEvq42hc6whRyY3EFYAvebMqDNDGCgxN5Z": "2000000000000"
        },
        "outputTotals": {
          "FvwEAhmxKfeiG8SnEvq42hc6whRyY3EFYAvebMqDNDGCgxN5Z": "2000000000000"
        },
        "reusedAddressTotals": null,
        "timestamp": "2020-10-10T07:09:44Z",
        "txFee": 0,
        "genesis": false
      },
      "score": 0
    }
  ]
}
```

### 合计

计算一段时间内的总交易数据。

**参数个数**

| 名称 | 类型 | 描述 | 默认值 | 最大值 |
| :--- | :--- | :--- | :--- | :--- |
| `chainID` | `id` | 用于过滤结果的链ID。可以提供多次。 | 没有 | 没有 |
| `assetID` | `id` | 用于过滤结果的资产ID。 | 没有 | 没有 |

**示例调用**

```text
curl "http://localhost:8080/v2/aggregates?startTime=2020-09-21T00:00:00Z&endTime=2020-10-21T00:00:00Z"
```

**示例响应**

```javascript
{
  "startTime": "2020-09-21T00:00:00Z",
  "endTime": "2020-10-21T00:00:00Z",
  "aggregates": {
    "startTime": "2020-09-21T00:00:00Z",
    "endTime": "2020-10-21T00:00:00Z",
    "transactionVolume": "1652211194850792239",
    "transactionCount": 135966,
    "addressCount": 19567,
    "outputCount": 283221,
    "assetCount": 180
  }
}
```

### Tx费用总计

AVAX 总计 tx费用

**示例调用**

```text
curl "http://localhost:8080/v2/txfeeAggregates?startTime=2020-09-21T00:00:00Z&endTime=2020-10-21T00:00:00Z"
```

**示例响应**

```javascript
{
  "aggregates": {
    "startTime": "2020-09-21T00:00:00Z",
    "endTime": "2020-10-21T00:00:00Z",
    "txfee": "134818000000"
  },
  "startTime": "2020-09-21T00:00:00Z",
  "endTime": "2020-10-21T00:00:00Z"
}
```

### 地址的链

用地址所在的链进行响应。

**参数个数**

| 名称 | 类型 | 描述 | 默认值 | 最大值 |
| :--- | :--- | :--- | :--- | :--- |
| `address` | `address` | 用于过滤结果的地址。可以提供多次。 | 没有 | 没有 |

**示例调用**

```text
curl "http://localhost:8080/v2/addressChains?address=X-fujiABC"
```

**示例响应**

```javascript
{
  "addressChains": {
    "avax14q43wu6wp8fs745dt6y5s0a02vx57ypq4xc5s3": [
      "11111111111111111111111111111111LpoYY"
    ],
    "avax1y8cyrzn2kg4udccs5d625gkac7a99pe452cy5u": [
      "11111111111111111111111111111111LpoYY",
      "2oYMBNV4eNHyqk2fjjV5nVQLDbtmNJzq5s3qs3Lo6ftnC6FByM"
    ]
  }
}
```

### 交易列表

从网络上查找已确认的交易。

**参数个数**

| 名称 | 类型 | 描述 | Default | Max |
| :--- | :--- | :--- | :--- | :--- |
| `chainID` | `id` | 用于过滤结果的链ID。可以提供多次。| 没有 | 没有 |
| `assetID` | `id` | 用于过滤结果的资产ID。 | 没有 | 没有 |
| `address` | `address` | 用于过滤结果的地址。可以提供多次。| 没有 | 没有 |
| `disableGenesis` | `bool` | 如果为true，则不返回Genesis顶点的数据。 | 真的 | N/A |
| `sort` | `string` | 排序结果的方法。可能是`timestamp-asc`或`timestamp-desc`。| `timestamp-asc` | N/A |

**示例调用**

```bash
curl "http://localhost:8080/v2/transactions?limit=1&chainID=11111111111111111111111111111111LpoYY&offset=100"
```

**示例响应**

```javascript
{
  "startTime": "0001-01-01T00:00:00Z",
  "endTime": "2020-11-16T04:18:07Z",
  "transactions": [
    {
      "id": "2jEugPDFN89KXLEXtf5oKp5spsJawTht2zP4kKJjkQwwRsDdLX",
      "chainID": "11111111111111111111111111111111LpoYY",
      "type": "add_validator",
      "inputs": [
        {
          "output": {
            "id": "G2Jq9fj6atW1jvJDTXJKHSkMhRWdrsFuafPpR98DK3izZdfqT",
            "transactionID": "11111111111111111111111111111111LpoYY",
            "outputIndex": 14025,
            "assetID": "FvwEAhmxKfeiG8SnEvq42hc6whRyY3EFYAvebMqDNDGCgxN5Z",
            "outputType": 7,
            "amount": "2000000000000",
            "locktime": 0,
            "threshold": 1,
            "addresses": [
              "avax14q43wu6wp8fs745dt6y5s0a02vx57ypq4xc5s3"
            ],
            "timestamp": "2020-09-10T00:00:00Z",
            "redeemingTransactionID": "2jEugPDFN89KXLEXtf5oKp5spsJawTht2zP4kKJjkQwwRsDdLX"
          },
          "credentials": [
            {
              "address": "avax14q43wu6wp8fs745dt6y5s0a02vx57ypq4xc5s3",
              "public_key": "AgSmTeCLGsNhKvSbRIi01jswlr2fV+C/tv3v86Ty4eDQ",
              "signature": "Ms5KquahoTfLGeIl5s6iP5r1fj15lm5MmrMahu8X7L0m5UTyRBRmcXnniURFaJP6X8dCL9f46t8zYawXscdgkQE="
            }
          ]
        }
      ],
      "outputs": [
        {
          "id": "U7M4jk3y7KGWPmSoeS4WhBX6qNHGtkDtQ5dSzYiaw4rmZ92yE",
          "transactionID": "2jEugPDFN89KXLEXtf5oKp5spsJawTht2zP4kKJjkQwwRsDdLX",
          "outputIndex": 0,
          "assetID": "FvwEAhmxKfeiG8SnEvq42hc6whRyY3EFYAvebMqDNDGCgxN5Z",
          "outputType": 7,
          "amount": "2000000000000",
          "locktime": 0,
          "threshold": 1,
          "addresses": [
            "avax14q43wu6wp8fs745dt6y5s0a02vx57ypq4xc5s3"
          ],
          "timestamp": "2020-10-10T07:09:44Z",
          "redeemingTransactionID": ""
        }
      ],
      "memo": "AAAAAA==",
      "inputTotals": {
        "FvwEAhmxKfeiG8SnEvq42hc6whRyY3EFYAvebMqDNDGCgxN5Z": "2000000000000"
      },
      "outputTotals": {
        "FvwEAhmxKfeiG8SnEvq42hc6whRyY3EFYAvebMqDNDGCgxN5Z": "2000000000000"
      },
      "reusedAddressTotals": null,
      "timestamp": "2020-10-10T07:09:44Z",
      "txFee": 0,
      "genesis": false
    }
  ]
}
```

### 获取交易

通过其ID找到单个交易。

**示例调用**

```text
curl "http://localhost:8080/v2/transactions/2jEugPDFN89KXLEXtf5oKp5spsJawTht2zP4kKJjkQwwRsDdLX"
```

**示例响应**

```javascript
{
  "id": "2jEugPDFN89KXLEXtf5oKp5spsJawTht2zP4kKJjkQwwRsDdLX",
  "chainID": "11111111111111111111111111111111LpoYY",
  "type": "add_validator",
  "inputs": [
    {
      "output": {
        "id": "G2Jq9fj6atW1jvJDTXJKHSkMhRWdrsFuafPpR98DK3izZdfqT",
        "transactionID": "11111111111111111111111111111111LpoYY",
        "outputIndex": 14025,
        "assetID": "FvwEAhmxKfeiG8SnEvq42hc6whRyY3EFYAvebMqDNDGCgxN5Z",
        "outputType": 7,
        "amount": "2000000000000",
        "locktime": 0,
        "threshold": 1,
        "addresses": [
          "avax14q43wu6wp8fs745dt6y5s0a02vx57ypq4xc5s3"
        ],
        "timestamp": "2020-09-10T00:00:00Z",
        "redeemingTransactionID": "2jEugPDFN89KXLEXtf5oKp5spsJawTht2zP4kKJjkQwwRsDdLX"
      },
      "credentials": [
        {
          "address": "avax14q43wu6wp8fs745dt6y5s0a02vx57ypq4xc5s3",
          "public_key": "AgSmTeCLGsNhKvSbRIi01jswlr2fV+C/tv3v86Ty4eDQ",
          "signature": "Ms5KquahoTfLGeIl5s6iP5r1fj15lm5MmrMahu8X7L0m5UTyRBRmcXnniURFaJP6X8dCL9f46t8zYawXscdgkQE="
        }
      ]
    }
  ],
  "outputs": [
    {
      "id": "U7M4jk3y7KGWPmSoeS4WhBX6qNHGtkDtQ5dSzYiaw4rmZ92yE",
      "transactionID": "2jEugPDFN89KXLEXtf5oKp5spsJawTht2zP4kKJjkQwwRsDdLX",
      "outputIndex": 0,
      "assetID": "FvwEAhmxKfeiG8SnEvq42hc6whRyY3EFYAvebMqDNDGCgxN5Z",
      "outputType": 7,
      "amount": "2000000000000",
      "locktime": 0,
      "threshold": 1,
      "addresses": [
        "avax14q43wu6wp8fs745dt6y5s0a02vx57ypq4xc5s3"
      ],
      "timestamp": "2020-10-10T07:09:44Z",
      "redeemingTransactionID": ""
    }
  ],
  "memo": "AAAAAA==",
  "inputTotals": {
    "FvwEAhmxKfeiG8SnEvq42hc6whRyY3EFYAvebMqDNDGCgxN5Z": "2000000000000"
  },
  "outputTotals": {
    "FvwEAhmxKfeiG8SnEvq42hc6whRyY3EFYAvebMqDNDGCgxN5Z": "2000000000000"
  },
  "reusedAddressTotals": null,
  "timestamp": "2020-10-10T07:09:44Z",
  "txFee": 0,
  "genesis": false
}
```

### 地址列表

查找已确认交易中涉及的地址。

**参数个数**

| 名称 | 类型 | 描述 | 默认值 | 最大值 |
| :--- | :--- | :--- | :--- | :--- |
| `chainID` | `id` | 用于过滤结果的链ID。可以提供多次。 | 没有 | 没有 |
| `address` | `address` | 用于过滤结果的地址。可以提供多次。 | 没有 | 没有 |

**示例调用**

```text
curl "http://localhost:8080/v2/addresses?limit=1"
```

**示例响应**

```javascript
{
  "addresses": [
    {
      "address": "avax1y8cyrzn2kg4udccs5d625gkac7a99pe452cy5u",
      "publicKey": null,
      "assets": {
        "FvwEAhmxKfeiG8SnEvq42hc6whRyY3EFYAvebMqDNDGCgxN5Z": {
          "id": "FvwEAhmxKfeiG8SnEvq42hc6whRyY3EFYAvebMqDNDGCgxN5Z",
          "transactionCount": 2,
          "utxoCount": 17,
          "balance": "39561999999996",
          "totalReceived": "39561999999996",
          "totalSent": "0"
        }
      }
    }
  ]
}
```

### 获取地址

通过ID找到单个地址。

**示例调用**

```text
curl "http://localhost:8080/v2/addresses/avax1y8cyrzn2kg4udccs5d625gkac7a99pe452cy5u"
```

**示例响应**

```javascript
{
  "address": "avax1y8cyrzn2kg4udccs5d625gkac7a99pe452cy5u",
  "publicKey": null,
  "assets": {
    "FvwEAhmxKfeiG8SnEvq42hc6whRyY3EFYAvebMqDNDGCgxN5Z": {
      "id": "FvwEAhmxKfeiG8SnEvq42hc6whRyY3EFYAvebMqDNDGCgxN5Z",
      "transactionCount": 2,
      "utxoCount": 17,
      "balance": "39561999999996",
      "totalReceived": "39561999999996",
      "totalSent": "0"
    }
  }
}
```

### 资产列表

找到在x链上创建的资产。

**参数个数**

| 名称 | 类型 | 描述 | 默认值 | 最大值 |
| :--- | :--- | :--- | :--- | :--- |
| `enableAggregate` | 字符串 | 当提供值“分钟”、“小时”、“日”、“周”、“月”或“年”时，将包括关于资产的汇总数据。 | N/A | N/A |

**示例调用**

```text
curl "http://localhost:8080/v2/assets?limit=1&enableAggregate=minute"
```

**示例响应**

```javascript
{
  "assets": [
    {
      "id": "FvwEAhmxKfeiG8SnEvq42hc6whRyY3EFYAvebMqDNDGCgxN5Z",
      "chainID": "2oYMBNV4eNHyqk2fjjV5nVQLDbtmNJzq5s3qs3Lo6ftnC6FByM",
      "name": "Avalanche",
      "symbol": "AVAX",
      "alias": "AVAX",
      "currentSupply": "24509771588234718",
      "timestamp": "2020-09-10T00:00:00Z",
      "denomination": 9,
      "variableCap": 0,
      "aggregates": {
        "day": {
          "startTime": "2020-11-15T04:47:00Z",
          "endTime": "2020-11-16T04:47:00Z",
          "transactionVolume": "0",
          "transactionCount": 0,
          "addressCount": 0,
          "outputCount": 0,
          "assetCount": 0
        },
        "hour": {
          "startTime": "2020-11-16T03:47:00Z",
          "endTime": "2020-11-16T04:47:00Z",
          "transactionVolume": "0",
          "transactionCount": 0,
          "addressCount": 0,
          "outputCount": 0,
          "assetCount": 0
        },
        "minute": {
          "startTime": "2020-11-16T04:46:00Z",
          "endTime": "2020-11-16T04:47:00Z",
          "transactionVolume": "0",
          "transactionCount": 0,
          "addressCount": 0,
          "outputCount": 0,
          "assetCount": 0
        },
        "month": {
          "startTime": "2020-10-17T04:47:00Z",
          "endTime": "2020-11-16T04:47:00Z",
          "transactionVolume": "0",
          "transactionCount": 0,
          "addressCount": 0,
          "outputCount": 0,
          "assetCount": 0
        },
        "week": {
          "startTime": "2020-11-09T04:47:00Z",
          "endTime": "2020-11-16T04:47:00Z",
          "transactionVolume": "0",
          "transactionCount": 0,
          "addressCount": 0,
          "outputCount": 0,
          "assetCount": 0
        },
        "year": {
          "startTime": "2019-11-17T04:47:00Z",
          "endTime": "2020-11-16T04:47:00Z",
          "transactionVolume": "6637657099999996",
          "transactionCount": 1,
          "addressCount": 159,
          "outputCount": 1,
          "assetCount": 817
        }
      }
    }
  ]
}
```

### 获取资产

根据其ID找到单个资产。

**示例调用**

```text
curl "http://localhost:8080/v2/assets/FvwEAhmxKfeiG8SnEvq42hc6whRyY3EFYAvebMqDNDGCgxN5Z?enableAggregate=true"
```

**示例响应**

```javascript
{
  "id": "FvwEAhmxKfeiG8SnEvq42hc6whRyY3EFYAvebMqDNDGCgxN5Z",
  "chainID": "2oYMBNV4eNHyqk2fjjV5nVQLDbtmNJzq5s3qs3Lo6ftnC6FByM",
  "name": "Avalanche",
  "symbol": "AVAX",
  "alias": "AVAX",
  "currentSupply": "24509771588234718",
  "timestamp": "2020-09-10T00:00:00Z",
  "denomination": 9,
  "variableCap": 0,
  "aggregates": {
    "day": {
      "startTime": "2020-11-15T04:50:00Z",
      "endTime": "2020-11-16T04:50:00Z",
      "transactionVolume": "0",
      "transactionCount": 0,
      "addressCount": 0,
      "outputCount": 0,
      "assetCount": 0
    },
    "hour": {
      "startTime": "2020-11-16T03:50:00Z",
      "endTime": "2020-11-16T04:50:00Z",
      "transactionVolume": "0",
      "transactionCount": 0,
      "addressCount": 0,
      "outputCount": 0,
      "assetCount": 0
    },
    "minute": {
      "startTime": "2020-11-16T04:49:00Z",
      "endTime": "2020-11-16T04:50:00Z",
      "transactionVolume": "0",
      "transactionCount": 0,
      "addressCount": 0,
      "outputCount": 0,
      "assetCount": 0
    },
    "month": {
      "startTime": "2020-10-17T04:50:00Z",
      "endTime": "2020-11-16T04:50:00Z",
      "transactionVolume": "0",
      "transactionCount": 0,
      "addressCount": 0,
      "outputCount": 0,
      "assetCount": 0
    },
    "week": {
      "startTime": "2020-11-09T04:50:00Z",
      "endTime": "2020-11-16T04:50:00Z",
      "transactionVolume": "0",
      "transactionCount": 0,
      "addressCount": 0,
      "outputCount": 0,
      "assetCount": 0
    },
    "year": {
      "startTime": "2019-11-17T04:50:00Z",
      "endTime": "2020-11-16T04:50:00Z",
      "transactionVolume": "6637657099999996",
      "transactionCount": 1,
      "addressCount": 159,
      "outputCount": 1,
      "assetCount": 817
    }
  }
}
```

### List Outputs

Find outputs that have been created by a transaction confirmed on the network.

**Params**

| Name | Type | Description | Default | Max |
| :--- | :--- | :--- | :--- | :--- |
| `chainID` | `id` | A chain ID to filter results by. May be supplied multiple times. | None | None |
| `address` | `address` | An address to filter results by. May be supplied multiple times. | None | None |
| `spent` | `bool` | If set, results will be filtered by whether they're spent \(true\) or unspent \(false\) | None | N/A |

**Example Call**

```text
curl "http://localhost:8080/v2/outputs?limit=1&spent=false"
```

**Example Response**

```javascript
{
  "outputs": [
    {
      "id": "114RMPhYM7do7cDX7KWSqFeLkbUXFrLKcqPL4GMdjTvemPzvc",
      "transactionID": "dhU8aMRrtMWvBWSh41aTxUbwArYootNUBcL3N3UJXVPL8H9ip",
      "outputIndex": 4,
      "assetID": "FvwEAhmxKfeiG8SnEvq42hc6whRyY3EFYAvebMqDNDGCgxN5Z",
      "outputType": 7,
      "amount": "2327176470588",
      "locktime": 0,
      "threshold": 1,
      "addresses": [
        "avax1y8cyrzn2kg4udccs5d625gkac7a99pe452cy5u"
      ],
      "timestamp": "2020-09-10T00:00:00Z",
      "redeemingTransactionID": ""
    }
  ]
}
```

### Get Output

Find a single output by its ID.

**Example Call**

```text
curl "http://localhost:8080/v2/outputs/114RMPhYM7do7cDX7KWSqFeLkbUXFrLKcqPL4GMdjTvemPzvc"
```

**Example Response**

```javascript
{
  "id": "114RMPhYM7do7cDX7KWSqFeLkbUXFrLKcqPL4GMdjTvemPzvc",
  "transactionID": "dhU8aMRrtMWvBWSh41aTxUbwArYootNUBcL3N3UJXVPL8H9ip",
  "outputIndex": 4,
  "assetID": "FvwEAhmxKfeiG8SnEvq42hc6whRyY3EFYAvebMqDNDGCgxN5Z",
  "outputType": 7,
  "amount": "2327176470588",
  "locktime": 0,
  "threshold": 1,
  "addresses": [
    "avax1y8cyrzn2kg4udccs5d625gkac7a99pe452cy5u"
  ],
  "timestamp": "2020-09-10T00:00:00Z",
  "redeemingTransactionID": ""
}
```

### Legacy API

Version 1 of the API was built to support only the X-chain, and it did not use a version prefix \(`/v1`\). It is available at the path `/x` off of the root, which is the Overview endpoint for only the X-chain:

**Example Call**

```text
curl "http://localhost:8080/x"
```

**Example Response**

```javascript
{
  "networkID": 1,
  "vm": "avm",
  "chainAlias": "x",
  "chainID": "2oYMBNV4eNHyqk2fjjV5nVQLDbtmNJzq5s3qs3Lo6ftnC6FByM",
  "avaxAssetID": "FvwEAhmxKfeiG8SnEvq42hc6whRyY3EFYAvebMqDNDGCgxN5Z"
}
```

The legacy API supports the same endpoints and parameters as version 2, except the chainID parameter for all endpoints defaults to the X-chain ID.

<!--stackedit_data:
eyJoaXN0b3J5IjpbODMyOTE5OTY2LDE0OTI3NDAwMjksLTE2OD
QwNjIwODgsMTg5MjY4MTUwNywtMTU4Mjk2NTA1MywxODg3NTQ2
NjQxLDIxMzI2MDQ2MDYsMjU5MzUxODY2LDExMzE2ODEyNTMsMT
M3NDY4ODM5XX0=
-->