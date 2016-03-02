#!/bin/sh
ver=`host -t txt current.cvd.clamav.net | awk -F":" '{print $3}'`
dl="daily-$ver.cdiff"
wget -O /usr/share/nginx/html/$dl http://database.clamav.net/$dl
