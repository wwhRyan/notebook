# SSH算法

ssh key的类型有很多种，比如dsa、rsa、 ecdsa、ed25519等.

1. ssh key的类型有四种，分别是dsa、rsa、 ecdsa、ed25519。

2. 根据数学特性，这四种类型又可以分为两大类，dsa/rsa是一类，ecdsa/ed25519是一类，后者算法更先进。

3. dsa因为安全问题，已不再使用了。

4. ecdsa因为政治原因和技术原因，也不推荐使用。

5. rsa是目前兼容性最好的，应用最广泛的key类型，在用ssh-keygen工具生成key的时候，默认使用的也是这种类型。不过在生成key时，如果指定的key size太小的话，也是有安全问题的，推荐key size是3072或更大。

6. ed25519是目前最安全、加解密速度最快的key类型，由于其数学特性，它的key的长度比rsa小很多，优先推荐使用。它目前唯一的问题就是兼容性，即在旧版本的ssh工具集中可能无法使用。不过据我目前测试，还没有发现此类问题。

7. 总结：优先选择ed25519，否则选择rsa。

Github 已经默认推荐大家使用 Ed25519: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

## Ed25519

Ed25519 是一个椭圆曲线，非常优美，安全性经过数学严格证明.

目前使用 Ed25519 的列表： https://ianix.com/pub/ed25519-deployment.html