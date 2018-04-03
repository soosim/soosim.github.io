#### PHP set_exception_handler
[官方文档](http://php.net/manual/zh/function.set-exception-handler.php "官方文档")已经写的很明白了，建议查看官方文档。

该函数有个非常大的好处，就是处理用于没有用 try/catch 块来捕获的异常。这在框架中、项目中非常有用。

特别是在PHP7中，新增了Error类型的异常，该函数也能捕获Error类型异常。

几个简单例子，从[官方文档](http://php.net/manual/zh/function.set-exception-handler.php "官方文档")抄来的：

```php
<?php
function exception_handler($exception) {
  echo "Uncaught exception: " , $exception->getMessage(), "\n";
}

set_exception_handler('exception_handler');

throw new Exception('Uncaught Exception');
echo "Not Executed\n";
?
```


使用自定义异常类：
```php
<?php
class ExceptionHandler {
    public static function printException(Exception $e) {
        echo 'Uncaught '.get_class($e).', code: ' . $e->getCode() . "<br />Message: " . htmlentities($e->getMessage())."\n";
    }

    public static function handleException(Exception $e) {
         self::printException($e);
    }
}

set_exception_handler(array("ExceptionHandler", "handleException"));

class NewException extends Exception {}

try {
  throw new NewException("Catch me once", 1);
} catch (Exception $e) {
  ExceptionHandler::handleException($e);
}

throw new Exception("Catch me twice", 2);
?>
```