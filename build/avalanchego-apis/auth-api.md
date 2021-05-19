# 授权API

运行节点时，可以要求API调用附加一个授权令牌。此API管理授权令牌的创建和撤销。

授权令牌提供对一个或多个API端点的访问。这对于委派对节点api的访问很有用。令牌12小时后过期。

授权令牌在API调用的开头。具体来说，开头的`Authorization`应该有Auth API

An authorization token is provided in the header of an API call. Specifically, the header `Authorization` should have value `Bearer TOKEN.GOES.HERE`值。\(这里 \(where `TOKEN.GOES.HERE`被替换为令牌 is replaced with the token\)。.

这个API只有在节点使用This API is only reachable if the node is started with [command line argument ](../references/command-line-interface.md)`--api-auth-required`启动时才可访问。如果节点在没有此CLI的情况下启动，API调用不需要授权令牌，因此此API不可达。此API从不需要授权令牌来获取。

必须有权限创建授权令牌。如果使用`--api-auth-required`运行节点，则还必须使用参数`--api-auth-password`指定授权令牌密码。您必须提供此密码才能创建/撤消授权令牌。

注意，如果你用`--api-auth-required`运行你的节点，那么像MetaMask这样的工具可能无法对你的节点进行API调用，因为它们没有一个认证令牌。

## 格式

这个API使用. If the node is started without this CLI, API calls do not require authorization tokens, so this API is not reachable. This API never requires an authorization token to be reached.

Authorization token creation must be permissioned. If you run your node with `--api-auth-required`, you must also specify an authorization token password with argument `--api-auth-password`. You must provide this password in order to create/revoke authorization tokens.

Note that if you run your node with `--api-auth-required` then some tools like MetaMask may not be able to make API calls to your node because they don’t have an auth token.

## Format

This API uses the `json 2.0` RPC格式。有关JSON RPC调用的更多信息，请参见 format. For more information on making JSON RPC calls, see [here.](issuing-api-calls.md)。

## 端点Endpoint

```text
/ext/auth
```

## Methods方法

### auth.newToken

创建一个新的授权令牌，以授予对一个或多个API端点的访问权。

#### **签名Creates a new authorization token that grants access to one or more API endpoints.

#### **Signature**

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

#### **调用示例is this node’s authorization token password.
* `endpoints` is a list of endpoints that will be accessible using the generated token. If `endpoints` contains an element `"*"`, the generated token can access any API endpoint.
* `token` is the authorization token.

#### **Example Call**

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

这个调用将生成一个授权令牌，允许访问API端点This call will generate an authorization token that allows access to API endpoints `/ext/bc/X`  \(即X-链 \)和ie the X-Chain\) and `/ext/info` \(即ie the [info API](info-api.md).\)

#### **响应示例Example Response**

```cpp
{
    "jsonrpc": "2.0",
    "result": {
        "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJFbmRwb2ludHMiOlsiKiJdLCJleHAiOjE1OTM0NzU4OTR9.Cqo7TraN_CFN13q3ae4GRJCMgd8ZOlQwBzyC29M6Aps"
    },
    "id": 1
}
```

这个授权令牌应该包含在API调用中，通过给出头文件This authorization token should be included in API calls by giving header `Authorization`, 值为 value `Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJFbmRwb2ludHMiOlsiKiJdLCJleHAiOjE1OTM0NzU4OTR9.Cqo7TraN_CFN13q3ae4GRJCMgd8ZOlQwBzyC29M6Aps`。.

例如, 使用以下令牌调用For example, to call [`info.peers`](info-api.md#info-peers) with this token:


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

#### **签名Revoke a previously generated token. The given token will no longer grant access to any endpoint. If the token is invalid, does nothing.

#### **Signature**

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

#### **调用示例is this node’s authorization token password.
* `token` is the authorization token being revoked.

#### **Example Call**

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

#### **响应示例Example Response**

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

#### **签名Change this node’s authorization token password. Any authorization tokens created under an old password will become invalid.

#### **Signature**

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

#### **调用示例is this node’s current authorization token password.
* `newPassword` is the node’s new authorization token password after this API call. Must be between 1 and 1024 characters.

#### **Example Call**

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

#### **响应示例Example Response**

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
eyJoaXN0b3J5IjpbMzk1MTk2NDA0LDEwMTM4OTEzMTQsLTg1ND
g0MTExOCwyMDA2MTU3NDUzLC0xMjg3MTIzODkzLC0xODgyODk5
NTY2LC0xOTUzNDMxLDI3Mjc3OTYzLC0xMzgwMzI1NTAyXX0=
-->