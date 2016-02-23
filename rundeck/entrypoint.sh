#!/bin/bash
confd -backend env -onetime

. /etc/rundeck/profile
RDECK_JVM="$RDECK_JVM -Drundeck.ssl.config=/etc/rundeck/ssl/ssl.properties -Dserver.https.port=${RDECK_HTTPS_PORT}"
${JAVA_HOME:-/usr}/bin/java ${RDECK_JVM} -cp ${BOOTSTRAP_CP} com.dtolabs.rundeck.RunServer /var/lib/rundeck ${RDECK_HTTPS_PORT}


