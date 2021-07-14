[avalanche](../README.md) › [API-Admin](../modules/api_admin.md) › [AdminAPI](api_admin.adminapi.md)

# 类:AdminAPI 

类用于与节点的AdminAPI交互。 

**`remarks`** 这扩展了[JRPCAPI](common_jrpcapi.jrpcapi.md)类。 这个类不应该被直接调用。
相反，使用[Avalanche.addAPI](avalanche.avalanche-1.md#addapi) 函数向Avalanche注册该接口。 

## 层级

  ↳ [JRPCAPI](common_jrpcapi.jrpcapi.md)

  ↳ **AdminAPI**

## 索引

### 构造函数 

* [构造函数 ](api_admin.adminapi.md#constructor)

### 属性 

* [baseurl](api_admin.adminapi.md#protected-baseurl)
* [核心 ](api_admin.adminapi.md#protected-core)
* [db](api_admin.adminapi.md#protected-db)
* [jrpc版本](api_admin.adminapi.md#protected-jrpcversion)
* [rpcid](api_admin.adminapi.md#protected-rpcid)

### 方法

* [别名](api_admin.adminapi.md#alias)
* [别名链](api_admin.adminapi.md#aliaschain)
* [调用方法](api_admin.adminapi.md#callmethod)
* [获取BaseURL](api_admin.adminapi.md#getbaseurl)
* [获取DB](api_admin.adminapi.md#getdb)
* [获取RPCID](api_admin.adminapi.md#getrpcid)
* [封锁配置文件 ](api_admin.adminapi.md#lockprofile)
* [内存配置文件](api_admin.adminapi.md#memoryprofile)
* [设置BaseURL](api_admin.adminapi.md#setbaseurl)
* [启动CPU分析器](api_admin.adminapi.md#startcpuprofiler)
* [停止CPU分析器](api_admin.adminapi.md#stopcpuprofiler)

## 构造函数 

###  构造函数 

\+ **新 AdminAPI**(`core`: [AvalancheCore](avalanchecore.avalanchecore-1.md), `baseurl`: string): *[AdminAPI](api_admin.adminapi.md)*

*Overrides [JRPCAPI](common_jrpcapi.jrpcapi.md).[构造函数 ](common_jrpcapi.jrpcapi.md#constructor)*

*定义[src/apis/admin/api.ts:98](https://github.com/ava-labs/avalanchejs/blob/2850ce5/src/apis/admin/api.ts#L98)*

这个类不应该被直接实例化。 而是使用[Avalanche.addAPI](avalanche.avalanche-1.md#addapi)方法。 

**参数:**

名称 | 类型 | 默认值 | 描述 |
------ | ------ | ------ | ------ |
`core` | [AvalancheCore](avalanchecore.avalanchecore-1.md) | - | 对Avalanche类的引用|
`baseurl` | 字符串 | "/ext/admin" | 默认为字符串"/ext/admin"作为rpc的baseurl路径 |

**返回:** *[AdminAPI](api_admin.adminapi.md)*

## 属性 

### `Protected` baseurl

• **baseurl**: *字符串*

*继承自 [APIBase](common_apibase.apibase.md).[baseurl](common_apibase.apibase.md#protected-baseurl)*

*定义 [src/common/apibase.ts:38](https://github.com/ava-labs/avalanchejs/blob/2850ce5/src/common/apibase.ts#L38)*

___

### `Protected` 核心

• **核心**: *[AvalancheCore](avalanchecore.avalanchecore-1.md)*

*继承自 [APIBase](common_apibase.apibase.md).[core](common_apibase.apibase.md#protected-core)*

*定义 [src/common/apibase.ts:36](https://github.com/ava-labs/avalanchejs/blob/2850ce5/src/common/apibase.ts#L36)*

___

### `Protected` db

• **db**: *StoreAPI*

*继承自[APIBase](common_apibase.apibase.md).[db](common_apibase.apibase.md#protected-db)*

*定义 [src/common/apibase.ts:40](https://github.com/ava-labs/avalanchejs/blob/2850ce5/src/common/apibase.ts#L40)*

___

### `Protected` jrpc版本

• **jrpc版本**: *字符串* = "2.0"

*继承自[JRPCAPI](common_jrpcapi.jrpcapi.md).[jrpcVersion](common_jrpcapi.jrpcapi.md#protected-jrpcversion)*

*定义 [src/common/jrpcapi.ts:17](https://github.com/ava-labs/avalanchejs/blob/2850ce5/src/common/jrpcapi.ts#L17)*

___

### `Protected` rpcid

• **rpcid**: *数量* = 1

*继承自 [JRPCAPI](common_jrpcapi.jrpcapi.md).[rpcid](common_jrpcapi.jrpcapi.md#protected-rpcid)*

*定义 [src/common/jrpcapi.ts:19](https://github.com/ava-labs/avalanchejs/blob/2850ce5/src/common/jrpcapi.ts#L19)*

## 方法

###  别名

▸ **alias**(`endpoint`: 字符串, `alias`: 字符串): *Promise‹boolean›*

*定义 [src/apis/admin/api.ts:31](https://github.com/ava-labs/avalanchejs/blob/2850ce5/src/apis/admin/api.ts#L31)*

为API分配别名，即API的另一个端点。 原始端点仍然会工作。 此更改只影响此节点; 其他节点将不知道这个别名。 

别名的API现在可以在ext/alias处调用 

**参数:**

名称 | 类型 | 描述 |
------ | ------ | ------ |
`endpoint` | 字符串 | API的原始端点。端点应该只包含/ext/之后的端点部分 |
`alias` | 字符串 | - |

**返回:** *Promise‹boolean›*

返回一个包含成功的Promise，成功为true，失败为false。

___

###  别名链

▸ **aliasChain**(`chain`: 字符串, `alias`: 字符串): *Promise‹boolean›*

*定义 [src/apis/admin/api.ts:49](https://github.com/ava-labs/avalanchejs/blob/2850ce5/src/apis/admin/api.ts#L49)*

给区块链一个别名，一个可以在任何地方使用的不同名称的区块链的ID。 

**参数:**

名称 | 类型 | 描述 |
------ | ------ | ------ |
`chain` | 字符串 | - |
`alias` | 字符串 | 现在可以用来代替区块链的ID(例如，在API端点中)  |

**返回:** *Promise‹boolean›*

返回一个包含成功的Promise ，成功为true，失败为false。 

___

###  调用方法 

▸ **callMethod**(`method`: 字符串, `params?`: 数组‹对象› | 对象, `baseurl?`: 字符串): *承诺‹[RequestResponseData](common_apibase.requestresponsedata.md)›*

*继承自 [JRPCAPI](common_jrpcapi.jrpcapi.md).[callMethod](common_jrpcapi.jrpcapi.md#callmethod)*

*定义[src/common/jrpcapi.ts:21](https://github.com/ava-labs/avalanchejs/blob/2850ce5/src/common/jrpcapi.ts#L21)*

**参数:**

名称 | 类型 |
------ | ------ |
`method` | 字符串 |
`params?` | Array‹object› &#124; object |
`baseurl?` | 字符串 |

**返回:** *Promise‹[RequestResponseData](common_apibase.requestresponsedata.md)›*

___

###  获取BaseURL

▸ **获取BaseURL**(): *字符串*

*继承自 [APIBase](common_apibase.apibase.md).[getBaseURL](common_apibase.apibase.md#getbaseurl)*

*定义 [src/common/apibase.ts:63](https://github.com/ava-labs/avalanchejs/blob/2850ce5/src/common/apibase.ts#L63)*

返回 baseurl的路径。

**返回:** *string*

___

###  获取DB

▸ **getDB**(): *StoreAPI*

*继承自[APIBase](common_apibase.apibase.md).[getDB](common_apibase.apibase.md#getdb)*

*定义[src/common/apibase.ts:68](https://github.com/ava-labs/avalanchejs/blob/2850ce5/src/common/apibase.ts#L68)*

返回 baseurl的数据库

**返回:** *StoreAPI*

___

###  获取RPCID

▸ **getRPCID**(): *number*

*继承自[JRPCAPI](common_jrpcapi.jrpcapi.md).[getRPCID](common_jrpcapi.jrpcapi.md#getrpcid)*

*定义 [src/common/jrpcapi.ts:66](https://github.com/ava-labs/avalanchejs/blob/2850ce5/src/common/jrpcapi.ts#L66)*

返回rpcid，一个严格递增的数字，从1开始，表示下一个将被发送的请求ID。 

**返回:** *number*

___

###  lockProfile

▸ **lockProfile**(): *Promise‹boolean›*

*定义 [src/apis/admin/api.ts:63](https://github.com/ava-labs/avalanchejs/blob/2850ce5/src/apis/admin/api.ts#L63)*

将该节点的互斥统计信息转储到指定文件中。

**返回:** *Promise‹boolean›*

承诺一个布尔值。

___

###  内存配置文件

▸ **memoryProfile**(): *Promise‹boolean›*

*定义[src/apis/admin/api.ts:74](https://github.com/ava-labs/avalanchejs/blob/2850ce5/src/apis/admin/api.ts#L74)*

将节点的当前内存占用转储到指定文件。 

**返回:** *Promise‹boolean›*

承诺一个布尔值。 

___

###  setBaseURL

▸ **setBaseURL**(`baseurl`: string): *void*

*Inherited from [APIBase](common_apibase.apibase.md).[setBaseURL](common_apibase.apibase.md#setbaseurl)*

*Defined in [src/common/apibase.ts:47](https://github.com/ava-labs/avalanchejs/blob/2850ce5/src/common/apibase.ts#L47)*

Sets the path of the APIs baseurl.

**Parameters:**

Name | Type | Description |
------ | ------ | ------ |
`baseurl` | string | Path of the APIs baseurl - ex: "/ext/bc/X"  |

**Returns:** *void*

___

###  startCPUProfiler

▸ **startCPUProfiler**(): *Promise‹boolean›*

*Defined in [src/apis/admin/api.ts:86](https://github.com/ava-labs/avalanchejs/blob/2850ce5/src/apis/admin/api.ts#L86)*

Start profiling the cpu utilization of the node. Will dump the profile information into
the specified file on stop.

**Returns:** *Promise‹boolean›*

Promise for a boolean that is true on success.

___

###  stopCPUProfiler

▸ **stopCPUProfiler**(): *Promise‹boolean›*

*Defined in [src/apis/admin/api.ts:97](https://github.com/ava-labs/avalanchejs/blob/2850ce5/src/apis/admin/api.ts#L97)*

Stop the CPU profile that was previously started.

**Returns:** *Promise‹boolean›*

Promise for a boolean that is true on success.
<!--stackedit_data:
eyJoaXN0b3J5IjpbMjgxNzQxNzY2LDEzMTY1NDA2OTQsLTE1Nz
E5NzQ3NjVdfQ==
-->