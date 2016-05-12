FROM nginx

RUN apt-get update && apt-get install wget cron host -y --force-yes && apt-get clean && rm -rf /var/lib/apt/lists/*

ADD files/clamsubver.sh /etc/cron.daily/
ADD files/dailyupdate.sh /etc/cron.daily/
ADD entrypoint.sh /

RUN chmod +x /etc/cron.daily/clamsubver.sh /etc/cron.daily/dailyupdate.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
