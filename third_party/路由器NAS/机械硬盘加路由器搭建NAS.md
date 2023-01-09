# 路由器 + 机械硬盘 = NAS

NAS的想法是路由器外接一个硬盘，实现多媒体文件的自动离线下载，同时实现DDNS内网穿透，随时随地访问的多媒体云。

## 外接硬盘

1. 硬盘的供电
   - 移动硬盘的话，常见的2.5寸硬盘盒‍需要0.5~0.9A的5V供电启动。可以算出，电机启动瞬时大功率需求，大约是0.9*5=4.5W。过了启动阶段，这个电源需求会降低
   - 3.5寸硬盘，同时要求12V和5V供电，并且启动瞬时功率需要30W以上
   - USB 2.0 5V 0.5A
   - USB 3.0 5V 0.9A, USB 3.0的电源供应就足够2.5寸硬盘供电。
   - USB 3.1定义了多个USB电力传递模式，大功率可以达到100W——不过一般只用于电源适配器向电脑/设备供电,目前还没看到支持反向供电100W的主板上市。
	> 早期的主板不支持USB 3.0的，如果移动硬盘里面的机械硬盘用的是0.9A启动的型号，经常会出现插上去不认盘的现象

2. 硬盘的读写
   - 家用级的2.5寸硬盘，读写速度一般在75~150MB/s之间
   - 3.5寸硬盘，已经可以达到100~200MB/s

3. 硬盘容量
   - 标准盘体（9.5mm厚）2.5寸硬盘盒‍只能做到2TB
   - 超厚盘体（12.7mm）2.5寸硬盘盒‍才能达到4TB
   - 3.5寸硬盘，已经有12TB容量的在售

4. 机械硬盘的抗震
   - 硬盘抗冲击里的 Gs 中 G 与 s 分别代表两个物理量，其中大写的 G 代表的是重力加速度，而小写的 s 代表的是时间(秒)。合在一起的意思是，单位时间(秒)内的重力加速度变化值。
   - ![](2023-01-04-14-46-02.png)
   - 机械硬盘防震 TBD

## 路由器的选择

需要一个价格便宜，具有USB3.0接口的路由器，支持第三方固件刷入，最好支持千兆网络。

小米路由器支持老毛子padavan固件（贴吧信息），价格便宜，3系是2016年量产，其中一款小米路由器3G是千兆路由器，性价比高。

![](2023-01-04-10-52-12.png)

还对比了同期（250元内）名气比较大的路由器：小米路由器3G 腾达AC9 网件R6220 斐讯K2P

其他的路由器的USB接口都是USB2.0，接移动硬盘有供电风险。选中了小米路由器3G （R3G）

## 路由系统的优化过程

1. pavadan 
   
   pavadan 是我的首选系统，但是之前在极路由上用的很方便。但是发现我的128M flash的文件系统用不到10%，扩展程序需要重编译固件或者额外的储存设备。我的硬盘是单纯的存储数据的，不想要存放这些程序。我又不想麻烦的重新编译固件，太费时间，需要多次测试。

   > 将entware安装到硬盘的话,我觉得会频繁的读硬盘,对硬盘寿命有影响.如果是U盘或者SD卡,我觉得可以用这个方法扩展功能.

   ```bash
   MI-R3G:/home/root # df
   Filesystem           Type            Size      Used Available Use% Mounted on
   rootfs               rootfs         10.8M     10.8M         0 100% /
   /dev/root            squashfs       10.8M     10.8M         0 100% /
   tmpfs                tmpfs           8.0K         0      8.0K   0% /dev
   tmpfs                tmpfs           6.0M    964.0K      5.1M  16% /etc
   tmpfs                tmpfs           1.0M      4.0K   1020.0K   0% /home
   tmpfs                tmpfs           8.0K         0      8.0K   0% /media
   tmpfs                tmpfs           8.0K         0      8.0K   0% /mnt
   tmpfs                tmpfs          24.0M     60.0K     23.9M   0% /tmp
   tmpfs                tmpfs           4.0M     68.0K      3.9M   2% /var
   /dev/sda1            ufsd            1.8T    287.4G      1.5T  15% /media/WD_2T
   ```
   padavan更合适当普通路由器用，暂时研究到这里.

2. openwrt 原版
   原版的openwrt太简陋了.不是很友好.

3. openwrt lean 定制版 https://www.right.com.cn/forum/thread-3191532-1-1.html
   将基本的功能都打包进去了,也可以增加自定义的功能到flash中,符合我的需求




## 文件共享服务


转而思考小米路由器3G提供webdav服务共享给软路由，尽可能的减少路由器性能消耗。由高性能软路由提供多媒体服务。

思考如何最简单的webdav服务搭建？

![](2023-01-05-23-27-50.png)

性能消耗：

可道云（php）kiftd（Java）> chfs（C 语言）> Caddy(Go) > hacdias/webdav(Go 功能单一)

可道云、kiftd等高级语言写的私有云系统都是基于数据库，chfs、Caddy、hacdias/webdav都是基于系统的文件系统，消耗更小。

老毛子自带有owncloud、nextcloud、可道云、SeaFile，可以作为私有云的系统。

[对于文件服务器极简性能的交流帖](https://www.v2ex.com/t/766471)

chfs程序文件10M左右，运行使用虽然都正常，内存占用20M左右，但是cpu占用100%

hacdias webdav程序文件只有8M左右，运行起来消耗的内存在10M以内，CPU占用小。[github release](https://github.com/hacdias/webdav/releases) 选择linux-mipsle-webdav。
## 离线下载

aria2 是一个用于下载文件的实用程序。支持的协议有 HTTP(S)、FTP、SFTP、BitTorrent 和 Metalink。老毛子中有对应的简单配置。

aria2优秀的地方：
- 支持 BitTorrent Metalink 协议
- 远程控制（通过 web 端）下载进程
- 支持多线程下载
- 支持迅雷链接下载
- 搭配Chrome插件 `迅雷离线助手`,可以实现远程推送,自动下载

## DDNS

## 局域网VPN

代理选择通过V2Ray访问局域网，实现一个端口加密安全的暴露所有的内网服务。主机客户端需要安装V2Ray，移动客户端需要安装shadowrocket。
mi路由器作为V2Ray服务端，实现vmess协议的分发请求到局域网内各个成员。

示意图：
```
 URL                    switchyomega       proxy
                                           inbound   router          outbound

 baidu.com          +-->proxy+------------>socks5+-->domain router+  vps +---> vmess
 webdav.mi.home:8080+   direct                                    +->home+
 google.com




 inbound     domain router   outbound

 vmess+----->home+---------->IP:port+---> 192.168.1.6.8080
             others drop
```

## 软路由搭建方案

软路由的主流方案都是作为主路由,作为光猫桥接后的主要路由器,可以充分的利用的带宽资源.硬路由只是作为一个无线AP.

软件系统一是采用openwrt或者第三方定制系统(基于openwrt),由此可以使用现有的系统中开源的各类插件,迅速实现需要的nas功能.

二是采用群辉等专业nas系统,依托于社区环境的丰富插件,方便的实现很多性能要求很高的功能.

冷门的方案:
- 单网口软路由
- Ubuntu系列linux系统搭建软路由
- WSL虚拟机软路由

