# clangd

clangd 插件可以静态代码扫描的功能，对比vscode自带的`C/C++` 插件,性能好了很多.而且代码提示也有很大的提升.

clagnd 识别JSON文件,产生JSON的一些方案:
- make + https://github.com/nickdiego/compiledb
- cmake自带JSON文件输出