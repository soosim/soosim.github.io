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

## expect 交互处理
Expect是一个用来处理交互的命令。借助Expect，我们可以将交互过程写在一个脚本上，使之自动化完成。

博客:

[http://www.jianshu.com/p/5bf59848d5a9](http://www.jianshu.com/p/5bf59848d5a9)



基本使用：

```shell
# 基本命令：
send：用于向进程发送字符串
expect：从进程接收字符串
spawn：启动新的进程
interact：允许用户交互

# 示例一:
#!/usr/bin/expect
spawn ssh root@192.168.22.194
expect "*password:"
send "123\r"
expect "*#"
interact

# 示例二：
set timeout -1
spawn sudo ssh -p 22 -i /tmp/dev.pem jinlong@1.1.1.1
expect "*username*"
send "password\r"
expect "*key*"
send "primary_key\r"
interact
```

嵌入bash:

```shell
#!/usr/bin/bash
...
expect<<- END 
scp -r -P 2214:lex@192.168.120.204:/data/user/user.profile  ./ 
expect "*password"
send "password"
expect eof 
END
```

将expect脚本嵌入expect<<- END 和END之间即可