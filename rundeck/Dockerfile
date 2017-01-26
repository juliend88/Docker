FROM java:7

ENV RUN_DECK_VERSION 2.6.11-1-GA

RUN wget http://dl.bintray.com/rundeck/rundeck-deb/rundeck-${RUN_DECK_VERSION}.deb && dpkg -i rundeck-${RUN_DECK_VERSION}.deb && rm -f rundeck-${RUN_DECK_VERSION}.deb

ADD entrypoint.sh /entrypoint.sh

RUN bash -c "echo project.resources.url = http://10.1.1.10:30000/api/servers/rundeck >> /etc/rundeck/project.properties"

CMD ["/entrypoint.sh"]

EXPOSE 4440
VOLUME /etc/rundeck
VOLUME /var/rundeck
