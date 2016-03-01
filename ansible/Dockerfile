FROM ansible/ubuntu14.04-ansible

RUN apt-get update && apt-get install -y python-dev && pip install python-openstackclient shade && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV ANSIBLE_HOST_KEY_CHECKING False

ADD openstack.py /ansible/
ADD entrypoint.sh /

ADD *.yml /ansible/

ENTRYPOINT ["/entrypoint.sh"]

