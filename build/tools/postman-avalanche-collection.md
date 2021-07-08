# Postman集合

## Postman是什么?

Postman是一个免费的工具，开发人员可以使用它快速而轻松地发送REST、SOAP和GraphQL请求和测试API。它既可以作为在线工具，也可以作为Linux、MacOS和Windows的应用程序。Postman允许您快速发出API调用，并以格式良好、可搜索的形式查看响应。

我们的Postman集合是为[Avalanche](https://docs.avax.network),包括所有的公共在[AvalancheGo instance](../release-notes/avalanchego.md)上可用的API调用,允许您快速命令节点和看到响应问题,不用复制粘贴又长又复杂的`curl`命令。

除了API集合之外，还有针对Postman的示例Avalanche环境，它定义了常见变量，如节点的IP地址、您的Avalanche地址和查询的类似常见元素，因此您不必多次输入它们。

结合起来，它们将允许您轻松地在您的节点上保持标签，检查其状态，并进行快速查询，以找到其操作的详细信息。

## Setup

### Postman installation

Postman can be installed locally or used as a web app. We recommend installing the application, as it simplifies operation. You can download Postman from its [website](https://www.postman.com/downloads/). It is recommended that you sign up using your email address as then your workspace can be easily backed up and shared between web app and the app installed on your computer.

![Download Postman](../../.gitbook/assets/postman_01_download.png)

After you installed the application, run it. It will prompt you to create an account or log in. Do so. Again, it is not necessary, but recommended.

### Collection import

Select `New workspace` from Workspaces tab and follow the prompts to crate a new workspace. This will where the rest of the work will be done.

![New workspace](../../.gitbook/assets/postman_02_workspace.png)

We're ready to import the collection. On the header of the Worskspaces tab select `New` and switch to `Link` tab.

![Import collection](../../.gitbook/assets/postman_03_import.png)

There, in the URL input field paste the link to the collection:

```text
https://raw.githubusercontent.com/ava-labs/avalanche-postman-collection/master/Avalanche.postman_collection.json
```

Postman will recognize the format of the file content and offer to import the file as a collection. Complete the import. Now you will have Avalanche collection in your Workspace.

![Collection content](../../.gitbook/assets/postman_04_collection.png)

### Environment import

Next, we have to import the environment variables. Again, the header of the Worskspaces tab select `New` and switch to `Link` tab. this time, paste the link to the environment JSON:

```text
https://raw.githubusercontent.com/ava-labs/avalanche-postman-collection/master/Example_Avalanche_Environment.postman_environment.json
```

Postman will recognize the format of the file:

![Environment import](../../.gitbook/assets/postman_05_environment.png)

Import it to your workspace. Now, we will need to edit that environment to suit the actual parameters of your particular installation. These are the parameters that differ from the defaults in the imported file.

Click the eye icon next to the environment dropdown:

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
eyJoaXN0b3J5IjpbNDg2MDg4NzA3XX0=
-->