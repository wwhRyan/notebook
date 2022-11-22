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