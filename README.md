# Docker

This repository contains different images :

## ntpserver

A NTP Server synced with default timeservers

Launch the container by this way : docker run -d -p 123:123  cloudwattfr/ntpserver:latest

## rundeck

A Rundeck Server

You must have a keystore to activate ssl, see : http://rundeck.org/docs/administration/configuring-ssl.html

Launch the container by this way : docker run -v *the_path_to_your_keystore_file*_:/keystore -e RUNDECK_USERS_ADMIN=*the_admin_password* -e RUNDECK_USERS_TOTO=*toto_user_password* -e RUNDECK_BASEURI=*the_base_uri* -e RUNDECK_SSL_KEYSTORE_FILE=/keystore -e RUNDECK_SSL_KEYSTORE_PASSWORD=*the_keystore_password* -d -p 4443:4443 cloudwattfr/rundeck:latest

## Aptly

