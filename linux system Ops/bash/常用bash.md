# 常用bash scripts

- 从字符串中提取子字符串
  ```bash
  $ echo "libgcc-4.8.5-4.h5.x86_64.rpm" | grep -Eo "[0-9]+\.[0-9]+.*x86_64"
  $ 4.8.5-4.h5.x86_64
  ```
  >- `-E` 开启扩展（Extend）的正则表达式
  >- `-o` 只截取正则匹配的部分

- 使用字符分割字符串
  ```bash
  echo $1 | cut -d "V" -f2 | cut -d "_" -f1 | awk '{print int($0)}'
  ```
  >获得`_`为分割符的中间的元素
  >
  >输入 `***_V1.00_***` 会获得 V1.00

- 查找相似文件名的文件，并执行删除操作
  ```bash
  find . -name *_*xample_S32K342 | xargs rm -rfv
  ```

- 批量修改文件名

  删除所有的企业微信截图的前缀,只留下时间作为文件名.
  ```bash
  for file in $(find . -name "*企业微信截图_*"); do mv $file $(echo $file | sed 's/企业微信截图_//g'); done
  ```

- 取括号中的字符,例子:获取ip地址
  ```bash
  $ arp -a | grep b4:2e:99:30:fa:c0
  ? (192.168.1.9) at b4:2e:99:30:fa:c0 [ether]  on br0
  $ arp -a | grep b4:2e:99:30:fa:c0 | cut -d '(' -f2 | cut -d ')' -f1
  192.168.1.9
  ```

- ln -s 建立目录软连接
  ```
  ln -s 源目录/文件 目标目录/文件
  ```
  - 要用绝对路径写才能识别为目录，我一直用相对路径结果一直失败。
  - 目标目录在建立连接之前不能存在，但要保证它的上级目录存在。

- linux环境下文件完全复制(属性不变)
  ```bash
  cp -avx /home/* /mnt/newhome
  # 
  ```
  
- 磁盘操作
  - df -h 查看磁盘分区和挂载点信息
  - fdisk -l 查看挂载情况