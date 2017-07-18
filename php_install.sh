#!/usr/bin/env bash
cd /opt/source/php-src
git branch -a
echo "PHP version: (7.0.9)"
read version
git checkout PHP-$version
sudo ./buildconf --force
sudo mkdir -p /opt/php/$version

./configure \
--prefix=/opt/php/$version \
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
sudo cp /opt/source/php-src/sapi/fpm/php-fpm.conf /opt/php/$version/etc/php-fpm.conf
sudo cp /opt/source/php-src/php.ini-production /opt/php/$version/lib/php.ini
sudo cp /opt/source/php-src/sapi/fpm/php-fpm /etc/init.d/php$version-fpm
sudo chmod 755 /etc/init.d/php$version-fpm
sudo chkconfig php$version-fpm on

echo "Install PHP version $version successful, please change php-fpm port on /opt/php/$version/etc/php-fpm.conf after start service php$version-fpm"