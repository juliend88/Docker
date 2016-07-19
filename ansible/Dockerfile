FROM williamyeh/ansible:master-ubuntu14.04

RUN apt-get update && apt-get install -y python-pip libffi-dev python-dev libssl-dev && pip install zabbix-api paramiko

ENV ANSIBLE_HOST_KEY_CHECKING False

ADD entrypoint.sh /

ADD backup /ansible/backup
ADD ansible-install /ansible/ansible-install
ADD ansible-uninstall /ansible/ansible-uninstall

ENTRYPOINT ["/entrypoint.sh"]

