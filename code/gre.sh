#!/bin/bash

narrowing()
{
    # Option parser
    if [ -p /dev/stdin ]; then
        local target='-'
    else
        if [ "$#" -ge 2 ]; then
            # if last arguments is exists
            if [ -f "${!#}" ]; then
                local target="${!#}"
            else
                echo "${!#}: no such file or directory" 1>&2
                return 1
            fi
        else
            echo 'too few arguments' 1>&2
            return 1
        fi
    fi

    # Main
    local target_sorted=$(cat "$target" | awk '!colname[$0]++{print $0}')
    for i in "${@:1:$#-1}"
    do
        local target_sorted=$(echo "${target_sorted}" | \grep -i "${i}")
    done

    echo "${target_sorted}"
}

narrowing ${@+"$@"}
