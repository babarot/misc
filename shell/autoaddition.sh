#!/bin/bash

path=$PWD

file=$(
for ((i=1; i<${#path}+1; i++))
do
    if [[ ${path:0:i+1} =~ /$ ]]; then
        echo ${path:0:i}
    fi
done
find $path -maxdepth 2 -type d | grep -v ".git"
if [ -n "$1" ]; then
    while read LINE
    do
        echo "$LINE"
    done <$1
fi
echo $path
)

echo "${file[@]}"
