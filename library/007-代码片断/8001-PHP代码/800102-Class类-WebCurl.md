# 类-WebCurl 代码片断
>创建人员：**Tony Wang**   
>创建时间：2016-12-06

## 类：WebCurl

```php
use Phalcon\Mvc\User\Component;

/**
*   在 Phalcon 框架下封装 cURL 请求
*/
class WebCurl extends Component {
	protected $_status;   // 返回状态码
	protected $_content;  // 请求返回内容
	protected $_error;    // 请求错误消息
	protected $_auth_token = '';   // 票据

	/**
	 * 设置API认证的账号与密码
	 */
	public function get_auth() {
		$appid = $this -> config -> api -> app_id;
		$appkey = $this -> config -> api -> app_key;
		return "{$appid}:{$appkey}";
	}

	/**
	 * 设置票据
	 * @param $token 请求数据地址
	 */
	public function get_token() {
		return $this -> user -> getToken();
	}

	/**
	 * 获取URL地址
	 * @param $url 请求数据的地址
	 */
	public function get_url($url) {
		$host = $this -> config -> api -> url;
		return $host . $url;
	}

	/**
	 * GET方式 请求数据
	 * @param $url 请求数据地址
	 */
	public function get_request($url) {
		return $this -> send($url);
	}

	/**
	 * POST方式 请求数据
	 * @param $url 请求数据地址
	 * @param $data Array 数据
	 */
	public function post_request($url, $data) {
		$data = json_encode($data);
		$post = array(CURLOPT_POSTFIELDS => $data);
		return $this -> send($url, $post, strlen($data));
	}

	/**
	 * DELETE方式 请求数据
	 * @param $url 请求数据地址
	 * @param $data Array 数据
	 */
	public function delete_request($url, $data) {
		$data = json_encode($data);
		$post = array(CURLOPT_CUSTOMREQUEST => "DELETE", CURLOPT_POSTFIELDS => $data);
		return $this -> send($url, $post, strlen($data));
	}

	/**
	 * PUT方式 请求数据
	 * @param $url 请求数据地址
	 * @param $data Array 数据
	 */
	public function put_request($url, $data) {
		$post = array(CURLOPT_CUSTOMREQUEST => "PUT", CURLOPT_POSTFIELDS => json_encode($data));
		return $this -> send($url, $post, strlen($post[CURLOPT_POSTFIELDS]));
	}

	/**
	 * POST方式 上传文件
	 * @param $url 请求数据地址
	 * @param $files 需要上文件的列表
	 * @param $data Array 数据
	 */
	public function upload_request($url, $files, $data) {
		$data = array_merge($files, $data);
		$post = array(CURLOPT_POSTFIELDS => $data);
		return $this -> send($url, $post);
	}

	/**
	 * 执行请求
	 * $post array 请求数据
	 */
	public function send($url, $post = '', $len = 0) {
		if (empty($url) && empty(trim($url)))
			return 401;

		// 地址不存在
		$header = array("author:Tony Wang", "token:" . $this -> get_token());
		if ($len > 0) {
			$header = array_merge($header,
				array("Content-Type:application/json; charset=utf-8",
				"Content-Length:" . $len)
			);
		}
		$options = array(CURLOPT_HTTPHEADER => $header, CURLOPT_RETURNTRANSFER => true, // 将curl_exec()获取的信息以文件流的形式返回，而不是直接输出。
		CURLOPT_HEADER => false, // 启用时会将头文件的信息作为数据流输出。
		CURLOPT_FOLLOWLOCATION => true, // 启用时会将服务器服务器返回的"Location: "放在header中递归的返回给服务器，使用CURLOPT_MAXREDIRS可以限定递归返回的数量。
		CURLOPT_ENCODING => "gzip", // HTTP请求头中"Accept-Encoding: "的值。支持的编码有"identity"，"deflate"和"gzip"。如果为空字符串""，请求头会发送所有支持的编码类型。
		CURLOPT_USERAGENT => "Server(CentOS) MonkeyPHP/0.2", // 在HTTP请求中包含一个"User-Agent: "头的字符串。
		CURLOPT_AUTOREFERER => true, // 当根据Location:重定向时，自动设置header中的Referer:信息。
		CURLOPT_CONNECTTIMEOUT => 2, // 在发起连接前等待的时间，如果设置为0，则无限等待。
		CURLOPT_TIMEOUT => 10, // 设置cURL允许执行的最长秒数。
		CURLOPT_MAXREDIRS => 4	// 指定最多的HTTP重定向的数量，这个选项是和CURLOPT_FOLLOWLOCATION一起使用的。
		);
		if (is_array($post) && count($post) > 0) {
			$options[CURLOPT_POST] = 1;
			$options[CURLOPT_POSTFIELDS] = $post[CURLOPT_POSTFIELDS];
			$options[CURLOPT_CUSTOMREQUEST] = isset($post[CURLOPT_CUSTOMREQUEST]) ? $post[CURLOPT_CUSTOMREQUEST] : "POST";
		}
		$options[CURLOPT_USERPWD] = $this -> get_auth();
		$options[CURLOPT_HTTPAUTH] = CURLAUTH_BASIC;

		$ch = curl_init($this -> get_url($url));
		curl_setopt_array($ch, $options);
		$this -> _content = curl_exec($ch);
		$this -> _error = curl_error($ch);
		$this -> _status = curl_getinfo($ch, CURLINFO_HTTP_CODE);
		curl_close($ch);

		// 返回状态码
		return $this -> _status;
	}

	/**
	 * 获取 HTTP Status Code
	 */
	public function getHttpStatus() {
		return $this -> _status;
	}

	/**
	 * 获取 错误信息
	 */
	public function getErrorMessage() {
		return $this -> _error;
	}

	/**
	 * 返回JSON数据格式
	 */
	public function getJsonData() {
		return @json_decode($this -> _content);
	}

	/**
	 * 返回Array数据格式
	 */
	public function getArrayData() {
		return @json_decode($this -> _content, TRUE);
	}

	/**
	 * 返回请求的原文本数据
	 */
	public function getResponseText() {
		return $this -> _content;
	}

	/**
	 * 获取 数据内容
	 */
	public function __tostring() {
		return $this -> _content;
	}

}
```
