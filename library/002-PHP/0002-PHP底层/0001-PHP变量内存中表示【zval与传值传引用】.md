# PHP变量在内存中的表示

标签（空格分隔）： php变量 zval 传值与传引用

---

参考转载自：
    [Gong Yong的Blog](http://gywbd.github.io/posts/2015/4/php-variable-in-memory.html)
    [CSDN](http://blog.csdn.net/ohmygirl/article/details/41542445)

## zval
Zval是PHP中最重要的数据结构之一（另一个比较重要的数据结构是hash table），它包含了PHP中的变量值和类型的相关信息。它是一个struct。

它的全称是zend value，PHP的解释器被称为zend engine，所以顾名思义zend value就是zend engine中的value，而在计算机程序设计的世界中，value一般都是通过变量来指代的。PHP中的变量在内存中是以zval结构体的形式存在的，zval包含了变量的值以及其他一些相关的信息。


### 基本结构：
```c
struct _zval_struct {
    zvalue_value value;     /* value 变量的实际值*/
    zend_uint refcount__gc;  /* variable ref count 计数器,保存多少变量指向改zval*/
    zend_uchar type;          /* active type 变量的实际类型*/
    zend_uchar is_ref__gc;    /* if it is a ref variable 标记变量是否是引用变量*/
};
typedef struct _zval_struct zval;
```


如果安装了 xdebug , 可以通过xdebug_debug_zval打印Zval的信息:
```php
$a = array( 'test' );  
$a[] = &$a;  
xdebug_debug_zval( 'a' );
```
### ZVAL的更多原理
前面我们已经说过，PHP使用Zval这种结构来保存变量，这里我们将继续追踪zval的更多细节。
#### 1.创建变量时，会创建一个zval
```php
$str = "test zval";  
xdebug_debug_zval('str');  

// 结果
// str: (refcount=1, is_ref=0)='test zval'
```
当使用$str="test zval";来创建变量时，会在当前作用域的符号表中插入新的符号（str）,由于该变量是一个普通的变量，因此会生成一个refcount=1且is_ref=0的zval容器。也就是说，实际上是这样的:
![zval](https://soosim.github.io/assets/images/252356036066910.png)

#### 2.变量赋值给另外一个变量时，会增加zval的refcount值。
```php
$str  = "test zval";  
$str2 = $str;  
xdebug_debug_zval('str');  
xdebug_debug_zval('str2'); 

// 结果
// str: (refcount=2, is_ref=0)='test zval'
// str2: (refcount=2, is_ref=0)='test zval'
```
同时我们看到，str和是str2这两个symbol的zval结构是一样的。这里其实是PHP所做的一个优化，由于str和str2都是普通变量，因而它们指向了同一个zval，而没有为str2开辟单独的zval。这么做，可以在一定程度上节省内存。这时的str,str2与zval的对应关系是这样的：
![zval](https://soosim.github.io/assets/images/252357198403053.png)

#### 3.使用unset时，对减少相应zval的refcount值
```php
$str  = "test zval";  
$str3 = $str2 = $str;  
xdebug_debug_zval('str');  
unset($str2,$str3)  
xdebug_debug_zval('str');

/*
结果：
str: (refcount=3, is_ref=0)='test zval'
str: (refcount=1, is_ref=0)='test zval'
*/
```
由于unset($str2,$str3)会将str2和str3从符号表中删除，因此，在unset之后，只有str指向该zval，如下图所示：
![zval](https://soosim.github.io/assets/images/252358485127530.png)

#### 4. 数组变量与普通变量生成的zval非常类似，但也有很大不同
*详情百度吧.....*

---
## 传值和传引用
首先我想说PHP普通类型的变量，或者被称为标量（scala）是传值的，除非你显示声明为传递一个引用（使用&操作符），所以当你把一个变量赋值给另外一个变量，或者通过函数传递参数的时候，这两个赋值和被赋值的变量是不同的，不再赘述。

这里来看看传递对象的情况：
```php
<?php
$obj = (object) ['value' => 1];
function fnByVal($val) {
    $val = 100;
}
function fnByRef(&$ref) {
    $ref = 100;
}

//fnByVal是传值的，所以这个函数调用后，$obj并未改变，而fnByRef是传的是引用，调用后$obj也改变了

fnByVal($obj);
var_dump($obj); // stdClass(value => 1)
fnByRef($obj);
var_dump($obj); // int(100)
```
上面的示例也可以看到当传递的变量是对象，它也是传值的，所以当我们以传值的方式把一个变量赋值给另外一个新的变量（函数的参数传递也是一种变量赋值），如果我们会改变这个新的变量，之前的变量并不会改变。不过有一种不同的情况：
```php
$obj = (object) ['value' => 1];
function changeObj($o) {
    $o->value = 100;
}
changeObj($obj);
var_dump($obj); // stdClass(value => 100)
```

上面的代码中的对象\$obj在调用changeObj之后被改变了，这看起来像是传引用的。事实上并非如此的，我们从上面的表示变量的值的union中可以看到表示对象的值的类型为zend_object_value，这是一个结构体，它其中有一个long型的字段，它表示对象的ID。当要使用这个对象的时候，PHP会查找这个ID对应的真正的对象在内存中的表示，然后再对这块内存进行操作，所以上面的代码中的$obj和函数的参数\$o都包含同一个对象的ID，而当\$o在changeObj中被当做对象使用的时候，它所对应的对象跟变量\$obj是同一个对象，所以改变这个对象中的value字段的值，就改变了保存在这个对象中的数据。resource类型的数据也有类似的行为，我们就不深究了。

我们现在已经搞清楚了传值和传引用的特点，以及PHP就是传值的。但是，我们先看下面一个例子：
```php
$s = memory_get_usage();
$arr = range(1,10000);
echo memory_get_usage() - $s; //1491520
$arr2 = $arr;
echo memory_get_usage() - $s; //1491640
```
这里例子首先调用range函数生成了一个包含10000个整数的数组，然后输出这个数组占用的内存的大小为1491520个字节，大约为1.42M（我的php版本是5.5.14），然后把这个数组赋值给另外一个变量，这个时候的内存消耗为1491640，约为1.42M，基本上没有变化。

按照传值的理论，\$arr2和\$arr是两个不同的变量，在内存中分别对应不同的zval，如果第一个$arr对应的zval占用1.42M的内存，那么第二个\$arr2也应该占用这么多的内存啊，但是赋值之后总的内存空间的大小依旧为1.42M，为什么会这样呢？

在回答这个问题之前，我想先啰嗦两句，如果PHP的传值被设计成上面说的那样，PHP就不会存在了，这样的话每次赋值和函数调用都会分配一块新的内存，而且如果传递的变量占用的内存很大，要分配的内存也会相应的很大，这样内存的消耗会非常恐怖！

## 写时拷贝（copy-on-write）和引用计数（refcount)
上面问题的答案就是PHP使用了一种叫做写时拷贝的技术，这个技术类似于延迟加载，在需要用到的时候才会新建一个zval。在PHP中，有时候我们把一个变量对应的zval叫做一个拷贝（copy），写时拷贝就是指在需要向变量写入数据的时候才创建一个新的拷贝，所以有时候我们把PHP中的参数传递方式称为“传拷贝”。
*详解再google吧，看不太懂*

## 总结
PHP即不是传值的，也不是传引用的，而是使用了一种写时拷贝的机制（copy-on-write）,我们可以把它称为“传拷贝”。某种意义上这是一种语言优势，完全传值必然会造成性能损失，而如果完全传引用的话又有一些历史的包袱（实际上就是兼容性问题），而且我们在写程序的时候也应该尽量避免拷贝的发生，例如尽量不要使用PHP的引用。





