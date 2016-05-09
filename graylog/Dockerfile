FROM graylog2/server:2.0.0-2

ADD custom-entrypoint.sh /
ADD graylog.conf /
ADD log4j2.xml /

CMD ["/custom-entrypoint.sh"]