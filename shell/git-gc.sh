#!/bin/bash

find ${GOPATH%%:*}/src/github.com \
    -follow \
    -maxdepth 2 \
    -mindepth 2 \
    -type d | while read repo; do
builtin cd "$repo"
git gc &
done
wait
