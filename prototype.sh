#!/bin/sh

DOTFILES=~/Dropbox/etc/dotfiles
i=1
a=$(echo $DOTFILES/etc/init/*.sh $DOTFILES/etc/init/osx/*.sh)
b=$(echo "$a" | tr ' ' '\n' | wc -l | tr -d ' ')
for file in $a
do
    echo "[$i/$b] $(basename "$file"): running..."
    echo "$file"
    i=$((i+1))
done
