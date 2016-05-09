#!/usr/bin/env bash
set -x

if [ -f /usr/share/graylog/data/journal/.lock ]; then
    rm -f /usr/share/graylog/data/journal/.lock
fi
for d in journal log plugin config contentpacks; do
    if [ ! -d /usr/share/graylog/data/$d ]; then
        mkdir /usr/share/graylog/data/$d
    fi
done
if [ ! -f /usr/share/graylog/data/config/graylog.conf ]; then
    cp /graylog.conf /usr/share/graylog/data/config/graylog.conf
    cp /log4j2.xml /usr/share/graylog/data/config/log4j2.xml
fi

# Start Graylog server
"$JAVA_HOME/bin/java" $GRAYLOG_SERVER_JAVA_OPTS \
  -jar \
  -Dlog4j.configuration=file:///usr/share/graylog/data/config/log4j2.xml \
  -Djava.library.path=/usr/share/graylog/lib/sigar/ \
  -Dgraylog2.installation_source=docker /usr/share/graylog/graylog.jar \
  server \
  -f /usr/share/graylog/data/config/graylog.conf
