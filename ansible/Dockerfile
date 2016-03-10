FROM williamyeh/ansible:ubuntu14.04

ENV ANSIBLE_HOST_KEY_CHECKING False

ADD entrypoint.sh /

ADD graylog-file/90-graylog2.j2 /ansible/graylog-file/
ADD ansible-install/* /ansible/ansible-install/
ADD ansible-uninstall/* /ansible/ansible-uninstall/
ADD *.yml /ansible/


ENTRYPOINT ["/entrypoint.sh"]

