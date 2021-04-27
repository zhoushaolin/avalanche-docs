# 授权API

运行节点时，可以要求API调用附加一个授权令牌。此API管理授权令牌的创建和撤销。

授权令牌提供对一个或多个API端点的访问。这对于委派对节点api的访问很有用。令牌12小时后过期。

授权令牌在API调用的开头。具体来说，开头的`Authorization`应该有`Bearer TOKEN.GOES.HERE`值。\(这里`TOKEN.GOES.HERE`被替换为令牌\)。

这个API只有在节点使用[command line argument ](../references/command-line-interface.md)`--api-auth-required`启动时才可访问。如果节点在没有此CLI的情况下启动，API调用不需要授权令牌，因此此API不可达。此API从不需要授权令牌来获取。

必须有权限创建授权令牌。如果使用`--api-auth-required`运行节点，则还必须使用参数`--api-auth-password`指定授权令牌密码。您必须提供此密码才能创建/撤消授权令牌。

注意，如果你用`--api-auth-required`运行你的节点，那么像MetaMask这样的工具可能无法对你的节点进行API调用，因为它们没有一个认证令牌。

## 格式

这个API使用`json 2.0`RPC格式。有关JSON RPC调用的更多信息，请参见[here.](issuing-api-calls.md)。

## 端点

```text
/ext/auth
```

## Methods方法

### auth.newToken

创建一个新的授权令牌，以授予对一个或多个API端点的访问权。

#### **签名**

```cpp
auth.newToken(
    {
        password: string,
        endpoints: []string
    }
) -> {token: string}
```

* `password` 是节点的授权令牌密码。
* `endpoints` 是一个可以使用生成的令牌访问的端点列表。如果`endpoints` 包含一个元素`"*"`，则生成的令牌可以访问任何API端点。
* `token` 是授权令牌。

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "auth.newToken",
    "params":{
        "password":"YOUR PASSWORD GOES HERE",
        "endpoints":["/ext/bc/X", "/ext/info"]
    },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/auth
```

这个调用将生成一个授权令牌，允许访问API端点`/ext/bc/X`  \(即X-链 \)和`/ext/info` \(即 [info API](info-api.md))

#### **响应示例**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJFbmRwb2ludHMiOlsiKiJdLCJleHAiOjE1OTM0NzU4OTR9.Cqo7TraN_CFN13q3ae4GRJCMgd8ZOlQwBzyC29M6Aps"
    },
    "id": 1
}
```

这个授权令牌应该包含在API调用中，通过给出头文件`Authorization`, 值为`Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJFbmRwb2ludHMiOlsiKiJdLCJleHAiOjE1OTM0NzU4OTR9.Cqo7TraN_CFN13q3ae4GRJCMgd8ZOlQwBzyC29M6Aps`。

例如, 使用以下令牌调用[`info.peers`](info-api.md#info-peers) :


```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"info.peers"
}' 127.0.0.1:9650/ext/info \
-H 'content-type:application/json;' \
-H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJFbmRwb2ludHMiOlsiKiJdLCJleHAiOjE1OTM0NzU4OTR9.Cqo7TraN_CFN13q3ae4GRJCMgd8ZOlQwBzyC29M6Aps'
```

### auth.revokeToken

撤销先前生成的令牌。给定的令牌将不再授予对任何端点的访问权。如果令牌无效，则不执行任何操作。

#### **签名**

```cpp
auth.revokeToken(
    {
        password: string,
        token: string
    }
) -> {success: bool}
```

* `password` 是节点授权令牌的密码。
* `token`正在撤销的授权令牌。

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "auth.revokeToken",
    "params":{
        "password":"123",
        "token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1OTMxNzIzMjh9.qZVNhH6AMQ_LpbXnPbTFEL6Vm5EM5FLU-VEKpYBH3k4"
    },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/auth
```

#### **响应示例**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "success": true
    },
    "id": 1
}
```

### auth.changePassword

更改此节点的授权令牌密码。在旧密码下创建的任何授权令牌都将失效。

#### **签名**

```cpp
auth.changePassword(
    {
        oldPassword: string,
        newPassword: string
    }
) -> {success: bool}
```

* `oldPassword` 此节点当前授权令牌密码。
* `newPassword` 是此API调用后节点的新授权令牌密码。长度必须在1到1024个字符之间。

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc": "2.0",
    "method": "auth.changePassword",
    "params":{
        "oldPassword":"OLD PASSWORD HERE",
        "newPassword":"NEW PASSWORD HERE"
    },
    "id": 1
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/auth
```

#### **响应示例**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "success": true
    },
    "id": 1
}
```

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTg1NDg0MTExOCwyMDA2MTU3NDUzLC0xMj
g3MTIzODkzLC0xODgyODk5NTY2LC0xOTUzNDMxLDI3Mjc3OTYz
LC0xMzgwMzI1NTAyXX0=
-->