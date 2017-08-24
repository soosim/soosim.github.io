#### array_walk与array_map的区别

##### array_map
array_map() 函数返回用户自定义函数作用后的数组。回调函数接受的参数数目应该和传递给 array_map() 函数的数组数目一致。

###### 语法
```php
array_map(function, $array1, $array2, $array3...)
```
###### 示例

```php
//示例一
$arr = ['asdasf', 124512, 'dsafsa12321', '123124sadasf'];
$res = array_map('intval', $arr)

//示例二
function myfunction($v1, $v2) {
    if ($v1 === $v2) {
        return "same";
    }
    return "different";
}

$a1 = array("Horse", "Dog", "Cat");
$a2 = array("Cow", "Dog", "Rat");
print_r(array_map("myfunction", $a1, $a2));

//示例三：当自定义函数名设置为 null 时的情况：
$a1 = array("Dog", "Cat");
$a2 = array("Puppy", "Kitten");
print_r(array_map(null, $a1, $a2));
结果：
  Array (
  	Array (0 => Dog, 1 => Puppy ),
  	Array (0 => Cat, 1 => Kitten )
  )
```

##### array_walk

array_walk() 函数对数组中的每个元素应用回调函数。如果成功则返回 TRUE，否则返回 FALSE。

典型情况下 function 接受两个参数。array **参数的值**作为第一个，**键名**作为第二个。如果提供了可选参数 userdata ，将被作为第三个参数传递给回调函数。

###### 语法：

```php
array_walk($array, function, $userdata..)
```

###### 示例

```php
// 示例一：
function myfunction($value, $key, $p) {
    echo "$key $p $value<br />";
}
$a = array("a" => "Cat", "b" => "Dog", "c" => "Horse");
array_walk($a, "myfunction", "has the value");

// 示例二（该表元素值）：
$arr = [
    12345,
    '12452121re',
    'sadaf asdasdasd  '
];

array_walk($arr, function(&$a, $k, $s){
    $a = $k . '==>' . intval($a) . ':' .$s;
}, 'asdadad');

print_r($arr);
/*
Array
(
    [0] => 0==>12345:asdadad
    [1] => 1==>0:asdadad
    [2] => 2==>12452121:asdadad
    [3] => 3==>0:asdadad
)
*/
```

#### array_walk_recursive 对数组中的每个成员递归地应用用户函数
```php
bool array_walk_recursive ( array &$array , callable $callback [, mixed $userdata = NULL ] )
```
##### 示例

```php
$af = [
		[
			['asdsafasgasf',441,'2423fsafsa','sfasf32432'],
			['sadsafasgggggg',63630,'asdafasg','asdafasfgas']
		]
	];
function intv(&$a) {
    $a = intval($a);
}

array_walk_recursive($af, 'intv');
print_r($af);exit;

# 结果
Array
(
    [0] => Array
        (
            [0] => Array
                (
                    [0] => 0
                    [1] => 441
                    [2] => 2423
                    [3] => 0
                )
            [1] => Array
                (
                    [0] => 0
                    [1] => 63630
                    [2] => 0
                    [3] => 0
                )
        )
)
```

