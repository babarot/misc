#!/bin/bash

if awk --version 2>&1 | grep -q "GNU Awk"; then
    # GNU Awk
    awk 'BEGIN {print "I am GNU Awk"}'
elif awk -Wv 2>&1 | grep -q "mawk"; then
    # mawk
    awk 'BEGIN {print "I am mawk"}'
else
    # nawk
    awk 'BEGIN {print "I might be nawk, might not be"}'
fi
