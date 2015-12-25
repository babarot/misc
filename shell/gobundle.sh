#!/bin/bash

cnt=0
cd ~/.vim/bundle &&
    for d in *; do
        if [ -d $d/.git ]; then
            echo "Updating $d"
            cd $d && git pull >/dev/null &
            # Prevent having too many subprocesses
            (( (cnt += 1) % 16 == 0 )) && wait
        fi
    done

wait
