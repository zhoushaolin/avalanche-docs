# 管理X链密钥

AvalancheJS自带AVM密钥链。这个密钥链用于API的函数中，使它们能够使用它注册的密钥进行签名。这个过程的第一步是创建一个连接到我们所选择的Avalanche平台端点的AvalancheJS实例。

```text
import {
    Avalanche,
    BinTools,
    Buffer,
    BN
  } from "avalanche" 

let bintools = BinTools.getInstance();

let myNetworkID = 12345; //default is 3, we want to override that for our local network
let myBlockchainID = "GJABrZ9A6UQFpwjPU8MDxDd8vuyRoDVeDAXc694wJ5t3zEkhU"; // The X-Chain blockchainID on this network
let ava = new avalanche.Avalanche("localhost", 9650, "http", myNetworkID, myBlockchainID);
let xchain = ava.XChain(); //returns a reference to the X-Chain used by AvalancheJS
```

## 访问密钥链

密钥链通过X链访问，可以直接引用密钥链，也可以通过引用变量引用密钥链。

```text
let myKeychain = xchain.keyChain();
```

这将公开类AVM密钥链的实例，该实例是在创建X链API时创建的。目前，它支持ECDSA密钥对的secp256k1曲线。

## 创建X链密钥对

密钥链能够为您创建新的密钥对，并返回与密钥对关联的地址。

```text
let newAddress1 = myKeychain.makeKey(); //returns a Buffer for the address
```

您也可以将现有的私钥导入到密钥链中使用Buffer…

```text
let mypk = bintools.avaDeserialize("24jUJ9vZexUM6expyMcT48LBx27k1m7xpraoV62oSQAHdziao5"); //returns a Buffer
let newAddress2 = myKeychain.importKey(mypk); //returns a Buffer for the address
```

或者Avalanche序列化字符串也行:

```text
let mypk = "24jUJ9vZexUM6expyMcT48LBx27k1m7xpraoV62oSQAHdziao5";
let newAddress2 = myKeychain.importKey(mypk); //returns a Buffer for the address
```

## 使用密钥链

X链的密钥链具有标准化的密钥管理能力。以下功能在任何实现此接口的密钥链上都可用。

```text
let addresses = myKeychain.getAddresses(); //returns an array of Buffers for the addresses
let addressStrings = myKeychain.getAddressStrings(); //returns an array of strings for the addresses
let exists = myKeychain.hasKey(newAddress1); //returns true if the address is managed
let keypair = myKeychain.getKey(newAddress1); //returns the KeyPair class
```

## 使用密钥对

X链的密钥对已经标准化了密钥对功能。以下操作可在任何实现此接口的密钥对上执行。

```text
let address = keypair.getAddress(); //returns Buffer
let addressString = keypair.getAddressString(); //returns string

let pubk = keypair.getPublicKey(); //returns Buffer
let pubkstr = keypair.getPublicKeyString(); //returns a CB58 encoded string

let privk = keypair.getPrivateKey(); //returns Buffer
let privkstr = keypair.getPrivateKeyString(); //returns a CB58 encoded string

keypair.generateKey(); //creates a new random KeyPair

let mypk = "24jUJ9vZexUM6expyMcT48LBx27k1m7xpraoV62oSQAHdziao5";
let successul = keypair.importKey(mypk); //returns boolean if private key imported successfully

let message = Buffer.from("Wubalubadubdub");
let signature = keypair.sign(message); //returns a Buffer with the signature

let signerPubk = keypair.recover(message, signature);
let isValid = keypair.verify(message, signature); //returns a boolean
```

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTk4ODczNzYwOF19
-->