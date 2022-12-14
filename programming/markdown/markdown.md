# markdown备忘

## 基本语法

- [markdown备忘](#markdown备忘)
  - [基本语法](#基本语法)
    - [标题](#标题)
    - [段落和换行](#段落和换行)
    - [强调语法](#强调语法)
    - [引用语法](#引用语法)
    - [列表语法](#列表语法)
      - [无序列表](#无序列表)
      - [任务列表](#任务列表)
      - [有序列表](#有序列表)
    - [代码框](#代码框)
    - [分隔线](#分隔线)
    - [链接语法](#链接语法)
    - [插入图片](#插入图片)
    - [转义字符](#转义字符)
  - [扩展语法](#扩展语法)
    - [表格](#表格)
    - [脚注](#脚注)
    - [删除线](#删除线)
    - [任务列表](#任务列表-1)
    - [LaTeX 公式](#latex-公式)

>Markdown All in One:Create Table of Contents 实时更新文章目录

### 标题

`# level1` 

`## level2`

`### level3`

`#### level4`

`##### level5`

没有特殊符号开头的文字就是正文段落。正文段落之间必须有**空行**。没有**空行**的换行会被认为仍然是一段话

### 段落和换行

要创建段落和换行，可以使用空白行进行分隔。空格和制表符是没有用的。多少个连续的**空格**,在markdown都视为一个**空格**\
在当前行的结尾加 两个空格 或者 `\` 就可以进行换行,另起新行.

### 强调语法

`**粗体**` **粗体**

`*斜体*` *斜体*

### 引用语法

```markdown
>这是一个引用

>引用
>> 嵌套

>- 引用列表1
>- 引用列表2
```

### 列表语法

#### 无序列表

```markdown
* Item 1
* Item 2
    * item 3a
    * item 3b
```

```markdown
- Item 1
- Item 2
```

```markdown
+ Item 1
+ Item 2
```
#### 任务列表

```markdown
- [ ] Checkbox off
- [x] Checkbox on
```

#### 有序列表

```markdown
1. Item 1
2. Item 2
    a. item 3a
    b. item 3b
```

### 代码框

\`\`\` 后面增加语言名称,如JavaScript,然后这里面的代码就会按照对应的语法进行高亮显示.支持高亮显示的语言有:
`shell` `c` `c#` `java` `json` `python` `matlab` `go` 等

```python
print('hello')
```

### 分隔线

---

### 链接语法

`[Markdown语法](https://markdown.com.cn)`

 [Markdown语法](https://markdown.com.cn)

`[Markdown语法](https://markdown.com.cn "最好的markdown教程")`

 [Markdown语法](https://markdown.com.cn "最好的markdown教程")

>鼠标悬停在超链接上,会显示对应的title

### 插入图片

`![插入图片](./image/Sponbob.jpg "海绵宝宝")`

![插入图片](./image/Sponbob.jpg "海绵宝宝")

### 转义字符

| 字符 | 转义   | 描述                               |
| ---- | ------ | ---------------------------------- |
| \\   | \\\\   | backslash 反斜杠                   |
| \`   | \\\`   | backtick 反引号                    |
| \*   | \\\*   | asterisk 星号                      |
| \_   | \\\_   | underscore 下划线                  |
| \{\} | \\\{\} | curly braces 花括号                |
| \[\] | \\\[\] | square brackets 方括号             |
| \(\) | \\\(\) | parentheses 圆括号                 |
| \#   | \\\#   | hash mark 哈希标记                 |
| \+   | \\\+   | plus sign 加号                     |
| \-   | \\\-   | minus sign \(hyphen\) 减号(连字符) |
| \.   | \\\.   | dot 点                             |
| \!   | \\\!   | exclamation mark 感叹号            |

- \* \# \\ \. 等字符需要加反斜杠可以进行转义
- &lt; &amp; 这两个字符是特殊的,分别是`&lt;` `&amp;`
- 本质上markdown会转换为网页进行渲染,有一些共同特性

---

## 扩展语法
>并非所有Markdown应用程序都支持扩展语法元素。这里使用vscode markdown all in one 插件解析markdown扩展语法

### 表格

| 左栏     | 中间栏   | 右栏  |
| -------- | -------- | ----- |
| 单元格 1 | 居中     | $1600 |
| 单元格 2 | 单元格 3 | $12   |
> vscode markdown all in one 插件提供表格的格式化 `alt + shift + F`

### 脚注

vscode markdown all in one 插件不支持

### 删除线

```markdown
~~世界是平坦的。~~
```

~~世界是平坦的。~~ 我们现在知道世界是圆的。

### 任务列表

```markdown
- [x] Write the press release
- [ ] Update the website
- [ ] Contact the media
```
- [x] Write the press release
- [ ] Update the website
- [ ] Contact the media

### LaTeX 公式

```
$$
e=mc^2
$$
```

$$
e=mc^2
$$

在文本中嵌入数学公式 `$x^2$` --> $x^2$
