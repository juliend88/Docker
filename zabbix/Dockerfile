FROM zabbix/zabbix-3.0:latest

RUN bash -c 'echo "UPDATE items SET type=7 WHERE type=0;" >> /usr/local/src/zabbix/database/mysql/data.sql'
