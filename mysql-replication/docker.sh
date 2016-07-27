#!/bin/sh

docker run --name mysql-master -v $(pwd)/master/_data:/var/lib/mysql -v $(pwd)/master/conf.d:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=root -d mysql:5.7
docker run --name mysql-slave-1 -v $(pwd)/slave-1/_data:/var/lib/mysql -v $(pwd)/slave-1/conf.d:/etc/mysql/conf.d --link mysql-master:mysql -e MYSQL_ROOT_PASSWORD=root -d mysql:5.7
docker run --name mysql-slave-2 -v $(pwd)/slave-2/_data:/var/lib/mysql -v $(pwd)/slave-2/conf.d:/etc/mysql/conf.d --link mysql-master:mysql -e MYSQL_ROOT_PASSWORD=root -d mysql:5.7
docker run --name mysql-slave-3 -v $(pwd)/slave-3/_data:/var/lib/mysql -v $(pwd)/slave-3/conf.d:/etc/mysql/conf.d --link mysql-master:mysql -e MYSQL_ROOT_PASSWORD=root -d mysql:5.7

echo "sleep 3 min to wait for mysql db init ..."
sleep 180

docker exec -ti mysql-master 'mysql' -uroot -proot -vvv -e"GRANT REPLICATION SLAVE ON *.* TO repl@'%' IDENTIFIED BY 'slavepass'\G"
docker exec -ti mysql-master 'mysql' -uroot -proot -e"RESET MASTER;"
docker exec -ti mysql-master 'mysql' -uroot -proot -e"SHOW MASTER STATUS\G"

docker exec -ti mysql-slave-1 'mysql' -uroot -proot -e'change master to master_host="mysql",master_user="repl",master_password="slavepass",master_log_file="mysql-bin.000001",master_log_pos=0;' -vvv
docker exec -ti mysql-slave-1 'mysql' -uroot -proot -e"START SLAVE;" -vvv
docker exec -ti mysql-slave-1 'mysql' -uroot -proot -e"SHOW SLAVE STATUS\G" -vvv

docker exec -ti mysql-slave-2 'mysql' -uroot -proot -e'change master to master_host="mysql",master_user="repl",master_password="slavepass",master_log_file="mysql-bin.000001",master_log_pos=0;' -vvv
docker exec -ti mysql-slave-2 'mysql' -uroot -proot -e"START SLAVE;" -vvv
docker exec -ti mysql-slave-2 'mysql' -uroot -proot -e"SHOW SLAVE STATUS\G" -vvv

docker exec -ti mysql-slave-3 'mysql' -uroot -proot -e'change master to master_host="mysql",master_user="repl",master_password="slavepass",master_log_file="mysql-bin.000001",master_log_pos=0;' -vvv
docker exec -ti mysql-slave-3 'mysql' -uroot -proot -e"START SLAVE;" -vvv
docker exec -ti mysql-slave-3 'mysql' -uroot -proot -e"SHOW SLAVE STATUS\G" -vvv


# Master:
# FLUSH logs
# PURGE BINARY LOGS TO 'mysql-bin.00000X'
# RESET master
#

# GRANT REPLICATION SLAVE ON *.* TO repl@'%' IDENTIFIED BY 'slavepass'
#
# CHANGE MASTER to master_host="mysql",master_user="repl",master_password="slavepass",master_log_file="mysql-bin.000001",master_log_pos=0;

# RESET slave

# show master status \G
# show slave status \G


# mysqldump -uroot -p --all-databases > mysqldump.sql
#
# mysql -uroot -p < mysqldump.sql
