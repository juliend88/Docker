#!/bin/bash
ACTION=$1

if [ "$ACTION" == "restore" ]
then
    IP=$3
    ID=$2
    mkdir -p /mnt/restore
    sshfs $IP:/restore/ /mnt/restore -o IdentityFile=/secret/key.pem -o StrictHostKeyChecking=no
    echo $ACTION
    exec ./restore.sh $ID
elif [ "$ACTION" == "backup" ]
then
  PERIOD=$2
  ID=$3
  IP=$4
  DIRECTORY=$5
  for dir in $DIRECTORY
  do
    mkdir -p /mnt/$dir
    sshfs $IP:$dir /mnt/$dir -o IdentityFile=/secret/key.pem -o StrictHostKeyChecking=no
  done
  echo $ACTION
  exec ./$PERIOD.sh $ID
else
  exec $*
fi
