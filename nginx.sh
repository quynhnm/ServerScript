#!/usr/bin/env bash
yum -y install wget nano zip unzip nodejs npm git
npm -g install forever
yum -y update

## Remi Dependency on CentOS 6 and Red Hat (RHEL) 6 ##
rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

## CentOS 6 and Red Hat (RHEL) 6 ##
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

echo "[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/\$releasever/\$basearch/
gpgcheck=0
enabled=1" > /etc/yum.repos.d/nginx.repo

yum --enablerepo=remi,remi-php56 -y install nginx php-fpm php-common

yum --enablerepo=remi,remi-php56 -y install php-opcache php-pecl-apcu php-cli php-pear php-pdo php-mysqlnd php-pgsql php-pecl-mongo php-pecl-sqlite php-pecl-memcache php-pecl-memcached php-gd php-mbstring php-mcrypt php-xml

service nginx start
chkconfig --add nginx
chkconfig --levels 235 nginx on

service php-fpm start
chkconfig --add php-fpm
chkconfig --levels 235 php-fpm on

mkdir -p /home/dev.vaber.vn/public_html
mkdir -p /var/log/nginx/dev.vaber.vn
chown -R nginx:nginx /home
chown -R nginx:nginx /var/log/nginx

mkdir /etc/nginx/sites-available
mkdir /etc/nginx/sites-enabled

scp root@dev.vaber.vn:/etc/nginx/sites-available/*.conf /etc/nginx/sites-available

ln -s /etc/nginx/sites-available/*.conf /etc/nginx/sites-enabled/

service nginx restart