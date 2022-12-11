# 搭建内网穿透的windows服务器

遇到问题:
1. sshpass在openwrt中不能安装,hiWiFi是通过源码编译的形式进行安装的.
   需要广泛的找别人的帖子中使用过的sshpass.是mips架构的32位处理器的程序.或者拷贝hiwifi固件中的sshpass进程.估计他们开发的时候,图省事,特意编译这个sshpass进去.
   源码:wget http://sourceforge.net/projects/sshpass/files/sshpass/1.05/sshpass-1.05.tar.gz

2. 路由器DHCP模式下,ip不固定.
   光猫的DHCP没有特定的MAC地址绑定IP的功能.并且这个系统如果依赖于光猫的设置,那么移植性就不会太好.

3. windows中ssh服务端密钥登录的设置,等待整理
   | -                                                                | -                                                                       |
   | ---------------------------------------------------------------- | ----------------------------------------------------------------------- |
   | https://zhuanlan.zhihu.com/p/111812831                           | 多台WIN10之间的SSH免密登录 - 知乎                                       |
   | https://segmentfault.com/a/1190000038657243                      | Windows系统下实现服务器SSH免密登录 - 狐七的前端之路 - SegmentFault 思否 |
   | https://www.cnblogs.com/sparkdev/p/10166061.html                 | Windows 支持 OpenSSH 了！ - sparkdev - 博客园                           |
   | http://woshub.com/using-ssh-key-based-authentication-on-windows/ | Configuring SSH Public Key Authentication on Windows                    | Windows OS Hub |
   | https://zhuanlan.zhihu.com/p/404179039                           | Windows OpenSSH 服务器启用密钥登录 - 知乎                               |
   | https://lab.snomiao.com/SNOLAB-481C                              | Windows 启用 OpenSSH Server 及无密码登录操作笔记 ''                     | 雪星实验室     |