#!/bin/bash

set -ex

declare -a DISTS=("precise" "trusty")
ARCHS="amd64"

function register-mirror {
    UBUNTU_URI='http://fr.archive.ubuntu.com/ubuntu/'

    for DIST in ${DISTS[@]}; do
        aptly -architectures=$ARCHS mirror create ubuntu-$DIST $UBUNTU_URI $DIST main
    done
}

function update-mirror-and-create-snapshot {
    DATE=`date +%Y%m%d%H`
    aptly mirror list -raw | xargs -I{} aptly task run mirror update -force=true {}, snapshot create {}-$DATE from mirror {}
}

function merge-check-newer-repository {
    for MIRROR in `aptly mirror list -raw`; do
        echo "chacking mirror $MIRROR..."
        DIFF_SNAPSHOTS=`aptly snapshot list -raw -sort="time" | grep $MIRROR | grep -v $MIRROR-merged | tail -n2 | tr '\n' ' '`
        NUM_DIFF_SNAPSHOTS=`echo "$DIFF_SNAPSHOTS" | wc -w`
        echo "comparing $NUM_DIFF_SNAPSHOTS snapshots: $DIFF_SNAPSHOTS..."
        if [ $NUM_DIFF_SNAPSHOTS -eq 1 ]; then
            echo "$MIRROR is new snapshot. merging itself..."
            aptly snapshot merge $MIRROR-merged $DIFF_SNAPSHOTS
            continue
        elif [ $NUM_DIFF_SNAPSHOTS -eq 0 ]; then
            echo "error occurs!"
            return 1
        fi
        DIFF_RES="`aptly snapshot diff $DIFF_SNAPSHOTS |wc -l`"
        if [ $DIFF_RES -ne 1 ]; then
            # update available
            echo "$MIRROR has been updated"
            DATE=`date +%Y%m%d%H`
            LATEST_PUB_SNAPSHOT=$MIRROR-merged
            LATEST_SNAPSHOT=`echo $DIFF_SNAPSHOTS | tail -n1`
            aptly snapshot rename $LATEST_PUB_SNAPSHOT $LATEST_PUB_SNAPSHOT-$DATE
            aptly snapshot merge $LATEST_PUB_SNAPSHOT $LATEST_PUB_SNAPSHOT-$DATE $LATEST_SNAPSHOT
        fi
    done
}

function publish-switch-all-repository {
    for MIRROR in `aptly mirror list -raw=true`; do
        DIST=`echo $MIRROR | tr '-' '\n' | tail -n1`
        REPO_NAME=`echo $MIRROR | sed -e "s/-$DIST//g"`
        set +e
        PUBLISHED=`aptly publish list -raw=true`
        PUBLISHED=`echo "${PUBLISHED:=dummy}" | grep "$REPO_NAME $DIST"`
        set -e

        if [ "$PUBLISHED" = "" ]; then
            echo "publish $MIRROR..."
            aptly publish snapshot -distribution="$DIST" $MIRROR-merged $REPO_NAME
        else
            echo "publish switch $MIRROR..."
            aptly publish switch $DIST $REPO_NAME $MIRROR-merged
        fi
    done
}

function cleanup {
    aptly db cleanup
    set +e
#    aptly snapshot list -raw=true | xargs -n1 aptly snapshot drop
    set -e
}

if [ "`aptly mirror list -raw=true |wc -l`" -eq 0 ]; then
    register-mirror
fi
update-mirror-and-create-snapshot
merge-check-newer-repository
publish-switch-all-repository
cleanup
exit 0