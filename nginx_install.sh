#!/usr/bin/env bash
## Install Nginx
## Remi Dependency on CentOS 6 and Red Hat (RHEL) 6 ##
rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

## CentOS 6 and Red Hat (RHEL) 6 ##
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

echo "[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/6/x86_64/
gpgcheck=0
enabled=1" > /etc/yum.repos.d/nginx.repo

yum -y --enablerepo=remi,remi-php70 install nginx php-fpm php-common
yum -y --enablerepo=remi,remi-php70 install php-opcache php-pecl-apcu php-cli php-pear php-pdo php-mysqlnd php-pgsql php-pecl-mongodb php-pecl-redis php-pecl-memcache php-pecl-memcached php-gd php-mbstring php-mcrypt php-xml
service nginx start
chkconfig --add nginx
chkconfig --levels 235 nginx on

service php-fpm start
chkconfig --add php-fpm
chkconfig --levels 235 php-fpm on

mkdir /etc/nginx/sites-available
mkdir /etc/nginx/sites-enabled

mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
sed -e $'s/include \/etc\/nginx\/conf\.d\/\*.conf;/include \/etc\/nginx\/conf\.d\/\*.conf;\\\n\\\tinclude \/etc\/nginx\/sites-enabled\/\*.conf;/g' /etc/nginx/nginx.conf.bak > /etc/nginx/nginx.conf
service nginx restart

yum -y install redis
chkconfig --add redis
chkconfig --levels 235 redis on
service redis start