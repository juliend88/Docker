FROM williamyeh/ansible:ubuntu14.04

ENV ANSIBLE_HOST_KEY_CHECKING False

ADD entrypoint.sh /

ADD graylog-file/90-graylog2.j2 /ansible/graylog-file/
ADD clamav-file-ubuntu/clamav.j2 /ansible/clamav-file-ubuntu/
ADD clamav-file-centos/* /ansible/clamav-file-centos/
ADD *.yml /ansible/


ENTRYPOINT ["/entrypoint.sh"]

