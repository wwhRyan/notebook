# webhook

## 什么是 webhook?

Webhook 是一个 HTTP 请求，由源系统中的事件触发并发送到目标系统，通常带有数据负载。

Webhook 用于广泛用于实现网络系统的自动化，源系统“告知”目标系统已发生的事件的信息。

信息统治着网络，实时获取信息使在线服务高效并响应客户需求。Webhooks 提供了一种简单的方式，使在线平台之间实时共享信息成为可能。

[](https://hookdeck.com/_next/image?url%3Dhttps%3A%2F%2Fimages.contentful.com%2Fq2jghs8i0z4e%2F3CedtboP9WlNzgFG284mNc%2F370e3ed3c0d6a65dc7427b7cfadf72ff%2Fwhat-is-a-webhook.png%3Fw%3D3000%26h%3D1884%26w%3D1920%26q%3D75)

## webhooks 有什么用途?

webhook 用于将一个系统中事件的发生传达给另一个系统，并且它们经常共享有关该事件的数据。然而，一个例子总是更容易说明，所以让我们看一个 webhook 的例子。

假设你在开发网站，网站已经部署完成了。客户新需求的产生，你需要更新网站源代码，同时提交代码至github。

部署的网站（目标系统）可以订阅github（源系统）的在代码推送时发送的webhook。网站处理这个事件之后，每次代码提交，网站会自动更新最新的代码。

Webhook 在GitHub、Shopify、Stripe、Twilio和Slack等SaaS平台中最为常见，因为它们根据其中发生的活动支持不同类型的事件。

## 使用webhook事项

- Webhook 有效负载采用序列化的表单编码 JSON 或 XML 格式
- Webhook 是一种单向通信系统，目标系统会返回 200 或 302 状态代码，让源应用程序知道已收到它
- 接收 webhook 请求，目标系统为其提供 webhook 的一个或多个事件（也称为主题）的处理。它可以是您的应用程序，将应用程序注册为该Webhook URL的回调。

## POST or GET Webhooks

您可能会以 GET 或 POST 请求的形式获取 webhook 请求，具体取决于 webhook 提供程序。GET webhook 请求很简单，它们的有效负载作为查询字符串附加到 webhook URL。POST webhook 请求的负载在请求正文中，还可能包含身份验证令牌等属性。

---

## docker搭建webhook项目，实现远程自动同步

| 项目 | 描述                                                                |
| ---- | ------------------------------------------------------------------- |
| 需求 | 开发过程中，经常需要不定时让远程设备执行一些shell命令。             |
| 设计 | 发送webhook至远程设备，执行对应脚本                                 |
| 工具 | [adnanh/webhook](https://github.com/adnanh/webhook)                 |
| -    | [almir/docker-webhook](https://github.com/almir/docker-webhook)     |
| -    | [almir/webhook](https://hub.docker.com/r/almir/webhook/) （18.2MB） |

### 概要图示

```
                                                            remote
                                                  ┌──────────────────────────┐
                                                  │                          │
                                                  │                          │
                                                  │         container        │
                       ┌────────┐                 │       ┌──────────┐       │
 ┌─────┐    git push   │        │    webhook      │ port  │          │       │
 │ PC  ├──────────────►│ github ├────────────────►├──────►│ callback │       │
 └─-│-─┘               │        │                 │ map   │          │       │
   ─┴─                 └────────┘                 │       │          │       │
                                                  │       └─────┬────┘       │
                                                  │             │            │
                                                  │             ▼            │
                                                  │       exec target.sh     │
                                                  └──────────────────────────┘
```
用户提交代码到github，github自动发送webhook到remote，remote的端口映射到容器，容器中运行webhook的服务端，接收到对应的webhook之后，触发对应的回调脚本。实现远程设备的自动执行。  

启动容器
```bash
docker run -d -p 9000:9000 -v /root/Code/docker_work/webhook-json:/etc/webhook --name=webhook  almir/webhook -verbose -hooks=/etc/webhook/hooks.json -hotreload
```

webhook \
`http://www.lidefish.tk:9000/hooks/webhook`

### 容器网络

docker容器默认的网络配置是桥接。当容器进程启动之后，docker会配置一个虚拟的网桥，docker0，在宿主机上。这个网桥会分配虚拟的子网给对应的容器。容器启动之后，docker0会创建一个虚拟的接口并分配给一个子网的IP。docker会自动配置iptables规则并配置NAT。

docker搭建后，如果需要访问安装在宿主机上的数据库或中间件，是不能直接使用127.0.0.1这个ip的，这个ip在容器中指向容器自己，那么应该怎么去访问宿主机呢：例如你的docker环境的虚拟IP是192.168.99.100，那么宿主机同样会托管一个和192.168.99.100同网段的虚拟IP，并且会是主IP：192.168.99.1，那么就简单了，在容器中访问192.168.99.1这个地址就等于访问宿主机，问题解决注意，通过192.168.99.1访问宿主机，等于换了一个ip，如果数据库或中间件限制了本机访问或者做了ip段限制，要记得添加192.168.99.1到白名单

默认下，容器访问主机网络各个端口没有限制，容器可以通过ssh工具连接宿主机，通过内部网络让宿主机执行对应的脚本。

外部设备需要访问容器，需要映射宿主机的端口到容器，转而改为外部设备访问宿主机的特定端口。

### 容器交互
通常容器为了轻量级，大多都是不包含较为基础网络管理调试工具，比如：ip、ping、telnet、ssh、tcpdump等命令，给调试容器内网络带来相当大的困扰。nsenter 是一个可以用来进入到目标程序所在 Namespace 中运行命令的工具.大部分的 Linux 操作系统，已经内置了 nsenter 命令。

nsenter 命令可以很方便的进入指定容器的网络命名空间，一般常用于在宿主机上调试容器中运行的程序。


#### 主机下，进入容器namespace环境

- 获取容器的PID \
  `PID=$(docker inspect --format {{.State.Pid}} <container_name_or_ID>)`
- 使用对应参数进入容器的namespace \
  `nsenter -m -u -i -n -p -t $PID <command>`
  
例子：
```bash
$ docker run --rm --name test -d busybox  sleep 10000
8115009baccc53a2a5f6dfff642e0d8ab1dfb95dde473d14fb9a06ce4e89364c

$ docker ps |grep busybox
8115009baccc        busybox             "sleep 10000"            9 seconds ago       Up 8 seconds                            test

$ PID=$(docker inspect --format {{.State.Pid}} 8115009baccc)

$ nsenter -m -u -i -n -p -t $PID ps aux
PID   USER     TIME  COMMAND
    1 root      0:00 sleep 10000
    7 root      0:00 ps aux

$ nsenter -m -u -i -n -p -t $PID hostname
8115009baccc
```

#### 容器下，进入容器namespace环境

**以特权模式，使用主机的 Namespace 创建容器**，非特权模式容器没有权限访问宿主机。

```bash
docker run --privileged --net=host --ipc=host --pid=host -d -p 9000:9000 -v /root/webhook/volume:/etc/webhook --name=webhook almir/webhook -verbose -hooks=/etc/webhook/hooks.json -hotreload
```
进入 PID=1 进程的 Namespace 环境,执行命令，操作主机环境
```
/etc/webhook # nsenter -m -u -i -n -p -t 1 "/root/Code/docker_work/web
hook-json/webhook.sh"
```

---

容器下,直接执行命令，没有权限访问宿主机的文件。
```
/etc/webhook # nsenter -m -u -i -n -p -t 1 "/usr/bin/ssh -V"
nsenter: can't execute '/usr/bin/ssh -V': No such file or directory
```

容器下,能访问和执行已经挂载的volume上的命令。
```
/etc/webhook # nsenter -m -u -i -n -p -t 1 "/root/Code/docker_work/web
hook-json/webhook.sh"
```

容器下，执行已经挂载的volume上 webhook.sh 脚本，宿主机的 webhook.sh 可以访问整个宿主机的文件系统。


---

## 附录：

### Namespace

不同 Namespace 下的资源相互独立、不可见。Linux 从 2.4.19 完成了支持 Mount Namespace，2.6.19 完成了支持 UTS、IPS Namespace，2.6.24 完成了支持 PID Namespace，2.6.29 完成了支持 Network Namespace，3.8 完成了支持 User Namespace 。其中，除了 User Namespace ，其他都需要以 root 权限创建。同时，在 4.6 中已经新增了 Cgroup namespace，目前 RunC（Docker 提供的运行时） ，已经合并了相关的 PR: https://github.com/opencontainers/runc/pull/1916 。下面是其中的 7 种 Namespace。

- Mount namespace，隔离文件系统挂载点。一个 Namespace 中，程序对文件的修改，只影响自身的文件系统，而对其他 Namespace 没有影响。
- UTS namespace，隔离主机名和域名信息。每个 Namespace 中，主机和域名信息相互独立。
- IPC namespace，隔离进程通信的行为。只有一个 Namespace 中的进程可以互相通信。
- PID namespace，隔离进程的 PID 空间。不同 Namespace 中的进程 PID 可以重复，互不影响。PID 为 1 的进程是其他所有进程的父进程，因此这个 Namespace 非常有意义。
- Network namespace，隔离网络资源。每个 Namespace 都具有独立的网络栈信息，容器运行时仿佛在一个独立的网络中。
- User namespace，隔离用户和用户组。同一个用户在不同的 Namespce，可以具有不同的角色，用来保障安全性。
- Cgroup namespace，隔离 Cgroup 的可见性。每个 Namespace 中，都具有独立的 cgroupns root 和 cgroup filesystem 视图。

### Cgroups

将一组进程放置到一个 Namespace，对外隔离，对内共享资源，接着使用 Cgroups 对其进行资源的控制。Cgroups 提供了四个功能:

- 资源限制。针对一个进程或进程组，设置资源消耗限制。比如内存超出限制，会导致申请内存失败。
- 资源统计。统计 CPU 使用时长、内存用量等。
- 任务控制。控制进程的状态，可以挂起、恢复进程。
- 优先级分配。设置进程的优先级。

利用 Namespcae 和 Cgroups 提供的沙箱环境，再加上文件系统技术，就支持起了容器技术。
