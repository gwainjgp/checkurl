#!/bin/bash

#Functions
checkWithCurl(){
  response=$(curl -s -o /dev/null -I -w "%{http_code}" $1 )
  if [ -z "$response" ]; then
     echo "NOT host"
  else
    echo $response
  fi
}

while read line
do
  # Stop if asterisk not as first char
  if [[ $line =~ \* ]] && [[ ! $line =~ ^\*\. ]]; then
    echo "${line}| Asterisk in middle| ERROR"
    continue
  fi
  original=$line
  # Check por first . or * and chop it
  # Detect if is a full URL
  if [[ $line =~ [[:alnum:]]+:// ]]; then
    # Full URL
    response=$(checkWithCurl "$line"  )
    echo "${original}| Full URL| ${response}"
  else
    # Other things
    # Check partial domains
    if [[ $line =~ ^\. ]]; then
      line="${line:1}"
    fi
    if [[ $line =~ ^\*\. ]]; then
      line="${line:2}"
    fi
    # Check if only domain
    if [[ $line =~ \/ ]]; then
      # Check URL
      response=$(checkWithCurl "$line"  )
      if [[ $response -eq "200" ]]; then
        echo "${original}| Partial URL| ${response}"
      else
        response=$(checkWithCurl "https://${line}"  )
        echo "${original}| Partial URL (https)| ${response}"
      fi
    else
      # Check Domain or hostname
      response=$(checkWithCurl "$line"  )
      echo "${original}| Hostname| ${response}"
   fi
  fi
done < "${1:-/dev/stdin}"
