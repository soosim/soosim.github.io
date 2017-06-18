# Fiddler 命令行的应用

[TOC]

## 1.请求筛选

### select 命令

​	选择所有相应类型（指content-type）为指定类型的HTTP请求，如：

​	1.```select html``` : 能筛选出所有```content-type```包含```html```的请求

​	2.```select json``` : 能筛选出所有```content-type```包含```json```的请求

​	3.同理，还能适用于```css、image、javascript```等等

### allbut 命令

​	allbut命令用于选择所有响应类型不是给定类型的HTTP请求。例如：

​	使用 ```allbut json```将会**删除所有类型不包括json的请求**



### = 命令

​	选择等于此类型、状态的请求，如：

​	1.输入命令```=POST```然后点击```enter```就能选中所有POST的请求行。

​	2. ```=404```，筛选Response CODE = 404 的请求

###   ?text 命令

​	选择所有 **URL、HOST、Protocol** 匹配问号后的字符的全部 session

### >size 和 <size命令

​	选择响应 ```Body``` 大小大于某个大小（单位是b）或者小于某个大小的所有HTTP请求

### @host命令
​	选择包含指定 HOST 的全部 HTTP请求。例如：@ifchange.com
​	选择所有host包含ifchange.com的请求

## 批量断点

​	pafter xxx: 中断 URL 包含指定字符的全部 session 响应

​	Bps xxx: 中断 HTTP 响应状态为指定字符的全部 session 响应。

​	Bpv xxx: 中断指定请求方式的全部 session 响应

​	Bpm xxx: 中断指定请求方式的全部 session 响应。等同于bpv xxx

​	Bpu xxx:与bpafter类似。

​	当这些命令没有加参数时，会清空所有设置了断点的HTTP请求。

​	更多的其他命令可以参考Fiddler官网手册。






