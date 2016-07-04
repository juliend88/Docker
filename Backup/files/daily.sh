#!/bin/bash
IP=$1
DIRECTORY=$2
for dir in $DIRECTORY
do
  sshfs cloud@$IP:$dir /mnt/$dir -o IdentityFile=/secret/key.pem -o StrictHostKeyChecking=no
done

src=/mnt
dest="swift://$1"

duplicity --allow-source-mismatch --no-encryption --verbosity notice \
        --full-if-older-than 7D \
        --num-retries 3 \
        --asynchronous-upload \
         "${src}" "${dest}"
