# Postman集合

## Postman是什么?

Postman是一个免费的工具，开发人员可以使用它快速而轻松地发送REST、SOAP和GraphQL请求和测试API。它既可以作为在线工具，也可以作为Linux、MacOS和Windows的应用程序。Postman允许您快速发出API调用，并以格式良好、可搜索的形式查看响应。

我们的Postman集合是为[Avalanche](https://docs.avax.network),包括所有的公共在[AvalancheGo instance](../release-notes/avalanchego.md)上可用的API调用,允许您快速命令节点和看到响应问题,不用复制粘贴又长又复杂的`curl`命令。

除了API集合之外，还有针对Postman的示例Avalanche环境，它定义了常见变量，如节点的IP地址、您的Avalanche地址和查询的类似常见元素，因此您不必多次输入它们。

结合起来，它们将允许您轻松地在您的节点上保持标签，检查其状态，并进行快速查询，以找到其操作的详细信息。

## 设置

### Postman安装

Postman可以在本地安装，也可以作为网页应用程序使用。我们建议安装这个应用程序，因为它简化了操作。你可以从它的[网站](https://www.postman.com/downloads/)下载Postman。建议您使用您的电子邮件地址注册，这样您的工作空间可以很容易地备份和共享之间的应用程序和安装在您的电脑上的应用程序。

![Download Postman](../../.gitbook/assets/postman_01_download.png)

安装应用程序后，运行它。它将提示您创建帐户或登录。这不是必要的，但推荐使用。

### 收藏导入

从workspace选项卡中选择`New workspace`，并根据提示创建一个新的工作区。 剩下的工作将在这里完成。 

![New workspace](../../.gitbook/assets/postman_02_workspace.png)

我们准备导入收藏。在Worskspaces选项卡的头部选择`New`并切换到`Link`选项卡。

![Import collection](../../.gitbook/assets/postman_03_import.png)

在这里，在URL输入字段中粘贴链接到收藏:

```text
https://raw.githubusercontent.com/ava-labs/avalanche-postman-collection/master/Avalanche.postman_collection.json
```

Postman将识别文件内容的格式，并提供导入文件作为一个收藏集。完成导入。现在你的工作空间中将有Avalanche收藏集。

![Collection content](../../.gitbook/assets/postman_04_collection.png)

### 环境导入

接下来，我们必须导入环境变量。 再次，工作区选项卡的标题选择`New`，并切换到`Link`选项卡。 这一次，将链接粘贴到环境JSON: 

```text
https://raw.githubusercontent.com/ava-labs/avalanche-postman-collection/master/Example_Avalanche_Environment.postman_environment.json
```

Postman将会识别文件的格式:

![Environment import](../../.gitbook/assets/postman_05_environment.png)

将其导入到您的工作区中。现在，我们需要编辑该环境以适应特定安装的实际参数。这些参数与导入文件中的默认值不同。

点击环境下拉框旁边的眼睛图标: 

![Environment content](../../.gitbook/assets/postman_06_variables.png)

选择`Edit`按钮来更改默认值。 至少，您需要更改您的节点的IP地址，它是`host`变量的值。 将其更改为您的节点的IP \(更改`initial`和`current`值\)。 此外，如果您的节点不在安装Postman的同一台机器上运行，请通过检查适当的[命令行选项](../references/command-line-interface.md#http-server)确保您的节点从外部接受API端口上的连接。 

现在我们把所有东西都整理好了，准备查询节点。 

## 进行API 调用

打开一个API调用组，例如`Health`。 双击`getLiveness`调用: 

![API call](../../.gitbook/assets/postman_07_making_calls.png)

您将看到调用的格式使用了`http`、`host`和`port`环境变量。 点击`Send`。 请求将被发送，很快你就会在`Response`中的`Body`选项卡中看到响应，: 

![Response](../../.gitbook/assets/postman_08_response.png)

要查看实际的调用和发送到节点的变量，请切换到API调用选项卡中的`Body`选项卡。 在那里，您可以快速更改变量，以查看对不同查询的响应。 

## 总结

如果您完成了本教程，现在就可以快速地向您的节点发出API调用，而不必打乱终端中的curl命令。 这允许您快速查看节点的状态、跟踪更改或再次检查节点的运行状况或活动状态。 

## 贡献

我们希望不断更新[Avalanche api](https://docs.avax.network/build/avalanchego-apis)，并添加[数据可视化](https://learning.postman.com/docs/sending-requests/visualizer/#visualizing-response-data)。 如果你能以任何方式帮助改善Avalanche Postman 收集,首先创建一个特性分支的分支`master`, 接下来在你的特性分支上进行改进,最后创建一个[拉取请求](https://github.com/ava-labs/avalanche-docs/pulls)将你的工作在“大师”。 
If you're able to help improve the Avalanche Postman Collection in any way, first create a feature branch by branching off of `master`, next make the improvements on your feature branch and lastly create a [拉取请求](https://github.com/ava-labs/avalanche-docs/pulls) to merge your work back in to `master`.

If you have any other questions or suggestions, come [talk to us](https://chat.avalabs.org/).

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE0NzkyMjcyOCw0MTg3MDYwNTYsLTEzNT
A1MDQyOTUsMTk4MzIyNTM4NiwtNjgyNzE0MTY4LC03ODEwNzA2
OThdfQ==
-->