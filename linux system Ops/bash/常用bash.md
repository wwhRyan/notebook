# 常用bash scripts

- 从字符串中提取子字符串
  ```bash
  echo "libgcc-4.8.5-4.h5.x86_64.rpm" | grep -Eo "[0-9]+\.[0-9]+.*x86_64"
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