#!/bin/bash
if [ -f "/initialized" ]
then
    until [ -n "$(curl -H 'X-API-Key: 8EqKansuOM1TQPt3O3aJs-tDlMdlTpLF' --silent "http://localhost:8384/rest/system/status")" ]
    do
      echo "Trying: http://localhost:8384"
      sleep 1
    done
    /usr/bin/curl -X POST -H 'X-API-Key: 8EqKansuOM1TQPt3O3aJs-tDlMdlTpLF' http://localhost:8384/rest/system/restart
fi
