FROM alpine

RUN apk -U add ca-certificates \
 && rm -rf /var/cache/apk/*

RUN cd /tmp \
  && wget -q http://downloads.rclone.org/rclone-current-linux-386.zip \
  && unzip /tmp/rclone-current-linux-386.zip \
  && mv /tmp/rclone-*-linux-386/rclone /usr/bin \
  && rm -r /tmp/rclone*

ADD crontab /var/spool/cron/crontabs/root
ADD entrypoint.sh /entrypoint.sh
ADD backup.sh /root/backup.sh

CMD ["/entrypoint.sh"]
