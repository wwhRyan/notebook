# SSH

## 远程执行命令

| 命令          | 例子                                                    |
| ------------- | ------------------------------------------------------- |
| 普通指令      | ssh nick@xxx.xxx.xxx.xxx "df -h"                        |
| 多条指令      | ssh nick@xxx.xxx.xxx.xxx "pwd; cat hello.txt"           |
| 执行本地脚本  | ssh nick@xxx.xxx.xxx.xxx < test.sh                      |
| 本地脚本+参数 | ssh nick@xxx.xxx.xxx.xxx 'bash -s' < test.sh helloworld |
| 执行远程脚本  | ssh nick@xxx.xxx.xxx.xxx "/home/nick/test.sh"           |
| 远程脚本+参数 | ssh nick@xxx.xxx.xxx.xxx /home/nick/test.sh helloworld  |

**NOTE:**
- 需要用户交互的指令会执行失败
- 远程服务器上的脚本指定绝对路径

## 远程登录

1. 账号密码登录
   需要使用到 `sshpass` 这个工具，如下用户 root ,密码 123123opop
   ```
   sshpass -p 123123opop ssh -p '6000' 'root@localhost'
   ```

## 代理功能

- 正向代理（-L）：相当于 iptable 的 port forwarding
- 反向代理（-R）：相当于 frp 或者 ngrok
- socks5 代理（-D）：相当于 ss/ssr

1. **正向代理**
   所谓“正向代理”就是在本地启动端口，把本地端口数据转发到远端。\
   用法1：远程端口映射到其他机器HostB 上启动一个 PortB 端口，映射到 HostC:PortC 上，在 HostB 上运行：
   ```
   HostB$ ssh -L 0.0.0.0:PortB:HostC:PortC user@HostC
   ```
   这时访问 HostB:PortB 相当于访问 HostC:PortC（和 iptable 的 port-forwarding 类似）。
   用法2：本地端口通过跳板映射到其他机器HostA 上启动一个 PortA 端口，通过 HostB 转发到 HostC:PortC上，在 HostA 上运行：
   ```
   HostA$ ssh -L 0.0.0.0:PortA:HostC:PortC  user@HostB
   ```
   这时访问 HostA:PortA 相当于访问 HostC:PortC。\
   两种用法的区别是，第一种用法本地到跳板机 HostB 的数据是明文的，而第二种用法一般本地就是 HostA，访问本地的 PortA，数据被 ssh 加密传输给 HostB 又转发给 HostC:PortC。

2. **反向代理**

   所谓“反向代理”就是让远端启动端口，把远端端口数据转发到本地。
   HostA 将自己可以访问的 HostB:PortB 暴露给外网服务器 HostC:PortC，在 HostA 上运行：
   ```
   HostA$ ssh -R HostC:PortC:HostB:PortB  user@HostC
   ```
   那么链接 HostC:PortC 就相当于链接 HostB:PortB。\
   使用时需修改 HostC 的 /etc/ssh/sshd_config，添加：GatewayPorts yes相当于内网穿透，比如 HostA 和 HostB 是同一个内网下的两台可以互相访问的机器，HostC是外网跳板机，HostC不能访问 HostA，但是 HostA 可以访问 HostC。\
   那么通过在内网 HostA 上运行 ssh -R 告诉 HostC，创建 PortC 端口监听，把该端口所有数据转发给我（HostA），我会再转发给同一个内网下的 HostB:PortB。\
   同内网下的 HostA/HostB 也可以是同一台机器，换句话说就是内网 HostA 把自己可以访问的端口暴露给了外网 **HostC**。\
   按照前文《韦易笑：内网穿透：在公网访问你家的 NAS》中，相当于再 HostA 上启动了 frpc，而再 HostC 上启动了 frps。
3. **socks5代理**
   在 HostA 的本地 1080 端口启动一个 socks5 服务，通过本地 socks5 代理的数据会通过 ssh 链接先发送给 HostB，再从 HostB 转发送给远程主机：
   ```
   HostA$ ssh -D localhost:1080  HostB
   ```
   那么在 HostA 上面，浏览器配置 socks5 代理为 127.0.0.1:1080，看网页时就能把数据通过 HostB 代理出去，类似 ss/ssr 版本，只不过用 ssh 来实现。

4.  使用优化
   为了更好用一点，ssh 后面还可以加上：-CqTnN 参数，比如：
   ```
   $ ssh -CqTnN -L 0.0.0.0:PortA:HostC:PortC  user@HostB
   ```
   其中 :
   | 参数 | -                |
   | ---- | ---------------- |
   | -C   | 为压缩数据       |
   | -q   | 安静模式         |
   | -T   | 禁止远程分配终端 |
   | -n   | 关闭标准输入     |
   | -N   | 不执行远程命令   |
   | -f   | ssh 放到后台运行 |

   这些 ssh 代理没有短线重连功能，链接断了命令就退出了，所以需要些脚本监控重启，或者使用 autossh 之类的工具保持链接。
    
5. 功能对比正向代理（-L）的第一种用法可以用 iptable 的 port-forwarding 模拟，iptable 性能更好，但是需要 root 权限.\
   ssh -L 性能不好，但是正向代理花样更多些。
   反向代理（-R）一般就作为没有安装 frp/ngrok/shootback 时候的一种代替，但是数据传输的性能和稳定性当然 frp 这些专用软件更好。\
   socks5 代理（-D）其实是可以代替 ss/ssr 的，区别和上面类似。所以要长久使用，推荐安装对应软件，临时用一下 ssh 挺顺手。
