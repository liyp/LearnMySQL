从`Distribution`安装的MySQL，恢复Replication的一些步骤。

1. 删除 `data` 所有数据。 `sudo rm -rf data/*`

2.  ```
    sudo ./scripts/mysql_install_db --user=mysql --force
    sudo chown -R root:root ./
    sudo chown -R mysql:mysql data

    sudo ln -f -s /usr/local/mysql/bin/mysql /usr/local/bin/mysql
    sudo ln -f -s /usr/local/mysql/bin/mysqladmin /usr/local/bin/mysqladmin
    sudo ln -f -s /usr/local/mysql/bin/mysqldump /usr/local/bin/mysqldump
    ```

4.  ```
    sudo cp support-files/mysql.server /etc/init.d/mysql
    # sudo rm /etc/init/mysql.conf
    ```
    添加服务自启动 `sudo update-rc.d mysql defaults`

    > update-rc.d allows setting init script links on Ubuntu and Debian Linux systems to control what services are run by init when entering various runlevels. It should be able to add mysql to the list of services to run at boot:  
    > `sudo update-rc.d mysql defaults`  
    > If you later want to disable running mysql on bootup:  
    > `sudo update-rc.d mysql remove`

    也可以手动启动 `sudo ./mysqld_safe &`

5. `mysqladmin -uroot password root`

6.  master:SQL  
    `grant replication slave on *.* to 'replication'@'%' identified by '123456';`  
    `reset master`  
    slave:  
    `change master to master_host="10.5.2.212",master_user="replication",master_password="123456",master_log_file="mysql-bin.000001",master_log_pos=120;`  
    `start slave`  
    到这里，主从搭建就可以了，剩下的都是对主进行操作

7.  添加操作用户权限  
    `grant all on *.* to user@'%' identified by 'userpasswd';`  


对MySQL了解不足，很多不知所以然。
