#!/bin/bash

glob2regexp() {
    glob="$1"
    if [[ -z $glob ]]; then
        return 1
    fi

    printf "^"
    for ((i=0; i<${#glob}; i++)); do
        char="${glob:$i:1}"
        case $char in
            \*)
                printf '.*'
                ;;
            .)
                printf '\.'
                ;;
            {)
                printf '('
                ;;
            })
                printf ')'
                ;;
            ,)
                printf '|'
                ;;
            \\)
                printf '\\\\'
                ;;
            *)
                printf "$char"
                ;;
        esac
    done
    printf "$\n"
}
