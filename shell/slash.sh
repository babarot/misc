#!/bin/bash
    target=$PWD
    for ((i=1; i<${#target}+1; i++))
    do
        if [[ ${target:0:$i+1} =~ /$ ]]; then
            echo ${target:0:$i}
        fi
    done
