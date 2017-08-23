### 常用/实用命令

#### 按照使用内存大小排序列出进程

```shell
ps aux --sort=rss | sort -k 6 -rn
```



