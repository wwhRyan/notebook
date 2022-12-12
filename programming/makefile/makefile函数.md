# 常用函数

## make控制函数

1. **error**

   产生一个致命的错误，中断make进程,并输出对应的信息.
2. **warning**

   产生一个警告错误,输出对应信息,不会中断make
3. **info**

   产生一个告知信息,输出对应文本,不会中断make
4. 

## 字符串操作函数

1. **wildcard**

	例如：SRC = $(wildcard ./*.c)  
	匹配目录下的所有c文件

2. **subst**

   替换字符串中的字符
	```makefile
	$(subst t,e,maktfilt)
	# makefile
	```
3. **patsubst**

	pat 是 pattern 的缩写，subst是substring的缩写。对字符串进行模板的替换

	例如：`OBJ = $(patsubst %.c, %.o, $(SRC))`
	取出SRC中的所有值，然后.c结尾替换为.o结尾，然后赋值到OBJ变量
	```makefile
	SRC = $(wildcard *.c)
	OBJ = $(patsubst %.c, %.o, $(SRC))
	
	ALL: hello.out
	
	hello.out: $(OBJ)
			gcc $(OBJ) -o hello.out
	
	$(OBJ): $(SRC)
			gcc -c $(SRC) -o $(OBJ)
	```
4. **strip**

   去除空格函数，去掉字符串多余的空格，只保留最多一个空格符。

5. **filter**

	`$(filter <pattern...>,<text> )`,以<pattern>模式过滤<text>字符串中的单词，保留符合模式<pattern>的单词。可以有多个模式。
	```makefile
	sources := foo.c bar.c baz.s ugh.h
	source := $(filter %.c %.s,$(sources))
	# source = foo.c bar.c baz.s
	```
	`$(filter-out <pattern...>,<text> )` 反过滤函数,去除符合pattern的字符串

6. 

## 文件&目录操作函数

1. **dir**

   `$(dir <names...> )` 取文件目录
	```makefile
	$(dir src/foo.c hacks)
	# src/ ./
	```
2. **basename**

   提取名称中每个文件名的后缀以外的所有内容。如果文件名包含一个 `.` ，则基本名称是从最后一个 `.` 开始（但不包括）的所有内容。
   ```makefile
	$(basename src/foo.c src-1.0/bar hacks)
	# src/foo src-1.0/bar hacks
	```
3. **notdir**

   取文件名函数
	```makefile
	$(dir src/foo.c hacks)
	# foo.c hacks
	```
4. **suffix**

   取后缀函数,如果文件没有后缀,则返回空字符串.
	```makefile
	$(suffix src/foo.c src-1.0/bar.c hacks)
	# .c .c
	```
5. **addsuffix**

   加后缀函数,把后缀加到中的每个单词后面
	```makefile
	$(addsuffix .c,foo bar)
	# foo.c bar.c
	```
6. **addprefix**

   ```makefile
	$(addprefix src/,foo bar)
	# src/foo src/bar
	```
7. **foreach**

   `$(foreach <var>,<list>,<text> )`

	把参数<list>中的单词逐一取出放到参数<var>所指定的变量中，然后再执行<text>所包含的表达式。每一次<text>会返回一个字符串，循环过程中，<text>的所返回的每个字符串会以空格分隔，最后当整个循环结束时，<text>所返回的每个字符串所组成的整个字符串（以空格分隔）将会是foreach函数的返回值。
   ```makefile
	names := a b c d
	files := $(foreach n,$(names),$(n).o)
	# a.o b.o c.o d.o
	# $(name)中的单词会被挨个取出，并存到变量“n”中，“$(n).o”每次根据“$(n)”计算出一个值，这些值以空格分隔，最后作为foreach函数的返回.
	# 所以，$(files)的值是“a.o b.o c.o d.o”
	```
8. **shell**

   这个函数会新生成一个Shell程序来执行命令，所以你要注意其运行性能，如果你的Makefile中有一些比较复杂的规则，并大量使用了这个函数，那么对于你的系统性能是有害的。特别是Makefile的隐晦的规则可能会让你的shell函数执行的次数比你想像的多得多。
   ```makefile
	PATH=`pwd`
	TODAY=`date`

	#等同于
	PATH=$(shell pwd)
	TODAY=$(shell date)
   ```
9.  


   