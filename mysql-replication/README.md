# MySQL Replication

- [Docker MySQL Replication](https://www.percona.com/blog/2016/03/30/docker-mysql-replication-101/)
- [How to re-sync the Mysql DB if Master and slave have different database incase of Mysql replication?](http://stackoverflow.com/questions/2366018/how-to-re-sync-the-mysql-db-if-master-and-slave-have-different-database-incase-o)
- percona PPT "MySQL Replication Best Practices"
- MySQL Offical [DOC](http://dev.mysql.com/doc/refman/5.7/en/replication.html)
- [mysql replication 主从(master-slave)同步](http://blog.51yip.com/mysql/1716.html)

## docker mysql replication

```
--- master          # master id 1
  |--_data          # db data dir
  |--conf.d         #
    |--master.cnf   # configuration
--- slave-1         # slave id 11
  |--_data
  |--conf.d
    |--slave.cnf
--- slave-2         # slave id 12
--- slave-3         # slave id 13
```


## mysql on ec2

看到一个介绍 EC2 Instance Limitations 中描述

> Data stored within instances is not persistent. If you create an instance and populate the instance with data, then the data only remains in place while the machine is running, and does not survive a reboot. If you shut down the instance, any data it contained is lost.

- https://dev.mysql.com/doc/refman/5.7/en/ha-vm-aws-instance.html
- http://docs.aws.amazon.com/zh_cn/AWSEC2/latest/UserGuide/RootDeviceStorage.html
