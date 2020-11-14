#!/bin/sh

# 导入初始数据
if [ ! -f "/data/mongodb/initdb.lock" ]; then
	echo "Initial mongo data"
	mongorestore -h localhost -d leanote --dir /data/leanote/mongodb_backup/leanote_install_data
	echo "do not delete this file" >> /data/mongodb/initdb.lock
	chmod 400 /data/mongodb/initdb.lock
fi
