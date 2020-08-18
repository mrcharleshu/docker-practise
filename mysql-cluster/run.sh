# rm -rf ~/Downloads/mysql/*
# docker run --name mysql-master --privileged=true -v ~/Downloads/mysql/master:/var/lib/mysql -p 3307:3306 -e MYSQL_ROOT_PASSWORD=root -d mysql:5.7
# sleep 3
# docker run --name mysql-slave1 --privileged=true -v ~/Downloads/mysql/slave1:/var/lib/mysql -p 3308:3306 --link mysql-master:master -e MYSQL_ROOT_PASSWORD=root -d mysql:5.7
# sleep 3
# docker run --name mysql-slave2 --privileged=true -v ~/Downloads/mysql/slave2:/var/lib/mysql -p 3309:3306 --link mysql-master:master -e MYSQL_ROOT_PASSWORD=root -d mysql:5.7
# sleep 3

# docker exec -it mysql-master /bin/bash
# docker exec -it mysql-master bash -c "echo 'log-bin=mysql-bin' >> /etc/mysql/mysql.conf.d/mysqld.cnf && echo 'server-id=1' >> /etc/mysql/mysql.conf.d/mysqld.cnf"
docker exec -it mysql-master tail -n3 /etc/mysql/mysql.conf.d/mysqld.cnf

# docker exec -it mysql-slave1 /bin/bash
# docker exec -it mysql-slave1 bash -c "echo 'log-bin=mysql-bin' >> /etc/mysql/mysql.conf.d/mysqld.cnf && echo 'server-id=2' >> /etc/mysql/mysql.conf.d/mysqld.cnf"
docker exec -it mysql-slave1 tail -n3 /etc/mysql/mysql.conf.d/mysqld.cnf

# docker exec -it mysql-slave2 /bin/bash
# docker exec -it mysql-slave2 bash -c "echo 'log-bin=mysql-bin' >> /etc/mysql/mysql.conf.d/mysqld.cnf && echo 'server-id=3' >> /etc/mysql/mysql.conf.d/mysqld.cnf"
docker exec -it mysql-slave2 tail -n3 /etc/mysql/mysql.conf.d/mysqld.cnf


# tail -n3 mysql.conf.d/master/mysqld.cnf;tail -n3 mysql.conf.d/slave1/mysqld.cnf;tail -n3 mysql.conf.d/slave2/mysqld.cnf

# docker restart mysql-master mysql-slave1 mysql-slave2

# mysql -uroot -proot -h172.31.254.239 -P3307 -e "GRANT REPLICATION SLAVE ON *.* TO 'backup'@'%' identified by 'backup';show grants for 'backup'@'%';"
# mysql -uroot -proot -h172.31.254.239 -P3308 -e "CHANGE MASTER TO MASTER_HOST='172.31.254.239',MASTER_PORT=3307,MASTER_USER='backup',MASTER_PASSWORD='backup',MASTER_LOG_FILE='mysql-bin.000010',MASTER_LOG_POS=985;START SLAVE;"
# mysql -uroot -proot -h172.31.254.239 -P3309 -e "CHANGE MASTER TO MASTER_HOST='172.31.254.239',MASTER_PORT=3307,MASTER_USER='backup',MASTER_PASSWORD='backup';MASTER_LOG_FILE='mysql-bin.000010',MASTER_LOG_POS=985;START SLAVE;"

# sleep 5

mysql -uroot -proot -h172.31.254.239 -P3307 --database charles -e "insert into charles.user(id,name) values (1, 'Lucy');select * from charles.user"
mysql -uroot -proot -h172.31.254.239 -P3308 --database charles -e "select * from charles.user"
mysql -uroot -proot -h172.31.254.239 -P3309 --database charles -e "select * from charles.user"

mysql -uroot -proot -h172.31.254.239 -P3307 --database charles -e "show master status\G"
mysql -uroot -proot -h172.31.254.239 -P3308 --database charles -e "show slave status\G"
mysql -uroot -proot -h172.31.254.239 -P3309 --database charles -e "show slave status\G"

# docker stop mysql-master;docker rm mysql-master;docker stop mysql-slave1;docker rm mysql-slave1;docker stop mysql-slave2;docker rm mysql-slave2;docker system prune -f;docker volume prune -f


# create database charles;
# use charles;create table user(id int, name varchar(255));
# insert into charles.user(id,name) values (1, 'Lucy');
# select * from charles.user;