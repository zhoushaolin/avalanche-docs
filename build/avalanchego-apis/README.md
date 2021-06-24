# AvalancheGo API

客户端通过对节点的API调用与Avalanche交互。API调用中的数值参数可以以字符串的形式给出\(例如, `"5"` 或`5` 都可以作为整数参数\)。数值返回值总是以字符串的形式给出\(例如, `"5"` 而不是 `5`\)。在示例中，API调用被发送到`127.0.0.1:9650`上监听HTTP流量的节点。

| 标题 | 描述 |
| :--- | :--- |
| [**发布API调用**](issuing-api-calls.md) | 本指南解释了如何调用Avalanche节点公开的API。|
| [**平台链(P链) API**](platform-chain-p-chain-api.md) | 允许客户端与P链(平台链)交互，它维护Avalanche的验证器集并处理区块链和子网创建。 |
| The [**Contract Chain \(C-Chain\) API**](contract-chain-c-chain-api.md) | Allows clients to interact with the C-Chain, Avalanche’s main EVM instance, as well as other EVM instances. |
| The [**Exchange Chain \(X-Chain\) API**](exchange-chain-x-chain-api.md) | Allows clients to create and trade assets, including AVAX, on the X-Chain as well as other instances of the AVM. |
| The [**Admin API**](admin-api.md) | Allows clients to examine a node’s internal state, set of connections, and similar internal protocol data. |
| The [**Auth API**](auth-api.md) | Allows clients to manage the creation and revocation of authorization tokens. |
| The [**Health API**](health-api.md) | Allows clients to check a node’s health. |
| The [**Info API**](info-api.md) | Allows clients to examine basic information about a node. |
| The [**IPC API**](ipc-api.md) | Allows users to create UNIX domain sockets for blockchains to publish to. |
| The [**Keystore API**](keystore-api.md) | Allows customers to use the embedded Keystore file of an Avalanche node. |
| The [**Metrics API**](metrics-api.md) | Allows clients to get statistics about a node’s health and performance. |

<!--stackedit_data:
eyJoaXN0b3J5IjpbNjMzODY3NTcxXX0=
-->