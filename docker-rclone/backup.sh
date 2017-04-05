#!/bin/sh
/usr/bin/rclone delete --max-age 1d Openstack:etcd-backup-${NODE}
/usr/bin/rclone copy /opt/etcd Openstack:etcd-backup-${NODE}
