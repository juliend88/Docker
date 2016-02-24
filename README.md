# Docker

This repository contains different images :

## ntpserver

A NTP Server synced with default timeservers

Launch the container by this way : 
~~~ bash 
docker run -d -p 123:123  cloudwattfr/ntpserver:latest 
~~~

## rundeck

A Rundeck Server

You must have a keystore to activate ssl, see : http://rundeck.org/docs/administration/configuring-ssl.html

Launch the container by this way : 
~~~ bash
docker run -v *the_path_to_your_keystore_file*_:/keystore -e RUNDECK_USERS_ADMIN=*the_admin_password* -e RUNDECK_USERS_TOTO=*toto_user_password* -e RUNDECK_BASEURI=*the_base_uri* -e RUNDECK_SSL_KEYSTORE_FILE=/keystore -e RUNDECK_SSL_KEYSTORE_PASSWORD=*the_keystore_password* -d -p 4443:4443 cloudwattfr/rundeck:latest
~~~

## Aptly

Launch the container by this way : 
~~~ bash
docker run -ti -e APTLY_NAME= -e APTLY_TENANT_USERNAME= -e APTLY_TENANT_PASSWORD= -e APTLY_AUTHURL= -e APTLY_TENANT_NAME= -e APTLY_TENANT_ID= cloudwattfr/aptly:latest
~~~

## ETCD

launch the container by this way : {HOSTIP} = SERVERIP

~~~ bash 
docker run -d -p 4001:4001 -p 2380:2380 -p 2379:2379 --name etcd quay.io/coreos/etcd:v2.0.3 \
 -name etcd0 \
 -advertise-client-urls http://**${HostIP}**:2379,http://**${HostIP}**:4001 \
 -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
 -initial-advertise-peer-urls http://**${HostIP}**:2380 \
 -listen-peer-urls http://0.0.0.0:2380 \
 -initial-cluster-token etcd-cluster-1 \
 -initial-cluster etcd0=http://**${HostIP}**:2380 \
 -initial-cluster-state new
~~~

## PULP
see Github readme:
https://github.com/pulp/pulp_packaging/blob/master/dockerfiles/docker-quickstart.rst

## Graylog 

launch the container by this way : docker run -t -p 9000:9000 -p 12201:12201 -e  -e GRAYLOG_SERVER_SECRET=somesecretsaltstring -v /graylog/data:/var/opt/graylog/data -v /graylog/logs:/var/log/graylog graylog2/allinone

Options list :
GRAYLOG_PASSWORD: Set admin password
GRAYLOG_USERNAME: Set username for admin user (default: admin)
GRAYLOG_TIMEZONE: Set timezone (TZ) you are in
GRAYLOG_SMTP_SERVER: Hostname/IP address of your SMTP server for sending alert mails
GRAYLOG_RETENTION: Configure how long or how many logs should be stored
GRAYLOG_NODE_ID: Set server node ID (default: random)
GRAYLOG_SERVER_SECRET: Set salt for encryption
GRAYLOG_MASTER: IP address of a remote master container (see multi container setup)
GRAYLOG_SERVER: Run only server components
GRAYLOG_WEB: Run web interface only
ES_MEMORY: Set memory used by Elasticsearch (syntax: 1024m). Defaults to 60% of host memory


## Zabbix 

launch the container by this way : 
Zabbix DB (maria db) : 

docker run \
    -d \
    --name zabbix-db \
    -p 3306:3306 \
    -v /etc/localtime:/etc/localtime:ro \
    --env="MARIADB_USER=zabbix" \
    --env="MARIADB_PASS=my_password" \
    zabbix/zabbix-db-mariadb \
   
    
Zabbix Server : 

docker run \
    -d \
    --name zabbix \
    -p 80:80 \
    -p 10051:10051 \
    -v /etc/localtime:/etc/localtime:ro \
    --link zabbix-db:zabbix.db \
    --env="ZS_DBHost=zabbix.db" \
    --env="ZS_DBUser=zabbix" \
    --env="ZS_DBPassword=my_password" \
    zabbix/zabbix-3.0:latest
    
Options : https://hub.docker.com/r/zabbix/zabbix-3.0/    
    