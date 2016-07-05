#!/bin/bash
ACTION=$1

if [ "$ACTION" == "restore" ]
then
    IP=$2
    mkdir -p /mnt/restore
    sshfs cloud@$IP:/restore/ /mnt/restore -o IdentityFile=/secret/key.pem -o StrictHostKeyChecking=no
    echo $ACTION
    exec ./restore.sh $IP
elif [ "$ACTION" == "backup" ]
then
  PERIOD=$2
  IP=$3
  DIRECTORY=$4
  for dir in $DIRECTORY
  do
    mkdir -p /mnt/$dir
    sshfs cloud@$IP:$dir /mnt/$dir -o IdentityFile=/secret/key.pem -o StrictHostKeyChecking=no
  done
  echo $ACTION
  exec ./$PERIOD.sh $IP
else
  exec $*
fi
