# entware

entware 是一个适用于嵌入式系统的软件包库，支持x86，x64，arm，mips架构,使用 opkg 包管理系统进行管理，现在在官方的源上已经有超过 2000 个软件包了。广泛适用于路由器.

1. entware 的前身是 optware，可以独立于openwrt 的 SquashFS 文件系统，一般存放于硬盘、SD卡、U盘等外置设备上，挂载于opt文件夹。

> [在Padavan 上使用Entware](https://xzhih.github.io/Padavan-entware/)

2. 

## 在极路由1S使用 entware

本想在极1S上安装些程序，结果登录ssh后发现系统自带的opkg有限制，即使更改为openWRT的源也不能安装，说各种不兼容。

打算装entware, 不使用之前系统阉割过的软件包管理.
可以把 entware 装在U盘或者SD卡中，可以看成便携式小系统。如果不想用entware及其软件，只需要拔下U盘或者SD卡。
对于极1S来说，需要准备SD卡，把entware安装在SD卡中。

## 安装 entware

- 将SD卡软连接到 `/opt` 目录
- 在 http://bin.entware.net/mipselsf-k3.4/installer/ 下载 generic.sh,并执行.(极路由属于mipselsf-k3.4)
- 按照提示更新PATH和增加启动服务,执行which opkg 返回结果是/opt/bin/opkg则说明安装成功
- 开机设置环境变量。修改文件 /etc/profile，在最后面添加代码 . /opt/etc/profile