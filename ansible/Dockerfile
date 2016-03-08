FROM ansible/ubuntu14.04-ansible

ENV ANSIBLE_HOST_KEY_CHECKING False

ADD entrypoint.sh /

ADD *.yml /ansible/

ENTRYPOINT ["/entrypoint.sh"]

