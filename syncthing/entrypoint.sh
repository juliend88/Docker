#!/bin/bash
export HOME=/home/user

syncthing &

until [ -n "$(curl -H 'X-API-Key: 8EqKansuOM1TQPt3O3aJs-tDlMdlTpLF' --silent "http://localhost:8384/rest/system/status")" ]
do
  echo "Trying: http://localhost:8384"
  sleep 1
done

until [ -n "$(curl --silent "http://localhost:2379/v2/keys")" ]
do
  echo "Trying: http://localhost:2379"
  sleep 1
done

ID=$(curl -H "X-API-Key: 8EqKansuOM1TQPt3O3aJs-tDlMdlTpLF" http://localhost:8384/rest/system/status | jq -r .myID)
curl -L -X PUT http://localhost:2379/v2/keys/syncthing/$(hostname) -d value=$ID

confd -backend etcd -node http://localhost:2379 -interval 10
