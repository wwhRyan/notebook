# openwrt

OpenWrt/LEDE是一个为嵌入式设备(通常是无线路由器)开发的高扩展度的GNU/Linux发行版。与许多其他路由器的发行版不同，OpenWrt是一个完全为嵌入式设备构建的功能全面、易于修改的由现代Linux内核驱动的操作系统。在实践中，这意味着您可以得到您需要的所有功能，却仍能避免臃肿。

## openwrt 发行版和 linux 普通发行版的区别(类似ubuntu)
- 内核打专属补丁
- 动态链接库精简，用了uclibc库而不是(e)glibc库
- 专用的软件包管理器opkg
- OpenWRT 上用的shell是 ash
- OpenWRT 网卡驱动支持ap功能
- 自带web配置界面 - luci
- 路由的核心功能是通过iptables实现，linux和openwrt都可以实现对应路由、NAT功能
- flash 文件系统定制，采用/overlay(jffs2 可读写) 与/rom(SqashFS 只读)共同构成统一的/根目录
- 采用精简的busybox、dropbear、iptables 作为roofts基础镜像，储存在SqashFS区域

## SquashFS

SquashFS是一个只读的压缩文件系统。虽然gzip可用，但在 OpenWrt，它使用LZMA进行压缩。由于 SquashFS 是一个只读文件系统，它不需要对齐数据，允许它更紧密地打包文件，因此占用的空间比 JFFS2 少得多（比 JFFS2 文件系统节省 20-30%）！

(+) 占用尽可能少的空间\
(+) 允许实施用于恢复的白痴证明FailSafe，因为不可能写入它\
(-) 只读\
(-) 浪费空间，因为每次修改其中包含的文件时，实际上都会将其副本复制到第二个 (JFFS2) 分区\
SquashFS 上的内核文档
SquashFs 性能比较
在 NAND 上运行 SquashFS 时有一个普遍的问题：问题是 SquashFS 根本没有坏块管理，需要所有块有序；但是对于正确的 NAND 坏块管理，您还需要能够跳过坏块并偶尔重新定位块（参见squashfs 和 NAND 闪存）。这就是为什么原始 SquashFS 在 NAND 上不是一个好主意（如果你使用像 UBIFS 这样的 FTL，它就可以工作）。

## JFFS2

JFFS2是一个可写的压缩文件系统，具有日志记录和磨损均衡功能，使用LZMA进行压缩。

(+) 可写，有日志记录和磨损均衡\
(+) 很酷\
(-) 是压缩的，所以程序（opkg特别是）无法提前知道一个包将占用多少空间\
(+) 是压缩的，所以程序（预装的）占用的空间要少得多，所以实际上你有更多的空间\
它已被 UBIFS 取代。

## Flash 布局

参考TP-Link TL-WR1043ND型号的分区图：

![](20221123105944.png)

- 第0层Layer0: 对应Flash芯片,8MiB大小, 焊接在PCB上,连接到CPU(SoC)soc – 通过SPI (Serial Peripheral Interface Bus)总线.
- 第1层Layer1: 我们把存储空间“分区”为 mtd0 给 bootloader, mtd5 给 firmware/固件使用, 并且, 在这个例子中, mtd4给ART (Atheros Radio Test/Atheros电波测试) - 它包含MAC地址和无线系统的校准信息(EEPROM). 如果该部分的信息丢失或损坏,ath9k (无线驱动程序) 就彻底罢工了.
- 第2层Layer2: 我们把mtd5 (固件) 进一步分割为 mtd1 (kernel/内核) and mtd2 (rootfs); 在固件的一般处理流程中 (参考imagebuilder) Kernel 二进制文件 先由LZMA打包, 然后用gzip压缩 之后文件被 直接写入到raw flash (mtd1)中 而不mount到任何文件系统上!
- 第3层Layer3: 我们把rootfs更进一步分割成 mtd3 (rootfs_data) 和剩下的 未命名 部分 - 未来用来容纳SquashFS-分区.

## 引导过程

1. 内核从已知的原始分区（没有 FS）启动，扫描 mtd 分区rootfs以寻找有效的超级块并挂载 SquashFS 分区（包含/etc）然后运行/etc/preinit。（更多信息在technical.details）
2. /etc/preinit跑/sbin/mount_root
3. mount_root安装 JFFS2 分区 ( /overlay) 并将其与 SquashFS 分区 ( /rom) 结合以创建新的虚拟根文件系统( /)
4. 启动继续/sbin/init

## 进程服务管理

openwrt 是通过 init.d 来管理服务的。所有的服务都在 /etc/init.d 目录下。对某个服务进行操作也很方便，例如对 network 服务：
```bash
# 启动 network
/etc/init.d/network start

# 重启 network
/etc/init.d/network restart

# 停止 network
/etc/init.d/network stop

# 注册 network, 会自动在 /etc/rc.d/ 目录下建立一个链接指向 /etc/init.d 下的对应服务，如：S95network。
# S95 表示此服务的启动顺序
/etc/init.d/frp enable
```

## 进程服务的注册

script 文件结构
```bash
#!/bin/sh /etc/rc.common

USE_PROCD=1	#定义我们的脚本是新的 procd 脚本而不是老版本的 init 脚本。
START=95	#启动顺序序号。最大为 95.
STOP=15		#服务关闭顺序序号。数字越小关闭排序越靠前

start_service() {
}
service_triggers() {
}
stop_service() {
}
restart_service() {
}
```

>参考自: https://blog.niekun.net/archives/2277.html

## 参考文档
| 简介              | 网址                                     |
| ----------------- | ---------------------------------------- |
| openwrt官网资料   | https://openwrt.org/start                |
| 树莓派openwrt开发 | https://doc.openwrt.cc/2-OpenWrt-Rpi/    |
| openwrt软件包管理 | https://openwrt.org/zh/docs/techref/opkg |

## FAQ

1. openwrt 的 DDNS 是什么意思？
	DDNS英文全称Dynamic Domain Name Server，中文含义是指动态域名服务。很多普通路由器或者智能路由器设置中，都可以找到DDNS（动态DNS）功能。\
	目前路由器拨号上网获得的多半是动态IP,DDNS可以将路由器变化的外网IP和固定的域名绑定，从而用户可以在外网通过该固定域名进行访问路由器。

2. DMZ 是什么意思?
	demilitarized zone, 是一个将局域网 (LAN) 与其他不受信任的网络（通常是公共互联网）分隔开的物理或逻辑子网。在路由器中,不受信任的外部网络的访问都会转发到这个DMZ的的子网,其他部分的局域网对于外部互联网不可见.\
	设置DMZ可以提高特定电脑的NAT等级,并将其他局域网电脑的NAT等级设置为最低的对称型.

3. 中国电信作为ISP封禁了哪些端口?
   80、8080、443端口肯定是被封禁了,另外被封掉的端口还有：1068、5554、9996、1025-1027、135-139、3127-3130、4444、445、5554、593。所以如果要在家用宽带上用自定义端口搭建网站，还是用10000以上的端口吧。

4. socks5代理是什么?
   - 基于IP层的数据传输,可以传输任何协议的数据.比如各种windows的应用QQ,微信,浏览器等,都可以走socks代理.
   - Socks5代理比http代理速度要快得多
   - http代理工作在应用层, Socks5代理工作在会话层, 只是简单的传数据包

## 常用操作

### 国内openwrt镜像源

| -        | -                                            |
| -------- | -------------------------------------------- |
| 清华大学 | https://mirrors.tuna.tsinghua.edu.cn/openwrt |
| 中科大   | https://mirrors.ustc.edu.cn/openwrt          |
| 腾讯     | https://mirrors.cloud.tencent.com/openwrt    |
| 官方     | https://archive.openwrt.org/                 |
| entware  | https://bin.entware.net/mipselsf-k3.4/       |

## 基于openwrt的定制版系统

### Pandora Box
   
   Pandora Box 是 OpenWrt 的中国分支，具有专有和非免费驱动程序。

### Padavan
   
   Padavan 是华硕路由器的固件的自定义固件RT-N56U，它也适用于一些非华硕路由器。

   - Padavan与OpenWRT最大的区别是没有overlay的JFFS2文件系统，基本上目录都是不可写入的，系统不会被轻易破坏，但是系统的修改难度也很高，只能依赖于外部储存安装entware或者源码重新编译。
   > pavadan 可修改区域 /etc/storage，修改后还需要执行 mtd_storage.sh save 保存，否则所做的修改在重启或者断电后会丢失

### dd-wrt