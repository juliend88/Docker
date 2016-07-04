FROM ubuntu:latest

# Install base packages apache php imagemagick
RUN apt-get update --quiet > /dev/null && \
    apt-get install --assume-yes --force-yes -qq \
    openssh-client sshfs duplicity rsync librsync-dev build-essential wget python-dev python-swiftclient python-pip && \
		apt-get clean && \
		rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip && pip install python-openstackclient

RUN cd /tmp \
    && wget https://code.launchpad.net/duplicity/0.7-series/0.7.07/+download/duplicity-0.7.07.tar.gz \
    && tar xf duplicity-0.7.07.tar.gz \
    && cd duplicity-0.7.07 && python2 setup.py install \
    && cd /tmp \
    && wget http://netcologne.dl.sourceforge.net/project/ftplicity/duply%20%28simple%20duplicity%29/1.11.x/duply_1.11.2.tgz \
    && tar xpf duply_1.11.2.tgz \
    && cp -a duply_1.11.2/duply /usr/bin/duply \
    && cd / && rm -rf /tmp/* \
    && mkdir /mnt/data \
    && mkdir /mnt/config \
    && mkdir /mnt/restore \
    && chmod 777 /mnt/restore

RUN mkdir /opt/scripts

WORKDIR /opt/scripts/
ENV HOME /opt/scripts/

ADD files/* ./


ENTRYPOINT ["./run.sh"]
