# 类-Bootstrap 代码片断
>创建人员：**Tony Wang**   
>创建时间：2016-12-06

## 类：Bootstrap

```php
use Phalcon\Config as PhConfig;
use Phalcon\Loader as PhLoader;
use Phalcon\Mvc\Url as PhUrl;
use Phalcon\Mvc\View as PhView;
use Phalcon\Mvc\Application as PhApplication;
use Phalcon\Logger\Adapter\File as PhFileLogger;
use Phalcon\Logger\Formatter\Line as PhFormatterLine;

/*
*
*/
class Bootstrap {
	private $di;

	/**
	 * 实例化类
	 * @author Tony Wang
	 * @param $di
	 */
	public function __construct() {
		$this -> di = new \Phalcon\DI\FactoryDefault();
	}

	/**
	 * 运行
	 * @access public
	 * @author Tony Wang
	 * @param string $options
	 * @return string
	 */
	public function run($options) {
		$loaders = array(
			'Config', 	// 配置文件
			'Loader', 	// 设置自动加载路径
			'Router', 	// 加载路由
			'Database',
			'View', 	// 初始化视图服务
			'WebRedis', // 初始化Redis 服务
			'Logger'	// 初始化写日志服务
		);
		foreach ($loaders as $service) {
			$function = 'init' . $service;
			$this -> $function();
		}
		$application = new PhApplication();
		$application -> setDI($this -> di);
		return $application -> handle() -> getContent();
	}

	/**
	 * 初始化配置文件
	 * @access protected
	 * @author Tony Wang
	 *
	 * @param array $options
	 * @return void
	 */
	protected function initConfig($options = array()) {
		$data = require_once (ROOT_PATH . '/configs/inc_config.php');
		$config = new PhConfig($data);
		$this -> di['config'] = $config;
	}

	/**
	 * 初始化加载器
	 * @access protected
	 * @author Tony Wang
	 *
	 * @param array $options
	 * @return void
	 */
	protected function initLoader($options = array()) {
		$config = $this -> di['config'];
		$loader = new PhLoader();
		$loader -> registerDirs(array(
			ROOT_PATH . '/app/controllers/',
			ROOT_PATH . '/app/librarys/',
			ROOT_PATH . '/app/models/',
			ROOT_PATH . '/app/services/')) -> register();
		$this -> di['loader'] = $loader;
	}

	/**
	 * 注册路由表
	 * @access protected
	 * @author Tony Wang
	 *
	 * @param array $options
	 * @return void
	 */
	protected function initRouter($options = array()) {
		$config = $this -> di['config'];
		$this -> di['router'] = function() use ($config) {
			$router = require_once (ROOT_PATH . '/configs/inc_routes.php');
			return $router;
		};
	}

	/**
	 * 注册数据库访问服务
	 */
	protected function initDatabase($options = array()) {
		$config = $this -> di['config'];
		$this -> di['db'] = function() use ($config) {
			return new \Phalcon\Db\Adapter\Pdo\Mysql(array(
        		'host' => $config->database->host,
        		'username' => $config->database->username,
        		'password' => $config->database->password,
        		'charset' => 'UTF8',
        		'dbname' => $config->database->dbname
    		));
		};
	}

	/**
	 * 注册视图服务
	 * @access protected
	 * @author Tony Wang
	 *
	 * @param array $options
	 * @return void
	 */
	protected function initView($options = array()) {
		$di = $this -> di;
		$config = $di['config'];
		$this -> di['view'] = function() use ($config, $di) {
			$view = new \Phalcon\Mvc\View();
			$view->disable();  // 禁止视图
			return $view;
		};
	}

	/**
	 *  初始化Redis 服务
	 * @access protected
	 * @author Tony Wang
	 *
	 * @param array $options 需要传值的数组对象
	 * @return void
	 */
	protected function initWebRedis($options = array()) {
		$di = $this->di;
		$this -> di['redis'] = function() use ($di) {
			return new WebRedis();
		};
	}

	/**
	 *  配置写日志服务
	 * @access protected
	 * @author Tony Wang
	 *
	 * @param array $options 需要传值的数组对象
	 * @return void
	 */
	protected function initLogger($options = array()) {
		$config = $this->di['config'];
		$this -> di -> set('logger',
				function($filename = null, $format = null) use ($config) {
						$format = $format ? : $config -> get('logger') -> format;
						$filename = trim($filename ? : $config -> get('logger') -> filename, '\\/');
						$path = rtrim($config -> get('logger') -> path, '\\/') . DIRECTORY_SEPARATOR;

						$formatter = new PhFormatterLine($format, $config -> get('logger') -> date);
						$logger = new PhFileLogger($path . $filename);

						$logger -> setFormatter($formatter);
						$logger -> setLogLevel($config -> get('logger') -> logLevel);

						return $logger;
				});
	}
}

```
