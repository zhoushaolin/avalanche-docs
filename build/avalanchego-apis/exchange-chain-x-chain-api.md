---
说明: X链是Avalanche 虚拟机(AVM)的一个实例
---

# 交换链\(X链\) API

[X-Chain](../../learn/platform-overview/#exchange-chain-x-chain)是Avalanche创建和交易资产的原生平台，是Avalanche虚拟机(AVM)的一个实例。这个API允许客户端在X链和AVM的其他实例上创建和交易资产。

## 格式

这个API使用`json 2.0` RPC格式。有关JSON RPC调用的更多信息，请参见这里[here](issuing-api-calls.md)。

## 端点

`/ext/bc/X` 与X链交互。

`/ext/bc/blockchainID`与其他AVM实例交互，其中`blockchainID`是运行AVM的区块链的ID。

## 方法

### avm.buildGenesis

此虚拟机起源状态由一个给定的JSON表示，创建代表该状态的字节。

#### **端点**

这个调用是针对AVM的静态API端点的:

`/ext/vm/avm`

注意:地址不应该包含链前缀\(即X-\)，因为这些前缀引用一个特定的链。

#### **签名**

```cpp
avm.buildGenesis({
    networkID: int,
    genesisData: JSON,
    encoding: string, //optional
}) -> {
    bytes: string,
    encoding: string,
}
```

Encoding指定用于任意字节的编码格式, 也就是说, 返回到起源字节。可以是“cb58”或“hex”, 默认为“cb58”。

`genesisData` 的格式如下:

```cpp
{
"genesisData" :
    {
        "assetAlias1": {               // Each object defines an asset
            "name": "human readable name",
            "symbol":"AVAL",           // Symbol is between 0 and 4 characters
            "initialState": {
                "fixedCap" : [         // Choose the asset type.
                    {                  // Can be "fixedCap", "variableCap", "limitedTransfer", "nonFungible"
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

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "id"     : 1,
    "method" : "avm.buildGenesis",
    "params" : {
        "networkId": 16,
        "genesisData": {
            "asset1": {
                "name": "myFixedCapAsset",
                "symbol":"MFCA",
                "initialState": {
                    "fixedCap" : [
                        {
                            "amount":100000,
                            "address": "avax13ery2kvdrkd2nkquvs892gl8hg7mq4a6ufnrn6"
                        },
                        {
                            "amount":100000,
                            "address": "avax1rvks3vpe4cm9yc0rrk8d5855nd6yxxutfc2h2r"
                        },
                        {
                            "amount":50000,
                            "address": "avax1ntj922dj4crc4pre4e0xt3dyj0t5rsw9uw0tus"
                        },
                        {
                            "amount":50000,
                            "address": "avax1yk0xzmqyyaxn26sqceuky2tc2fh2q327vcwvda"
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
                                "avax1kcfg6avc94ct3qh2mtdg47thsk8nrflnrgwjqr",
                                "avax14e2s22wxvf3c7309txxpqs0qe9tjwwtk0dme8e"
                            ],
                            "threshold":1
                        },
                        {
                            "minters": [
                                "avax1y8pveyn82gjyqr7kqzp72pqym6xlch9gt5grck",
                                "avax1c5cmm0gem70rd8dcnpel63apzfnfxye9kd4wwe",
                                "avax12euam2lwtwa8apvfdl700ckhg86euag2hlhmyw"
                            ],
                            "threshold":2
                        }
                    ]
                }
            }
        },
        "encoding": "hex"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/vm/avm
```

#### **响应示例**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "bytes": "0x0000000000010006617373657431000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f6d794669786564436170417373657400044d464341000000000100000000000000010000000700000000000186a10000000000000000000000010000000152b219bc1b9ab0a9f2e3f9216e4460bd5db8d153bfa57c3c",
        "encoding": "hex"
    },
    "id": 1
}
```

### avm.createAddress

创建一个由给定用户控制的新地址。

#### **签名**

```cpp
avm.createAddress({
    username: string,
    password: string
}) -> {address: string}
```

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "avm.createAddress",
    "params": {
        "username": "myUsername",
        "password": "myPassword"
    },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

#### **响应示例**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "address": "X-avax12c6n252g5v3w6a6v69f0mnnzwr77jxzr3q3u7d"
    },
    "id": 1
}
```

### avm.createFixedCapAsset

创造一个新的固定上限，同质化资产。在初始化时创建一个数量，然后不再创建更多。资产可以通过`avm.send`发送。

#### **签名**

```cpp
avm.createFixedCapAsset({
    name: string,
    symbol: string,
    denomination: int, //optional
    initialHolders: []{
        address: string,
        amount: int
    },
    from: []string, //optional
    changeAddr: string, //optional
    username: string,
    password: string
}) ->
{
    assetID: string,
    changeAddr: string
}
```

* `name` 是资产的可读名称, 不一定是独一无二的。
* `symbol` 是资产的速记符号, 0到4个字符, 不一定是独一无二的, 可以省略。
* `denomination` 确定该资产的余额如何在用户界面中显示。如果`denomination`为0，则该资产的100个单位显示为100。如果`denomination`为1100，则该资产的100个单位显示为10.0。如果`denomination`是2100，则该资产的100个单位显示为1.00，等等。默认值为0。
* `from` 是您要用于此操作的地址。如果省略，根据需要使用您的任何地址。
* `changeAddr` 是任何变化都会发送到的地址。如果省略，更改将被发送到用户控制的地址之一。
* `username`和`password`表示支付交易费用的用户。
* `initialHolders`中的每个元素指定`address`持有创世时资产的`amount`单位。
* `assetID`是新资产的ID。

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     : 1,
    "method" :"avm.createFixedCapAsset",
    "params" :{
        "name": "myFixedCapAsset",
        "symbol":"MFCA",
        "initialHolders": [
            {
                "address": "X-avax1s65kep4smpr9cnf6uh9cuuud4ndm2z4jguj3gp",
                "amount": 10000
            },
            {
                "address":"X-avax1y0h66sjk0rlnh9kppnfskwpw2tpcluzxh9png8",
                "amount":50000
            }
        ],
        "from":["X-avax1s65kep4smpr9cnf6uh9cuuud4ndm2z4jguj3gp"],
        "changeAddr":"X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8",
        "username":"myUsername",
        "password":"myPassword"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

#### **响应示例**

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "assetID":"ZiKfqRXCZgHLgZ4rxGU9Qbycdzuq5DRY4tdSNS9ku8kcNxNLD",
        "changeAddr":"X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8"
    }
}
```

### avm.mint

用[`avm.createVariableCapAsset`](exchange-chain-x-chain-api.md#avm-createvariablecapasset)创建的可变资产的铸币单位。

#### **签名**

```cpp
avm.mint({
    amount: int,
    assetID: string,
    to: string,
    from: []string, //optional
    changeAddr: string, //optional
    username: string,
    password: string
}) ->
{
    txID: string,
    changeAddr: string,
}
```

* `assetID`的`amount`单位数量将由`to`的地址创建并控制。
* `from` 是您要用于此操作的地址。如果省略，根据需要使用您的任何地址。
* `changeAddr`是任何更改都会发送到的地址。如果省略，更改将被发送到用户控制的地址之一。
* `username` 是支付交易费用的用户。`username` 必须持有密钥，以铸造更多的资产。也就是说，它必须至少为一个铸造器控制_threshold_密钥。
* `txID`是此交易的ID。
* `changeAddr` 是结果中发送任何更改的地址。

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     : 1,
    "method" :"avm.mint",
    "params" :{
        "amount":10000000,
        "assetID":"i1EqsthjiFTxunrj8WD2xFSrQ5p2siEKQacmCCB5qBFVqfSL2",
        "to":"X-avax1ap39w4a7fk0au083rrmnhc2pqk20yjt6s3gzkx",
        "from":["X-avax1s65kep4smpr9cnf6uh9cuuud4ndm2z4jguj3gp"],
        "changeAddr":"X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8",
        "username":"myUsername",
        "password":"myPassword"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

#### **响应示例**

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "txID":"2oGdPdfw2qcNUHeqjw8sU2hPVrFyNUTgn6A8HenDra7oLCDtja",
        "changeAddr": "X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8"
    }
}
```

### avm.createVariableCapAsset

创建一个新的可变上限，同质化资产, 初始化时资产的单位不存在, 铸造器可以使用`avm.mint`铸造代币。

#### **签名**

```cpp
avm.createVariableCapAsset({
    name: string,
    symbol: string,
    denomination: int, //optional
    minterSets: []{
        minters: []string,
        threshold: int
    },
    from: []string, //optional
    changeAddr: string, //optional
    username: string,
    password: string
}) ->
{
    assetID: string,
    changeAddr: string,
}
```

* `name` 是资产的可读名称, 不一定是独一无二的。
* `symbol` 是资产的速记符号, 0到4个字符之间, 不一定是独一无二的, 可以省略。
* `denomination` 确定该资产的余额如何在用户界面中显示。如果面值为0，该资产的100个单位显示为100。如果面值为1100，该资产的100单位显示为10.0。如果面值为2100，则该资产的100个单位显示为。100等。
* `minterSets` 是一个列表，其中每个元素指定`minters`中的地址的`threshold`可以通过签署一个铸币交易共同铸造更多的资产。
* `from` 是您要用于此操作的地址。如果省略，根据需要使用您的任何地址。
* `changeAddr` 是任何变化都会发送到的地址。如果省略，更改将被发送到用户控制的地址之一。
* `username` 支付交易费用的用户名。
* `assetID` 是新资产的ID。
* `changeAddr` 是结果中发送任何更改的地址。

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     : 1,
    "method" :"avm.createVariableCapAsset",
    "params" :{
        "name":"myVariableCapAsset",
        "symbol":"MFCA",
        "minterSets":[
            {
                "minters":[
                    "X-avax14q0p6y4yzweuugz9p080kapajwvac3ur755n7d"
                ],
                "threshold": 1
            },
            {
                "minters": [
                    "X-avax1fzyldr3mwn6lj7y46edhua6vr5ayx0ruuhezpv",
                    "X-avax1x5mrgxj0emysnnzyszamqxhq95t2kwcp9n3fy3",
                    "X-avax13zmrjvj75h3578rn3sfth8p64t2ll4gm4tv2rp"
                ],
                "threshold": 2
            }
        ],
        "from":["X-avax1s65kep4smpr9cnf6uh9cuuud4ndm2z4jguj3gp"],
        "changeAddr":"X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8",
        "username":"myUsername",
        "password":"myPassword"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

#### **响应示例**

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "assetID":"2QbZFE7J4MAny9iXHUwq8Pz8SpFhWk3maCw4SkinVPv6wPmAbK",
        "changeAddr":"X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8"
    }
}
```

### avm.createNFTAsset

创建一个新的非同质化资产, 初始化时资产的单位数量不存在, 铸造器可以使用`avm.mintNFT`来铸造该资产的单位。

#### **签名**

```cpp
avm.createNFTAsset({
    name: string,
    symbol: string,
    minterSets: []{
        minters: []string,
        threshold: int
    },
    from: []string, //optional
    changeAddr: string, //optional
    username: string,
    password: string
}) ->
 {
    assetID: string,
    changeAddr: string,
}
```

* `name` 是资产的可读名称, 不一定是独一无二的。
* `symbol` 是资产的速记符号, 0到4个字符之间, 不一定是独一无二的, 可以省略。
* `minterSets` 是一个列表，其中每个元素指定`minters`中的地址的`threshold`可以通过签署一个铸币交易共同铸造更多的资产。
* `from` 是您要用于此操作的地址。如果省略，根据需要使用您的任何地址。
* `changeAddr` 是地址有任何变化都会发送到, 如果省略，更改将被发送到用户控制的地址之一。
* `username` 支付交易费用。
* `assetID` 是新资产的ID。
* `changeAddr` 是结果中发送任何更改的地址。

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     : 1,
    "method" :"avm.createNFTAsset",
    "params" :{
        "name":"Coincert",
        "symbol":"TIXX",
        "minterSets":[
            {
                "minters":[
                    "X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8"
                ],
                "threshold": 1
            }
        ],
        "from": ["X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8"],
        "changeAddr": "X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8",
        "username":"myUsername",
        "password":"myPassword"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

#### **响应示例**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "assetID": "2KGdt2HpFKpTH5CtGZjYt5XPWs6Pv9DLoRBhiFfntbezdRvZWP",
        "changeAddr": "X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8"
    },
    "id": 1
}
```

### avm.mintNFT

使用[`avm.createNFTAsset`](exchange-chain-x-chain-api.md#avm-createnftasset)创建的不可替代令牌。

#### **签名**

```cpp
avm.mintNFT({
    assetID: string,
    payload: string,
    to: string,
    encoding: string, //optional
    from: []string, //optional
    changeAddr: string, //optional
    username: string,
    password: string
}) ->
{
    txID: string,
    changeAddr: string,
}
```

* `assetID` 是新创建的NFT资产的ID。
* `payload` 是最多1024字节的任意负载。它的编码格式由 `encoding`参数指定。
* `from` 是您要用于此操作的地址。如果省略，根据需要使用您的任何地址。
* `changeAddr` 是任何变化都会发送到的地址。如果省略，更改将被发送到用户控制的地址之一。
* `username` 是支付交易费用的用户。`username`必须持有密钥，以铸成更多的这一资产。也就是说，它必须至少控制一个铸造器的_threshold_密钥。
* `txID` 是此交易的ID。
* `changeAddr` 是结果中发送任何更改的地址。
* `encoding` 为有效负载参数使用的编码格式。可以是“cb58”或“hex”。默认为“cb58”。

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     : 1,
    "method" :"avm.mintNFT",
    "params" :{
        "assetID":"2KGdt2HpFKpTH5CtGZjYt5XPWs6Pv9DLoRBhiFfntbezdRvZWP",
        "payload":"2EWh72jYQvEJF9NLk",
        "to":"X-avax1ap39w4a7fk0au083rrmnhc2pqk20yjt6s3gzkx",
        "from":["X-avax1s65kep4smpr9cnf6uh9cuuud4ndm2z4jguj3gp"],
        "changeAddr":"X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8",
        "username":"myUsername",
        "password":"myPassword"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

#### **响应示例**

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "txID":"2oGdPdfw2qcNUHeqjw8sU2hPVrFyNUTgn6A8HenDra7oLCDtja",
        "changeAddr": "X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8"
    }
}
```

### avm.export

从X链发送一个非avax到P链或C链。调用此方法后，必须在C链上调用[`avax.import`](contract-chain-c-chain-api.md#avax-import)来完成传输。

#### **签名**

```cpp
avm.export({
    to: string,
    amount: int,
    assetID: string,
    from: []string, //optional
    changeAddr: string, //optional
    username: string,
    password: string,
}) ->
{
    txID: string,
    changeAddr: string,
}
```

* `to` 是资产被发送到的P链或C链的地址。
* `amount` 是要发送的资产数量。
* `assetID`被发送的资产的ID。
* `from`是您要用于此操作的地址。如果省略，根据需要使用您的任何地址。
* `changeAddr` 是地址有任何变化都会发送到。如果省略，更改将被发送到用户控制的地址之一。
* `username`是发送资产的用户名。
* `txID`是此交易的ID。
* `changeAddr` 是结果中发送任何更改的地址。

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avm.export",
    "params" :{
        "to":"C-avax1q9c6ltuxpsqz7ul8j0h0d0ha439qt70sr3x2m0",
        "amount": 500,
        "assetID": "2YmsQfMaCczE4mLG1DPYUnRURNGfhjj4qrqnLRR3LmZ3GxDWPt",
        "from":["X-avax1s65kep4smpr9cnf6uh9cuuud4ndm2z4jguj3gp"],
        "changeAddr":"X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8",
        "username":"myUsername",
        "password":"myPassword"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

#### **响应示例**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "txID": "2Eu16yNaepP57XrrJgjKGpiEDandpiGWW8xbUm6wcTYny3fejj",
        "changeAddr": "X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8"
    },
    "id": 1
}
```

### avm.exportAVAX

从X链发送AVAX到另一个链。调用此方法后，必须调用另一个链上的 `import`以完成传输。

#### **签名**

```cpp
avm.exportAVAX({
    to: string,
    amount: int,
    from: []string, //optional
    changeAddr: string, //optional
    username: string,
    password: string,
}) ->
{
    txID: string,
    changeAddr: string,
}
```

* `to` 是AVAX发送到的P-Chain地址。
* `amount` 是要发送的nAVAX的数量。
* `from` 是您要用于此操作的地址。如果省略，根据需要使用您的任何地址。
* `changeAddr` 是有任何变化都会发送到的地址。如果省略，更改将被发送到用户控制的地址之一。
* `username` 是发送AVAX的用户名。 
* `txID` 是此交易的ID。
* `changeAddr`是结果中发送任何更改的地址。
#### **Example Call**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avm.exportAVAX",
    "params" :{
        "to":"P-avax1q9c6ltuxpsqz7ul8j0h0d0ha439qt70sr3x2m0",
        "amount": 500,
        "from":["X-avax1s65kep4smpr9cnf6uh9cuuud4ndm2z4jguj3gp"],
        "changeAddr":"X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8",
        "username":"myUsername",
        "password":"myPassword"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

#### **响应示例**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "txID": "25VzbNzt3gi2vkE3Kr6H9KJeSR2tXkr8FsBCm3vARnB5foLVmx",
        "changeAddr": "X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8"
    },
    "id": 1
}
```

### avm.exportKey

获取控制给定地址的私钥。
返回的私钥可以通过[`avm.importKey`](exchange-chain-x-chain-api.md#avm-importkey)添加到用户。

#### **签名**

```cpp
avm.exportKey({
    username: string,
    password: string,
    address: string
}) -> {privateKey: string}
```

* `username` 必须控制 `address`.
* `privateKey` 是控制`address`的私钥的字符串表示形式。

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avm.exportKey",
    "params" :{
        "username":"myUsername",
        "password":"myPassword",
        "address":"X-avax1jggdngzc9l87rgurmfu0z0n0v4mxlqta0h3k6e"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

#### **响应示例**

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "privateKey":"PrivateKey-2w4XiXxPfQK4TypYqnohRL8DRNTz9cGiGmwQ1zmgEqD9c9KWLq"
    }
}
```

### avm.getAllBalances

获取由给定地址控制的所有资产的余额。

#### **签名**

```cpp
avm.getAllBalances({address:string}) -> {
    balances: []{
        asset: string,
        balance: int
    }
}
```

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     : 1,
    "method" :"avm.getAllBalances",
    "params" :{
        "address":"X-avax1c79e0dd0susp7dc8udq34jgk2yvve7haclsz5r"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

#### **响应示例**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "balances": [
            {
                "asset": "AVAX",
                "balance": "102"
            },
            {
                "asset": "2sdnziCz37Jov3QSNMXcFRGFJ1tgauaj6L7qfk7yUcRPfQMC79",
                "balance": "10000"
            }
        ]
    },
    "id": 1
}
```

### avm.getAssetDescription

获取有关资产的信息。

#### **签名**

```cpp
avm.getAssetDescription({assetID: string}) -> {
    assetId: string,
    name: string,
    symbol: string,
    denomination: int
}
```

* `assetID` 是资产的ID, 需要相关信息。 
* `name` 是资产的可读名称，不一定是唯一的名称。
* `symbol` 是资产的符号。
* `denomination` 确定该资产的余额如何在用户界面中显示。如果面值为0，该资产的100个单位显示为100。如果面值为1100，该资产的100单位显示为10.0。如果面值为2100，则该资产的100个单位显示为100, 等等。

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avm.getAssetDescription",
    "params" :{
        "assetID" :"2fombhL7aGPwj3KH4bfrmJwW6PVnMobf9Y2fn9GwxiAAJyFDbe"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

#### **响应示例**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "assetID": "2fombhL7aGPwj3KH4bfrmJwW6PVnMobf9Y2fn9GwxiAAJyFDbe",
        "name": "Avalanche",
        "symbol": "AVAX",
        "denomination": "9"
    },
    "id": 1
}`
```

### avm.getBalance

获取由给定地址控制的资产的余额。

#### **签名**

```cpp
avm.getBalance({
    address: string,
    assetID: string
}) -> {balance: int}
```

* `address` 资产所有者
* `assetID` 要求余额的资产的Id

#### **调用示例**

```cpp
curl -X POST --data '{
  "jsonrpc":"2.0",
  "id"     : 1,
  "method" :"avm.getBalance",
  "params" :{
      "address":"X-avax1ns3jzhqyk7parg29qan56k0fcxwstc76cjqq2s",
      "assetID": "2pYGetDWyKdHxpFxh2LHeoLNCH6H5vxxCxHQtFnnFaYxLsqtHC"
  }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

#### **响应示例**

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "balance":"299999999999900",
        "utxoIDs":[
            {
                "txID":"WPQdyLNqHfiEKp4zcCpayRHYDVYuh1hqs9c1RqgZXS4VPgdvo",
                "outputIndex":1
            }
        ]
    }
}
```

### avm.getTx

返回指定的交易, `encoding`参数设置返回交易的格式, 可以是“cb58” 或“hex”, 默认为“cb58”。

#### **签名**

```cpp
avm.getTx({
    txID: string,
    encoding: string, //optional
}) -> {
    tx: string,
    encoding: string,
}
```

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avm.getTx",
    "params" :{
        "txID":"2QouvFWUbjuySRxeX5xMbNCuAaKWfbk5FeEa2JmoF85RKLk2dD",
        "encoding": "cb58"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

#### **响应示例**

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "tx":"1111111vQFqEEHkkAGwJnpdAJgga28zHk9pFARHp1VWe3QM5wC7ztGA5cZAPanFWXHkhbWEbFs9qsEpNZ7QHrzucUUZqLEPrAwJZLrZBik4dEhbsTCF3nS6s2fXVzc5ar2esLFD92WVMZmJNuTUQuKjVkjag2Gy3HHYSqm6bojrG62KrazywKPhrYx8QF9AqNfYYwD3XcSUV1g46r7sQ1WqzM8nyG4qL517JS1YVuTC3aWPeN5cxP6FdvbYexwHcgaBtiQsYbCEeZ9cuJqhE2Pxx8BJFpicLN8FBexb6fzQyBLiFR7yx6v6YBjq7dtu9MBczFdNCnDE4MsG2SyPZsdUv1XxQYVVwDqgqi8Zto5esJKph72YZbrXX3SHVSZBFZXkKbTzyEQFWHCF1jC",
        "encoding": "cb58"
    }
}
```

### avm.getTxStatus

获取发送到网络的交易的状态。

#### **签名**

```cpp
avm.getTxStatus({txID: string}) -> {status: string}
```

`status` 的以下情况:

* `Accepted`: 交易被每个节点(或将被)接受
* `Processing`: 该节点正在对交易进行投票
* `Rejected`: 该交易将永远不会被网络中的任何节点接受
* `Unknown`: 该节点未看到该交易

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avm.getTxStatus",
    "params" :{
        "txID":"2QouvFWUbjuySRxeX5xMbNCuAaKWfbk5FeEa2JmoF85RKLk2dD"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

#### **响应示例**

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "status":"Accepted"
    }
}
```

### avm.getUTXOs

获取引用给定地址的UTXO, 如果指定了源链，那么它将检索从该链导出到X链的原子UTXO。

#### **签名**

```cpp
avm.getUTXOs({
    addresses: []string,
    limit: int, //optional
    startIndex: { //optional
        address: string,
        utxo: string
    },
    sourceChain: string, //optional
    encoding: string //optional
}) -> {
    numFetched: int,
    utxos: []string,
    endIndex: {
        address: string,
        utxo: string
    },
    sourceChain: string, //optional
    encoding: string
}
```

* `utxos` 是一个UTXO列表，每个UTXO至少引用`addresses`中的一个地址。
* 最多返回`limit` 限定的UTXO数量。如果`limit`省略了或大于1024，则将其设置为1024。 
* 此方法支持分页, `endIndex`表示返回的最后一个UTXO。要获取下一组UTXO，在下一个调用中使用`endIndex`的值作为`startIndex`。   
* 如果`startIndex`省略，将获取`limit`限量以内的所有UTXO。
* 当使用分页\(当提供了`startIndex`  \)，UTXO不能保证在多个 调用中是唯一的。也就是说，UTXO可能出现在第一次调用的结果中，然后在第二次调用中再次出现。
* 使用分页时，不能保证多个调用之间的一致性。也就是说，地址的UTXO集可能在调用之间发生了变化。  
* `encoding` 设置返回的UTXO的格式, 可以是“cb58” 或“hex”, 默认为“cb58”。

#### **示例**

假设我们希望所有UTXO至少引用`X-avax1yzt57wd8me6xmy3t42lz8m5lg6yruy79m6whsf`和`X-avax1x459sj0ssujguq723cljfty4jlae28evjzt7xz`的其中一个。   

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avm.getUTXOs",
    "params" :{
        "addresses":["X-avax1yzt57wd8me6xmy3t42lz8m5lg6yruy79m6whsf", "X-avax1x459sj0ssujguq723cljfty4jlae28evjzt7xz"],
        "limit":5,
        "encoding": "cb58"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

此处响应:

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
            "address": "X-avax1x459sj0ssujguq723cljfty4jlae28evjzt7xz",
            "utxo": "kbUThAUfmBXUmRgTpgD6r3nLj7rJUGho6xyht5nouNNypH45j"
        },
        "encoding": "cb58"
    },
    "id": 1
}
```

由于`numFetched`与`limit`相同，我们可以知道可能有更多的UTXO没有被获取。我们再次调用该方法，这次使用`startIndex`:  

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :2,
    "method" :"avm.getUTXOs",
    "params" :{
        "addresses":["X-avax1x459sj0ssujguq723cljfty4jlae28evjzt7xz"],
        "limit":5,
        "endIndex": {
            "address": "X-avax1x459sj0ssujguq723cljfty4jlae28evjzt7xz",
            "utxo": "kbUThAUfmBXUmRgTpgD6r3nLj7rJUGho6xyht5nouNNypH45j"
        },
        "encoding": "cb58"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

此处响应:

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
            "address": "X-avax1x459sj0ssujguq723cljfty4jlae28evjzt7xz",
            "utxo": "21jG2RfqyHUUgkTLe2tUp6ETGLriSDTW3th8JXFbPRNiSZ11jK"
        },
        "encoding": "cb58"
    },
    "id": 1
}
```

由于`numFetched`小于`limit`，我们知道已经完成了UTXO的获取，不需要再次调用该方法。

假设我们想要获取从P链导出到X链的UTXO，以便构建ImportTx。然后我们需要使用源链参数调用GetUTXOs来检索原子UTXO:       

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avm.getUTXOs",
    "params" :{
        "addresses":["X-avax1yzt57wd8me6xmy3t42lz8m5lg6yruy79m6whsf", "X-avax1x459sj0ssujguq723cljfty4jlae28evjzt7xz"],
        "limit":5,
        "sourceChain": "P",
        "encoding": "cb58"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

此处响应:

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "numFetched": "1",
        "utxos": [
            "115P1k9aSVFBfi9siZZz135jkrBCdEMZMbZ82JaLLuML37cgVMuxgu73ukQbPjXtDgyBCE1cgrJjqDPgboUswV5BGAYhnuxunkHS3xncB599V3mxyvWnwVwNPmq3mKQwF5EWhfTaXkhqE5VFr92yQBk9Nh5ekZBDSFGCSC"
        ],
        "endIndex": {
            "address": "X-avax1x459sj0ssujguq723cljfty4jlae28evjzt7xz",
            "utxo": "2Sz2XwRYqUHwPeiKoRnZ6ht88YqzAF1SQjMYZQQaB5wBFkAqST"
        },
        "encoding": "cb58"
    },
    "id": 1
}
```

### avm.import

将AVAX从P链或C链转移到X链。在调用这个方法之前，你必须调用P链的[`platform.exportAVAX`](platform-chain-p-chain-api.md#platform-exportavax)或C链的[`avax.export`](contract-chain-c-chain-api.md#avax-export) 方法来启动传输。

#### **签名**

```cpp
avm.import({
    to: string,
    sourceChain: string,
    username: string,
    password: string,
}) -> {txID: string}
```

* `to` 是AVAX发送到的地址, 这必须与对应调用P链的`exportAVAX`或C链的 `export`中的`to` 的参数相同。  
* `sourceChain` 是从其中导入AVAX的链的ID或别名。要从C链导入资金，请使用`"C"`。 
* `username` 是控制`to`的用户。
* `txID` 是新创建的原子交易的ID。

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avm.import",
    "params" :{
        "to":"X-avax1s7aygrkrtxflmrlyadlhqu70a6f4a4n8l2tru8",
        "sourceChain":"C",
        "username":"myUsername",
        "password":"myPassword"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

#### **响应示例**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "txID": "2gXpf4jFoMAWQ3rxBfavgFfSdLkL2eFUYprKsUQuEdB5H6Jo1H"
    },
    "id": 1
}
```

### avm.importAVAX

将AVAX的P链转移到X链。在调用此方法之前，必须调用P链的[`platform.exportAVAX`](platform-chain-p-chain-api.md#platform-exportavax) 方法来初始化传输。 

#### **签名**

```cpp
avm.importAVAX({
    to: string,
    sourceChain: string,
    username: string,
    password: string,
}) -> {txID: string}
```

* `to` 是AVAX发送到的地址。这必须与对应调用P链的`exportAVAX`中的`to`参数相同。 
* `sourceChain` 是从其中导入AVAX的链的ID或别名。要从P链导入资金，请使用`"P"`。
* `username` 是控制`to`的用户。

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avm.importAVAX",
    "params" :{
        "to":"X-avax1s7aygrkrtxflmrlyadlhqu70a6f4a4n8l2tru8",
        "sourceChain":"P",
        "username":"myUsername",
        "password":"myPassword"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

#### **响应示例**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "txID": "MqEaeWc4rfkw9fhRMuMTN7KUTNpFmh9Fd7KSre1ZqTsTQG73h"
    },
    "id": 1
}
```

### avm.importKey

通过提供控制地址的私钥，让用户控制该地址。

#### **签名**

```cpp
avm.importKey({
    username: string,
    password: string,
    privateKey: string
}) -> {address: string}
```

* 添加`privateKey`到`username`的私钥集。`address`是`username` 现在用私钥控制的地址。

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avm.importKey",
    "params" :{
        "username":"myUsername",
        "password":"myPassword",
        "privateKey":"PrivateKey-2w4XiXxPfQK4TypYqnohRL8DRNTz9cGiGmwQ1zmgEqD9c9KWLq"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

#### **响应示例**

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "address":"X-avax1mwlnrzv0ezdycx4qhqj77j55cwgcvtf29zvmpy"
    }
}
```

### avm.issueTx

向网络发送一个验签事务。`encoding` 指定已签名事务的格式, 可以是“cb58” 或 “hex”。默认为“cb58”。

#### **签名**

```cpp
avm.issueTx({
    tx: string,
    encoding: string, //optional
}) -> {
    txID: string
}
```

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     : 1,
    "method" :"avm.issueTx",
    "params" :{
        "tx":"6sTENqXfk3gahxkJbEPsmX9eJTEFZRSRw83cRJqoHWBiaeAhVbz9QV4i6SLd6Dek4eLsojeR8FbT3arFtsGz9ycpHFaWHLX69edJPEmj2tPApsEqsFd7wDVp7fFxkG6HmySR",
        "encoding": "cb58"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

#### **响应示例**

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "txID":"NUPLwbt2hsYxpQg4H2o451hmTWQ4JZx2zMzM4SinwtHgAdX1JLPHXvWSXEnpecStLj"
    }
}
```

### avm.listAddresses

列出由给定用户控制的地址。

#### **签名**

```cpp
avm.listAddresses({
    username: string,
    password: string
}) -> {addresses: []string}
```

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "avm.listAddresses",
    "params": {
        "username":"myUsername",
        "password":"myPassword"
    },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

#### **响应示例**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "addresses": ["X-avax1rt4vac58crp0p59yf640c4gycm6creg2rt8hc6"]
    },
    "id": 1
}
```

### avm.send

将一个资产的数量发送到一个地址。

#### **签名**

```cpp
avm.send({
    amount: int,
    assetID: string,
    to: string,
    memo: string, //optional
    from: []string, //optional
    changeAddr: string, //optional
    username: string,
    password: string
}) -> {txID: string, changeAddr: string}
```

* 发送ID为`assetID`的资产的`amount`单位数量到地址`to`, `amount`是以资产的最小增量来计算的。对于AVAX，`amount`的最小增量是1 nAVAX \(1 AVAX的十亿分之一\)    。  
* `to` 是资产被发送到的X链地址。
* `from` 是您要用于此操作的地址。如果省略，根据需要使用您的任何地址。
* `changeAddr` 是有任何变化都会发送到的地址。如果省略，更改将被发送到用户控制的地址之一。
* 你可以附加一个`memo`, 最多可达到256个字节。
* 资产由`username`控制的地址发出。\(  当然, 该用户至少要持有足量的余额\)

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avm.send",
    "params" :{
        "assetID"   : "AVAX",
        "amount"    : 10000,
        "to"        : "X-avax1yzt57wd8me6xmy3t42lz8m5lg6yruy79m6whsf",
        "from"      : ["X-avax1s65kep4smpr9cnf6uh9cuuud4ndm2z4jguj3gp"],
        "changeAddr": "X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8",
        "memo"      : "hi, mom!",
        "username"  : "userThatControlsAtLeast10000OfThisAsset",
        "password"  : "myPassword"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

#### **响应示例**

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "txID":"2iXSVLPNVdnFqn65rRvLrsu8WneTFqBJRMqkBJx5vZTwAQb8c1",
        "changeAddr": "X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8"
    }
}
```

### avm.sendMultiple

从拥有的地址的列表发送多个`amount`的`assetID`到指定地址的传输。

#### **签名**

```cpp
avm.sendMultiple({
    outputs: []{
      assetID: string,
      amount: int,
      to: string
    },
    from: []string, //optional
    changeAddr: string, //optional
    memo: string, //optional
    username: string,
    password: string
}) -> {txID: string, changeAddr: string}
```

* `outputs` 是一个对象字面量数组，每个数组包含`assetID`， `amount`和`to`。
* `memo` 可选消息，最大长度为256字节。
* `from` 是您要用于此操作的地址。如果省略，根据需要使用您的任何地址。 
* `changeAddr` 是有任何变化都会发送到的地址。如果省略，更改将被发送到用户控制的地址之一。
* 资产是从用户`username`控制的地址发送的。\(当然，该用户将需要至少持有正在发送的资产的余额。\)  

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avm.sendMultiple",
    "params" :{
        "outputs": [
            {
                "assetID" : "AVAX",
                "to"      : "X-avax1yzt57wd8me6xmy3t42lz8m5lg6yruy79m6whsf",
                "amount"  : 1000000000
            },
            {
                "assetID" : "26aqSTpZuWDAVtRmo44fjCx4zW6PDEx3zy9Qtp2ts1MuMFn9FB",
                "to"      : "X-avax18knvhxx8uhc0mwlgrfyzjcm2wrd6e60w37xrjq",
                "amount"  : 10
            }
        ],
        "memo"      : "hi, mom!",
        "from"      : ["X-avax1s65kep4smpr9cnf6uh9cuuud4ndm2z4jguj3gp"],
        "changeAddr": "X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8",
        "username"  : "username",
        "password"  : "myPassword"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

#### **响应示例**

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "txID":"2iXSVLPNVdnFqn65rRvLrsu8WneTFqBJRMqkBJx5vZTwAQb8c1",
        "changeAddr": "X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8"
    }
}
```

### avm.sendNFT

发送一个非同质化代币。

#### **签名**

```cpp
avm.sendNFT({
    assetID: string,
    groupID: number,
    to: string,
    from: []string, //optional
    changeAddr: string, //optional
    username: string,
    password: string
}) -> {txID: string}
```

* `assetID` 是正在发送的NFT的资产ID。
* `groupID` 是发送NFT的NFT组, NFT创建允许每个NFT ID下有多个组, 您可以向每个组发出多个nft。  
* `to` 是NFT发送到的X链地址。
* `from` 是您要用于此操作的地址。如果省略，根据需要使用您的任何地址。`changeAddr`是任何变更都会发送到的地址。如果省略，更改将被发送到用户控制的地址之一。  
* 资产是从用户`username`控制的地址发送的。\(当然，该用户将需要至少持有正在发送的 NFT余额。\)  

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"avm.sendNFT",
    "params" :{
        "assetID"   : "2KGdt2HpFKpTH5CtGZjYt5XPWs6Pv9DLoRBhiFfntbezdRvZWP",
        "groupID"   : 0,
        "to"        : "X-avax1yzt57wd8me6xmy3t42lz8m5lg6yruy79m6whsf",
        "from"      : ["X-avax1s65kep4smpr9cnf6uh9cuuud4ndm2z4jguj3gp"],
        "changeAddr": "X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8",
        "username"  : "myUsername",
        "password"  : "myPassword"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X
```

#### **响应示例**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "txID": "DoR2UtG1Trd3Q8gWXVevNxD666Q3DPqSFmBSMPQ9dWTV8Qtuy",
        "changeAddr": "X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8"
    },
    "id": 1
}
```

### wallet.issueTx

向网络发送一个验签事务，并假设tx将被接受。`encoding`指定已验签事务的格式。可以是“cb58”或 “hex”。默认为“cb58”。  

这个调用是对钱包API端点的:

`/ext/bc/X/wallet`

#### 签名

```cpp
wallet.issueTx({
    tx: string,
    encoding: string, //optional
}) -> {
    txID: string
}
```

#### 调用示例

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     : 1,
    "method" :"wallet.issueTx",
    "params" :{
        "tx":"6sTENqXfk3gahxkJbEPsmX9eJTEFZRSRw83cRJqoHWBiaeAhVbz9QV4i6SLd6Dek4eLsojeR8FbT3arFtsGz9ycpHFaWHLX69edJPEmj2tPApsEqsFd7wDVp7fFxkG6HmySR",
        "encoding": "cb58"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X/wallet
```

#### 响应示例

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "txID":"NUPLwbt2hsYxpQg4H2o451hmTWQ4JZx2zMzM4SinwtHgAdX1JLPHXvWSXEnpecStLj"
    }
}
```

### 钱包发送

将一个资产的数量发送到一个地址，并假设tx将被接受，以便将来的调用可以使用修改后的UTXO集。

这个调用是对钱包API端点的:

`/ext/bc/X/wallet`

#### **签名**

```cpp
wallet.send({
    amount: int,
    assetID: string,
    to: string,
    memo: string, //optional
    from: []string, //optional
    changeAddr: string, //optional
    username: string,
    password: string
}) -> {txID: string, changeAddr: string}
```

* 发送ID为 `assetID` 的资产的`amount`数量单位到地址`to`。`amount`是以资产的最小增量来计算的。对于AVAX，最小增量为1 nAVAX \(1 AVAX的十亿分之一。\)    
* `to` 是资产被发送到的X链地址。
* `from` 是您要用于此操作的地址。如果省略，根据需要使用您的任何地址。
* `changeAddr` 是有任何变化都会发送到的地址。如果省略，更改将被发送到用户控制的地址之一。
* 你可以附加一个`memo`，它的长度可以达到256字节。
* 资产是从用户`username`控制的地址发送的。\(当然，该用户将需要至少持有正在发送的资产的余额。\)  

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"wallet.send",
    "params" :{
        "assetID"   : "AVAX",
        "amount"    : 10000,
        "to"        : "X-avax1yzt57wd8me6xmy3t42lz8m5lg6yruy79m6whsf",
        "memo"      : "hi, mom!",
        "from"      : ["X-avax1s65kep4smpr9cnf6uh9cuuud4ndm2z4jguj3gp"],
        "changeAddr": "X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8",
        "username"  : "userThatControlsAtLeast10000OfThisAsset",
        "password"  : "myPassword"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X/wallet
```

#### **响应示例**

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "txID":"2iXSVLPNVdnFqn65rRvLrsu8WneTFqBJRMqkBJx5vZTwAQb8c1",
        "changeAddr": "X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8"
    }
}
```

### wallet.sendMultiple

从拥有的地址列表发送多个 `amount`的`assetID`到指定地址的传输，并假设tx将被接受，以便将来的调用可以使用修改后的UTXO集。

这个调用是对钱包API端点的:

`/ext/bc/X/wallet`

#### **签名**

```cpp
wallet.sendMultiple({
    outputs: []{
      assetID: string,
      amount: int,
      to: string
    },
    from: []string, //optional
    changeAddr: string, //optional
    memo: string, //optional
    username: string,
    password: string
}) -> {txID: string, changeAddr: string}
```

* `outputs` 是一个对象字面量数组，每个数组包含`assetID`， `amount`和`to`。
* `from` 是您要用于此操作的地址。如果省略，根据需要使用您的任何地址。
* `changeAddr` 是有任何变化都会发送到的地址。如果省略，更改将被发送到用户控制的地址之一。
* 你可以附加一个`memo`，它的长度可以达到256字节。
* 资产是从用户`username`控制的地址发送的。\(当然，该用户将需要至少持有正在发送的资产的余额。\)

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"wallet.sendMultiple",
    "params" :{
        "outputs": [
            {
                "assetID" : "AVAX",
                "to"      : "X-avax1yzt57wd8me6xmy3t42lz8m5lg6yruy79m6whsf",
                "amount"  : 1000000000
            },
            {
                "assetID" : "26aqSTpZuWDAVtRmo44fjCx4zW6PDEx3zy9Qtp2ts1MuMFn9FB",
                "to"      : "X-avax18knvhxx8uhc0mwlgrfyzjcm2wrd6e60w37xrjq",
                "amount"  : 10
            }
        ],
        "memo"      : "hi, mom!",
        "from"      : ["X-avax1s65kep4smpr9cnf6uh9cuuud4ndm2z4jguj3gp"],
        "changeAddr": "X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8",
        "username"  : "username",
        "password"  : "myPassword"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/bc/X/wallet
```

#### **响应示例**

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "txID":"2iXSVLPNVdnFqn65rRvLrsu8WneTFqBJRMqkBJx5vZTwAQb8c1",
        "changeAddr": "X-avax1turszjwn05lflpewurw96rfrd3h6x8flgs5uf8"
    }
}
```

<!--stackedit_data:
eyJoaXN0b3J5IjpbMTU0MDgwNDU3NiwtMTk0ODgyOTg3NiwyMD
kwNDc2MjQ4LDIxMDk0MTY4MTYsLTE4OTk0NDExNDMsMTI3MjA0
Mzc0NywyMTE5NTA1MTIzLC0xMDMwNTk3MTMyLDE3ODA0ODAzND
UsLTY5NjAwMzEzNywxOTk4MjQ2NjAyLC0xNDE3ODQxNTIyLC0x
NDQyODY0NTc0LC0xMDEwMTQ5MTM3LDc5MzEwMTM4MCw0NzMxOT
AwMzYsMTU5NDY1MzI0NiwxMTEzODY5NTksOTQ2MTI2MzAsMTYy
MDAyNzMyMF19
-->