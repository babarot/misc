#!/bin/bash

mat_current() {
    local target
    for target in "$@"
    do
        ### perfect matching
        if [[ -d "$target" ]]; then
            echo "$target"
        else
            ### partial matching
            local list i
            list=( $(ls -1) )
            for i in "${list[@]}"
            do
                if echo "$i" | grep -q "^$target"; then
                    echo -e "${PWD/$HOME/~}"/"\033[31m${i}\033[m"
                fi
            done
        fi
    done
}

mat() {
    mat_current "$@"
    #mat_branch  "$@"
    #mat_other   "$@"
}

mat "$@"
