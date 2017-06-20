# PHP mysql_ping

最近遇到一个奇怪的错误，task任务SQL操作遇到“MySQL server has gone away“错误，重启task后正常。

最终定位到出现错误的原因：

如果使用了长连接而长期没有对[数据库](http://lib.csdn.net/base/mysql)进行任何操作，那么在timeout值后，[MySQL](http://lib.csdn.net/base/mysql) server就会关闭此连接，而客户端在执行查询的时候就会得到一个类似于“MySQL server has gone away“这样的错误。

解决方案：

1.  使用mysql_ping() 检查到服务器的连接是否正常。如果断开，则自动尝试连接。本函数可用于空闲很久的脚本来检查服务器是否关闭了连接，如果有必要则重新连接上。如果到服务器的连接可用则 **mysql_ping()** 返回 **TRUE**，否则返回**FALSE**。

2. PDO中未实现mysql_ping方法。可自定义方法实现相关功能。

   ```php
   // The ping() will try to reconnect once if connection lost.
       public function ping() {
           try {
               $this->pdo->query('SELECT 1');
           } catch (PDOException $e) {
               $this->init();            // Don't catch exception here, so that re-connect fail will throw exception
           }

           return true;
       }

       private function init() {
           $class = new ReflectionClass('PDO');
           $this->pdo = $class->newInstanceArgs($this->params);
       }
   ```

   ​