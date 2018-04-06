# 高可用redis集群方案

标签（空格分隔）： 未分类

---

### 一、主从
        redis原生支持，可使用Redis Sentinel 哨兵机制实现自动故障转移。同时可以使用 漂移VIP实现Redis故障转移后客户端连接问题。
        见博客 : http://www.jianshu.com/p/d7bc873b8797%20%22%22

### 二、官方集群方案Redis Cluster
        尚在开发阶段，支持的客户端不多。
        Redis Cluster是一种服务器Sharding技术。
        Redis Cluster中，Redis集群没有使用一致性hash,而是引入了哈希槽的概念，Sharding采用slot(槽)的概念，一共分成16384个槽，这有点儿类pre sharding思路。对于每个进入Redis的键值对，根据key进行散列，分配到这16384个slot中的某一个中。
        为了保证可用性，集群采用可主从复制模型，即每个节点有若干slave.
        jedis实现了集群客户端。
    

### 三、客户端Sharding
        主要思想是采用哈希算法将Redis数据的key进行散列，通过hash函数，特定的key会映射到特定的Redis节点上。这样，客户端就知道该向哪个Redis节点操作数据。
        
### 四、利用代理中间件实现大规模Redis集群
        twemproxy处于客户端和服务器的中间，将客户端发来的请求，进行一定的处理后(如sharding)，再转发给后端真正的Redis服务器。也就是说，客户端不直接访问Redis服务器，而是通过twemproxy代理中间件间接访问。
        当然，也是由于使用了中间件代理，相比客户端直连服务器方式，性能上会有所损耗，实测结果大约降低了20%左右。

#### 推荐文章:
[简书-Linux运维-搭建高可用Redis缓存](http://www.jianshu.com/p/d7bc873b8797)

[简书-搭建一个redis高可用系统](https://www.jianshu.com/p/c2ab606b00b7)

[知乎-Redis集群方案应该怎么做](https://www.zhihu.com/question/21419897)

[Redis中文网-Redis哨兵](http://redis.majunwei.com/topics/sentinel.html)

[Redis中文网-集群介绍](http://www.redis.cn/topics/cluster-tutorial.html)