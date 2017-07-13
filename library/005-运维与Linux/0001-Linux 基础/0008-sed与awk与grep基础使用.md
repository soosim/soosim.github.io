# sed与awk与grep

[TOC]

## sed

​	多转自博客：http://www.cnblogs.com/ggjucheng/archive/2013/01/13/2856901.html

### 简介

​	sed 是一种在线编辑器，它一次处理一行内容。处理时，把当前处理的行存储在临时缓冲区中，称为“模式空间”（pattern space），接着用sed命令处理缓冲区中的内容，处理完成后，把缓冲区的内容送往屏幕。接着处理下一行，这样不断重复，直到文件末尾。文件内容并没有 改变，除非你使用重定向存储输出。

```
[root@www ~]# sed [-nefr][动作] [动作]
选项与参数：
-n ：使用安静(silent)模式。在一般 sed 的用法中，所有来自 STDIN 的数据一般都会被列出到终端上。但如果加上 -n 参数后，则只有经过sed 特殊处理的那一行(或者动作)才会被列出来。
-e ：直接在命令列模式上进行 sed 的动作编辑；
-f ：直接将 sed 的动作写在一个文件内， -f filename 则可以运行 filename 内的 sed 动作；
-r ：sed 的动作支持的是延伸型正规表示法的语法。(默认是基础正规表示法语法)
-i ：直接修改读取的文件内容，而不是输出到终端。

动作说明： [n1[,n2]]function
n1, n2 ：不见得会存在，一般代表『选择进行动作的行数』，举例来说，如果我的动作是需要在 10 到 20 行之间进行的，则『 10,20[动作行为] 』

function：
a ：新增， a 的后面可以接字串，而这些字串会在新的一行出现(目前的下一行)～
c ：取代， c 的后面可以接字串，这些字串可以取代 n1,n2 之间的行！
d ：删除，因为是删除啊，所以 d 后面通常不接任何咚咚；
i ：插入， i 的后面可以接字串，而这些字串会在新的一行出现(目前的上一行)；
p ：列印，亦即将某个选择的数据印出。通常 p 会与参数 sed -n 一起运行～
s ：取代，可以直接进行取代的工作哩！通常这个 s 的动作可以搭配正规表示法！例如 1,20s/old/new/g 就是啦！
```

### 基本使用示例

```shell
# 将 /etc/passwd 的内容列出并且列印行号，同时，请将第 2~5 行删除
nl /etc/passwd | sed  '2,5d'

# 将第2-5行的内容取代成为『No 2-5 number』
nl /etc/passwd | sed '2,5c No 2-5 number'

# 仅列出 /etc/passwd 文件内的第 5-7 行
nl /etc/passwd | sed -n '5,7p'

# 搜索 /etc/passwd有root关键字的行
nl /etc/passwd | sed -n '/root/p'

# 数据的搜寻并替换
sed 's/要被取代的字串/新的字串/g'

# 搜索/etc/passwd,找到root对应的行，执行后面花括号中的一组命令，每个命令之间用分号分隔，这里把bash替换为blueshell，再输出这行; 只替换/etc/passwd的第一个bash关键字为blueshell，就退出
nl /etc/passwd | sed -n '/root/ {s/bash/blueshell/;p;q}'

# 每行末尾追加字符AAA
sed -i 's/$/AAA/' 1.txt

# 去除文件行尾^M
sed -i 's/\^M//g' 1.txt
```



## awk

​	原文多摘自：[http://www.cnblogs.com/ggjucheng/archive/2013/01/13/2858470.html](http://www.cnblogs.com/ggjucheng/archive/2013/01/13/2858470.html)

​	awk是一个强大的文本分析工具，相对于grep的查找，sed的编辑，awk在其对数据分析并生成报告时，显得尤为强大。简单来说awk就是把文件逐行的读入，以空格为默认分隔符将每行切片，切开的部分再进行各种分析处理。

### 调用方式

有三种方式调用awk：

#### 命令行方式

awk [-F  field-separator]  'commands'  input-file(s)
其中，commands 是真正awk命令，[-F域分隔符]是可选的。 input-file(s) 是待处理的文件。
在awk中，文件的每一行中，由域分隔符分开的每一项称为一个域。通常，在不指名-F域分隔符的情况下，默认的域分隔符是空格。

#### shell脚本方式

将所有的awk命令插入一个文件，并使awk程序可执行，然后awk命令解释器作为脚本的首行，一遍通过键入脚本名称来调用。
相当于shell脚本首行的：#!/bin/sh
可以换成：#!/bin/awk

#### 将所有的awk命令插入一个单独文件，然后调用：

awk -f awk-script-file input-file(s)
其中，-f选项加载awk-script-file中的awk脚本，input-file(s)跟上面的是一样的。

### 常用内置变量
```shell
ARGC               命令行参数个数
ARGV               命令行参数排列
FILENAME           awk浏览的文件名
FNR                浏览文件的记录数
FS                 设置输入域分隔符，等价于命令行 -F选项
NF                 浏览记录的域的个数
NR                 已读的记录数
```

### 使用示例

```shell
cat /etc/passwd |awk  -F ':'  'BEGIN {print "name,shell"}  {print $1","$7} END {print "blue,/bin/nosh"}'
name,shell
root,/bin/bash
....
blue,/bin/nosh
```

```shell
# 搜索/etc/passwd有root关键字的所有行
awk -F: '/root/' /etc/passwd
root:x:0:0:root:/root:/bin/bash

# 搜索/etc/passwd有root关键字的所有行，并显示对应的shell
awk -F: '/root/{print $7}' /etc/passwd             
/bin/bash
```

```shell
cat /etc/passwd | awk -F : '$3 > 100 {print $0}'
```

```shell
 awk  -F ':'  '{printf("filename:%10s,linenumber:%s,columns:%s,linecontent:%s\n",FILENAME,NR,NF,$0)}' /etc/passwd
```

```shell
# 变量赋值
echo "test"  | awk  'x=2,y=3 {print x*2, y*3}'

# 统计空白行数量
awk  '/^$/ {x+=1}  END {print x}'   test.txt

# 统计所有空白行
awk  '/^$/ {print x+=1}'   test.txt

# 打印空白行行号
cat .bashrc | awk '/^$/ {print NR}'

# 统计空白行数量
cat .bashrc | awk 'BEGIN {x=0} /^$/ {x+=1} END {print x}' 

# 取本机IP地址
ifconfig | sed -n 2 's/^[ \t]*//'p | cut -d " " -f 2
```




## grep

```shell
# 多个文件中查找
grep linuxtechi /etc/passwd /etc/shadow /etc/gshadow

# 在文件中查找指定模式并显示匹配行的行号
grep -n root /etc/passwd

# 使用-v参数输出不包含指定模式的行
grep -v root /etc/passwd

# 使用正则
grep ^soosim /etc/passwd
grep bash$ /etc/passwd
cat ~/.bashrc | grep -n ^$  # 输出空行行号

# 忽略大小写
grep -i soosim /etc/passwd

# 使用 -e 参数查找多个模式
grep -e 'soosim' -e 'root' /etc/passwd

# 使用扩展正则表达式
grep -E 'soosim|root' /erc/passwd

# 使用-c 统计匹配到的行数
grep -c -e 'soosim' -e 'root' /etc/passwd

# 使用 -A -B -C 参数
grep -A 5 soosim /etc/passwd  # 打印出搜索结果前5行
grep -B 5 soosim /etc/passwd  # 打印出搜索结果后5行
grep -C 5 soosim /etc/passwd  # 打印出搜索结果前后5行
```

### grep扩展：

#### egrpe：

egrep = grep -E 可以使用基本的正则表达外, 还可以用扩展表达式.

#### fgrep:

fgrep命令是用来查找一个或多个与给出的字符串或词组相匹配文件中的行。fgrep 查询速度比grep命令快，但是不够灵活：它只能找固定的文本，而不是规则表达式 

#### pgrep：

来自: [http://man.linuxde.net/pgrep](http://man.linuxde.net/pgrep)

pgrep命令以名称为依据从运行进程队列中查找进程，并显示查找到的进程id。每一个进程ID以一个十进制数表示，通过一个分割字符串和下一个ID分开，默认的分割字符串是一个新行。对于每个属性选项，用户可以在命令行上指定一个以逗号分割的可能值的集合。

另：相似命令```pidof```

##### 参数

```shell
-o：仅显示找到的最小（起始）进程号； 
-n：仅显示找到的最大（结束）进程号； 
-l：显示进程名称； 
-P：指定父进程号； 
-g：指定进程组； 
-t：指定开启进程的终端； 
-u：指定进程的有效用户ID。
```

##### 实例

```shell
[root@localhost ~]# pgrep httpd 
4557 
4560 
4561

[root@localhost ~]# pgrep -l httpd 
4557 httpd 
4560 httpd 
4561 httpd
```

