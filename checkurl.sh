#!/bin/bash

while read line
do
  response=$(curl -I $line  2>/dev/null | head -n 1 | cut -d$' ' -f2 )
  echo "${line}|${response}"
done < "${1:-/dev/stdin}"
