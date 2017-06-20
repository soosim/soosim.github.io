# PHP标准库

## 标准库简介

​	SPL是Standard PHP Library（PHP标准库）的缩写。从PHP5.0以上开始支持，并且内置，无需进行任何配置便可以运行。

​	详情请查阅

​		 [PHP官方文档](http://php.net/manual/zh/book.spl.php)

​		[阮一峰的博客](http://www.ruanyifeng.com/blog/2008/07/php_spl_notes.html)	

## 迭代器

目前感觉比较实用的迭代器：

1. DirectoryIterator [查看详情](http://php.net/manual/zh/class.directoryiterator.php)		
2. GlobIterator [查看详情](http://php.net/manual/zh/class.globiterator.php)

## 常用SPL函数

- [spl_autoload_functions](http://php.net/manual/zh/function.spl-autoload-functions.php) — 返回所有已注册的__autoload()函数。
- [spl_autoload_register](http://php.net/manual/zh/function.spl-autoload-register.php) — 注册给定的函数作为 __autoload 的实现

