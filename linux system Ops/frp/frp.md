# frp

## 要点问答

1. frpc 客户端如何热更新对应的配置文件？
   1. 在frpc中启用admin（管理员）端口，用于提供 API 服务。在frpc.ini头部common段加入如下配置：
		```ini
		# frpc.ini
		[common]
		admin_addr = 127.0.0.1
		admin_port = 7400
		```
		之后,执行frpc所在目录重启命令:
		`./frpc reload -c ./frpc.ini`
		> 注意: 端口 7400 应该是本机的端口, 如果做了端口映射、DMZ、upnp等端口修改的操作,此方法不可行
	2. 新增frpc客户端服务,然后杀死旧的客户端进程
		```bash
		./frpc -c ./new/frpc.ini
		ps aux | grep "old/frpc.ini" | grep -v grep | awk '{print $2}' | xargs kill 
		```
		新增的frpc客户端进程在端口被占用时，会不断的尝试启用，大概隔20几秒就尝试一次。、
		大概等20几秒就可以更新客户端配置