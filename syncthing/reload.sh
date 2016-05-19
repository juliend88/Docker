#!/bin/bash
if [ -f "/initialized" ]
then
    until [ "$(curl -H 'X-API-Key: 8EqKansuOM1TQPt3O3aJs-tDlMdlTpLF' --write-out %{http_code} --silent --output /dev/null "http://localhost:8384/rest/system/status")" -eq "200" ]
    do
      echo "Waiting for Syncthing API"
      sleep 1
    done
    /usr/bin/curl -X POST -H 'X-API-Key: 8EqKansuOM1TQPt3O3aJs-tDlMdlTpLF' http://localhost:8384/rest/system/restart
fi
