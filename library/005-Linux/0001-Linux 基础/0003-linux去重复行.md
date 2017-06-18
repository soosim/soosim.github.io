# linux 去重复行

[TOC]

## 一、去掉相邻重复行

```shell
cat 1.txt | uniq
# 或 uniq 1.txt
aaaa
bbbb
aaaa
```

## 二、去掉所有重复的数据行

```shell
cat 1.txt | sort | uniq
sort -u 1.txt
sort 1.txt | uniq
uniq -u 1.txt
```

## 三、仅显示重复出现的列

```shell
uniq -d 1.txt
```

## 四、去重计数

```shell
sort 1.txt | uniq -c
3 aaaa
1 asdsafas
3 ffff
2 sdafasf
3 ssss
```

