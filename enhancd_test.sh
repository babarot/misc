#!/bin/bash

function mycmd()
{
    if [[ -z $1 ]]; then return 1; fi
    echo "cd $1"
}

function _mycmd()
{
    local context curcontext=$curcontext state line
    declare -A opt_args
    local ret=1

    _arguments -C \
        '--help[Show help and usage]: :->_no_arguments' \
        '(-l --list)'{-l,--list}'[Lists all directories]:dirs:->dirs' \
        '1: :_mycmd_L' \
        '*:: :->args' \
        && ret=0

    IFS=$'\n'

    case $state in
        (dirs)
            _go_to_dir && ret=0
            ;;
        (args)
            case $words[1] in
                (+)
                    _buffer_ring_reverse && ret=0
                    ;;
                (-)
                    _buffer_ring_normal && ret=0
                    ;;
                (=)
                    _buffer_ring_normal && ret=0
                    ;;
            esac
            ;;
    esac

    return ret
}

_mycmd_L()
{
    local -a head
    local -a full
    local -a _c

    head=(`enhancd_logview | sed 's|.*/||g'`)
    full=(`enhancd_logview`)

    local i
    for ((i=1; i<${#head[@]}; i++))
    do
        _c+=(
        "$head[$i]"':'"$full[$i]"
        )
    done
    _describe -t others "History" _c
}

autoload -Uz compinit
compinit
compdef _mycmd mycmd
