#!/usr/bin/env bash
yum -y install nano zip unzip

## Install MySQL 5.7
yum -y localinstall https://dev.mysql.com/get/mysql57-community-release-el6-7.noarch.rpm
yum -y install mysql-community-server

service mysqld start
chkconfig --levels 235 mysqld on

grep 'A temporary password is generated for root@localhost' /var/log/mysqld.log |tail -1

echo "* Change MySQL Password? *"
echo "1 - Yes"
echo "2 - No"
echo "--------------------------"
read option

if [ $option="1" ]
then /usr/bin/mysql_secure_installation
exit 0
fi