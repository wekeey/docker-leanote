# docker-leanote
Docker 部署蚂蚁笔记服务

### 启动方式 1

```shell
docker-compose up -d
```

首次启动容器后 `docker-compose restart` 一下

### 启动方式 2

```shell
docker run -d \
--name leanote \
--restart=always \
--env SITE_URL="http://note.local.xapp.xyz:9000/" \
-p 9000:9000 \
wekeey/leanote
```

首次启动容器后 `docker restart leanote` 一下

### 访问

[http://note.local.xapp.xyz:9000](http://note.local.xapp.xyz:9000)

默认用户名和密码

```text
user: admin
pass: abc123
```

### 其他

[Leanote 二进制版详细安装教程](https://github.com/leanote/leanote/wiki/Leanote-%E4%BA%8C%E8%BF%9B%E5%88%B6%E7%89%88%E8%AF%A6%E7%BB%86%E5%AE%89%E8%A3%85%E6%95%99%E7%A8%8B----Mac-and-Linux)

数据备份和恢复

- mongodump path: `/usr/bin/mongodump`
- mongorestore path: `/usr/bin/mongorestore`

