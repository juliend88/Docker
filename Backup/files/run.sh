#!/bin/bash
IP=$2
DIRECTORY=$3
ACTION=$4
for dir in $DIRECTORY
do
  sshfs cloud@$IP:$dir /mnt/$dir -o IdentityFile=/secret/key.pem -o StrictHostKeyChecking=no
done

 if [  "$ACTION" != "backup" ]
 then
     sshfs cloud@$IP:/restore/ /mnt/restore -o IdentityFile=/secret/key.pem -o StrictHostKeyChecking=no
   echo $ACTION
   exec ./restore.sh $2
 else
   for dir in $DIRECTORY
   do
     sshfs cloud@$IP:$dir /mnt/$dir -o IdentityFile=/secret/key.pem -o StrictHostKeyChecking=no
   done
   echo $ACTION
   exec ./$1.sh $2 $3
 fi
