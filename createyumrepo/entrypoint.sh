#!/usr/bin/env bash

env

if [ ! -f /data/public/RPM-GPG-KEY-CentOS-7 ]
then
    echo "create repository"
    reposync --gpgcheck -l --repoid=epel --download_path=/data/public/

fi

nginx -g "daemon off;"