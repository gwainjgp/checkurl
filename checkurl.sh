#!/bin/bash

while read line
do
  host=$(echo $line | cut -f1 -d/)
  host $host > /dev/null 2>&1
  result=$?
  if [ "$result" -eq "0" ]; then
    response=$(curl -I $line  2>/dev/null | head -n 1 | cut -d$' ' -f2 )
    echo "${line}|${response}"
  else
    echo "${line}|ERROR DNS"
  fi
done < "${1:-/dev/stdin}"
