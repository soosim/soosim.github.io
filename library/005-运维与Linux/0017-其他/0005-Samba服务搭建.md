# Samba服务搭建基础

## 安装samba 服务

```sudo apt-get install samba```

## samba 配置

​	网上各种samba配置教程很多，但是很杂而且非常乱。对着各种教程配置下去，总是跑不起来。可能是版本原因，自己装的是 4.3.11-Ubuntu

​	自己对samba协议与配置理解很肤浅，这里只是记录下自己暂时使用的配置，简单但是正常运行：

### 配置用户访问

直接在 ```/etc/samba/smb.conf```中加入以下配置：

```ini
# 在 [global]目录下配置
	security = user
	map to guest = Bad User
	
# 在文件末尾追加
[sophia]
	comment = sophia smb
	path = /home/sophia
	writable = yes
	available = yes
	browseable = yes
	public = yes
```



运行```testpram ```检测smb.conf 配置是否正确.



然后，增加 ```sophia```用户到smb用户列表中

```shell
sudo smbpasswd -a sophia
```



### 配置匿名访问

```ini
#### Debugging/Accounting ####
# share the dir without passwd
    security = user
    map to guest = Bad User


# 在文件结尾添加如下行：
[share]
	comment=this is Linux share directory
	path=/home/myth/share
	public=yes
	writable=yes
	create mode = 0777
	directory mode = 0777
	guest ok =yes
```

在Windows 下访问共享目录，可点击运行，输入 \192.168.0.10\share 
这样就能以匿名用户访问共享目录share了。



**注意权限问题，直接给共享文件夹777权限吧**



## Samba服务的启动、关闭、重启

```shell
sudo /etc/init.d/samba start
sudo /etc/init.d/samba restart
sudo /etc/init.d/samba stop
```

