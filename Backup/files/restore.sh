#!/bin/bash
src="swift://$1"
dest=/mnt/restore/
time=$2

rm -Rf $dest/* $dest/.*
duplicity restore --allow-source-mismatch \
                  --no-encryption \
                  --verbosity notice \
                  --time ${time} \
                  "${src}" "${dest}"
