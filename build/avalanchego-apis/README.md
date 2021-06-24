# AvalancheGo API

客户端通过对节点的API调用与Avalanche交互。API调用中的数值参数可以以字符串的形式给出\(例如, `"5"` 或`5` 都可以作为整数参数\)。数值返回值总是以字符串的形式给出\(例如, `"5"` 而不是 `5`\)。在示例中，API调用被发送到`127.0.0.1:9650`上监听HTTP流量的节点。

| 标题 | 描述 |
| :--- | :--- |
| [**发布API调用**](issuing-api-calls.md) | 本指南解释了如何调用Avalanche节点公开的API。|
| [**平台链(P链) API**](platform-chain-p-chain-api.md) | 允许客户端与P链(平台链)交互，这维护了Avalanche的验证器集并处理区块链和子网的创建。 |
| [**合约链\(C链\) API**](contract-chain-c-chain-api.md) | 允许客户端与C链、Avalanche的主EVM实例以及其他EVM实例交互。 |
| [**交易链\(X链\) API**](exchange-chain-x-chain-api.md) |允许客户在X链以及AVM的其他实例上创建和交易资产，包括AVAX。 |
| [**管理员 API**](admin-api.md) | 允许客户端检查节点的内部状态、连接集和类似的内部协议数据。 |
| [**授权 API**](auth-api.md) | 允许客户端管理授权代币的创建和撤销。 |
| [**健康 API**](health-api.md) | 允许客户端检查节点的运行状况。 |
| [**信息 API**](info-api.md) | 允许客户端检查节点的基本信息。 |
| [**IPC API**](ipc-api.md) | 允许用户创建供区块链发布到的UNIX域套接字。 |
| [**密钥库 API**](keystore-api.md) | 允许客户使用Avalanche节点的嵌入式密钥库文件。|
| [**指标 API**](metrics-api.md) | 允许客户端获取有关节点运行状况和性能的统计信息。 |

<!--stackedit_data:
eyJoaXN0b3J5IjpbODU2ODAxNTA1XX0=
-->