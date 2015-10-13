#!/bin/bash

path='/Users/b4b4r07/dotfiles/bin'
path=$1

for ((i=1; i<${#path}+1; i++))
do
    if [[ ${path:0:i+1} =~ /$ ]]; then
        echo ${path:0:i}
    fi
    if [[ $i = ${#path} ]]; then
        echo ${path:0:i}
    fi
done
