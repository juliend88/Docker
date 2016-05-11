#!/bin/sh
ver=`host -t txt current.cvd.clamav.net | awk -F":" '{print $3}'`
dl="daily-$ver.cdiff"
wget -O /usr/share/nginx/html/$dl http://database.clamav.net/$dl

cat <<EOF > /etc/nginx/conf.d/default.conf
server {
    listen       80;
    server_name  localhost;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
        rewrite ^/diff /$dl break;
    }
}
EOF
