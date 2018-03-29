#### session_set_save_handler — 设置用户自定义会话存储函数

[官方文档](http://php.net/manual/zh/function.session-set-save-handler.php)说的很清楚了,也有MySQL相关示例。

这里贴一个现在项目中使用的memcache处理的代码
```php
class memcacheSessionHandler{
    private $host      = "localhost";
    private $port      = 11212;
    private $lifetime  = 0;
    private $memcached = null;
    private $session_prefix='memc.sess.key.';

    /**
     * Constructor
     */
    public function __construct(){
        $servers = $config->item(ENVIRONMENT,'sess_storage');
        foreach (array('host', 'port') as $key){
            $this->$key =  $servers[$key];
        }
        $this->memcached = new Memcached();

        $this->memcached->addServer($this->host, $this->port) ;
        $this->memcached->setOption(Memcached::OPT_PREFIX_KEY, $this->session_prefix);
        $this->memcached->setOption(Memcached::OPT_COMPRESSION, FALSE);
        session_set_save_handler(
                array($this, "open"),
                array($this, "close"),
                array($this, "read"),
                array($this, "write"),
                array($this, "destroy"),
                array($this, "gc")
                );
    }

    /**
     * Destructor
     */
    public function __destruct(){
        session_write_close();
    }

    /**
     * Open the session handler, set the lifetime ot session.gc_maxlifetime
     * @return boolean True if everything succeed
     */
    public function open(){
        $this->lifetime = ini_get('session.gc_maxlifetime') + time();
        return true;
    }

    /**
     * Read the id
     * @param string $id The SESSID to search format
     * @return string The session saved previously
     */
    public function read($id){
        $tmp = $_SESSION;
        $_SESSION = json_decode($this->memcached->get("{$id}"), true);
        if(isset($_SESSION) && !empty($_SESSION) && $_SESSION != null){
            $new_data = session_encode();
            $_SESSION = $tmp;
            return $new_data;
        }else{
            return "";
        }
    }

    /**
     * Write the session data, convert to json before storing
     * @param string $id The SESSID to saved
     * @param string $data The data to store, already serialized by phpcredits
     * @return boolean True if memcached was able to write the session data
     */
    public function write($id, $data){
        $tmp = $_SESSION;
        session_decode($data);
        $new_data = $_SESSION;
        $_SESSION = $tmp;
        return $this->memcached->set("{$id}", json_encode($new_data), $this->lifetime);
    }

    /**
     * Delete object in session
     * @param string $id The SESSID to Delete
     * @return boolean True if memcached was able delete session data
     */
    public function destroy($id){
        return $this->memcached->delete("{$id}");
    }

    /**
     * Close gc
     * @return boolean Always True
     */
    public function gc(){
        return true;
    }

    /**
     * Close session
     * @return boolean Always True
     */
    public function close(){
        return true;
    }
}
 new memcacheSessionHandler();
```
