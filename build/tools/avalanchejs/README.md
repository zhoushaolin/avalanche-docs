# AvalancheJS

AvalancheJS是一个JavaScript库，用于与[Avalanche](.. ./.. ./../# Avalanche)平台对接。它使用TypeScript构建，旨在同时支持browser和Node.js。AvalancheJS库允许向Avalanche节点API发出命令。

目前默认支持的API是:

* 管理员API
* AVM API \(X链\)
* 健康 API
* 信息 API
* 密钥库API
* 指标 API
* 平台VM API

我们在构建AvalancheJS时考虑到了易用性。有了这个库，任何Javascript开发人员都能够与Avalanche平台上的一个节点交互，该节点已启用API端点供开发人员使用。我们保持更新库的最新变化[雪崩平台规范](https://docs.avax.network/)。

使用AvalancheJS，开发者可以:

* 本地管理私钥
* 检索地址上的余额
* 获取UTXO地址
* 构建和签署交易
* 向X链发行已签署的交易
* 创建子网
* 管理本地节点
* 从节点检索Avalanche网络信息

## 要求

AvalancheJS需要Node.js LTS版本12.14.1或更高版本才能编译。

## 安装

Avalanche可通过`npm`安装:

`npm install --save avalanche`

你也可以直接下拉回购，从头开始构建:

`npm run build`

这将生成一个纯Javascript库，并将其放在项目根目录下名为“web”的文件夹中。“avalanchejs”文件可以作为Avalanche的纯javascript实现放到任何项目中。

This will generate a pure Javascript library and place it in a folder named “web” in the project root. The “avalanchejs” file can then be dropped into any project as a pure javascript implementation of Avalanche.

The AvalancheJS library can be imported into your existing Node.js project as follows:

```text
const avalanche = require("avalanche");
```

Or into your TypeScript project like this:

```text
import { Avalanche } from "avalanche"
```

## Importing essentials

```text
import {
    Avalanche,
    BinTools,
    Buffer,
    BN
  } from "avalanche"

let bintools = BinTools.getInstance();
```

The above lines import the libraries used in the tutorials. The libraries include:

* avalanche: Our javascript module.
* bn.js: A bignumber module use by AvalancheJS.
* buffer: A Buffer library.
* BinTools: A singleton built into AvalancheJS that is used for dealing with binary data.

<!--stackedit_data:
eyJoaXN0b3J5IjpbMzIwNzYyMzQ0XX0=
-->