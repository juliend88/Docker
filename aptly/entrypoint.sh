#!/usr/bin/env bash

if [ ! -f /etc/aptly.conf ]
then
    if [ -n "$ETCD_NODE" ]
    then
        confd -backend etcd -node ${ETCD_NODE} -onetime
    else
        confd -backend env -onetime
    fi
fi
exec $@

