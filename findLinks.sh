#!/bin/bash

base_url=$1
hostname=$(echo $base_url | grep 'http.*\/' -o | sed 's/\/$//')

# curl $1 | grep -Eo 'http.?://[^"]+' # misses relative links href="/asdf"

links=$(curl -s --compressed $base_url | grep -Eo 'href="[^"]+' | sed 's/href="//')



for link in $links; do
  # detect if it's a relative link
  if [[ $link == http* ]]
  then
    echo $link
  else
    # TODO check and avoid double //
    # prepend hostname
    echo $hostname/$link
  fi
done
