#!/usr/bin/env bash
sudo yum install -y nginx
sudo chkconfig nginx on
sudo service nginx start

sudo yum install -y gcc libxml2-devel libXpm-devel gmp-devel libicu-devel t1lib-devel aspell-devel openssl-devel bzip2-devel libcurl-devel libjpeg-devel libvpx-devel libpng-devel freetype-devel readline-devel libtidy-devel libxslt-devel libmcrypt-devel pcre-devel curl-devel ncurses-devel gettext-devel net-snmp-devel libevent-devel libtool-ltdl-devel libc-client-devel postgresql-devel bison gcc make
sudo mkdir /opt/source && cd /opt/source
git clone git@github.com:php/php-src.git && cd php-src
git checkout PHP-5.6.9
sudo ./buildconf --force
sudo mkdir -p /opt/php/5.6.9

./configure \
--prefix=/opt/php/5.6.9 \
--with-pdo-pgsql \
--with-zlib-dir \
--with-freetype-dir \
--enable-mbstring \
--with-libxml-dir=/usr \
--enable-soap \
--enable-calendar \
--with-curl \
--with-mcrypt \
--with-zlib \
--with-gd \
--with-pgsql \
--disable-rpath \
--enable-inline-optimization \
--with-bz2 \
--with-zlib \
--enable-sockets \
--enable-sysvsem \
--enable-sysvshm \
--enable-pcntl \
--enable-mbregex \
--with-mhash \
--enable-zip \
--with-pcre-regex \
--with-mysql \
--with-pdo-mysql \
--with-mysqli \
--with-png-dir=/usr \
--enable-gd-native-ttf \
--with-openssl \
--with-fpm-user=nginx \
--with-fpm-group=nginx \
--with-libdir=lib64 \
--enable-ftp \
--with-imap \
--with-imap-ssl \
--with-kerberos \
--with-gettext \
--with-gd \
--with-jpeg-dir=/usr/lib/ \
--enable-fpm

make && sudo make install
sudo cp /opt/source/php-src/php.ini-production /opt/php/5.6.9/lib/php.ini

echo ";;;;;;;;;;;;;;;;;;;;;
; FPM Configuration ;
;;;;;;;;;;;;;;;;;;;;;

;include=etc/fpm.d/*.conf

;;;;;;;;;;;;;;;;;;
; Global Options ;
;;;;;;;;;;;;;;;;;;

[global]
pid = run/php56-fpm.pid

;;;;;;;;;;;;;;;;;;;;
; Pool Definitions ;
;;;;;;;;;;;;;;;;;;;;

[www]
user = nginx
group = nginx
listen = 127.0.0.1:9000
pm = dynamic
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3" > /opt/php-5.6/etc/php-fpm.conf

sudo cp /opt/source/php-src/sapi/fpm/php-fpm /etc/init.d/php56-fpm
sudo chmod 755 /etc/init.d/php56-fpm
sudo chkconfig php56-fpm on
sudo /etc/init.d/php56-fpm start