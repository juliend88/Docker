#!/bin/bash
src="swift://$1"
dest=/mnt/restore/

duplicity restore --allow-source-mismatch \
                  --no-encryption \
                  --verbosity notice \
                  "${src}" "${dest}"
