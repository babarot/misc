#!/bin/bash

declare -i arg=0
declare -a exist_files=()
declare -a non_exist_files=()

while (( $# > 0 ))
do
	case "$1" in
		-*)
			if [[ "$1" =~ 'n' ]]; then
				#echo 'n'
				nflag='-n'
			fi
			if [[ "$1" =~ 'f' ]]; then
				#echo 'f'
				fflag='-f'
			fi
			shift
			;;
		*)
			((++arg))
			if [ -f "$1" ]; then
				exist_files=("${exist_files[@]}" "$1")
			else
				non_exist_files=("${non_exist_files[@]}" "$1")
			fi
			shift
			;;
	esac
done

#echo "$arg"
#echo "${exist_files[@]}"
#echo "${non_exist_files[@]}"
Pager='pygmentize -O style=monokai -f console256 -g'

if [ -n "$fflag" ]; then
	#\grep $nflag "" "${exist_files[@]}" /dev/null
	\grep "" "${exist_files[@]}" /dev/null | cat "$nflag"
else
	\cat "${exist_files[@]}" | $Pager | cat $nflag
fi

if [ -n "$non_exist_files" ]; then
	echo "$non_exist_files: no such file or directory" 1>&2
fi

