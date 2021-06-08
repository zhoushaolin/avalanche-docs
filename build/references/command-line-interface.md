# 命令行接口

运行节点时，可能支持多种配置。

## 参数

### 配置文件

`--config-file` \(字符串\):

指定此节点配置的JSON文件的路径。命令行参数将覆盖配置文件中设置的参数。

JSON配置文件示例:

```javascript
{
    "plugin-dir": "/home/ubuntu/avalanchego/plugins",
    "log-level": "debug"
}
```

### API

`--api-admin-enabled` \(布尔\):

如果设置为`false`，此节点将不会公开管理API。如默认为`false`。查看[这里](../avalanchego-apis/admin-api.md)获得更多信息。

`--api-auth-required` \(布尔\):

如果设置为`true`，API调用需要授权代币。如默认为`false`。查看[这里](../avalanchego-apis/auth-api.md)获取更多信息。

`--api-auth-password` \(字符串\):

创建/撤销授权代币所需的密码。如果`--api-auth-required=true`，必须指定; 否则忽略。查看[这里](../avalanchego-apis/auth-api.md)获取更多信息。

`--api-health-enabled` \(布尔\):

如果设置为`true`，此节点将公开运行状况API。如默认为`true`。查看[这里](../avalanchego-apis/health- apis .md)获得更多信息。

`--api-info-enabled` \(布尔\):

如果设置为`true`，该节点将公开Info API。默认为`true`。查看[这里](../avalanchego-apis/info-api.md)获取更多信息。

`--api-ipcs-enabled` \(布尔\):

如果设置为`true`，该节点将公开IPCs API。默认为`false`。查看[这里](../avalanchego-apis/ipc-api.md)获取更多信息。

`--api-keystore-enabled` \(布尔\):

如果设置为`false`，此节点将不会公开密钥库API。默认为`true`。查看[这里](../avalanchego-apis/keystore-api.md)获得更多信息。

`--api-metrics-enabled` \(布尔\):

如果设置为`false`，此节点将不会公开Metrics API。如默认为`true`。更多信息请参见[这里](../avalanchego-apis/metrics-api.md)。

### 断言

`--assertions-enabled` \(布尔\):

当设置为`true`时，断言将在整个代码库的运行时执行。这是用于调试的，因为我们可能会得到一个更具体的错误消息。默认为`true`。

### Bootstrapping

`--bootstrap-ids` \(字符串\):

Bootstrap ID是验证器ID的数组。这些ID将用于对引导对等体进行身份验证。这只需要在`--p2p-tls-enabled=true`时设置。该字段的设置示例是`--bootstrap-ids="NodeID-7Xhw2mDxuDS44j42TCB6U5579esbSt3Lg,NodeID-MFrZFVCXPv5iCn6M9K6XduxGTYp891xXZ"`。默认为空\(不尝试从其他节点引导。\)

`--bootstrap-ips` \(字符串\):

Bootstrap IP是一个IPv4:端口对数组。这些IP地址将用于引导当前的雪崩状态。该字段的设置示例是 `--bootstrap-ips="127.0.0.1:12345,1.2.3.4:5678"`。默认为空\(不尝试从其他节点引导。\)

`--bootstrap-retry-enabled` \(布尔\):

如果为true，将在引导失败时重试引导。

`--bootstrap-retry-max-attempts` \(单元\):

失败后重试引导的最大次数。

### 连接计量

`--conn-meter-max-conns` \(整数\):

最多只能从每个`conn-meter-reset-duration`给定的IP升级`conn-meter-max-conns`连接。如果`conn-meter-reset-duration`为0，则传入连接不受速率限制。

`--conn-meter-reset-duration` \(持续时间\):

最多只能从每个 `conn-meter-reset-duration`给定的IP升级`conn-meter-max-conns`连接。如果`conn-meter-reset-duration`为0，则传入连接不受速率限制。

### 数据库

`--db-dir` \(字符串,文件路径\):

指定数据库持久化到的目录。默认为`"$HOME/.avalanchego/db"`。

`--db-enabled` \(布尔\):

如果设置为`false`，状态更新只对内存中的数据库执行，而不对永久存储进行任何更改。当设置为`true`时，状态更新将写入本地持久数据库。默认为`true`。

### 起源

`--genesis` \(字符串\):

包含要使用的起源数据的JSON文件的路径。当运行标准网\(主网, 测试网\)络时忽略, 如果没有指定, 则使用默认的起源数据, 有关JSON的起源数据的呈现示例，请参见[这里](https://github.com/ava-labs/avalanchego/blob/master/genesis/genesis_local.go#L16)。

### HTTP 服务器

`--http-host` \(字符串\):

HTTP API监听的地址, 默认为`127.0.0.1`。这意味着默认情况下，您的节点只能处理来自同一台机器的API调用。要允许来自其他机器的API调用，请使用`--http-host=`。

`--http-port` \(整数\):

每个节点都运行一个HTTP服务器，该服务器提供与节点和Avalanche网络交互的API。此参数指定HTTP服务器将侦听的端口。默认值为`9650`。

`--http-tls-cert-file` \(字符串、文件路径\):

此参数指定节点用于HTTPS服务器的TLS证书的位置。当`--http-tls-enabled=true`时必须指定。此处没有默认值。

`--http-tls-enabled` \(布尔\):

如果设置为`true`，该标志将尝试将服务器升级为使用HTTPS。默认为`false`。

`--http-tls-key-file` \(字符串、文件路径\):

此参数指定节点用于HTTPS服务器的TLS私钥的位置。当`--http-tls-enabled=true`时必须指定。此处没有默认值。

### IPCS

`--ipcs-chain-ids` \(字符串\)

以逗号分隔的要连接的链ID列表。此处没有默认值。

`--ipcs-path` \(字符串\)

IPC套接字的目录(Unix)或命名管道前缀(Windows)。默认为/ tmp。

### 文件描述符的限制

`--fd-limit` \(整数\)

尝试将进程文件描述符限制提高到至少此值。默认为`32768`

### 日志记录

`--log-level` \(字符串 `{Off, Fatal, Error, Warn, Info, Debug, Verbo}`\):

日志级别决定了要记录哪些事件。有7个不同的级别，从最高优先级到最低优先级。

* `Off`: 没有日志具有此级别的日志记录。
* `Fatal`: 不可恢复的致命错误。
* `Error`: 当节点遇到错误时，这些错误可以被恢复。
* `Warn`: 一个警告，可能表明存在虚假复杂的节点，或潜在的未来错误。
* `Info`: 对节点状态更新的有用描述。
* `Debug`: 调试日志记录在试图理解代码中可能存在的漏洞时非常有用。将显示通常需要用于正常使用的更多信息。
* `Verbo`: 跟踪节点正在处理的大量信息。这包括用于极低级别协议分析的消息内容和数据二进制转储。

当指定日志级别时，请注意所有具有指定优先级或更高优先级的日志将被跟踪。默认为`Info`。

`--log-display-level` \(字符串`{Off, Fatal, Error, Warn, Info, Debug, Verbo}`\):

日志级别决定将哪些事件显示到屏幕上。如果留空，将默认为提供给`--log-level`的值。

`--log-display-highlight` \(字符串`{auto, plain, colors}`\):

是否将日志着色/高亮显示。当输出是终端时，默认会高亮显示。否则，应该是这三种情况`{auto, plain, colors}`之一

`--log-dir` \(字符串、文件路径\):

指定保存系统日志的目录。默认为`"$HOME/.avalanchego/logs"`。

### 网络ID

`--network-id` \(字符串\):

该节点应连接到的网络的标识。可以是:

* `--network-id=mainnet` -&gt; 连接到主网 \(默认\)。
* `--network-id=fuji` -&gt; 连接到富士测试网。
* `--network-id=testnet` -&gt; 连接到当前测试网。\(当下为富士测试网\)
* `--network-id=local` -&gt;连接到本地测试网。
* `--network-id=network-{id}` -&gt; 连接到给定ID到网络。`id` 必须在 `[0, 2^32)`这个范围内。

### 公共 IP

`--public-ip` \(字符串\):

验证器必须知道它们的面向大众的IP地址，以便让其他节点知道如何连接它们。如果不提供此参数，节点将尝试执行NAT遍历以获得节点的公共IP。应设置为`127.0.0.1`以创建本地网络。如果没有设置，则尝试通过NAT遍历学习IP。

`--dynamic-public-ip` \(字符串\):

如果参数存在，有效值为:`opendns`, `ifconfigco` 或 `ifconfigme`。这将覆盖`--public-ip`。如果设置了，将在每一个`--dynamic-update-duration`轮询远程服务，并更新节点的公共IP地址。

`--dynamic-update-duration` \(持续时间\):

`--dynamic-public-ip`或NAT遍历轮询事件之间的时间。建议最短时间为1分钟。默认为`5m`。

### 签名验证

`--signature-verification-enabled` \(布尔\):

开启签名验证。当设置为`false`时，在允许禁用签名的虚拟机中将不检查签名。默认为`true`。

### 质押

`--staking-port` \(字符串\):

绑定服务器将通过该端口从外部连接到Avalanche网络。默认为`9651`。

`--p2p-tls-enabled` \(布尔\):

Avalanche使用双向身份验证的TLS连接来安全地识别连接对的`stakingID`。但是，可以在测试时禁用此功能。当禁用TLS时，`stakingID`将从节点拥有的IP地址派生出来。这也将禁用节点间通信的加密。这应该只用于测试。默认为 `true`。当`--staking-enabled=true`时，这必须为真。

`--staking-enabled` \(布尔\):

Avalanche使用权益证明(PoS)作为Sybil抵抗，使攻击网络的代价高昂。当这是`true`时，`--p2p-tls-enabled`必须设置为`true`，以保护P2P通信。

`--staking-tls-cert-file` \(字符串、文件路径\):

当`--p2p-tls-enabled=true`时，Avalanche使用双向认证TLS连接安全地识别连接对的`stakingID`。此参数指定节点使用的TLS证书的位置。当`--p2p-tls-enabled=true`时必须指定。默认为`""`。

`--staking-tls-key-file` \(字符串、文件路径\):

当`--p2p-tls-enabled=true`时，Avalanche使用双向认证TLS连接安全地识别连接对的`stakingID`。此参数指定节点使用的TLS私钥的位置。当`--p2p-tls-enabled=true`时必须指定。默认为`""`。

`--staking-disabled-weight` \(整数\):

当锁定被禁用时，提供给每个对等点的重量。默认为“1”。

### 版本

`--version` \(布尔\)

如果这是`true`，打印版本并退出。默认为`false`。

## 高级选项

以下选项会影响平台的正确性。它们可能需要在整个网络范围内进行更改，因此，普通用户不应该更改缺省值。

### Benchlist

`--benchlist-duration` \(持续时间\):

在超过`--benchlist-fail-threshold`之后，一个对等点被列入基准测试的时间。默认为`1h`。

`--benchlist-fail-threshold` \(整数\):

在对一个节点进行测试之前连续失败的查询数(假设对它的所有查询都失败)默认为`10`。

`--benchlist-peer-summary-enabled` \(布尔\):

启用特定于对等点的查询延迟度量。默认为`false`。

`--benchlist-min-failing-duration` \(持续时间\):

在对对等体进行测试之前，发送到对等体的消息必须失败的最小时间量, 默认为`5m`。

### 共识的参数

`--consensus-gossip-frequency` \(持续时间\):

谈论公认的边界之间的时间, 默认为`10s`。

`--consensus-shutdown-timeout` \(持续时间\):

在剔除一个没有反应的链之前超时, 默认为`5s`。

`--creation-tx-fee` \(整数\):

以nAVAX来付用于创建新状态的交易费。默认为每个交易需要 `1000000`nAVAX \(.001AVAX \)。

`--min-delegator-stake` \(整数\):

nAVAX的最小质押份额可以委托给主网络的验证者。

在主网, 默认值是`25000000000` \(25 AVAX\) 。
在测试网, 默认值是`5000000` \(.005 AVAX\) 。

`--min-delegation-fee` \(整数\):

通过主网进行委托的最低费用，乘以`10,000`。必须在`[0, 1000000]`的范围内。主网默认为`20000`  \(2%\)。

The minimum delegation fee that can be charged for delegation on the Primary Network, multiplied by `10,000` . Must be in the range `[0, 1000000]`. Defaults to `20000` \(2%\) on Main Net.

`--min-stake-duration` \(duration\):

Minimum staking duration. The Default on Main Net is `336h` \(two weeks.\)

`--min-validator-stake` \(int\):

The minimum stake, in nAVAX, required to validate the Primary Network.

Defaults to `2000000000000` \(2,000 AVAX\) on Main Net. Defaults to `5000000` \(.005 AVAX\) on Test Net.

`--max-stake-duration` \(duration\):

The maximum staking duration, in hours. Defaults to `8760h` \(365 days\) on Main Net.

`--max-validator-stake` \(int\):s

The maximum stake, in nAVAX, that can be placed on a validator on the primary network. Defaults to `3000000000000000` \(3,000,000 AVAX\) on Main Net. This includes stake provided by both the validator and by delegators to the validator.

`--snow-avalanche-batch-size` \(int\):

DAG implementations of Snow consensus define `b` as the number of transactions a vertex should include. Increasing `b` will, theoretically, increase throughput while increasing latency. The node will wait for at most 1 second to collect a batch, and will then issue the entire batch at once. The value must be at least `1`. Defaults to `30`.

`--snow-avalanche-num-parents` \(int\):

DAG implementations of Snow consensus define `p` as the number of parents a vertex should include. Increasing `p` will improve the amortization of network queries. However, by increasing the connectivity of the graph, the complexity of the graph traversals is increased. The value must be at least `2`. Defaults to `5`.

`--snow-concurrent-repolls` \(int\):

Snow consensus requires repolling transactions that are issued during low time of network usage. This parameter lets one define how aggressive the client will be in finalizing these pending transactions. This should only be changed after careful consideration of the tradeoffs of Snow consensus. The value must be at least `1` and at most `--snow-rogue-commit-threshold`. Defaults to `4`.

`--snow-sample-size` \(int\):

Snow consensus defines `k` as the number of validators that are sampled during each network poll. This parameter lets one define the `k` value used for consensus. This should only be changed after careful consideration of the tradeoffs of Snow consensus. The value must be at least `1`. Defaults to `20`.

`--snow-quorum-size` \(int\):

Snow consensus defines `alpha` as the number of validators that must prefer a transaction during each network poll to increase the confidence in the transaction. This parameter lets us define the `alpha` value used for consensus. This should only be changed after careful consideration of the tradeoffs of Snow consensus. The value must be at greater than `k/2`. Defaults to `14`.

`--snow-virtuous-commit-threshold` \(int\):

Snow consensus defines `beta1` as the number of consecutive polls that a virtuous transaction must increase its confidence for it to be accepted. This parameter lets us define the `beta1` value used for consensus. This should only be changed after careful consideration of the tradeoffs of Snow consensus. The value must be at least `1`. Defaults to `15`.

`--snow-rogue-commit-threshold` \(int\):

Snow consensus defines `beta2` as the number of consecutive polls that a rogue transaction must increase its confidence for it to be accepted. This parameter lets us define the `beta2` value used for consensus. This should only be changed after careful consideration of the tradeoffs of Snow consensus. The value must be at least `beta1`. Defaults to `30`.

`--stake-minting-period` \(duration\):

Consumption period of the staking function, in hours. The Default on Main Net is `8760h` \(365 days\).

`--tx-fee` \(int\):

The required amount of nAVAX to be burned for a transaction to be valid. This parameter requires network agreement in its current form. Changing this value from the default should only be done on private networks. Defaults to `1000000` nAVAX per transaction.

`--uptime-requirement` \(float\):

Fraction of time a validator must be online to receive rewards. Defaults to `0.6`.

### Message Handling

`--max-non-staker-pending-msgs` \(int\):

Maximum number of messages a non-staker is allowed to have pending. Defaults to `20`.

`--staker-msg-reserved` \(float\):

Portion of pending message buffer reserved for messages from validators. Defaults to `0.375`.

`--staker-cpu-reserved` \(float\):

Portion of chain’s CPU time reserved for messages from validators. Defaults to `0.375`.

### Network

`--network-initial-timeout` \(duration\):

Initial timeout value of the adaptive timeout manager, in nanoseconds. Defaults to `5s`.

`--network-minimum-timeout` \(duration\):

Minimum timeout value of the adaptive timeout manager, in nanoseconds. Defaults to `2s`.

`--network-maximum-timeout` \(duration\):

Maximum timeout value of the adaptive timeout manager, in nanoseconds. Defaults to `10s`.

`--network-timeout-halflife` \(duration\):

Halflife used when calculating average network latency. Larger value --&gt; less volatile network latency calculation. Defaults to `5m`.

`--network-timeout-coefficient` \(duration\):

Requests to peers will time out after \[`network-timeout-coefficient`\] \* \[average request latency\]. Defaults to `2`.

`--network-health-min-conn-peers` \(uint\):

Node will report unhealthy if connected to less than this many peers. Defaults to `1`.

`--network-health-max-time-since-msg-received` \(duration\):

Node will report unhealthy if it hasn't received a message for this amount of time. Defaults to `1m`.

`--network-health-max-time-since-no-requests` \(duration\):

Node will report unhealthy if it hasn't received a message for this amount of time. Defaults to `1m`.

`--network-health-max-portion-send-queue-full` \(float\):

Node will report unhealthy if its send queue is more than this portion full. Must be in \[0,1\]. Defaults to `0.9`.

`--network-health-max-send-fail-rate` \(float\):

Node will report unhealthy if more than this portion of message sends fail. Must be in \[0,1\]. Defaults to `0.25`.

### Health

`--health-check-frequency` \(duration\):

Health check runs with this freqency. Defaults to `30s`.

`--health-check-averager-halflife` \(duration\):

Halflife of averagers used in health checks \(to measure the rate of message failures, for example.\) Larger value --&gt; less volatile calculation of averages. Defaults to `10s`.

### Throughput Server

`--xput-server-enabled` \[Deprecated\] \(boolean\):

An optional server helps run throughput tests by injecting load into the network on command. If enabled, this server is started up and listens for commands from a test coordinator. Defaults to `false`.

`--xput-server-port` \[Deprecated\] \(string\):

This option lets one specify on which port the throughput server, if enabled, will listen. Defaults to `9652`.

### Subnet Whitelist

`--whitelisted-subnets` \(string\):

Comma separated list of subnets that this node would validate if added to. Defaults to empty \(will only validate the Primary Network\).

### Restart on Disconnect

Some users have had an issue where their AvalancheGo node gets into an unhealthy state when their node loses internet connectivity or when their IP address changes. To help deal with this, there are command line flags that cause the node to restart if it disconnected from all peers. They are:

`--restart-on-disconnected` \(boolean, defaults to `false`\)

`--disconnected-check-frequency` \(duration, defaults to `10s`\)

`--disconnected-restart-timeout` \(duration, defaults to `1m`\)

If `restart-on-disconnected` is `true`, the node will check every `disconnected-check-frequency` to see whether it has lost connection to all peers. If the node has lost connection to all peers for `disconnected-restart-timeout`, it will restart.

If `restart-on-disconnected` is `false` or either`disconnected-check-frequency` or`disconnected-restart-timeout` is 0, node will not restart.

### Plugins

`--plugin-dir` \(string, file path\):

Specifies the directory in which the `evm` plugin is kept. Defaults to `"$HOME/.avalanchego/build/plugins"`.

`--coreth-config` \(json\):

This allows you to specify a config to be passed into Coreth, the VM running the C Chain. The default values for this config are:

```cpp
{
    "snowman-api-enabled": false,
    "coreth-admin-api-enabled": false,
    "net-api-enabled": true,
    "rpc-gas-cap": 2500000000,
    "rpc-tx-fee-cap": 100,
    "eth-api-enabled": true,
    "personal-api-enabled": true,
    "tx-pool-api-enabled": true,
    "debug-api-enabled": false,
    "web3-api-enabled": true
}
```

Note: if a config is specified, all default options are overridden. For example:

```text
./build/avalanchego --config-file=config.json
```

config.json:

```cpp
{
    "coreth-config": {
        "snowman-api-enabled": false,
        "coreth-admin-api-enabled": false,
        "net-api-enabled": true,
        "rpc-gas-cap": 2500000000,
        "rpc-tx-fee-cap": 100,
        "eth-api-enabled": true,
        "tx-pool-api-enabled": true,
        "debug-api-enabled": true,
        "web3-api-enabled": true
    }
}
```

Since the option `personal-api-enabled` is excluded, it will be set to false and disable the `personal_*` namespace.

The options specify parameters for Coreth \(the C Chain\) as follows:

* `snowman-api-enabled` -&gt; Enables Snowman API.
* `coreth-admin-apienabled` -&gt; Enables Admin API on Coreth plugin.
* `net-api-enabled` -&gt; Enables `net_*` API.
* `rpc-gas-cap` -&gt; Sets the maximum gas to be consumed by an RPC Call \(used in `eth_estimateGas`\)
* `rpc-tx-fee-cap` -&gt; Sets the global transaction fee \(price \* gaslimit\) cap for send-transction variants. The unit is AVAX.
* `eth-api-enabled` -&gt; Enables `eth_*` API.
* `personal-api-enabled` -&gt; Enables `personal_*` API.
* `tx-pool-api-enabled` -&gt; Enables `txpool_*` API.
* `debug-api-enabled` -&gt; Enables `debug_*` API.
* `web3-api-enabled` -&gt; Enables `web3_*` API.

<!--stackedit_data:
eyJoaXN0b3J5IjpbMTMyNjQ2NDY5NiwxMjI1MzM0MTE1LDE3NT
g2NDU1MDMsLTMzMTIxNDkyMiwxNTI2MTE2MTQzLDU5NDAyNDM0
NywxMzcxODI2OTc2LDEwNTY3MTE5NjgsLTQ5NDgxMjQ1OCw0Nj
I2NjQwODgsLTEyMTMzMTkyODcsMzQ4MjI0ODY4LDE0NDE5OTc4
MDgsLTI0ODU1NzAzNCwxOTkwOTUxMjY0XX0=
-->