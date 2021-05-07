# 密钥存储库API

每个节点都有一个内置的密钥库, 客户端在密钥存储库中创建用户，这些密钥存储库充当与区块链交互时使用的身份。密钥存储库存在于节点级别，因此如果您在一个节点上创建一个用户，它就只在该节点上存在。但是，可以使用此API导入和导出用户。

_**您应该只在您所操作的节点上创建一个密钥存储用户，因为节点操作员可以访问您的明文密码。**_

对于主网上的验证和委托，你应该通过钱包[the wallet](../tutorials/nodes-and-staking/staking-avax-by-validating-or-delegating-with-the-avalanche-wallet.md)发布交易。这样一来，你的资金控制键就不会存储在节点上，这大大降低了运行节点的计算机受到威胁的风险。

## 格式

该API使用`json 2.0`API格式, 有关JSON RPC调用的更多信息，请参见这里 [here](issuing-api-calls.md)。

## 端点

```text
/ext/keystore
```

## 方法

### 密钥库创建用户

使用指定的用户名和密码创建新用户。

#### **签名**

```cpp
keystore.createUser(
    {
        username:string,
        password:string
    }
) -> {success:bool}
```

* `username`和`password` 最多1024个字符。
* 如果`password`太弱，您的请求将被拒绝, `password`至少8个字符，包含大写字母和小写字母以及数字和符号。
* 
#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"keystore.createUser",
    "params" :{
        "username":"myUsername",
        "password":"myPassword"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/keystore
```

#### **响应示例**

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "success":true
    }
}
```

### 密钥库删除用户

删除一个用户。

#### **签名**

```cpp
keystore.deleteUser({username: string, password:string}) -> {success: bool}
```

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"keystore.deleteUser",
    "params" : {
        "username":"myUsername",
        "password":"myPassword"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/keystore
```

#### **响应示例**

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{"success" : true}
}
```

### 密钥库导出用户

导出一个用户, 用户可以通过[`keystore.importUser`](keystore-api.md#keystore-importuser)导入到另一个节点。用户的密码保持加密。

#### **签名**

```cpp
keystore.exportUser(
    {
        username:string,
        password:string,
        encoding:string //optional
    }
) -> {
    user:string,
    encoding:string
}
```

`encoding` 指定编码用户数据的字符串格式。可以是“cb58”或“hex”。默认为“cb58”。

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"keystore.exportUser",
    "params" :{
        "username":"myUsername",
        "password":"myPassword"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/keystore
```

#### **响应示例**

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "user":"4CsUh5sfVwz2jNrJXBVpoPtDsb4tZksWykqmxC5CXoDEERyhoRryq62jYTETYh53y13v7NzeReisi",
        "encoding":"cb58"
    }
}
```

### 密钥库导入用户

导入用户, `password`必须与用户的密码匹配, `username`不需要匹配`user`在导出时拥有的用户名。

#### **签名**

```cpp
keystore.importUser(
    {
        username:string,
        password:string,
        user:string,
        encoding:string //optional
    }
) -> {success:bool}
```

`encoding` 指定编码用户数据的字符串格式, 可以是“cb58” 或“hex”。默认为“cb58”。

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"keystore.importUser",
    "params" :{
        "username":"myUsername",
        "password":"myPassword",
        "user"    :"4CsUh5sfVwz2jNrJXBVpoPtDsb4tZksWykqmxC5CXoDEERyhoRryq62jYTETYh53y13v7NzeReisi"
    }
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/keystore
```

#### **响应示例**

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "success":true
    }
}
```

### 密钥库用户列表

列出此密钥库中的用户。

#### **签名**

```cpp
keystore.ListUsers() -> {users:[]string}
```

#### **调用示例**

```cpp
curl -X POST --data '{
    "jsonrpc":"2.0",
    "id"     :1,
    "method" :"keystore.listUsers"
}' -H 'content-type:application/json;' 127.0.0.1:9650/ext/keystore
```

#### **响应示例**

```cpp
{
    "jsonrpc":"2.0",
    "id"     :1,
    "result" :{
        "users":[
            "myUsername"
        ]
    }
}
```

<!--stackedit_data:
eyJoaXN0b3J5IjpbMTk1Mzg0NjI5MCwtOTIzNDEyMzk5LC0zNz
gwNDI3MV19
-->