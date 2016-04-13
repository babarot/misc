#!/bin/bash

contents="$(
pt "$1" 2>/dev/null \
    | perl -pe 's/^(.*?):(.*?):(.*?)$/\033[32m$1\033[m:$2:[$3]/g' \
    | fzf
)"

if [[ -n $contents ]]; then
    IFS=":"
    set -- $contents
    file="$1"
    line="$2"
    vim +"$line" "$file"
fi
