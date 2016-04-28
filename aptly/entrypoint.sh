#!/usr/bin/env bash

mkdir -p /data/public
echo <<EOF > /data/public/index.html
<html>
<head>
    <title>Aptly</title>
</head>
<body>
<h1>Welcome to Aptly server</h1>
</body>
</html>
EOF

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

MIRROREXIST=$(aptly mirror list)
if [ "$MIRROREXIST"="No mirrors found*" ]
then
    echo "Mirror does not exist"
    ./etc/cron.daily/deb-mirror &
fi

bash -c "$*"