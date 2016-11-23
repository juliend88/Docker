FROM graylog2/server:2.1.2-1

ADD custom-entrypoint.sh /
ADD graylog.conf /
ADD log4j2.xml /

CMD ["/custom-entrypoint.sh"]