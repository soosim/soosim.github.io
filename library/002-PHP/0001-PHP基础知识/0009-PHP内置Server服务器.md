##### PHP内置Web Server

###### 启动：
> php -S localhost:8080

通过 php -S 命令即可启动PHP自带的Web Server，后面跟网络地址及监听的端口号，默认的网站根目录为当前目录。访问http://localhost:8080

---

###### 指定网站根目录，-t命令
> php -S localhost:8080 -t /www

---

###### 支持远程访问
>php -S 0.0.0.0:8080 -t /www

###### 使用自定义配置
>php -S 0.0.0.0:9090 ss-c app/config/php.ini