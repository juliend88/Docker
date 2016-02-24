#!/usr/bin/env bash

if [ ! -f /etc/aptly.conf ]
then
confd -backend env -onetime
fi
exec $@