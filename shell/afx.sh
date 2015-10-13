#!/bin/bash

CDHIST_CDLOG=~/zsh_cdhist
target_sorted=$(tac <(tac "$CDHIST_CDLOG" | awk '!colname[$0]++'))

for i in "$@"
do
    target_sorted=$(echo "${target_sorted}" | \grep -iE "\/\.?$i")
done
echo "${target_sorted}"

exit
for i in "${target_sorted}"
do
    ls -ld $i
done
