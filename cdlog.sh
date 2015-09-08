#!/bin/bash

file=~/zsh_cdhist
declare -a cdlog_array

function cdlog_view()
{
    if [ "$ZSH_NAME" = "zsh" ];then
        setopt localoptions ksharrays
    fi
    OLDIFS=$IFS; IFS=$'\n'

    local -a mylist
    local -a list
    mylist=( $( cat $file ) )
    list=()
    local -a temp
    local -i i count

    temp=()
    count=0
    # I want to do 'sort $CDHIST_CDLOG | uniq | tail 10'
    # However, if I do that, the order of the lasted log file is messed up.
    # The following for-loop execute "uniq" disposal without "sort".


    for ((i=${#mylist[*]}-1; i>=0; i--)); do
        if ! echo "${temp[*]}" | grep -x "${mylist[i]}" >/dev/null; then
            temp[$count]="${mylist[i]}"
            #CDHIST_CDQ[$count]="${mylist[i]}"
            let count++
            #echo "${mylist[i]}"
            [ $count -eq 10 ] && break
        fi
    done
    j=0
    for ((i=${#temp[*]}-1; i>=0; i--))
    do
        cdlog_array[j]="${temp[i]}"
        echo "${temp[i]}"
        #let j++
    done


    #for name in "${temp[@]}"
    #do
    #    echo $name
    #done

    IFS=$OLDIFS
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
    echo ${cdlog_array[$((${#cdlog_array[@]}-1))]}
    #cdlog_initialize
}

function = { cdlog_view; }
function - { cdlog_pop; }
