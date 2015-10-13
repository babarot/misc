#!/bin/bash

a=$(
echo 'unko'
while read LINE
do
    echo "$LINE"
done <$1
)

echo "${a[@]}"
