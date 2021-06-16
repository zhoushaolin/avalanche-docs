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

**Please note that this patch is not backwards compatible with previous releases. This upgrade fixes performance issues related to interchange transfers between X, C, and P chains. We urge everyone in the community to upgrade as soon as possible in order to ensure that their nodes are not affected. Also, note that nodes may take several extra minutes to connect after the upgrade and the process should be allowed to complete uninterrupted.**

The primary components to this upgrade include:

* Fixed atomic import validation on C-Chain
* Added rule exception logic to allow atomic bonus blocks
* Added fail-fast logic into Shared Memory if duplicated deletes are issued
* Fixed issue where polls could stall in snowman because of a failure to clear requests
* Fixed BAD BLOCK issue in coreth due to unknown ancestors
* Fixed a race condition in the repair canonical chain script in coreth
* Limited number of processing blocks in Snowman and processing txs in Avalanche
* Updated networking timeout default values and benchlist settings
* Verified there was no safety violation after the initial network instability

## v1.1.5 AvalancheGo Release Notes \([View on GitHub](https://github.com/ava-labs/avalanchego/tree/v1.1.5)\)

{% hint style="danger" %}
This update is backwards compatible. It is optional but encouraged. The patch includes stability improvements.
{% endhint %}

* Fixed a potential deadlock when registering new chains that could cause the P-chain and http\(s\) endpoint to block.
* Repairs TxID -&gt; Block Height indexing in the C-chain.
* Added graceful handling of empty contract deployments in the debug\_traceTransaction API in the C-chain.
* Improved error handling in the C-chain.

## v1.1.4 AvalancheGo Release Notes \([View on GitHub](https://github.com/ava-labs/avalanchego/tree/v1.1.4)\)

{% hint style="danger" %}
This update is backwards compatible. It is optional but encouraged. The patch includes CLI upgrades, API bug fixes, stability improvements, and performance improvements.
{% endhint %}

* Fixed an issue where C-chain block indexes could map to unaccepted blocks at a given height.
* Fixed VM crash when the RPCChainVM experienced high API loads.
* Fixed optimistic vote bubbling in the Avalanche Engine to correctly pass votes through processing vertices.
* Added field IncludePartial to the AVM's GetBalance and GetAllBalances API methods. This changes the default behavior to only return the balances of spendable and uniquely owned assets.
* Added the ability to specify custom genesis configs for custom network IDs.
* Added additional IPC API functionality.
* Added additional caching to the RPCChainVM.
* Improved plugin directory lookup to always work with the binary releases.

## v1.1.3 AvalancheGo Release Notes \([View on GitHub](https://github.com/ava-labs/avalanchego/tree/v1.1.3)\)

{% hint style="danger" %}
This update is optional but encouraged. The patch includes minor bug fixes relating to APIs.
{% endhint %}

* Fixed hanging call when attempting to filter C-chain logs.
* Fixed C-chain client to call the proper multi-coin API.
* Added `getAtomicUTXOs` to `avm` and `platformvm` API clients.

## v1.1.2 AvalancheGo Release Notes \([View on GitHub](https://github.com/ava-labs/avalanchego/releases/tag/v1.1.2)\)

{% hint style="danger" %}
This update is optional but encouraged. The patch includes bug fixes and performance improvements.
{% endhint %}

* Fixed bootstrapping processing cache to reduce duplicated traversals when bootstrapping Avalanche.
* Optimized P-chain verification during bootstrapping.
* Fixed maximum bench list calculation to use the proper input values.
* Removed extra linter runs from CI.
* Added `Height` to the `snowman.Block` interface.

## v1.1.1 AvalancheGo Release Notes \([View on GitHub](https://github.com/ava-labs/avalanchego/releases/tag/v1.1.1)\) 

{% hint style="danger" %}
This update is optional but encouraged. The patch includes bug fixes and performance improvements.
{% endhint %}

* Fixed a node crash bug when users disabled the `Health` API.
* Fixed a bug in uptime tracking that could over report a node's uptime.
* Refactored vertex parsing to use a `Codec`.
* Separated stateful and stateless vertex management.
* Added per-field slice length checking to the Codec.
* Introduced a new codec type that groups `TypeID`s together.
* Introduced message limit flags to the CLI.
* Introduced a semanticdb package to be used during a future database migration.
* Added Epoch tracking to the chain context.
* Improved some of the error messages returned during transaction validation.
* Reduced GC pressure in the version DB.

## v1.1.0 AvalancheGo Release Notes \([View on GitHub](https://github.com/ava-labs/avalanchego/releases/tag/v1.1.0)\)

{% hint style="danger" %}
**Please note that this upgrade is not backwards compatible with previous releases. Upgrades must be performed no later than Monday, December 7th at 11 p.m. UTC \(6 p.m. EST\). The upgrade, which was originally scheduled around mid December, is now being expedited to fix an important token unlocking bug. We urge everyone in the community to upgrade as soon as possible in order to ensure that their nodes are not affected.**
{% endhint %}

There are two primary components to this upgrade:

* General preparations for our upcoming Apricot network upgrade called the Apricot Phase Zero Upgrade
* Fixing an issue that prevented stake-able locked outputs from being unlocked after their lock ****time had passed

## v1.0.6 AvalancheGo Release Notes \([View on GitHub](https://github.com/ava-labs/avalanchego/releases/tag/v1.0.6)\)

{% hint style="danger" %}
Please note that this release contains breaking changes described [here](https://docs.avax.network/build/apis/deprecated-api-calls). It changes the default response format of platform.getTxStatus and platform.getCurrentValidators. The update is optional but encouraged. The patch includes performance improvements and some quality of life improvements.
{% endhint %}

* Removed deprecated formats of  platform.getTxStatus and platform.getCurrentValidators.
* Added support for hex encodings of imported and exported users from the keystore API.
* Set golang requirement to v1.15.5 to avoid a DoS vulnerability found in the golang standard lib.
* Added API clients to act as helpers interacting with the node software.
* Enabled falling back to bootstrapping if a node becomes disconnected from the rest of the network.
* Fixed the GetUTXOs APIs when UTXOs referenced multiple addresses.
* Refactored binary encoding to better generalize RPC options.
* Fixed IP block filtering to correctly set the window length.
* Generalized the codec package to be able to manage multiple codecs with different versions.
* Added Epoch to the Vertex interface in preparation of a future release.
* Deferred transaction hashing to reduce CPU/Memory utilization past fast checks.
* For those using [https://explorerapi.avax-dev.network/](https://explorerapi.avax-dev.network/), the URL is going to be shut down in a future release. Please switch over to [https://explorerapi.avax.network/](https://explorerapi.avax.network/). 

For assistance with this update, follow our [Developer FAQ](https://support.avalabs.org/en/collections/2618154-developer-faq), if you are still running into issues you can join our [Discord](https://chat.avax.network/) for help.

## v1.0.5 AvalancheGo Release Notes  \([View on GitHub](https://github.com/ava-labs/avalanchego/releases/tag/v1.0.5)\)

{% hint style="danger" %}
Please note that the release after this one, v1.0.6, will contain the breaking changes described [here](https://docs.avax.network/build/apis/deprecated-api-calls). Namely, the response format of `platform.getTxStatus` and `platform.getCurrentValidators` will change.
{% endhint %}

The changes in this release, v1.0.5, are backwards compatible with previous releases. The update is optional but encouraged. The patch includes performance improvements and some quality of life improvements.

* Added `IssueTx` and `GetUTXOs` to the C-chain API to enable issuing atomic swaps without revealing private keys to a node.
* Fixed memory leak in the snowman request manager with oracle block processing.
* Fix UTXO pagination bug that under-reported available funds.
* Moved chain http logs to live in the human-readable chain logs folder.
* Restructure how IDs are managed to avoid heap allocations.
* Optimized the `UniformSampler`s to avoid creating multiple maps.
* Reduced usage of `ids.Set` in favor of `[]ids.ID` to better utilize continuous memory.
* Introduced `[]byte` reuse in `PrefixDB`.
* Implemented type-specific sorting functions to avoid frequent interface conversion allocations.
* Optimized AVM load user to avoid reading unnecessary information from disk.
* Removed a memory allocation + copy in socket sending for the full length of the message.

For assistance with this update, follow our [Developer FAQ](https://support.avalabs.org/en/collections/2618154-developer-faq), if you are still running into issues you can join our [Discord](https://chat.avax.network) for help.

## v1.0.4 AvalancheGo Release Notes  \([View on GitHub](https://github.com/ava-labs/avalanchego/releases/tag/v1.0.4)\)

![AvalancheGo release notes v1.0.4.png](../../.gitbook/assets/image%20%2817%29.png)

{% hint style="danger" %}
This update is optional but encouraged. The patch includes quality of life improvements and various performance enhancements. Note that this update requires the CLI parameters to be specified with -- rather than allowing for either - or --. For example, `-public-ip=127.0.0.1` is no longer allowed and must be specified as `--public-ip=127.0.0.1`. Otherwise, this update is backwards compatible.
{% endhint %}

```
• Added subnet whitelisting to allow a node owner to choose which subnets to validate.
```

```text
• Added config file parsing for node settings.
• Added more options for specifying a node's IP address and added getNodeIP to the info *endpoint.
• Added a TxID to the result of get.Validators in the platformvm.
• Updated Coreth version.
• Cleaned up the snowball trie implementation and added additional tests to align with mutation tests.
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

For assistance with this update, follow our [Developer FAQ](https://support.avalabs.org/en/collections/2618154-developer-faq), if you are still running into issues you can join our [Discord](https://chat.avax.network) for help.

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTEyNzQyNTI2NzgsLTUyOTAyMTQxNCwtMT
Q3NjQ3Njc2OSwyMzMzODc4NzAsLTI0NDg5Mzc0NCwtMTc5NTQ3
OTYyLC0yMDU2MTM3MTk4LC0xMzU2MTc0NTgxXX0=
-->