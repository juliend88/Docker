#!/usr/bin/env bash

/etc/cron.daily/dailyupdate.sh
/etc/cron.daily/clamsubver.sh

cron
nginx -g "daemon off;"

