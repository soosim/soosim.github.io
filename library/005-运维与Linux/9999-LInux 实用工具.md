# LInux 实用工具

[TOC]

## iotop

​	用来监视磁盘I/O使用状况的top类工具

## iftop

​	网络实时流量监测工具

## lrzsz 命令行上传下载文件

```shell
sz 文件   # 下载
rz       # 上传  
```
## tmux 分屏神器

## 快速切换常用目录

​	使用linux的过程中经常要切换到某些常用目录。目录又太长，我们可以利用 软连接 ，来达到快速切换目录的功能。

```shell
# mark
#书签保存的目录

export MARKPATH=$HOME/.marks

export MARKDEFAULT=soosim

function qq {
        local m=$1
        if [ "$m" = "" ]; then m=$MARKDEFAULT; fi
        cd -P "$MARKPATH/$m" 2>/dev/null || echo "No such mark: $m"
}
function mark {
        mkdir -p "$MARKPATH"
        local m=$1
        if [ "$m" = "" ]; then m=$MARKDEFAULT; fi
        rm -f "$MARKPATH/$m"
        ln -s "$(pwd)" "$MARKPATH/$m"
}
function unmark {
        local m=$1
        if [ "$m" = "" ]; then m=$MARKDEFAULT; fi
        rm -i "$MARKPATH/$m"
}
function qw {
        ls -l "$MARKPATH" | grep ^l | awk '{print $9,$10,$11}'
}
_completemarks() {
        local curw=${COMP_WORDS[COMP_CWORD]}
        ＃我改了一下，原来用ls
        local wordlist=$(find "$MARKPATH" -type l -printf "%f\n")
        COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
        return 0
}
# 提示
complete -F _completemarks qq unmark
```

将 此段脚本加入 ```.bashrc```下面，然后 ```source```一下就可以使用了。