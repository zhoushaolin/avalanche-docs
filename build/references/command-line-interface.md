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

`--bootstrap-retry-max-attempts` \(uint\):

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

`--min-stake-duration` \(持续时间\):

最低质押时间。主网络上的默认是`336h`\(两周\)。

`--min-validator-stake` \(整数\):

验证主网络所需的nAVAX最低质押。

在主网上, 默认为`2000000000000` \(2,000 AVAX\) 。
在测试网上, 默认为`5000000` \(.005 AVAX\) 。

`--max-stake-duration` \(持续时间\):

最大持续质押时间，单位为小时。主网默认为`8760h`\(365天\)。

`--max-validator-stake` \(整数\):s

以nAVAX为单位的最大质押份额，可以放置在主网络上的验证器上。在主网上默认为`3000000000000000` \(3,000,000 AVAX\)。这包括验证器和委托器向验证器提供的质押。

`--snow-avalanche-batch-size` \(整数\):

雪人共识的DAG实现将`b`定义为一个顶点应该包含的交易数。从理论上讲，增加`b`将增加吞吐量，同时增加延迟。节点将最多等待1秒来收集一个批处理，然后将立即发出整个批处理。取值至少为`1`。默认为`30`。

`--snow-avalanche-num-parents` \(整数\):

雪人共识的DAG实现将`p`定义为一个顶点应该包含的父结点的数量。增加`p`将改善网络查询的摊销。然而，通过增加图表的连通性，图表遍历的复杂性也会增加。取值至少为`2`。默认为 `5`。

`--snow-concurrent-repolls` \(整数\):

雪人共识要求重新轮询在网络使用率较低时发出的交易。此参数允许定义客户端在完成这些未决交易时的积极程度。只有在仔细考虑了雪人共识的权衡之后，才应该改变这一点。取值至少为`1`，最多为`--snow-rogue-commit-threshold`。默认为`4`。

`--snow-sample-size` \(整数\):

雪人共识将`k`定义为在每次网络调查中抽样的验证者的数量。这个参数允许定义用于一致性的`k`值。只有在仔细考虑了雪人共识的权衡之后，才应该改变这一点。取值至少为`1`。默认为`20`。

`--snow-quorum-size` \(整数\):

雪人共识将`alpha`定义为在每次网络轮询期间必须选择某个交易以增加对该交易的信心的验证器的数量。这个参数让我们定义用于共识的`alpha`值。只有在仔细考虑了雪人共识的权衡之后，才应该改变这一点。该值必须大于`k/2`。默认为`14`。

`--snow-virtuous-commit-threshold` \(整数\):

雪人共识将`beta1`定义为一个良性交易必须增加信心才能被接受的连续民意调查的数量。这个参数让我们定义用于共识的`beta1`值。只有在仔细考虑了雪人共识的权衡之后，才应该改变这一点。取值至少为`1`。默认为`15`。

`--snow-rogue-commit-threshold` \(整数\):

雪人共识将`beta2`定义为一个流氓交易必须增加信心才能被接受的连续民意调查次数。这个参数让我们定义用于共识的`beta2`值。只有在仔细考虑了雪人共识的权衡之后，才应该改变这一点。该值至少为`beta1`。默认为`30`。

`--stake-minting-period` \(持续时间\):

质押功能的消耗周期，单位为小时。主网上的默认值是`8760h` \(365天\)。

`--tx-fee` \(整数\):

交易有效需要烧掉的nAVAX金额, 该参数需要当前形式的网络协议。将此值从默认值改为仅应在专用网络上进行。每笔交易默认为 `1000000`nAVAX。

`--uptime-requirement` \(浮动\):

验证者必须在线接受奖励的时间, 默认为`0.6`。

### 消息处理

`--max-non-staker-pending-msgs` \(整数\):

非质押者允许等待的最大消息数, 默认为`20`。

`--staker-msg-reserved` \(浮动\):

为来自验证器的消息保留的等待消息缓冲区的一部分, 默认为`0.375`。

`--staker-cpu-reserved` \(浮动\):

为来自验证器的消息保留的部分的链CPU时间, 默认为`0.375`。

### 网络

`--network-initial-timeout` \(持续时间\):

自适应超时管理器的初始超时值，单位为纳秒, 默认为`5s`。

`--network-minimum-timeout` \(持续时间\):

自适应超时管理器的最小超时值，单位为纳秒。默认为`2s`。

`--network-maximum-timeout` \(持续时间\):

自适应超时管理器的最大超时值，单位为纳秒。默认为`10s`。

`--network-timeout-halflife` \(持续时间\):

计算平均网络延迟时使用的半衰期。更大的值 --&gt; 更小的易失性网络延迟计算, 默认为`5m`。

`--network-timeout-coefficient` \(持续时间\):

对等点的请求将在\[`network-timeout-coefficient`\] \* \[平均请求延迟\] 后超时, 默认为`2`。

`--network-health-min-conn-peers` \(uint\):

如果连接到的对等体少于这个数目，节点将报告不健康。默认为`1`。

`--network-health-max-time-since-msg-received` \(持续时间\):

如果在此时间内未收到消息，节点将报告不健康。默认为`1m`。

`--network-health-max-time-since-no-requests` \(持续时间\):

如果在此时间内未收到消息，节点将报告不健康。默认为`1m`。

`--network-health-max-portion-send-queue-full` \(浮动\):

如果节点的发送队列超过该部分，则节点将报告不健康。必须在\[0,1\]中。默认为`0.9`。

`--network-health-max-send-fail-rate` \(浮动\):

如果超过此部分的消息发送失败，节点将报告不健康。必须在\[0,1\]中。默认为`0.25`。

### 健康

`--health-check-frequency` \(持续时间\):

运行状况检查以此频率运行。默认为`30s`。

`--health-check-averager-halflife` \(持续时间\):

运行状况检查中使用的平均值的半衰期\(例如，测量消息失败率\)较大值--&gt; 减少平均数的不稳定计算。默认为`10s`。

### 吞吐量服务器

`--xput-server-enabled` \[已弃用\] \(布尔\):

一个可选的服务器通过命令将负载注入网络来帮助运行吞吐量测试。如果启用，该服务器将启动并侦听来自测试协调器的命令。默认为`false`。

`--xput-server-port` \[已弃用\] \(字符串\):

该选项允许指定吞吐量服务器(如果启用)将侦听的端口。默认为`9652`。

### 子网白名单

`--whitelisted-subnets` \(字符串\):

逗号分隔的子网列表，该节点将验证添加到其中的子网。默认为空\(只验证主网络\)。

### Restart on Disconnect

有些用户遇到过这样的问题，即当他们的节点失去互联网连接或IP地址更改时，他们的AvalancheGo节点进入不健康状态。为了帮助解决这个问题，有一些命令行标志会导致节点在与所有对等节点断开连接时重新启动。它们是:
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
eyJoaXN0b3J5IjpbLTM1MTA1MDcwLC0xNjc0MTU0NTM4LC05NT
E5Mjc2NTMsMjgyODEzNjUxLDM0NDcxOTYxOCwtMTM1ODY5MDg3
MywxMjI1MzM0MTE1LDE3NTg2NDU1MDMsLTMzMTIxNDkyMiwxNT
I2MTE2MTQzLDU5NDAyNDM0NywxMzcxODI2OTc2LDEwNTY3MTE5
NjgsLTQ5NDgxMjQ1OCw0NjI2NjQwODgsLTEyMTMzMTkyODcsMz
Q4MjI0ODY4LDE0NDE5OTc4MDgsLTI0ODU1NzAzNCwxOTkwOTUx
MjY0XX0=
-->