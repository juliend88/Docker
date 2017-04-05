#!/bin/sh
cat <<EOF > /root/.rclone.conf
[Openstack]
type = swift
user = ${OS_USERNAME}
key = ${OS_PASSWORD}
auth = ${OS_AUTH_URL}
tenant = ${OS_TENANT_NAME}
region = ${OS_REGION}
storage_url =
EOF

rclone copy Openstack:etcd-backup-${NODE} /opt/factorio/saves
touch /opt/etcd/ready
crond -f
