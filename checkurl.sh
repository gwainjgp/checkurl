#!/bin/bash

while read line
do
  response=$(curl -I $line  2>/dev/null | head -n 1 | cut -d$' ' -f2 )
  result=$?
  if [ "$?" -eq "0" ]; then
    echo "${line}|${response}"
  else
    echo "${line}|ERROR ${result}"
  fi
done < "${1:-/dev/stdin}"
