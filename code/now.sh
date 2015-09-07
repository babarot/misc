#!/bin/bash
# File: now.sh
# Data: 2014-01-07

FILE=$HOME/.bash_myhistory

#tail "$FILE" | awk '{for(i=7; i<NF; i++) {printf("%s%s", $i, OFS=" ")} print $NF}'

tmp=$( tail -1 $FILE | awk '{for(i=7; i<NF; i++) {printf("%s%s", $i, OFS=" ")} print $NF}' )

echo -e "Do?> \033[31m$tmp\033[m"
read ANS

if [ "$ANS" = "y" -o "$ANS" = "Y" ]; then
	eval "$tmp"
fi
