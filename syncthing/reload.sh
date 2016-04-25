#!/usr/bin/env bash
/usr/bin/curl -X POST -H 'X-API-Key: 8EqKansuOM1TQPt3O3aJs-tDlMdlTpLF' -d @/home/user/.config/syncthing/config.json http://localhost:8384/rest/system/config
/usr/bin/curl -X POST -H 'X-API-Key: 8EqKansuOM1TQPt3O3aJs-tDlMdlTpLF' http://localhost:8384/rest/system/restart
