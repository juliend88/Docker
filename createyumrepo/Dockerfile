FROM centos:7

RUN mkdir -p /data/public; \
yum update -y && yum install yum-utils createrepo rsync epel-release  -y; \
yum install nginx -y

ADD entrypoint.sh /entrypoint.sh
ADD files/nginx.conf /etc/nginx/sites-available/default
ADD files/updateyumly.sh /etc/cron.hourly/updateyumly.sh

CMD ["/entrypoint.sh"]