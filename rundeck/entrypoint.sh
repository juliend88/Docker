#!/bin/bash
if [ -n "$ETCD_NODE" ]
then
    confd -backend etcd -node ${ETCD_NODE} -prefix ${ETCD_PREFIX} -onetime
else
    confd -backend env -onetime
fi

. /etc/rundeck/profile
${JAVA_HOME:-/usr}/bin/java ${RDECK_JVM} -cp ${BOOTSTRAP_CP} com.dtolabs.rundeck.RunServer /var/lib/rundeck ${RDECK_HTTP_PORT}
