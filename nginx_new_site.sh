#!/usr/bin/env bash
echo "Domain name:"
read domain

echo "Alias:"
read alias

echo "Root path:"
read path

echo "server {
    listen 80;
    server_name $domain $alias;
    access_log /var/log/nginx/$domain/access.log;
    error_log /var/log/nginx/$domain/error.log;
    root $path;
    index index.html index.htm index.php;
    charset utf-8;

    location @rewrite {
        rewrite ^/(.*)$ /index.php?_url=/\$1;
    }

    location / {
        try_files \$uri \$uri/ @rewrite;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt { access_log off; log_not_found off; }

    access_log off;
    sendfile on;

    location ~ \.php$ {
        try_files \$uri \$uri/ /index.php?\$args;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_intercept_errors on;
        include fastcgi_params;
    }
    location ~ /\.ht {
        deny all;
    }
    location ~ \.(jpg|jpeg|gif|png|css|js|ico|xml|ttf|ttc|otf|eot|woff|woff2|font.css)$ {
        access_log        off;
        log_not_found     off;
        expires           360d;
    }
}" > /etc/nginx/sites-available/$domain.conf

mkdir /var/log/nginx/$domain

ln -s /etc/nginx/sites-available/$domain.conf /etc/nginx/sites-enabled/$domain.conf

service nginx restart