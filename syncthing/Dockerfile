FROM tianon/syncthing

USER root

ADD https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd-0.11.0-linux-amd64 /usr/bin/confd
RUN apk add --no-cache curl jq bash

ADD entrypoint.sh /entrypoint.sh
ADD reload.sh /reload.sh

RUN chmod +x /usr/bin/confd /entrypoint.sh /reload.sh

ADD conf/* /etc/confd/conf.d/
ADD templates/* /etc/confd/templates/

RUN chmod -Rf 777 /home/user

ENV HOME /home/user

CMD ["/entrypoint.sh"]
