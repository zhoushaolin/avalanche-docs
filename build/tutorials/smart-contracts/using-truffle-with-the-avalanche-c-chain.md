# 将 Truffle 应用于Avalanche C链

## 简介

[Truffle Suite](https://www.trufflesuite.com/)套装是用于在EVM上启动去中心化应用程序（dapps）的工具包。通过Truffle，您可以编写和编译智能合约、构建工件、运行程序迁移并与部署合约互动。本教程演示了如何将Truffle应用于Avalanche的C链，这是EVM的一个实例。

## 要求

您已经完成了Avalanche节点运行[Run an Avalanche Node](https://stackedit.io/get-started.md)，并熟悉Avalanche的架构[Avalanche’s architecture](https://stackedit.io/learn/platform-overview/)。您也会操作跨链交易，通过[Transfer AVAX Between X-Chain and C-Chain](https://stackedit.io/platform/transfer-avax-between-x-chain-and-c-chain.md)这个教程, 转账到C链地址。

## 附属项

* [Avash](https://github.com/ava-labs/avash) 是一个运行Avalanche网络的工具. 与 Truffle的 [Ganache](https://www.trufflesuite.com/ganache)相似。
* [NodeJS](https://nodejs.org/en) v8.9.4或更高版本.
* Truffle, 可以通过 `npm install -g truffle`进行安装

## 启用本地Avalanche网络

通过[Avash](https://github.com/ava-labs/avash), 您可以使用多达15个AvalancheGo节点来加速专用测试网络部署。通过Lua脚本，Avash支持常规任务的自动化。因此，能够针对各种部署进行快速测试。首次使用Avash时，需要安装并构建[install and build it](https://github.com/ava-labs/avash#quick-setup)。

启动本地五节点Avalanche网络：
```text
cd /path/to/avash
# build Avash if you haven't done so
go build
# start Avash
./avash
# start a five node staking network
runscript scripts/five_node_staking.lua
```
您的计算机上运行着五节点Avalanche网络。当您想要退出Avash时，请运行`exit`，但现在请勿运行，也请勿关闭此终端选项。

## 创建truffle目录并安装附属项

打开一个新的终端选项，然后我们就能创建truffle目录, 并安装详细附属项。

首先，导航至您打算创建truffle工作目录的目录：

```text
cd /path/to/directory
```

创建并输入新目录，命名为`truffle`:

```text
mkdir truffle; cd truffle
```

使用`npm` 来安装 [web3](https://web3js.readthedocs.io), 这是一个我们可用于与EVM对话的库:

```text
npm install web3 -s
```

我们会使用web3 来设置一个HTTP Provider，借此，web3可与EVM进行对话。最后，创建一个boilerplace truffle项目:

```text
truffle init
```

## 更新 truffle-config.js文件

当运行 `truffle init` 会创建`truffle-config.js`文件。将下列内容添加到`truffle-config.js`.

```javascript
const Web3 = require('web3');
const protocol = "http";
const ip = "localhost";
const port = 9650;
module.exports = {
  networks: {
   development: {
     provider: function() {
      return new Web3.providers.HttpProvider(`${protocol}://${ip}:${port}/ext/bc/C/rpc`)
     },
     network_id: "*",
     gas: 3000000,
     gasPrice: 470000000000
   }
  }
};
```
请注意，如果要将API调用导向到另一个AvalancheGo节点，您可以更改协议、IP和端口。还要注意，我们正在为Avalanche C链设置`gasPrice`和`gas`的适当值。

## 添加 Storage.sol

在`contracts`目录中，添加名为Storage.sol的新文件，并添加下列代码：
```text
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 */
contract Storage {

    uint256 number;

    /**
     * @dev Store value in variable
     * @param num value to store
     */
    function store(uint256 num) public {
        number = num;
    }

    /**
     * @dev Return value 
     * @return value of 'number'
     */
    function retrieve() public view returns (uint256){
        return number;
    }
}
```

`Storage`是一个实体智能合约，因此，我们可以通过`store` 函数向区块链编写数字，然后将通过`retrieve`函数从区块链读取数字。

## 添加新迁移程序

在`migrations` 目录里创建名为`2_deploy_contracts.js`的文件夹, 然后添加以下代码, 这将把`Storage` 智能合约部署到区块链。

```javascript
const Storage = artifacts.require("Storage");

module.exports = function (deployer) {
  deployer.deploy(Storage);
};
```

## 用Truffle编译合约

但凡你需要对`Storage.sol`作出更改, 你都需要运行`truffle compile`来进行编译.

```text
truffle compile
```

You should see:

```text
Compiling your contracts...
===========================
> Compiling ./contracts/Migrations.sol
> Compiling ./contracts/Storage.sol
> Artifacts written to /path/to/build/contracts
> Compiled successfully using:
   - solc: 0.5.16+commit.9c3226ce.Emscripten.clang
```

## 在C链上创建、充值和解锁账户

当给C链部署智能合约时，作为程序迁移过程中使用的from地址，truffle将默认为C链客户端提供的第一个可用帐户。
将智能合约部署到C-Chain时，truffle将默认使用C链客户端提供的第一个可用帐户，作为迁移期间使用的“`from`”地址。

### 创建账户

Truffle有一个非常有用的控制台 [console](https://www.trufflesuite.com/docs/truffle/reference/truffle-commands#console) 我们可以用它来与区块链和合约进行互动, 打开控制台:

```text
truffle console --network development
```

然后，在该控制台中创建账户：

```text
truffle(development)> let account = await web3.eth.personal.newAccount()
```

返回到：

```text
undefined
```

打印账户：

```text
truffle(development)> account
```

这将打印账户：

```text
'0x090172CD36e9f4906Af17B2C36D662E69f162282'
```

### 解锁账户:

```text
truffle(development)> await web3.eth.personal.unlockAccount(account)
```

返回到：

```text
true
```

### 账户充值

按照 [Transfer AVAX Between X-Chain and C-Chain](../platform/transfer-avax-between-x-chain-and-c-chain.md) 教程的步骤, 给新创建的账户充值, 您至少需要发送135422040nAVAX来支付合同部署费用。

### 脚本账户创建和充值

社区成员[Cinque McFarlane-Blake](https://github.com/cinquemb) 已经制作了一个可以自动化此过程的便利脚本。您可以在[here](https://github.com/ava-labs/avalanche-docs/tree/1b06df86bb23632b5fa7bf5bd5b10e8378061929/scripts/make_accounts.js)这里找到它。使用此命令来下载它：

```text
wget -nd -m https://raw.githubusercontent.com/ava-labs/avalanche-docs/master/scripts/make_accounts.js;
```
**注意**: 如果是按照教程设置的`truffle-config.js`文件, 那么, 你就需要使用端口9650来修改脚本`make_accounts.js`, 而不是端口9545(truffle使用的默认端口)

可以用以下代码运行该脚本:

```text
truffle exec make_accounts.js --network development
```

脚本会创建一个账户，并为其C链地址充值。通过编辑脚本中的`maxAccounts`最大账户数量）和`amount`（金额）变量，您可以自定义账户的数量和AVAX储蓄金额。

## 运行迁移程序

当前，一切均已就位，只待运行迁移程序并部署 `Storage`合约：

```text
truffle(development)> migrate --network development
```

您应该看到：

```text
Compiling your contracts...
===========================
> Everything is up to date, there is nothing to compile.

Migrations dry-run (simulation)
===============================
> Network name:    'development-fork'
> Network id:      1
> Block gas limit: 99804786 (0x5f2e672)


1_initial_migration.js
======================

   Deploying 'Migrations'
   ----------------------
   > block number:        4
   > block timestamp:     1607734632
   > account:             0x34Cb796d4D6A3e7F41c4465C65b9056Fe2D3B8fD
   > balance:             1000.91683679
   > gas used:            176943 (0x2b32f)
   > gas price:           225 gwei
   > value sent:          0 ETH
   > total cost:          0.08316321 ETH

   -------------------------------------
   > Total cost:          0.08316321 ETH

2_deploy_contracts.js
=====================

   Deploying 'Storage'
   -------------------
   > block number:        6
   > block timestamp:     1607734633
   > account:             0x34Cb796d4D6A3e7F41c4465C65b9056Fe2D3B8fD
   > balance:             1000.8587791
   > gas used:            96189 (0x177bd)
   > gas price:           225 gwei
   > value sent:          0 ETH
   > total cost:          0.04520883 ETH

   -------------------------------------
   > Total cost:          0.04520883 ETH

Summary
=======
> Total deployments:   2
> Final cost:          0.13542204 ETH
```

如果您未在C链上创建账户，您会看到此错误：

```text
Error: Expected parameter 'from' not passed to function.
```

如果您未给账户充值，您会看到此错误：

```text
Error:  *** Deployment Failed ***

"Migrations" could not deploy due to insufficient funds
   * Account:  0x090172CD36e9f4906Af17B2C36D662E69f162282
   * Balance:  0 wei
   * Message:  sender doesn't have enough funds to send tx. The upfront cost is: 1410000000000000000 and the sender's account only has: 0
   * Try:
      + Using an adequately funded account
```

如果您未解锁账户，您会看到此错误：

```text
Error:  *** Deployment Failed ***

"Migrations" -- Returned error: authentication needed: password or unlock.
```

## 与合约进行互动

当前，Storage合约已部署完毕。向区块链写入数字，然后将其读取回来。再次打开truffle控制台：

获取已部署`Storage` 合约的实例：

```javascript
truffle(development)> let instance = await Storage.deployed()
```

返回至：

```text
undefined
```

### 向区块链写入数字

既然您已获得`Storage` 合约的实例，调用其`store`方法并向区块链写入数字。

```javascript
truffle(development)> instance.store(1234)
```

如果您看到此错误：

```text
Error: Returned error: authentication needed: password or unlock
```

请再次运行它：

```text
truffle(development)> await web3.eth.personal.unlockAccount(account[0])
```

您应该看到如下内容：

```javascript
{
  tx: '0x10afbc5e0b9fa0c1ef1d9ec3cdd673e7947bd8760b22b8cdfe08f27f3a93ef1e',
  receipt: {
    blockHash: '0x8bacbce7c9d835db524bb856288e3a73a6afbe49ab34abd8cd8826db0240eb21',
    blockNumber: 9,
    contractAddress: null,
    cumulativeGasUsed: 26458,
    from: '0x34cb796d4d6a3e7f41c4465c65b9056fe2d3b8fd',
    gasUsed: 26458,
    logs: [],
    logsBloom: '0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000',
    status: true,
    to: '0x0d507b0467baef742f9cc0e671eddbdf6df41d33',
    transactionHash: '0x10afbc5e0b9fa0c1ef1d9ec3cdd673e7947bd8760b22b8cdfe08f27f3a93ef1e',
    transactionIndex: 0,
    rawLogs: []
  },
  logs: []
}
```

### 从区块链读取数字

如需从区块链读取数字，请调用`Storage` 合约实例的`retrieve`方法。

```javascript
truffle(development)> let i = await instance.retrieve()
```

应返回至：

```javascript
undefined
```

调用 `retrieve`的结果是`BN`(大数字）。调用其`.toNumber`方法，以查看其值：

```javascript
truffle(development)> i.toNumber()
```

您应看到您存储的数字。

```javascript
1234
```

## 总结

现在您已经拥有启动本地Avalanche网络、创建truffle项目、创建、编译、部署和与实体合约互动所需的工具了。

<!--stackedit_data:
eyJoaXN0b3J5IjpbMTk2ODQ4ODEyNiwzODMyNjc3OTUsLTE2OD
Q0OTAzNTEsMTM1NTM5MzAzNCwxMzQ5NDM5NDIsLTE2ODcxOTI1
MzcsLTE2Mzc2MjIyMzgsNzczMzA1ODI4LDIwNTYxNTIzMSwtMT
YwOTY5ODIwMywtOTU1MDUzNjM4XX0=
-->