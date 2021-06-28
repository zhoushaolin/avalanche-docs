# Avash

Avash是一个临时状态的shell执行环境，用于部署本地和远程网络并在其上运行测试。当Avash退出时，将退出本地部署的Avalanche节点。

Avash提供了运行Lua脚本的能力，这些脚本可以在Avash中执行一系列shell命令。这允许常规任务的自动化。例如，可以创建一个Lua脚本来部署Avalanche节点网络，其中每个节点都有一些给定的配置。这使得测试更容易。

## 安装

### 要求

* Golang 1.15.5 或者更新
* 雪崩客户端实现雪崩标准CLI标志"

### 快速安装 

1. 安装并构建一个Avalanche客户端
2. `cd $GOPATH`
3. `go get github.com/ava-labs/avash`
4. `cd src/github.com/ava-labs/avash`
5. `go build`

## 配置 

虽然Avash可以在没有预先配置文件的情况下启动，但它可以作为一个选项来调整一些shell的全局设置。Avash会默认搜索在`$HOME`目录下的`.avash.yaml`，但是`--config`标志可以用来设置一个自定义的配置文件路径来查找。

Avash配置文件格式如下:

```text
avalancheLocation: <filepath>
datadir: <directory>
log:
  terminal: <log-level>
  logfile: <log-level>
  dir: <directory>
```

各字段参数说明如下:

* `<filepath>` - 文件的完整路径。示例: `/home/username/file.txt`
* `<directory>` - 目录的完整路径。示例: `/home/username/folder`
* `<log-level>` - 过滤日志消息的有效日志级别。以下之一: `{verbo, debug, info, warn, error, fatal, off}`

### 字段 

**avalanche位置**

```text
avalanche二进制文件路径。

类型:
  optional, <filepath>

默认:
  $GOPATH/src/github.com/ava-labs/avalanchego/build/avalanche
```

**datadir**

```text
Avash数据存储的目录。

类型:
  optional, <directory>

默认:
  $GOPATH/src/github.com/ava-labs/avash/stash
```

**log.terminal**

```text
允许所有记录到shell终端的消息的输出级别。

类型:
  optional, <log-level>

默认:
  info
```

**log.logfile**

```text
允许记录到日志文件中的所有消息的输出级别。

类型:
  optional, <log-level>

默认:
  info
```

**log.dir**

```text
日志文件的目录。

类型:
  optional, <directory>

默认:
  <datadir>/logs
```

## 使用 Avash 

### 打开一个shell

使用`./avash`启动一个新的Avash实例。

运行`help` 查看可用的命令。

我们还可以运行`help [command]`来查看该命令可用的选项列表。

Ex:

```text
help procmanager
help procmanager start
```

### 命令

Avash附带有以下根命令: 

* `avawallet` - 通过网络与雪崩支付交互的工具。
* `callrpc` - 向节点发出RPC调用。
* `exit` - 退出shell。
* `help` - 关于所有命令的帮助。
* `network` - 用于与远程主机接口的工具。
* `procmanager` - 访问avash客户机的进程管理器。
* `runscript` - 运行提供的脚本。
* `setoutput` - 设置shell日志输出。
* `startnode` - 启动节点进程并为其命名。
* `varstore` - 用于创建变量存储和在其中打印变量的工具。

这些可以用tab键枚举或自动完成，下面将详细说明。

**ava钱包**

**警告**: 和Avash中的所有东西一样，这个钱包暂时保存在内存中，所有数据在退出时都会被清除。这应该用于测试。

```text
Tools for interacting with Avalanche Payments over the network. Using this 
    command we can create, send, and get the status of a transaction.

Usage:
  avash avawallet [command] [flags]

Available Commands:
  addkey      Adds a private key to a wallet.
  balance     Checks the balance of an address from a node.
  compare     Compares the UTXO set between two wallets.
  create      Creates a wallet.
  maketx      Creates a signed transaction.
  newkey      Creates a random private key.
  refresh     Refreshes UTXO set from node.
  remove      Removes a transaction from a wallet's UTXO set.
  send        Sends a transaction to a node.
  spend       Spends a transaction from a wallet's UTXO set.
  status      Checks the status of a transaction on a node.
  writeutxo   Writes the UTXO set to a file.
```

**callrpc**

```text
为指定的方法和参数向节点端点发出RPC调用。
将响应保存到本地varstore。

用法:
  callrpc [node name] [endpoint] [method] [JSON params] [var scope] [var name]
```

**退出**

```text
退出shell，尝试先优雅地停止所有进程。

用法:
  avash exit
```

**帮助**

```text
为应用程序中的所有命令提供帮助。
只需输入avash help[命令路径]即可获得详细信息。

用法:
  avash help [command] [flags]
```

**网络**

```text
用于与远程主机接口的工具。使用这个命令我们可以通过SSH和配置文件部署和删除节点网络。

用法:
  avash network [command] [flags]

可用命令:
  deploy      Deploys a remote network of nodes.
  remove      Removes a remote network of nodes.
```

**配置**

要部署和删除网络，需要`.yaml`的网络配置文件。在代码库的`network/example.network.yaml`中提到一个例子, 格式如下:

```text
# List of hosts
hosts:
  - user: <SSH-username>
    ip: <host-IP>
    # List of nodes
    nodes:
     - name: <node-name>
       # Set of node CLI flags
       flags:
        <CLI-flag>: <value>
        # ...
```

这种格式可以扩展到同时在多个主机上部署多个节点，使用YAML语法中的`-`向主机列表和每个主机的节点列表添加新元素。CLI标志的完整列表可以在[这里](https://docs.avax.network/v1.0/en/references/command-line-interface/)找到，其中`--node-flag`对应于我们配置文件中的`nodeflag`。

**procmanager**

```text
Access the process manager for the avash client. Using this 
    command we can list, stop, and start processes registered with the 
    process manager.

Usage:
  avash procmanager [command] [flags]

Available Commands:
  kill        Kills the process named if currently running.
  killall     Kills all processes if currently running.
  list        Lists the processes currently running.
  metadata    Prints the metadata associated with the node name.
  remove      Removes the process named.
  start       Starts the process named if not currently running.
  startall    Starts all processes if currently stopped.
  stop        Stops the process named if currently running.
  stopall     Stops all processes if currently running.
```

**runscript**

```text
Runs the script provided in the argument, relative to the present working directory.

Usage:
  avash runscript [script file] [flags]
```

**setoutput**

```text
Sets the log level of a specific log output type.

Usage:
  avash setoutput [log output] [log level]
```

**startnode**

```text
Starts an Avalanche client node using procmanager and gives it a name. Example:

startnode MyNode1 --public-ip=127.0.0.1 --staking-port=9651 --http-port=9650 ... 

Usage:
  avash startnode [node name] args... [flags]

Flags:
      --assertions-enabled                   Turn on assertion execution. (default true)
      --avax-tx-fee uint                     Transaction fee, in nAVAX.
      --bootstrap-ids string                 Comma separated list of bootstrap peer ids to connect to. Example: JR4dVmy6ffUGAKCBDkyCbeZbyHQBeDsET,8CrVPQZ4VSqgL8zTdvL14G8HqAfrBr4z
      --bootstrap-ips string                 Comma separated list of bootstrap nodes to connect to. Example: 127.0.0.1:9630,127.0.0.1:9620
      --client-location string               Path to Avalanche node client, defaulting to the config file's value.
      --data-dir string                      Name of directory for the data stash.
      --db-dir string                        Database directory for Avalanche state. (default "db1")
      --db-enabled                           Turn on persistent storage. (default true)
  -h, --help                                 help for startnode
      --http-port uint                       Port of the HTTP server. (default 9650)
      --http-tls-cert-file string            TLS certificate file for the HTTPS server.
      --http-tls-enabled                     Upgrade the HTTP server to HTTPS.
      --http-tls-key-file string             TLS private key file for the HTTPS server.
      --log-dir string                       Name of directory for the node's logging. (default "logs")
      --log-level string                     Specify the log level. Should be one of {all, debug, info, warn, error, fatal, off} (default "all")
      --meta string                          Override default metadata for the node process.
      --network-id string                    Network ID this node will connect to. (default "12345")
      --public-ip string                     Public IP of this node. (default "127.0.0.1")
      --signature-verification-enabled       Turn on signature verification. (default true)
      --snow-avalanche-batch-size int        Number of operations to batch in each new vertex. (default 30)
      --snow-avalanche-num-parents int       Number of vertexes for reference from each new vertex. (default 5)
      --snow-quorum-size int                 Alpha value to use for required number positive results. (default 2)
      --snow-rogue-commit-threshold int      Beta value to use for rogue transactions. (default 10)
      --snow-sample-size int                 Number of nodes to query for each network poll. (default 2)
      --snow-virtuous-commit-threshold int   Beta value to use for virtuous transactions. (default 5)
      --staking-port uint                    Port of the consensus server. (default 9651)
      --staking-tls-cert-file string         TLS certificate file for staking connections. Relative to the avash binary if doesn't start with '/'. Ex: certs/keys1/staker.crt
      --p2p-tls-enabled                      Require TLS authentication for all P2P connections.
      --staking-enabled                  Utilize staking (also requires p2p tls to be enabled).
      --staking-tls-key-file string          TLS private key file for staking connections. Relative to the avash binary if doesn't start with '/'. Ex: certs/keys1/staker.key
      --xput-server-port uint                Port of the deprecated throughput test server. (default 9652)
```

**varstore**

```text
Tools for creating variable stores and printing variables within them. Using this 
    command we can create variable stores, list all variables they store, and print data 
    placed into these stores. Variable assignment and update is often managed by avash commands.

Usage:
  avash varstore [command] [flags]

Available Commands:
  create      Creates a variable store.
  list        Lists all stores. If store provided, lists all variables in the store.
  print       Prints a variable that is within the store.
  set         Sets a simple variable that within the store.
  storedump   Writes the store to a file.
  vardump     Writes the variable to a file.
```

## Writing Scripts <a id="writing-scripts"></a>

Avash imports the [gopher-lua](https://github.com/yuin/gopher-lua) to run Lua scripts. Scripts have hooks available to them which allows the user to write code which invokes the current Avash environment.

The functions available to Lua are:

* `avash_call` - Takes a string and runs it as an Avash command, returning output
* `avash_sleepmicro` - Takes an unsigned integer representing microseconds and sleeps for that long
* `avash_setvar` - Takes a variable scope \(string\), a variable name \(string\), and a variable \(string\) and places it in the variable store. The scope must already have been created.

When writing Lua, the standard Lua functionality is available to automate the execution of series of Avash commands. This allows a developer to automate:

* Local network deployments
* Sending transactions
* Order transaction test cases
* Save the value of UTXO sets and test results to disk
* Compare the values of two nodes UTXO sets
* Track expected results and compare them with real nodes

Example Lua scripts are in the `./scripts` folder.

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTEzMTc5NjkyMTMsLTkzMTk1NjY1MywyMD
AzMzUzMDEsLTU4ODAyNDAzLDE0Njc0Njc0NjNdfQ==
-->