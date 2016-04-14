#!/bin/bash
if `aptly mirror list` == *No mirrors found*; then
    ./etc/cron.daily/deb-mirror
fi
