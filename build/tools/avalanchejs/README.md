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

Using AvalancheJS, developers can:

* Locally manage private keys
* Retrieve balances on addresses
* Get UTXOs for addresses
* Build and sign transactions
* Issue signed transactions to the X-Chain
* Create a Subnetwork
* Administer a local node
* Retrieve Avalanche network information from a node

## Requirements

AvalancheJS requires Node.js LTS version 12.14.1 or higher to compile.

## Installation

Avalanche is available for install via `npm`:

`npm install --save avalanche`

You can also pull the repo down directly and build it from scratch:

`npm run build`

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
eyJoaXN0b3J5IjpbLTQ0MDc4OTIzMF19
-->