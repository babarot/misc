#!/bin/bash

qfind()
{ 
	CDHIST_CDLOG=~/.cdhistlog
	IFS=$'\n';
	#array=$( awk '!colname[$1]++{print $1}' $CDHIST_CDLOG )
	#echo "${array[@]}"
	#return

	#db=$(
	#	for path in "${array[@]}"; do
	#		find "$path" -maxdepth 1 -type f -iname *$1* 2> /dev/null;
	#	done
	#)

	#shift
	db=$( awk '!colname[$1]++{print $1}' $CDHIST_CDLOG )

	for i in "$@"
	do
		db=$(echo "${db}" | \grep -i "${i}")
	done

	#echo "${db}"
	ken=(`echo "${db}"`)
	for path in "${ken[@]}"
	do
		find "$path" -type f 2>/dev/null
	done
	return

}

#qfind "$@"

function richfind()
{
	CDHIST_CDLOG=~/.cdhistlog
	IFS=$'\n';

	list=()
	db=$( awk '!colname[$1]++{print $1}' $CDHIST_CDLOG )
	
	for ((i=1; i<=$#; i++))
	do
		list+=("| \\find \"\$$i\"")
	done

	eval cat \"\$testfile\" "${list[@]}"
}

function Or_find_old()
{
	list=()
	for ((i=2; i<=$#; i++))
	do
		list+=("-or -iname \"*\$$i*\"")
	done

	eval find . -iname \"*\$1*\" "${list[@]}"
	
}

function Or_find()
{
	list=()
	for ((i=2; i<=$#; i++))
	do
		list+=("-or -iname \"*\$$i*\"")
	done

	CDHIST_CDLOG=~/.cdhistlog
	IFS=$'\n';
	db=$( awk '!colname[$1]++{print $1}' $CDHIST_CDLOG )
	ken=(`echo "${db}"`)
	for path in "${ken[@]}"
	do
		eval find "$path" -type f -iname \"*\$1*\" "${list[@]}" 2>/dev/null
	done
}
Or_find "$@"
