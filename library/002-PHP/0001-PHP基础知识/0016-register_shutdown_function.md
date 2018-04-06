 ##### 注册一个会在php中止时执行的函数

 [官方文档](http://php.net/manual/zh/function.register-shutdown-function.php)

 ```php
if ( ! function_exists('_shutdown_function')) 
{
    function _shutdown_function(){
        $error = error_get_last();
        var_dump($error);
    }
}

register_shutdown_function('_shutdown_function');

 ```