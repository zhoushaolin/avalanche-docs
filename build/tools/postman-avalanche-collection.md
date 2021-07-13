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

Select the `Edit` button to change the defaults. As a minimum, you will need to change the IP address of your node, which is the value of the `host` variable. Change it to the IP of your node \(change both the `initial` and `current` values\). Also, if your node is not running on the same machine where you installed Postman, make sure your node is accepting the connections on the API port from the outside by checking the appropriate [command line option](../references/command-line-interface.md#http-server).

Now we sorted everything out, and we're ready to query the node.

## Making API calls

Open one of the API call groups, for example `Health`. Double-click `getLiveness` call:

![API call](../../.gitbook/assets/postman_07_making_calls.png)

You will see that format of the call uses the `http`, `host` and `port` environment variables. Click `Send`. Request will be sent, and soon you will see the response, in the `Body` tab in the `Response`:

![Response](../../.gitbook/assets/postman_08_response.png)

To see the actual call and the variables that are sent to the node, switch to `Body` tab in the API call tabs. There you can quickly change the variables to see the response to different queries.

## Conclusion

If you completed the tutorial, you are now able to quickly issue API calls to your node without messing with the curl commands in the terminal. This allows you to quickly see the state of your node, track changes or double-check the health or liveness of your node.

## Contributing

We're hoping to continuously keep this collection up-to-date with the [Avalanche APIs](https://docs.avax.network/build/avalanchego-apis), and also add [data visualizations](https://learning.postman.com/docs/sending-requests/visualizer/#visualizing-response-data). If you're able to help improve the Avalanche Postman Collection in any way, first create a feature branch by branching off of `master`, next make the improvements on your feature branch and lastly create a [pull request](https://github.com/ava-labs/avalanche-docs/pulls) to merge your work back in to `master`.

If you have any other questions or suggestions, come [talk to us](https://chat.avalabs.org/).

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTY4MjcxNDE2OCwtNzgxMDcwNjk4XX0=
-->