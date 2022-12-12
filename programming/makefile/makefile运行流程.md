# 运行流程

makefile 运行流程
本文讲述make工具执行makefile的规则。
先回顾一下makefile最基本的语法，如下：
```makefile
targets : prerequisites
    recipe
    …
```

make执行makefile的规则大体为：
1. 扫一遍prerequisites，生成目标（子目标）间的依赖关系，该依赖关系类似树的节点关系；
2. 根据该依赖关系以类似树的后序遍历规则进行目标的生成；

下面以一个例子说明：
```makefile
all: m n
	@echo recipe_all

m: m1 m2
	@echo recipe_m

n: n1 n2 m2
	@echo recipe_n

m1:
	@echo recipe_m1

m2:
	@echo recipe_m2

n1:
	@echo recipe_n1

n2:
	@echo recipe_n2
```

执行make，有如下输出：

```
recipe_m1
recipe_m2
recipe_m
recipe_n1
recipe_n2
recipe_n
recipe_all
```

从以上打印可以得出：
1. make时，首先会扫一遍makefile中各目标的依赖关系；
2. 目标生成的顺序：m1->m2->m->n1->n2->n->all，即类似于树的后序遍历规则进行目标的生成。

再执行命令：make m1，即生成目标m1，输出如下：
```
pre_all
pre_m
pre_n
pre_m1
pre_m2
pre_n1
pre_n2
recipe_m1
```

可得：
1. make时，会生成完整的依赖关系；
2. 不相关目标不会生成。

