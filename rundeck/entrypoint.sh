#!/bin/bash
cp -f /etc/rundeck/custom/* /etc/rundeck/
. /etc/rundeck/profile
${JAVA_HOME:-/usr}/bin/java ${RDECK_JVM} -cp ${BOOTSTRAP_CP} com.dtolabs.rundeck.RunServer /var/lib/rundeck ${RDECK_HTTP_PORT}
