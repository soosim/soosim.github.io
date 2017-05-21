##### 重启/关闭/打开：
    systemctl restart/start/stop firewalld

    firewall-cmd --reload
    firewall-cmd --state
---
##### 区域：
```
查看所有的zone信息: firewall-cmd --list-all-zones

设置默认区域：firewall-cmd --set-default-zone=public
查看默认区域：firewall-cmd --get-default-zone

查看某个zone里开启了哪些服务、端口、接口：
firewall-cmd --zone=public --list-all

```

---
##### 端口与服务：
```
firewall-cmd --add-service=http    #暂时开放http
firewall-cmd --permanent --add-service=http  #永久开放http
firewall-cmd --permanent --remove-service=http  #永久开放http

firewall-cmd --zone=public --add-port=80/tcp --permanent  #在public中永久开放80端口
firewall-cmd --permanent --zone=public --remove-service=ssh   #从public zone中移除服务
firewall-cmd --zone=public --add-port=80/tcp --permanent    #开放80 端口

命令含义：

--zone #作用域 如果没有指定zone的话，则是在默认的zone上操作
--add-port=80/tcp  #添加端口，格式为：端口/通讯协议
--permanent   #永久生效，没有此参数重启后失效
```
