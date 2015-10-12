#!/bin/sh

#echo "${BASH_SOURCE}"
#echo $0
#echo $_

(
if [ "$_" != "$0" ]; then
#echo $0
#echo $_
    echo ok
fi
)
#if [ -n "${BASH_SOURCE}" ]; then
#    if [ "${BASH_SOURCE}" = "$0" ]; then
#        echo ok
#    fi
#else
##    echo $_
##    echo $0
#    if [ $(basename "$_") != "$0" ]; then
#        echo OK
#    fi
#fi
