#!/bin/sh
until [ $(stat -c '%s' "/usr/share/nginx/html/daily.cvd") -gt 0 ]; do
    wget -c -O /usr/share/nginx/html/daily.cvd http://database.clamav.net/daily.cvd
done
until [ $(stat -c '%s' "/usr/share/nginx/html/main.cvd") -gt 0 ]; do
    wget -c -O /usr/share/nginx/html/main.cvd http://database.clamav.net/main.cvd
done
