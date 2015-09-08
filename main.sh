#!/bin/bash

sort_without_uniq() {
    :
}


cd() {
    local target
    for target in "$@"
    do
        if [[ -d "$target" ]]; then
            builtin cd "$target"
        else
            if [[ -d .git ]] && git branch | cut -c3- | grep -xq "$target"; then
                git checkout "$target"
            fi
        fi
    done
}



