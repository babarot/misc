#!/bin/bash

tmp=($(awk '!colname[$0]++' ~/Dropbox/zsh_cdhist))
for i in $(awk '!colname[$0]++' ~/Dropbox/zsh_cdhist)
do
    if [ ! -d "$i" ]; then
        non_exist_directory+=($i)
    fi
done

tmp2=$(cat ~/zsh_cdhist)
for i in "${non_exist_directory[@]}"
do
    echo $i
    #tmp2=$(echo "${tmp2}" | \grep -xv "${i}")
done
#echo "${tmp2}"
