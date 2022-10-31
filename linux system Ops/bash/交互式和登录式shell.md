# shell在运行中有两种属性,交互(interactive)和登录(login)

- shell是否和用户进行交互
- shell是否用于用户登录
  
---

## 交互(interactive)

- 交互式shell
  - 在终端执行,等待用户输入,并执行用户指令.
    ```bash
    root@ubuntu:~#
    ```
  - 类似 ubuntu terminal 图形界面打开的终端,也是交互式shell
  - 通过 `su username` 也是交互式shell
  - 通过`bash -i ***` 执行的shell script

- 非交互式shell
  - 执行shell script

- 如何区别交互式shell
  - shell启动 `-c` 选项为非交互式,`-i` 选项为交互式
  - 交互式shell具有`$PS1`,非交互式没有
  - 交互式(interactive)的`$-`变量包含`i`字符,非交互式不包含

    ```bash
    root@ubuntu:~# echo $-
    himBHs
    root@ubuntu:~# cat test.sh
    echo $-
    root@ubuntu:~# ./test.sh
    hB
    root@ubuntu:~# bash -i test.sh
    himB
    ```
---

## 登录(login)

- 登录式shell
  - 需要用户名和密码登录后的shell
  >![](image\image_10.png)

- 非登录式shell
  - 通过 `su username` 调用的shell
  - shell script 执行的子shell
  - ubuntu 图形界面打开的shell

- 如何判断是否为登录式shell?
  - 检查是否设置了login_shell属性
  ```bash
    root@ubuntu:~# shopt login_shell
    login_shell     on
    root@ubuntu:~# su postgres
    postgres@ubuntu:/root$ shopt login_shell
    login_shell     off
  ```
  >什么是login shell？
  >
  >一般来说，启动shell时需要认证（密码、公钥等方式）的shell是login shell，比如登录云服务器。
  >被其它进程直接启动的shell一般是non-login shell，比如直接执行bash命令。
  >动shell时带上--login参数的是login shell，比如直接执行命令bash --login。

---

## 登录和交互式环境变量的差异

>![](image\image_10.1.png)

- 如果一个shell是login shell，`/etc/profile` 会被调用，随后按顺序查找`~/.bash_profile`, `~/.bash_login`, 和 `~/.profile`，并执行最先找到的一个。
- 如果是交互式的non-login shell，则会调用 `~/.bashrc`
- 如果是非交互式的non-login shell，则会执行环境变量`$BASH_ENV`中的脚本（如果存在
- 大多数的登录交互式shell的启动脚本如下
  ```bash
  /etc/profile -> /etc/profile.d/* (in alphabetical order) -> ~/.bash_profile -> ~/.bash_login -> ~/.profile
  ```

