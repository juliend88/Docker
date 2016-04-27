#!/usr/bin/env bash

if [ ! -f /etc/aptly.conf ]
then
    if [ -n "$ETCD_NODE" ]
    then
        confd -backend etcd -node ${ETCD_NODE} -prefix ${ETCD_PREFIX} -onetime
    else
        confd -backend env -onetime
    fi
         gpg --no-default-keyring --keyring trustedkeys.gpg --keyserver keys.gnupg.net --recv-keys 2A194991
fi

<<<<<<< Updated upstream
MIRROREXIST=$(aptly mirror list)
if [ "$MIRROREXIST"="No mirrors found*" ]
then
    echo "Mirror does not exist"
    ./etc/cron.daily/deb-mirror &
=======
if `aptly mirror list` == "*No mirrors found*"; then
    ./etc/cron.daily/deb-mirror
>>>>>>> Stashed changes
fi

bash -c "$*"