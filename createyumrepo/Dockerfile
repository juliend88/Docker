FROM centos:7

RUN yum install ngnix createrepo \
mkdir -pv /data/public; \
wget -m -p -E -k -K -np http://mirror.cogentco.com/pub/linux/epel/6/x86_64/ \
createrepo /data/public/;

ADD nginx.conf /etc/nginx/sites-available/default
CMD ["nginx", "-g", "'daemon off;'"]
