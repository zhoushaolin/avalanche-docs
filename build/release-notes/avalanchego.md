# AvalancheGo 发布说明


## v1.3.1 AvalancheGo 发布说明 \([在GitHub上查看](https://github.com/ava-labs/avalanchego/releases/tag/v1.3.1)\)

这个更新是向后兼容的。它是可选的，但鼓励使用。该补丁包括稳定性、监控改进和小错误修复。

**本次升级的主要组件包括:**

* 修正了在arm64 CPU上执行压缩时C链段错误。
* 为本地文件添加组权限，以启用复杂的节点监控。
* 通过api-auth-password-file标志从Auth密码中剥离空白。
* 删除timeSinceNoOutstandingRequests, 因为它被longestRunningRequest取代。
* 在网络节流中增加了额外的指标。
* 各种代码清理。

**添加命令行参数:**

* `network-health-max-outstanding-request-duration`

**删除命令行参数:**

* `network-health-max-time-since-no-requests`


## v1.3.0 AvalancheGo 发布说明\([在GitHub上查看](https://github.com/ava-labs/avalanchego/releases/tag/v1.3.0)\)

请注意，此更改与以前的版本不向后兼容。
****  
这次升级降低了C链的gas费用，取消了C链的gas退款，并包括各种安全改进。我们敦促社区中的每个人尽快更新，以确保他们的节点保持健康。

升级的改变将于2021年3月25日东部时间上午10点在富士测试网和2021年3月31日东部时间上午10点在主网生效。

**本次升级的主要组件包括:**

* C链gas成本从470 nAVAX降低到225 nAVAX。
* 取消C链gas退款。这一变化采用[EIP-3298](https://eips.ethereum.org/EIPS/eip-3298)。
* 重构C链验证，使其在执行网络升级时更干净。
* 修正了Auth API以正确地执行被撤销的代币。
* 加强了Auth API，以确保使用了预期的签名格式。
* 从CLI参数中删除了Auth API的密码。
* 增加了更严格的文件权限检查。
* 添加了一些次要的附加错误处理。
* 在写到磁盘之前，经过消毒的日志写操作。
* 向HTTP端点添加可配置的源。
* 删除启动时尝试的HTTPs到HTTP的故障转移。现在，如果将HTTP端点升级为HTTPs失败，该节点将在启动时关闭。

**添加命令行参数:**

* `api-auth-password-file` 指定从哪个文件中读取Auth API的密码。

**删除命令行参数:**

* `api-auth-password`

## **v1.2.4 AvalancheGo 发布说明 \(**[**在GitHub上查看**](https://github.com/ava-labs/avalanchego/releases/tag/v1.2.4)**\)**

这个更新是向后兼容的。它是可选的，但鼓励使用。该补丁包括稳定性和监控方面的改进。

* 更新自述文件以纠正存储要求。
* 在引导期间向AvalancheTx验证添加了额外的错误处理。
* 更新了许多指标，包括添加与节点运行状况和数据库使用有关的许多新指标，删除未使用的和无效的指标，并修复一些指标名称。
* 向CI添加额外的日志记录。
* 将C链添加到关键链列表中。

## **v1.2.3 AvalancheGo 发布说明\(**[**在GitHub上查看**](https://github.com/ava-labs/avalanchego/releases/tag/v1.2.3-signed)**\)**

这个更新是向后兼容的。它是可选的，但鼓励使用。该补丁包括稳定性和监控方面的改进。

* 调整`[network, router, consensus]`健康检查参数，以删除薄片健康检查。
* 简化C链块处理。

## **v1.2.2 AvalancheGo 发布说明 \(**[**在GitHub上查看**](https://github.com/ava-labs/avalanchego/releases/tag/v1.2.2)**\)**

这个更新是向后兼容的。它是可选的，但鼓励使用。该补丁包括稳定性、性能和监控方面的改进。

* 在网络库中添加IP别名，以避免重复的`SYN` 调用。
* 修正了从自己引导时的引导消息处理。
* 简化了`AdvanceTimeTx` 发行。
* 增加了新的共识健康检查。
* 添加节点运行状况日志记录。
* 向运行状况`GET`请求添加运行状况响应。
* 合并传入消息日志。
* 添加错误日志到`LevelDB`包装器。
* 向`rpcdb`添加错误代码以避免字符串解析。
* 改进了规范链的C链处理，减少了重整的数量。
* 改进了对`pending`块执行的模拟调用的C链处理。

## **v1.2.1 AvalancheGo 发布说明\(**[**在GitHub上查看**](https://github.com/ava-labs/avalanchego/tree/v1.2.1)**\)**

这个更新是向后兼容的。它是可选的，但鼓励使用。该补丁包括稳定性、性能和监控方面的改进。

请注意，此更新删除了\`network-timeout-increase\`和\' network-timeout-reduction\'作为命令行参数。

更改摘要:

* 添加了\`UTXO\`到\`platformvm.getStake\`响应。
* 增加了基准列表报告到 \`info.peers\` 响应。
* 向网络层添加了额外的健康检查。
* 增加了\`percent of stake connected\`作为报告指标。
* 添加了引导重启逻辑，以确保节点跟上当前提示，即使在高吞吐量时期也是如此。
* 增加了子网范围内的引导，以确保一个链不会因另一个链的引导而落后。
* 防止被拒绝块的验证，以避免不必要的计算。
* 移除了闲言碎语的非首选块到网络。
* 切换网络超时计算器以使用观察到的网络延迟的EWMA。
* 从网络延迟计算中删除了\`Get\`请求。
* 清理了基准列表算法。
* 清除了发送时丢弃消息的处理。
* 清理未完成的请求和超时逻辑。
* 通用性能跟踪，允许配置文件名称的前缀。
* 为Avalanche引导遍历添加了额外的缓存。
* 修复 ansible。
* 新增的命令行参数主要包括健康检查的配置。此外，修改后的网络延迟计算更改了一些命令行参数的名称。

增加了命令行参数: 

* \`network-timeout-halflife\`
* \`network-timeout-coefficient\`
* \`network-health-min-conn-peers\`
* \`network-health-max-time-since-msg-received\`
* \`network-health-max-time-since-msg-sent\`
* \`network-health-max-portion-send-queue-full\`
* \`network-health-max-send-fail-rate\`
* \`network-health-max-time-since-no-requests\`
* \`router-health-max-drop-rate\`
* \`router-health-max-outstanding-requests\`
* \`health-check-frequency\`
* \`health-check-averager-halflife\`
* \`bootstrap-retry-enabled\`
* \`bootstrap-retry-max-attempts\`

删除命令行参数:

* \`network-timeout-increase\`
* \`network-timeout-reduction\`

## v1.2.0 AvalancheGo发布说明\([在GitHub上查看](https://github.com/ava-labs/avalanchego/tree/v1.2.0)\)

**请注意，此补丁与以前的版本不向后兼容。此升级修复了与X、C和P链之间交换传输相关的性能问题。我们敦促社区的每个人尽快升级，以确保他们的节点不受影响。此外，请注意，升级后节点可能需要多花几分钟来连接，应该允许该过程不间断地完成。**

本次升级的主要组件包括:

* 修正了C链上的原子导入验证
* 增加了允许原子奖励块的规则异常逻辑
* 如果发出重复删除，将快速故障逻辑添加到共享内存中
* 修正了雪人中由于未能清除请求而导致投票停滞的问题
* 修复了未知祖先造成的坏块问题
* 修正了在核心修复规范链脚本中的竞争条件
* 限制了在雪人和 Avalanche中的处理块和处理txs的数量
* 更新了网络超时默认值和基准测试列表设置 
* 初始网络不稳定后验证无安全违规

## v1.1.5 AvalancheGo 发布说明 \([在GitHub上查看](https://github.com/ava-labs/avalanchego/tree/v1.1.5)\)

这个更新是向后兼容的。它是可选的，但鼓励使用。该补丁包括稳定性改进。

* 修正了注册新链时可能导致P链和http端点阻塞的潜在死锁。
* 修复 TxID -&gt; C链中的块高度索引。
* 在C链中的调试\_traceTransaction API中添加了对空契约部署的优雅处理。
* 改进了C链中的错误处理。

## v1.1.4 AvalancheGo 发布说明 \([在GitHub上查看](https://github.com/ava-labs/avalanchego/tree/v1.1.4)\)

这个更新是向后兼容的。它是可选的，但鼓励使用。该补丁包括CLI升级、API bug修复、稳定性改进和性能改进。

* 修正了一个问题，C链块索引可以映射到给定高度的不接受的块。
* 修复了RPCChainVM经历高API负载时的虚拟机崩溃。
* 修正了雪崩引擎中的乐观投票冒泡，以正确地通过处理顶点投票。
* 增加字段IncludePartial的AVM的GetBalance和GetAllBalances API方法。这将改变默认行为，只返回可使用的和唯一拥有的资产的余额。
* 增加了为自定义网络ID指定自定义创建配置的能力。
* 增加了额外的IPC API功能。
* 增加了额外的缓存到RPCChainVM。
* 改进插件目录查找，以始终与二进制版本一起工作。

## v1.1.3 AvalancheGo 发布说明\([在GitHub上查看](https://github.com/ava-labs/avalanchego/tree/v1.1.3)\)

此更新是可选的，但鼓励更新。该补丁包括与API相关的小错误修复。

* 修正了试图过滤C链日志时代解决调用问题。
* 修正了C链客户端调用正确的多币API。
* 添加 `getAtomicUTXOs` 到 `avm` 和 `platformvm` API客户端。

## v1.1.2 AvalancheGo 发布说明 \([在GitHub上查看](https://github.com/ava-labs/avalanchego/releases/tag/v1.1.2)\)

此更新是可选的，但鼓励更新。该补丁包括错误修复和性能改进。

* 修正引导处理缓存，引导雪崩时, 以减少重复遍历。
* 引导过程中优化的P链验证。
* 修正最大基准列表计算使用适当的输入值。
* 从CI删除了额外的linter运行。
* 添加`Height` 到 `snowman.Block` 接口。

## v1.1.1 AvalancheGo 发布说明\([在 GitHub上查看](https://github.com/ava-labs/avalanchego/releases/tag/v1.1.1)\) 

此更新是可选的，但鼓励更新。该补丁包括错误修复和性能改进。

* 修正了当用户禁用`Health`API时节点崩溃的bug。
* 修正了一个在正常运行时间跟踪可能超过报告一个节点的正常运行时间的bug。
* 重构顶点解析使用`Codec`。
* 分离有状态和无状态顶点管理。
* 在编解码器中添加了每字段切片长度检查。
* 引入了一种新的编解码器类型，将`TypeID`分组在一起。
* 引入消息限制标志到CLI中。
* 引入了一个语义数据库包，用于将来的数据库迁移。
* 向链上下文添加Epoch跟踪。
* 改进了事务验证期间返回的一些错误消息。
* 减少了版本数据库中的GC压力。

## v1.1.0 AvalancheGo 发布说明\([在GitHub上查看](https://github.com/ava-labs/avalanchego/releases/tag/v1.1.0)\)

**请注意，此升级与以前的版本不向后兼容。升级必须不迟于12月7日星期一UTC晚上11点(东部标准时间下午6点)。这次升级原本计划在12月中旬，现在正在加速修复一个重要的代币解锁bug。我们敦促社区的每个人尽快升级，以确保大家节点不受影响。**

这个升级有两个主要组件:

* 为即将到来的Apricot网升级(Apricot 零期升级)做综合准备
* 修复了一个锁定时间过后阻止可质押的锁定输出被解锁的问题

## v1.0.6 AvalancheGo 发布说明 \([在GitHub上查看](https://github.com/ava-labs/avalanchego/releases/tag/v1.0.6)\)

请注意，发布内容包含了破坏性更改, 在[这里](https://docs.avax.network/build/apis/deprecated-api-calls)查看。它改变了platform.getTxStatus和platform.getCurrentValidators的默认响应格式。更新是可选的，但鼓励更新。该补丁包括性能改进和一些生命质量改进。

* 删除了弃用的platform.getTxStatus 和platform.getCurrentValidators格式。
* 增加了对从keystore API导入和导出用户的十六进制编码的支持。
* 将golang要求设置为v1.15.5，以避免在golang标准库中发现DoS漏洞。
* 添加API客户端作为与节点软件交互的助手。
* 如果一个节点与网络的其余部分断开连接，则启用恢复引导。
* 修正了当UTXO引用多个地址时的GetUTXOs API。
* 重构二进制编码以更好地泛化RPC选项。
* 修复IP块过滤, 以合理设置窗口长度。
* 推广编解码器包, 使其能够管理多个不同版本的编解码器。
* 添加Epoch到顶点界面，为未来的发布做准备。
* 延迟交易哈希以减少快速检查时的CPU/内存利用率。
* 对于那些使用[https://explorerapi.avax-dev.network/](https://explorerapi.avax-dev.network/)的用户，该URL将在未来的版本中被关闭。请转到[https://explorerapi.avax.network/](https://explorerapi.avax.network/)。

更新如需帮助，请关注我们的[开发者常见问题解答](https://support.avalabs.org/en/collections/2618154-developer-faq)，如果你仍然遇到问题，你可以加入我们的[Discord](https://chat.avax.network/)寻求帮助。

## v1.0.5 AvalancheGo 发布说明  \([在GitHub上查看](https://github.com/ava-labs/avalanchego/releases/tag/v1.0.5)\)

请注意，v1.0.6这个版本之后的版本，将包含破坏性更改, 在[这里](https://docs.avax.network/build/apis/deprecated-api-calls)查看。即`platform.getTxStatus` 和`platform.getCurrentValidators` 的响应格式将发生改变。

v1.0.5这个版本中的变化与以前的版本向后兼容。更新是可选的，但鼓励更新。该补丁包括性能改进和一些生命质量改进。

* 添加了`IssueTx`和`GetUTXOs`到C链 API，以允许在不向节点显示私钥的情况下, 发布原子交换而。
* 修复了使用oracle块处理雪人请求管理器中的内存泄漏问题。
* 修复未报告可用资金的UTXO分页bug。
* 将链http日志移动到可读的链日志文件夹中。
* 重新构造ID的管理方式，以避免堆式分配。
* 优化`UniformSampler`，避免创建多个地图。
* 减少使用`ids.Set`, 而使用`[]ids.ID`, 更好地利用连续内存。
* 在`PrefixDB`中引进`[]byte`重新使用。  
* 实现特定类型的排序函数，以避免频繁的接口转换分配。
* 优化AVM加载用户，以避免从磁盘读取不必要的信息。
* 删除了一个内存分配+复制套接字发送的完整长度的消息。

如需帮助，请关注我们的[开发者常见问题解答](https://support.avalabs.org/en/collections/2618154-developer-faq)，如果你仍然遇到问题，你可以加入我们的[Discord](https://chat.avax.network)寻求帮助。


## v1.0.4 AvalancheGo 发布说明\([在GitHub上查看](https://github.com/ava-labs/avalanchego/releases/tag/v1.0.4)\)

![AvalancheGo release notes v1.0.4.png](../../.gitbook/assets/image%20%2817%29.png)

此更新是可选的，但鼓励更新。该补丁包括生命质量改进和各种性能的增强。注意，此更新要求使用——而不是允许使用-或——来指定CLI参数。例如，`-public-ip=127.0.0.1`不再被允许，必须指定为`--public-ip=127.0.0.1`。否则，此更新是向后兼容的。

```
• 添加子网白名单，允许节点所有者选择验证哪个子网。
```

```text
• 增加了节点设置的配置文件解析。
• 添加更多指定节点IP地址的选项，并将getNodeIP添加到info *endpoint。
• 在platformvm中, 向get.Validators的结果添加TxID。platformvm中的验证器。
• Coreth版本更新。
• 清理了雪球尝试实现，并添加了额外的测试以与突变测试保持一致。Cleaned up the snowball trie implementation and added additional tests to align with mutation tests.
• Implemented and optimized continuous time averages for tracking CPU and network latency.
• Significantly optimized memory allocations in various locations.
• Increased the signature verification cache size.
• Reduced DB reads during vertex management.
```

```text
• Added an optional argument includeReason to platform.getTxStatus.
If not provided, or if false, the output from getTxStatus is the same as before.

For example:
{
    "jsonrpc": "2.0",
    "result": "Dropped",
    "id": 1
}

If includeReason is true, the output from getTxStatus has a new format. It's an object that looks like this:

{
    "jsonrpc": "2.0",
    "result": {
        "status":"[Status]",
        "reason":"[Reason tx was dropped, if applicable]"
    },
    "id": 1
}

In this new format, reason will not be present unless the status is Dropped.
Anything that depends on platform.getTxStatus should switch to using the includeReason argument and use the new response format. After a few releases, we'll only support the new response format.
```

如需帮助，请关注我们的[开发者常见问题解答](https://support.avalabs.org/en/collections/2618154-developer-faq)，如果你仍然遇到问题，你可以加入我们的[Discord](https://chat.avax.network)寻求帮助。
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTEyNDkwMDIzMjUsLTE0MDEwMDcwMDUsMT
c1MTM2NjM1MywyNjYxMDk0MTgsMTE0NTQ4NDAyNCwxMzcwODUw
MTgyLC00MTMwMzI0NSwtNzEzMTU5MDIyLC0xNDQyMTI4NTM5LD
IwMjU3NDk4NjgsMTkwMzc5MjcxNiwtNzcyNjYwMDY3LC01NzEy
MzM1ODEsLTk2MjMzMDIxNywyMDY5MDEwODY2LC0xMzE3NDgwMj
U5LC0xMjc0MjUyNjc4LC01MjkwMjE0MTQsLTE0NzY0NzY3Njks
MjMzMzg3ODcwXX0=
-->