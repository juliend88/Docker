#!/bin/sh
ver=`host -t txt current.cvd.clamav.net | awk -F":" '{print $3}'`
dl="daily-$ver.cdiff"
until [ $(stat -c '%s' "/usr/share/nginx/html/$dl") -gt 0 ]; do
    wget -c -O /usr/share/nginx/html/$dl http://database.clamav.net/$dl
done

cat <<EOF > /etc/nginx/conf.d/default.conf
server {
    listen       80;
    server_name  localhost;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    location /diff {
        return 200 $dl;
    }
}
EOF

/etc/init.d/nginx reload
