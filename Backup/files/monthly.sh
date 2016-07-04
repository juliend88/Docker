#!/bin/bash
src=/mnt
dest="swift://$1"

duplicity --allow-source-mismatch --no-encryption --verbosity notice \
          --full-if-older-than 3M \
          --num-retries 3 \
          --asynchronous-upload \
         "${src}" "${dest}"
