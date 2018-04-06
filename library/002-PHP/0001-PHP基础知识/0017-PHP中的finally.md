#### PHP中的finally

以前看python和java的异常处理机制中都有finally的实现，一直以为PHP没有。最近才发现鸟哥早在2012年已经在5.5版本中实现了。

[风雪之隅博客](http://www.laruence.com/2012/08/16/2709.html)
[PHP官方文档](http://php.net/manual/en/language.exceptions.php)

**不过使用中同其他语言一样，要养成良好的代码习惯，避免在finally块中使用return，这样会忽略try或catch中的return语句，造成逻辑混乱，容易产生bug。**

贴段伪代码：
```php

try {
    echo inverse(5) . "\n";
} catch (Exception $e) {
    echo 'Caught exception: ',  $e->getMessage(), "\n";
} finally {
    echo "First finally.\n";
}
```
