#!/usr/bin/env bash

if [ ! -f /data/public/RPM-GPG-KEY-CentOS-7 ]
then
    echo "create repository"
    createrepo /data/public/; \
    rsync -avz rsync://mirror1.babylon.network/centos/7/os/x86_64/ /data/public/; \
    createrepo --update /data/public/
fi

nginx -g "daemon off;"

