# 加密原语

[Avalanche](../../#avalanche) 为其不同的功能使用了多种加密原语。这个文件总结了在网络层和区块链层中使用的密码学的类型和种类。

## 网络层中的密码学

Avalanche使用Transport Layer Security(TLS)，来保护节点间的通信不被窃听。TLS结合了公钥密码体制的实用性和对称密钥密码学的高效性。这导致TLS成为互联网通信的标准。虽然大多数经典的共识协议使用公钥密码技术来证明第三方接收到的消息，但是新的雪人共识家族不需要这样的证明。这使得Avalanche能够使用TLS来验证利益相关者，并消除了为签名网络消息而使用昂贵的公钥加密的需要。

### TLS 证书

Avalanche不依赖于任何中心化的第三方，特别是它不使用第三方认证机构颁发的证书。网络层中用于标识端点的所有证书都是自签名的，因此创建了一个自主身份层。没有第三方参与。

### TLS 地址

为了避免将完整的TLS证书发送到平台链，首先对证书进行哈希处理。为了一致性，Avalanche为TLS证书采用了与比特币中使用的相同的哈希机制。即，使用sha256对证书的DER表示进行哈希处理，然后使用ripemd160对结果进行散列，为质押者生成一个20字节的标识符。

这个20字节的标识符由“NodeID-”后面跟着数据的[CB58](https://support.avalabs.org/en/articles/4587395-what-is-cb58)编码字符串表示。

## 雪崩虚拟机中的密码学

Avalanche虚拟机使用椭圆曲线密码，特别是`secp256k1`，用于区块链上的签名。

这个32字节的标识符由“PrivateKey-”后跟数据的[CB58](https://support.avalabs.org/en/articles/4587395-what-is-cb58)编码字符串表示。

### Secp256k1 地址

Avalanche没有规定寻址方案，而是选择将寻址留给每个区块链。

x链和p链的寻址方案依赖于secp256k1。Avalanche采用了与比特币类似的方法，并对ECDSA公钥进行哈希处理。33字节的公钥压缩表示用sha256 **一次**进行哈希处理。然后用ripemd160对结果进行哈希处理，得到一个20字节的地址。

Avalanche使用约定`chainID-address`来指定地址存在于哪个链上。`chainID`可以被替换为链的别名。通过外部应用传输信息时，需要遵循CB58约定。

### Bech32

X链和P链上的地址使用[BIP 0173](https://en.bitcoin.it/wiki/BIP_0173)中概述的[Bech32](http://support.avalabs.org/en/articles/4587392-what-is-bech32)标准。Bech32地址方案有四个部分。按外观排列:

* 人可读的部分(HRP)。在主网上这是`avax`。
* 数字`1`，将HRP与地址和纠错码分开。
* 一个用base-32编码的字符串，表示20字节的地址。
* 一个6个字符的base-32编码的纠错码。

此外，Avalanche地址的前缀是它所在链的别名，后面是破折号。例如，X链地址前缀为`X-`。

下面的正则表达式匹配主网、富士网和本地网的X链、 P链和C链上的地址。注意，所有有效的Avalanche地址都会匹配这个正则表达式，但是一些无效的Avalanche地址的字符串也可能会匹配这个正则表达式。

```text
^([XPC]|[a-km-zA-HJ-NP-Z1-9]{36,72})-[a-zA-Z]{1,83}1[qpzry9x8gf2tvdw0s3jn54khce6mua7l]{38}$
```

阅读更多关于Avalanche的信息[addressing scheme](https://support.avalabs.org/en/articles/4596397-what-is-an-address)。

### Secp256k1 可恢复的签名

可恢复签名存储为65字节的`[R || S || V]`**, 其中**`V`**是0或1，以允许快速恢复公钥。 `S`必须在可能范围的下半部分，以防止签名展延性。在给消息签名之前，使用sha256对消息进行哈希处理。

### Secp256k1 示例

假设瑞克和莫蒂正在建立一个安全的通信通道。Morty创建了一个新的公私密钥对。
Suppose Rick and Morty are setting up a secure communication channel. Morty creates a new public-private key pair.

Private Key: `0x98cb077f972feb0481f1d894f272c6a1e3c15e272a1658ff716444f465200070`

Public Key \(33-byte compressed\): `0x02b33c917f2f6103448d7feb42614037d05928433cb25e78f01a825aa829bb3c27`

Because of Rick’s infinite wisdom, he doesn’t trust himself with carrying around Morty’s public key, so he only asks for Morty’s address. Morty follows the instructions, SHA256’s his public key, and then ripemd160’s that result to produce an address.

SHA256\(Public Key\): `0x28d7670d71667e93ff586f664937f52828e6290068fa2a37782045bffa7b0d2f`

Address: `0xe8777f38c88ca153a6fdc25942176d2bf5491b89`

Morty is quite confused because a public key should be safe to be public knowledge. Rick belches and explains that hashing the public key protects the private key owner from potential future security flaws in elliptic curve cryptography. In the event cryptography is broken and a private key can be derived from a public key, users can transfer their funds to an address that has never signed a transaction before, preventing their funds from being compromised by an attacker. This enables coin owners to be protected while the cryptography is upgraded across the clients.

Later, once Morty has learned more about Rick’s backstory, Morty attempts to send Rick a message. Morty knows that Rick will only read the message if he can verify it was from him, so he signs the message with his private key.

Message: `0x68656c702049276d207472617070656420696e206120636f6d7075746572`

Message Hash: `0x912800c29d554fb9cdce579c0abba991165bbbc8bfec9622481d01e0b3e4b7da`

Message Signature: `0xb52aa0535c5c48268d843bd65395623d2462016325a86f09420c81f142578e121d11bd368b88ca6de4179a007e6abe0e8d0be1a6a4485def8f9e02957d3d72da01`

Morty was never seen again.

## Signed Messages

A standard for interoperable generic signed messages based on the Bitcoin Script format and Ethereum format.

```text
sign(sha256(length(prefix) + prefix + length(message) + message))
```

The prefix is simply the string `\x1AAvalanche Signed Message:\n`, where `0x1A` is the length of the prefix text and `length(message)` is an [integer](serialization-primitives.md#integer) of the message size.

### Gantt Pre-image Specification

```text
+---------------+-----------+------------------------------+
| prefix        : [26]byte  |                     26 bytes |
+---------------+-----------+------------------------------+
| messageLength : int       |                      4 bytes |
+---------------+-----------+------------------------------+
| message       : []byte    |          size(message) bytes |
+---------------+-----------+------------------------------+
                            |       26 + 4 + size(message) |
                            +------------------------------+
```

### Example

As an example we will sign the message "Through consensus to the stars"

```text
// prefix size: 26 bytes
0x1a
// prefix: Avalanche Signed Message:\n
0x41 0x76 0x61 0x6c 0x61 0x6e 0x63 0x68 0x65 0x20 0x53 0x69 0x67 0x6e 0x65 0x64 0x20 0x4d 0x65 0x73 0x73 0x61 0x67 0x65 0x3a 0x0a
// msg size: 30 bytes
0x00 0x00 0x00 0x1e
// msg: Through consensus to the stars
54 68 72 6f 75 67 68 20 63 6f 6e 73 65 6e 73 75 73 20 74 6f 20 74 68 65 20 73 74 61 72 73
```

After hashing with `sha256` and signing the pre-image we return the value [cb58](https://support.avalabs.org/en/articles/4587395-what-is-cb58) encoded: `4Eb2zAHF4JjZFJmp4usSokTGqq9mEGwVMY2WZzzCmu657SNFZhndsiS8TvL32n3bexd8emUwiXs8XqKjhqzvoRFvghnvSN`. Here's an example using the [Avalanche Web Wallet](https://wallet.avax.network/wallet/advanced).

![Sign message](../../.gitbook/assets/sign-message.png)

## Cryptography in Ethereum Virtual Machine

Avalanche nodes support the full Ethereum Virtual Machine \(EVM\) and precisely duplicate all of the cryptographic constructs used in Ethereum. This includes the Keccak hash function and the other mechanisms used for cryptographic security in the EVM.

## Cryptography in Other Virtual Machines

Since Avalanche is an extensible platform, we expect that people will add additional cryptographic primitives to the system over time.

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTYzNjgzMDUwOSwxNDgwODg5OTAxLDE5Mj
k4NjM0NTUsMTM3NzU4MDg5MSwtMTAyMzEyMjM5NSwtMTI1MTEz
NTIyMV19
-->