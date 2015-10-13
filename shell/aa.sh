#!/bin/bash

search() {
    if [ -z "$1" ]; then exit 1; fi

    if [ -n "$PATH" ]; then
        old_PATH="$PATH:"
        while [ -n "$old_PATH" ]; do
            x=${old_PATH%%:*}
            old_PATH=${old_PATH#*:}
            if [ -x "$x/$1" ]; then
                echo "$x/$1"
                exit 0
            else
                continue
            fi
        done

        exit 1
    else
        exit 1
    fi
}

# empty returns true if $1 is empty value
empty() {
    [ -z "$1" ]
}

# has returns true if $1 exists in the PATH environment variable
has() {
    if empty "$1"; then
        return 1
    fi

    type "$1" >/dev/null 2>/dev/null
    return $?
}

#available() {
#    if [ -n "$ENHANCD_FILTER" ]; then
#        old_PATH="$ENHANCD_FILTER:"
#        while [ -n "$old_PATH" ]; do
#            x=${old_PATH%%:*}
#            old_PATH=${old_PATH#*:}
#            if has "$x"; then
#                echo "$x"
#                exit 0
#            else
#                continue
#            fi
#        done
#
#        exit 1
#    else
#        exit 1
#    fi
#}

ENHANCD_FILTER="/usr/local/bin/peco:fzf"

available() {
    local x candidates

    # candidates should be list like "a:b:c" concatenated by a colon
    candidates="$1:"

    while [ -n "$candidates" ]; do
        # the first remaining entry
        x=${candidates%%:*}
        # reset candidates
        candidates=${candidates#*:}

        # check if x is available
        if has "$x"; then
            echo "$x"
            return 0
        else
            continue
        fi
    done

    return 1
}

available $ENHANCD_FILTER
