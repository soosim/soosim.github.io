#### PHP生成器
[官方文档](http://php.net/manual/zh/language.generators.overview.php)
[What Generators Can Do For You](https://blog.ircmaxell.com/2012/07/what-generators-can-do-for-you.html)

具体解释看文档吧，贴几个实用的代码:
1. 读取大文件
```php
<?php
function getLines($file) {
    $f = fopen($file, 'r');
    try {
        while ($line = fgets($f)) {
            yield $line;
        }
    } finally {
        fclose($f);
    }
}
foreach (getLines("phpstorm.todo") as $n => $line) {
    if ($n > 100) break;
    echo $line;
}

# 或者:读取csv文件
function readCsv($file) {
    $handle = fopen($file, 'rb');
    if ($handle === false) {
        throw new Exception();
    }
    while(feof($handle) !== false) {
        yield fgetcsv($handle);
    }
    fclose($handle);
}
foreach($readCsv('data.csv') as $row) {
    print_r($row);
}


```

2.实现xrange()
```php
function xrange($min, $max) {
    for ($i = $min; $i < $max; $i++) yield $i;
}
```

3. 发送内容到生成器
```php
function createLog($file) {
    $f = fopen($file, 'a');
    while (true) {
        $line = yield;
        fwrite($f, $line);
    }
}
$log = createLog($file);
$log->send("First");
$log->send("Second");
$log->send("Third");
```