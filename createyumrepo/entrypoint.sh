#!/usr/bin/env bash

if [ ! -f /var/www/html/repos/centos/7/RPM-GPG-KEY-CentOS-7 ]
then
    "/var/www/html/repos/centos/7/RPM-GPG-KEY-CentOS-7: No such file or directory"
    createrepo /var/www/html/repos/centos/7/; \
    rsync -avz rsync://mirror1.babylon.network/centos/7/os/x86_64/ /var/www/html/repos/centos/7/; \
    createrepo --update /var/www/html/repos/centos/7/
fi