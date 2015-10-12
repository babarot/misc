#!/bin/bash

trap "final; exit 1" 2

function final {
  echo "Ctrl+C pushed."
  rm -f /tmp/interrupt.tmp
}

touch /tmp/interrupt.tmp

while :
do
  sleep 1
done
