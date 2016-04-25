#!/bin/bash
chown -Rf $(id -u):$(id -g) /home/user
chmod -Rf $(id -u):$(id -g) /home/user
export HOME=/home/user

syncthing &

while true
do
  echo "Trying: http://localhost:8384"
  if [ -n "$(curl --silent "http://localhost:8384/rest/system/status")" ]; then
      break
  else
      sleep 1
  fi
done

ID=$(curl -H "X-API-Key: 8EqKansuOM1TQPt3O3aJs-tDlMdlTpLF" http://localhost:8384/rest/system/status | jq -r .myID)
curl -L -X PUT http://localhost:2379/v2/keys/syncthing/$(hostname) -d value=$ID

confd -backend etcd -node http://localhost:2379 -interval 10
