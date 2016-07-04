#!/bin/bash
export HOME=/home/user
mkdir -p /home/user/.config/syncthing/

until curl --silent "http://localhost:2379/v2/keys"
do
  echo "Trying: http://localhost:2379"
  sleep 1
done

curl -X PUT http://localhost:2379/v2/keys/syncthing?dir=true&prevExist=false -d ""

confd -backend etcd -node http://localhost:2379 -onetime

syncthing -gui-address=http://0.0.0.0:8384 -gui-apikey=8EqKansuOM1TQPt3O3aJs-tDlMdlTpLF &

until [ "$(curl -H 'X-API-Key: 8EqKansuOM1TQPt3O3aJs-tDlMdlTpLF' --write-out %{http_code} --silent --output /dev/null "http://localhost:8384/rest/system/status")" -eq "200" ]
do
  echo "Waiting for Syncthing API"
  sleep 1
done
touch /initialized
ID=$(curl -H "X-API-Key: 8EqKansuOM1TQPt3O3aJs-tDlMdlTpLF" http://localhost:8384/rest/system/status | jq -r .myID)
curl -L -X PUT http://localhost:2379/v2/keys/syncthing/$(hostname) -d value=$ID

confd -backend etcd -node http://localhost:2379 -interval 10
