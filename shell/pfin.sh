#!/bin/bash

narrow()
{
    targetfile="$HOME/zsh_cdhist"
    if [ ! -f "${targetfile}" ]; then
        echo 'no file'
        return 0
    fi

    narrowing_down=$(cat "${targetfile}" | awk '!colname[$0]++{print $0}')
    #narrowing_down=$(cat "${targetfile}")

    for i in "$@"
    do
        narrowing_down=$(echo "${narrowing_down}" | \grep "/${i}")
    done

    echo "${narrowing_down}"
}

narrow "$@"
