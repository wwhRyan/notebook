# 基本的git操作

## 撤回
- 已暂存撤回\
    `git reset HEAD`

- 未暂存撤回\
    `git checkout .`

## 删除
- 查看将要被删除的文件\
    `git clean -n`
    
- 删除未跟踪文件\
    `git clean -df`
    > -d 删除
    > -f 强制

- 取消文件的跟踪\
    `git rm -rf --cache file`
