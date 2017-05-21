# Python PyMySQL
>创建人员：**Tony Wang**   
>创建时间：2016-12-08


## 创建测试用户表
```sql
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8_bin NOT NULL,
  `password` varchar(255) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin
AUTO_INCREMENT=1;

```

## 数据库 CRUD
```Python
#!/usr/bin/env python
import pymysql.cursors

config = {
          'host':'127.0.0.1',
          'port':3306,
          'user':'root',
          'password':'zhyea.com',
          'db':'employees',
          'charset':'utf8mb4',
          'cursorclass':pymysql.cursors.DictCursor,
          }
# 创建连接
connection = pymysql.connect(**config)

# Connect to the database    
connection = pymysql.connect(
    host='localhost',
    user='user',
    password='passwd',
    db='db',
    charset='utf8mb4',
    cursorclass=pymysql.cursors.DictCursor)
try:
  with connection.cursor() as cursor:
    # Create a new record
    sql = "INSERT INTO `users` (`email`, `password`) VALUES (%s, %s)"
    cursor.execute(sql, ('webmaster@python.org', 'very-secret'))

    # connection is not autocommit by default. So you must commit to save
    # your changes.
    connection.commit()

    with connection.cursor() as cursor:
      # Read a single record
      sql = "SELECT `id`, `password` FROM `users` WHERE `email`=%s"
      cursor.execute(sql, ('webmaster@python.org',))
      result = cursor.fetchone()
      print(result)
finally:
  connection.close()
```

## 修改日志
> + [2016-12-20]  新增  
