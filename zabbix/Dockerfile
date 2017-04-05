FROM zabbix/zabbix-server-pgsql:ubuntu-3.2.3

RUN bash -c 'echo "UPDATE items SET type=7 WHERE type=0;" >> /usr/share/doc/zabbix-server-postgresql/data.sql'
