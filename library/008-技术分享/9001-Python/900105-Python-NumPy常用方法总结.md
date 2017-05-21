# Python-NumPy常用方法总结
>创建人员：**Tony Wang**   
>创建时间：2016-12-20

[TOC]

NumPy是Python的一种开源的数值计算扩展。这种工具可用来存储和处理大型矩阵，比Python自身的嵌套列表（nested list structure)结构要高效的多（该结构也可以用来表示矩阵（matrix））。NumPy（Numeric Python）提供了许多高级的数值编程工具，如：矩阵数据类型、矢量处理，以及精密的运算库。专为进行严格的数字处理而产生。多为很多大型金融公司使用，以及核心的科学计算组织如：Lawrence Livermore，NASA用其处理一些本来使用C++，Fortran或Matlab等所做的任务。


numpy中的数据类型，ndarray类型，和标准库中的array.array并不一样。

## 数据创建
### ndarray 的创建  
```Python
>>> import numpy as np
>>> a = np.array([2,3,4])
>>> a
array([2, 3, 4])
>>> a.dtype
dtype('int64')
>>> b = np.array([1.2, 3.5, 5.1])
>>> b.dtype
dtype('float64')

```

### 二维的数组
```Python
>>> b = np.array([(1.5,2,3), (4,5,6)])
>>> b
array([[ 1.5,  2. ,  3. ],
       [ 4. ,  5. ,  6. ]])
```

### 创建时指定类型
```Python
>>> c = np.array( [ [1,2], [3,4] ], dtype=complex )
>>> c
array([[ 1.+0.j,  2.+0.j],
       [ 3.+0.j,  4.+0.j]])
```

### 创建一些特殊的矩阵
```Python
>>> np.zeros( (3,4) )
array([[ 0.,  0.,  0.,  0.],
       [ 0.,  0.,  0.,  0.],
       [ 0.,  0.,  0.,  0.]])
>>> np.ones( (2,3,4), dtype=np.int16 )                # dtype can also be specified
array([[[ 1, 1, 1, 1],
        [ 1, 1, 1, 1],
        [ 1, 1, 1, 1]],
       [[ 1, 1, 1, 1],
        [ 1, 1, 1, 1],
        [ 1, 1, 1, 1]]], dtype=int16)
>>> np.empty( (2,3) )                                 # uninitialized, output may vary
array([[  3.73603959e-262,   6.02658058e-154,   6.55490914e-260],
       [  5.30498948e-313,   3.14673309e-307,   1.00000000e+000]])
```

### 创建一些有特定规律的矩阵
```Python
>>> np.arange( 10, 30, 5 )
array([10, 15, 20, 25])
>>> np.arange( 0, 2, 0.3 )                 # it accepts float arguments
array([ 0. ,  0.3,  0.6,  0.9,  1.2,  1.5,  1.8])
>>> from numpy import pi
>>> np.linspace( 0, 2, 9 )                 # 9 numbers from 0 to 2
array([ 0.  ,  0.25,  0.5 ,  0.75,  1.  ,  1.25,  1.5 ,  1.75,  2.  ])
>>> x = np.linspace( 0, 2*pi, 100 )        # useful to evaluate function at lots of points
>>> f = np.sin(x)
```

## 一些基本的运算
### 加减乘除三角函数逻辑运算
```Python
>>> a = np.array( [20,30,40,50] )
>>> b = np.arange( 4 )
>>> b
array([0, 1, 2, 3])
>>> c = a-b
>>> c
array([20, 29, 38, 47])
>>> b**2
array([0, 1, 4, 9])
>>> 10*np.sin(a)
array([ 9.12945251, -9.88031624,  7.4511316 , -2.62374854])
>>> a<35
array([ True, True, False, False], dtype=bool)

```

### 矩阵运算
matlab中有.* ,./等等

但是在numpy中，如果使用+，-，×，/优先执行的是各个点之间的加减乘除法

* 如果两个矩阵（方阵）可既以元素之间对于运算，又能执行矩阵运算会优先执行元素之间的运算  
```Python
>>> import numpy as np
>>> A = np.arange(10,20)
>>> B = np.arange(20,30)
>>> A + B
array([30, 32, 34, 36, 38, 40, 42, 44, 46, 48])
>>> A * B
array([200, 231, 264, 299, 336, 375, 416, 459, 504, 551])
>>> A / B
array([0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
>>> B / A
array([2, 1, 1, 1, 1, 1, 1, 1, 1, 1])
```

* 如果需要执行矩阵运算，一般就是矩阵的乘法运算
```Python
>>> A = np.array([1,1,1,1])
>>> B = np.array([2,2,2,2])
>>> A.reshape(2,2)
array([[1, 1],
       [1, 1]])
>>> B.reshape(2,2)
array([[2, 2],
       [2, 2]])
>>> A * B
array([2, 2, 2, 2])
>>> np.dot(A,B)
8
>>> A.dot(B)
8
```

### 一些常用的全局函数
```Python
>>> B = np.arange(3)
>>> B
array([0, 1, 2])
>>> np.exp(B)
array([ 1.        ,  2.71828183,  7.3890561 ])
>>> np.sqrt(B)
array([ 0.        ,  1.        ,  1.41421356])
>>> C = np.array([2., -1., 4.])
>>> np.add(B, C)
array([ 2.,  0.,  6.])
```

### 矩阵的索引分片遍历
```Python
>>> a = np.arange(10)**3
>>> a
array([  0,   1,   8,  27,  64, 125, 216, 343, 512, 729])
>>> a[2]
8
>>> a[2:5]
array([ 8, 27, 64])
>>> a[:6:2] = -1000    # equivalent to a[0:6:2] = -1000; from start to position 6, exclusive, set every 2nd element to -1000
>>> a
array([-1000,     1, -1000,    27, -1000,   125,   216,   343,   512,   729])
>>> a[ : :-1]                                 # reversed a
array([  729,   512,   343,   216,   125, -1000,    27, -1000,     1, -1000])
>>> for i in a:
...     print(i**(1/3.))
...
nan
1.0
nan
3.0
nan
5.0
6.0
7.0
8.0
9.0
```

### 矩阵的遍历
```Python
>>> import numpy as np
>>> b = np.arange(16).reshape(4, 4)
>>> for row in b:
...  print(row)
...
[0 1 2 3]
[4 5 6 7]
[ 8  9 10 11]
[12 13 14 15]
>>> for node in b.flat:
...  print(node)
...
0
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
```

## 矩阵的特殊运算
### 改变矩阵形状--reshape
```Python
>>> a = np.floor(10 * np.random.random((3,4)))
>>> a
array([[ 6.,  5.,  1.,  5.],
       [ 5.,  5.,  8.,  9.],
       [ 5.,  5.,  9.,  7.]])
>>> a.ravel()
array([ 6.,  5.,  1.,  5.,  5.,  5.,  8.,  9.,  5.,  5.,  9.,  7.])
>>> a
array([[ 6.,  5.,  1.,  5.],
       [ 5.,  5.,  8.,  9.],
       [ 5.,  5.,  9.,  7.]])
```
resize和reshape的区别

resize会改变原来的矩阵，reshape并不会
```Python
>>> a
array([[ 6.,  5.,  1.,  5.],
       [ 5.,  5.,  8.,  9.],
       [ 5.,  5.,  9.,  7.]])
>>> a.reshape(2,-1)
array([[ 6.,  5.,  1.,  5.,  5.,  5.],
       [ 8.,  9.,  5.,  5.,  9.,  7.]])
>>> a
array([[ 6.,  5.,  1.,  5.],
       [ 5.,  5.,  8.,  9.],
       [ 5.,  5.,  9.,  7.]])
>>> a.resize(2,6)
>>> a
array([[ 6.,  5.,  1.,  5.,  5.,  5.],
       [ 8.,  9.,  5.,  5.,  9.,  7.]])
```

### 矩阵的合并
```Python
>>> a = np.floor(10*np.random.random((2,2)))
>>> a
array([[ 8.,  8.],
       [ 0.,  0.]])
>>> b = np.floor(10*np.random.random((2,2)))
>>> b
array([[ 1.,  8.],
       [ 0.,  4.]])
>>> np.vstack((a,b))
array([[ 8.,  8.],
       [ 0.,  0.],
       [ 1.,  8.],
       [ 0.,  4.]])
>>> np.hstack((a,b))
array([[ 8.,  8.,  1.,  8.],
       [ 0.,  0.,  0.,  4.]])
```

## 修改日志
> + [2016-12-20]  新增  
