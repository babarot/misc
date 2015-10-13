#!/bin/bash

file=~/zsh_cdhist
declare -a cdlog_array

function cdlog_view()
{
    if [ "$ZSH_NAME" = "zsh" ];then
        setopt localoptions ksharrays
    fi
    tac <(tac $file | awk '!colname[$0]++{print $0}')
    #tac $file | awk '!colname[$0]++{print $0}'
}

function cdlog_initialize()
{
    if [ "$ZSH_NAME" = "zsh" ];then
        setopt localoptions ksharrays
    fi
    cdlog_array=( $(cdlog_view) )
}

function cdlog_pop()
{
    if [ "$ZSH_NAME" = "zsh" ];then
        setopt localoptions ksharrays
    fi
    cdlog_initialize
    echo ${cdlog_array[$((${#cdlog_array[@]}-${1:-1}))]}
}

function cdlog_push()
{
    if [ "$ZSH_NAME" = "zsh" ];then
        setopt localoptions ksharrays
    fi
    cdlog_initialize
    echo ${cdlog_array[$((${1:-1}-1))]}
}

function cd()
{
    if [ "$ZSH_NAME" = "zsh" ];then
        setopt localoptions ksharrays
    fi
    function cdp()
    {
        if [ -d "$1" ]; then
            builtin cd "$1" && return 0
        else
    filered_array=($(cdlog_view | \grep -i "/${1}$"))
    for ((i=${#filered_array[*]}-1; i>=0; i--))
    #for ((i=0; i<${#filered_array[*]}-1; i++))
    do
        if [ "$PWD" = "${filered_array[i]}" ]; then
            builtin cd "${filered_array[0]}" && return 0
        fi
        builtin cd "${filered_array[i]}" && return 0
    done
            #tmp1=( $( cdlog_view | \grep -i "/${1}$" ) )
            #for ((i=0; i<${#tmp1[*]}; i++))
            #do
            #    if [[ $PWD == ${tmp1[$((${#tmp1}-1))]} ]]; then
            #    #if [[ $PWD == ${tmp1[i]} ]]; then
            #        #builtin cd "${tmp1[$((${#tmp1}-1))]}" && return 0
            #        builtin cd "${tmp1[0]}" && return 0
            #    fi
            #    builtin cd "${tmp1[i]}" && return 0
            #done
            #return 0

            #tmp1=( $(cdlog_view) )
            #for ((i=0; i<${#tmp1[*]}; i++))
            #do
            #    if [[ $PWD == ${tmp1[i]} ]]; then
            #        continue
            #    fi
            #    if [[ "$1" == `echo ${tmp1[i]} | sed 's|.*/||g'` ]]; then
            #        builtin cd "${tmp1[i]}" && return 0
            #    fi
            #done
        fi
        return 1
    }

        [ -z "$1" ] && builtin cd $HOME && return 0
    while (( $# > 0 ))
    do
        case "$1" in
            -*)
                if [[ "$1" =~ 'l' ]]; then
                    shift
                    cdp "$1"
                    return 0
                fi
                if [[ "$1" =~ 'n' ]]; then
                    shift
                    builtin cd `cdlog_push "$@"`
                    return 0
                fi
                if [[ "$1" =~ 'p' ]]; then
                    shift
                    builtin cd `cdlog_pop "$@"`
                    return 0
                fi
                ;;
            *)
                cdp "$1" && break
                ;;
        esac
    done

}

function _cdlog_hokan()
{
    if [ "$ZSH_VERSION" ]; then
        local -a all
        all=(`cdlog_view | head`)
        all_mini=(`cdlog_view  | sed 's|.*/||g'`)

        _arguments -s -S \
            '(- *)'{-h,--help}'[show help]' \
            "-l+[history]:font:->fonts" \
            "-n[next directory]: :->next" \
            "-p[previous directory]: :->prev" \
            '*: :->list' \
            && return 0

        case $state in
            (next)
                cdlog_view | tail
                ;;
            (prev)
                _files $(cdlog_view | tail)
                ;;
            (list)
                _files -/
                _describe -t others "Hist" all_mini
                ;;
            (fonts)
                _describe -t directory "Hist" all && return 0
                ;;
        esac
        return 1
    fi
}
if [ -n "$ZSH_VERSION" ]; then
    autoload -Uz compinit
    compdef _cdlog_hokan cd
fi
