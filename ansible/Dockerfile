FROM williamyeh/ansible:ubuntu14.04

RUN apt-get update && apt-get install -y python-pip && pip install zabbix-api paramiko

ENV ANSIBLE_HOST_KEY_CHECKING False

ADD entrypoint.sh /

ADD ansible-install /ansible/ansible-install
ADD ansible-uninstall /ansible/ansible-uninstall

ENTRYPOINT ["/entrypoint.sh"]

