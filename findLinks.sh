#!/bin/bash

base_url=$1
hostname=$(echo $base_url | cut -d'/' -f1-3)

# curl $1 | grep -Eo 'http.?://[^"]+' # misses relative links href="/asdf"

links=$(curl $base_url | grep -Eo 'href="[^"]+' | sed 's/href="//')

# TODO attach host address to relative links


for link in $links; do
  # detect if it's a relative link
  if [[ $link == http* ]]
  then
    echo $link
  else
    # prepend hostname
    echo $hostname/$link
  fi
done
