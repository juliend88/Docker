#!/usr/bin/env bash

env

if [ ! -f /data/public/RPM-GPG-KEY-CentOS-7 ]
then
    echo "create repository"
    reposync --gpgcheck -l --repoid=updates --download_path=/data/public/ --download-metadata --downloadcomps -g comps.xml



fi

nginx -g "daemon off;"