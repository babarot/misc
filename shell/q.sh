#!/bin/bash

declare -i Q_MAX=5
#declare -i Q_NUM=0
#declare -i Q_FRONT=0
#declare -i Q_REAR=0
declare -i Q_NUM=Q_FRONT=Q_REAR=0

enqueue() {
	if [ $Q_NUM -ge $Q_MAX ]; then
		echo "job is full"
		return -1
	else
		let Q_NUM++
		Q[$((Q_REAR++))]="$1"
		if [ $Q_REAR -eq $Q_MAX ]; then
			Q_REAR=0
		fi
		return 0
	fi
	echo ${Q[@]}
}

dequeue() {
	if [ $Q_NUM -le 0 ]; then
		echo "job is empty"
		return -1
	else
		let Q_NUM--
		echo ${Q[$((Q_FRONT++))]}
		if [ $Q_FRONT -eq $Q_MAX ]; then
			Q_FRONT=0
		fi
		return 0
	fi
	echo ${Q[@]}
}

peek() {
	echo ${Q[@]}
}
