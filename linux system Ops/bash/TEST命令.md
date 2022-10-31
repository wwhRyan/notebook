# TEST

## TEST测试某个条件是否成立，分为数值、字符串和文件

### 数值测试，只支持整数，不支持浮点数

- `-eq`  数值相等
- `-ne` 数值不相等
- `-gt` 数值大于
- `-lt` 数值小于
- `-ge` 数值大于或者等于
- `-le` 数值小于或者等于

> example
```bash
root@ubuntu:~# test 12 -eq 23
root@ubuntu:~# echo $?
1
root@ubuntu:~#
```

### 字符串测试

- `=` 字符串相等
- `==` 字符串相等，与`=`相等
- `!=` 字符串不相等
- `-z string` 字符串长度为零
- `-n string` 字符串长度不为零
- `>` str1字母顺序是否大于str2
- `<` str1字母顺序是否小于str2

> example
```bash
root@ubuntu:~# test 'hello'='hello'
root@ubuntu:~# echo $?
0
root@ubuntu:~# test -n 'hello'
root@ubuntu:~# echo $?
0
root@ubuntu:~#
```

### 文件测试

- `-e` 如果文件存在
- `-r` 如果可读文件存在
- `-w` 如果可写文件存在
- `-x` 如果可执行文件存在
- `-d` 如果目录文件存在
- `-f` 如果普通文件存在
- `-c` 如果字符特殊文件存在
- `-d` 如果块特殊文件存在
- ...
  
>example
```bash
root@ubuntu:~# test -e 3LCD
root@ubuntu:~# echo $?
0
root@ubuntu:~# test -e 3LCDV
root@ubuntu:~# echo $?
1
```



