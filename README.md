# Nginx, PHP FPM, MariaDB,mongodb and Redis with Docker Compose based on Images


## 要求
Install Docker and Compose 详情安装下载如下
	- 在这里[https://www.docker.com/products/docker-toolbox](https://www.docker.com/products/docker-toolbox)选择对应的系统下载
## 克隆
- https://github.com/sheldon9527/docker-compose-php-nginx-mariadb-redis.git
## 执行
	- docker-compose up
## 结果
	- http://localhost:8082
## 数据库主从配置
	- 主从配置
		- 进入Master库容器 `docker exec -it master-mariadb-service /bin/bash `
		- 获取Master容器IP `more /etc/hosts` 例如：172.23.0.2	75e2dc084df2
		- 打开另一个终端进入Slave容器 `docker exec -it slave-mariadb-service /bin/bash `
		-  获取Slave容器IP `more /etc/hosts` 例如：172.23.0.3	75e2dc084fr4
		-  进入Master `/usr/bin/mysql -uroot -p` 密码是root
		-  授权 `GRANT REPLICATION SLAVE ON *.* TO 'slaveUser'@'IP' IDENTIFIED BY '123456';` IP 参数代表从容器的ip
		-  `flush privileges;`
		-  `show master status;` 查看主库的信息
			-------------------+----------+--------------+------------------+
			| File              | Position | Binlog_Do_DB | Binlog_Ignore_DB |
			+-------------------+----------+--------------+------------------+
			| master-bin.000005 |      635 |              |                  |
			+-------------------+----------+--------------+------------------+
	   - 进入Slave `/usr/bin/mysql -uroot -p` 密码是root
	   - 连接Master `change master to master_host='172.23.0.2',master_user='slaveUser',master_password='123456',master_log_file='master-bin.000005',master_log_pos=635;` master_host: Master容器ip;
	   - 启动Slave `start slave;`
	   - 查看是否开启`show slave status\G;`
	  *************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 172.23.0.3
                  Master_User: slaveUser
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: master-bin.000005
          Read_Master_Log_Pos: 635
               Relay_Log_File: mysqld-relay-bin.000002
                Relay_Log_Pos: 538
        Relay_Master_Log_File: master-bin.000005
             Slave_IO_Running: Yes //这两个为yes开启成功
            Slave_SQL_Running: Yes //这两个为yes开启成功
	- 测试
		- 在Master中操作
			create database test;
			CREATE TABLE `admin` (
			`id` int(11) NOT NULL AUTO_INCREMENT,
			`dt` date DEFAULT NULL COMMENT '日期',
			PRIMARY KEY (`id`)
			);
			insert into admin values('1','2017');
