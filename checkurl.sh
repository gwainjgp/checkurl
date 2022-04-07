#!/bin/bash

while read line
do
  # Stop if asterisk not as first char
  if [[ $line =~ \* ]] && [[ ! $line =~ ^\*\. ]]; then
    echo "${line}| ERROR not URL"
    continue
  fi
  original=$line
  # Check por first . or * and chop it
  # Detect if is a full URL
  if [[ $line =~ ^\w+:// ]]; then
    # Full URL
    echo "${original}| Full URL"

  else
    # Other things
    # Check domains
    if [[ $line =~ ^\. ]]; then
      line="${line:1}"
    fi
    if [[ $line =~ ^\*\. ]]; then
      line="${line:2}"
    fi
    # Check URL
    response=$(curl -s -o /dev/null -I -w "%{http_code}" $line )
    if [ -z "$response" ]; then
      echo "${original}|NOT host"
    else
      echo "${original}|${response}"
    fi
  fi
done < "${1:-/dev/stdin}"
