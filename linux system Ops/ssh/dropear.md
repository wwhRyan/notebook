# dropear

dropbear是一款基于ssh协议的轻量sshd服务器，与OpenSSH相比，他更简洁，更小巧，运行起来占用的内存也更少。每一个普通用户登录，OpenSSH会开两个sshd进程，而dropbear只开一个进程，所以其对硬件要求更低，也更利于系统的运行。Dropbear特别用于嵌入式的Linux（或其他Unix）系统.

dropbear 主要有以下程序：

- 服务程序：dropbear （类似于Openssh的 sshd）
- 客户程序：dbclient （类似于Openssh的 ssh）
- 密钥生成程序：dropbearkey
- 授权文件位置 /etc/dropbear/authorized_keys


# 常用指令

1. 生成key
   ```
	# 生成RSA算法私钥
   dropbearkey -t rsa -f /etc/dropbear/id_rsa
	# 生成RSA算法公钥
	dropbearkey -y -f /etc/dropbear/id_rsa | grep "^ssh-rsa " > /etc/dropbear/id_rsa.pub
	# 生成ecdsa算法私钥
	dropbearkey -t ecdsa -f /etc/dropbear/dropbear_ecdsa_host_key
   ```
2. 启动
   ```
   dropbear -p 22
   ```
