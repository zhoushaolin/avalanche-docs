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

• **baseurl**: *string*

*Inherited from [APIBase](common_apibase.apibase.md).[baseurl](common_apibase.apibase.md#protected-baseurl)*

*Defined in [src/common/apibase.ts:38](https://github.com/ava-labs/avalanchejs/blob/2850ce5/src/common/apibase.ts#L38)*

___

### `Protected` core

• **core**: *[AvalancheCore](avalanchecore.avalanchecore-1.md)*

*Inherited from [APIBase](common_apibase.apibase.md).[core](common_apibase.apibase.md#protected-core)*

*Defined in [src/common/apibase.ts:36](https://github.com/ava-labs/avalanchejs/blob/2850ce5/src/common/apibase.ts#L36)*

___

### `Protected` db

• **db**: *StoreAPI*

*Inherited from [APIBase](common_apibase.apibase.md).[db](common_apibase.apibase.md#protected-db)*

*Defined in [src/common/apibase.ts:40](https://github.com/ava-labs/avalanchejs/blob/2850ce5/src/common/apibase.ts#L40)*

___

### `Protected` jrpcVersion

• **jrpcVersion**: *string* = "2.0"

*Inherited from [JRPCAPI](common_jrpcapi.jrpcapi.md).[jrpcVersion](common_jrpcapi.jrpcapi.md#protected-jrpcversion)*

*Defined in [src/common/jrpcapi.ts:17](https://github.com/ava-labs/avalanchejs/blob/2850ce5/src/common/jrpcapi.ts#L17)*

___

### `Protected` rpcid

• **rpcid**: *number* = 1

*Inherited from [JRPCAPI](common_jrpcapi.jrpcapi.md).[rpcid](common_jrpcapi.jrpcapi.md#protected-rpcid)*

*Defined in [src/common/jrpcapi.ts:19](https://github.com/ava-labs/avalanchejs/blob/2850ce5/src/common/jrpcapi.ts#L19)*

## Methods

###  alias

▸ **alias**(`endpoint`: string, `alias`: string): *Promise‹boolean›*

*Defined in [src/apis/admin/api.ts:31](https://github.com/ava-labs/avalanchejs/blob/2850ce5/src/apis/admin/api.ts#L31)*

Assign an API an alias, a different endpoint for the API. The original endpoint will still
work. This change only affects this node; other nodes will not know about this alias.

The API being aliased can now be called at ext/alias

**Parameters:**

Name | Type | Description |
------ | ------ | ------ |
`endpoint` | string | The original endpoint of the API. endpoint should only include the part of the endpoint after /ext/ |
`alias` | string | - |

**Returns:** *Promise‹boolean›*

Returns a Promise<boolean> containing success, true for success, false for failure.

___

###  aliasChain

▸ **aliasChain**(`chain`: string, `alias`: string): *Promise‹boolean›*

*Defined in [src/apis/admin/api.ts:49](https://github.com/ava-labs/avalanchejs/blob/2850ce5/src/apis/admin/api.ts#L49)*

Give a blockchain an alias, a different name that can be used any place the blockchain’s
ID is used.

**Parameters:**

Name | Type | Description |
------ | ------ | ------ |
`chain` | string | - |
`alias` | string | Can now be used in place of the blockchain’s ID (in API endpoints, for example)  |

**Returns:** *Promise‹boolean›*

Returns a Promise<boolean> containing success, true for success, false for failure.

___

###  callMethod

▸ **callMethod**(`method`: string, `params?`: Array‹object› | object, `baseurl?`: string): *Promise‹[RequestResponseData](common_apibase.requestresponsedata.md)›*

*Inherited from [JRPCAPI](common_jrpcapi.jrpcapi.md).[callMethod](common_jrpcapi.jrpcapi.md#callmethod)*

*Defined in [src/common/jrpcapi.ts:21](https://github.com/ava-labs/avalanchejs/blob/2850ce5/src/common/jrpcapi.ts#L21)*

**Parameters:**

Name | Type |
------ | ------ |
`method` | string |
`params?` | Array‹object› &#124; object |
`baseurl?` | string |

**Returns:** *Promise‹[RequestResponseData](common_apibase.requestresponsedata.md)›*

___

###  getBaseURL

▸ **getBaseURL**(): *string*

*Inherited from [APIBase](common_apibase.apibase.md).[getBaseURL](common_apibase.apibase.md#getbaseurl)*

*Defined in [src/common/apibase.ts:63](https://github.com/ava-labs/avalanchejs/blob/2850ce5/src/common/apibase.ts#L63)*

Returns the baseurl's path.

**Returns:** *string*

___

###  getDB

▸ **getDB**(): *StoreAPI*

*Inherited from [APIBase](common_apibase.apibase.md).[getDB](common_apibase.apibase.md#getdb)*

*Defined in [src/common/apibase.ts:68](https://github.com/ava-labs/avalanchejs/blob/2850ce5/src/common/apibase.ts#L68)*

Returns the baseurl's database.

**Returns:** *StoreAPI*

___

###  getRPCID

▸ **getRPCID**(): *number*

*Inherited from [JRPCAPI](common_jrpcapi.jrpcapi.md).[getRPCID](common_jrpcapi.jrpcapi.md#getrpcid)*

*Defined in [src/common/jrpcapi.ts:66](https://github.com/ava-labs/avalanchejs/blob/2850ce5/src/common/jrpcapi.ts#L66)*

Returns the rpcid, a strictly-increasing number, starting from 1, indicating the next
request ID that will be sent.

**Returns:** *number*

___

###  lockProfile

▸ **lockProfile**(): *Promise‹boolean›*

*Defined in [src/apis/admin/api.ts:63](https://github.com/ava-labs/avalanchejs/blob/2850ce5/src/apis/admin/api.ts#L63)*

Dump the mutex statistics of the node to the specified file.

**Returns:** *Promise‹boolean›*

Promise for a boolean that is true on success.

___

###  memoryProfile

▸ **memoryProfile**(): *Promise‹boolean›*

*Defined in [src/apis/admin/api.ts:74](https://github.com/ava-labs/avalanchejs/blob/2850ce5/src/apis/admin/api.ts#L74)*

Dump the current memory footprint of the node to the specified file.

**Returns:** *Promise‹boolean›*

Promise for a boolean that is true on success.

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
eyJoaXN0b3J5IjpbLTIzMTk2MzcxNSwtMTU3MTk3NDc2NV19
-->