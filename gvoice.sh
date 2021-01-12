#!/bin/bash -x

country_code=1

# input is expected without country code

if [ -z "$1" ]; then
    input=$(xsel -p) # or -b
else
    input="${@}"
fi

tel=$(echo $input | sed -e 's/-//g' -e 's/ //g' -e 's/(//g' -e 's/)//g' -e 's/\.//g' | grep -o '\([0-9]\{3\}\-[0-9]\{3\}\-[0-9]\{4\}\)\|\(([0-9]\{3\})[0-9]\{3\}\-[0-9]\{4\}\)\|\([0-9]\{10\}\)\|\([0-9]\{3\}\s[0-9]\{3\}\s[0-9]\{4\}\)')

if [ -z "$tel" ]; then
    notify-send "no phone number found"
    exit 1
fi

url=https://voice.google.com/u/0/calls?a=nc,%2B${country_code}${tel}

# echo $tell

xdg-open $url
