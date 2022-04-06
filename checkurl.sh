#!/bin/bash

while read line
do
  # Check por first . or * and chop it
  if [[ $line =~ ^\. ]]; then
    line="${line:1}"
  fi
  if [[ $line =~ ^\*\. ]]; then
    line="${line:2}"
  fi
  # Stop if asterisk
  if [[ $line =~ \* ]]; then
    echo "${line}| ERROR not URL"
    continue
  fi
  # Check DNS
  host=$(echo $line | cut -f1 -d/)
  host $host > /dev/null 2>&1
  result=$?
  # Finally test URL if can be resolved
  if [ "$result" -eq "0" ]; then
    response=$(curl -I $line  2>/dev/null | head -n 1 | cut -d$' ' -f2 )
    if [ -z "$response" ]; then
      echo "${line}|NOT host"
    else
      echo "${line}|${response}"
    fi
  else
    echo "${line}|ERROR DNS"
  fi
done < "${1:-/dev/stdin}"
