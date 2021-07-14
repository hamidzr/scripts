#!/bin/bash -x

country_code=1

# input is expected without country code

# phone number styles
#
# CALL 1-888-766-4233
#
#
#
#

if [ -z "$1" ]; then
    input=$(xsel -p) # or -b
else
    input="${@}"
fi

# tel=$(echo $input | sed -e 's/-//g' -e 's/ //g' -e 's/(//g' -e 's/)//g' -e 's/\.//g' | grep -o '\([0-9]\{3\}\-[0-9]\{3\}\-[0-9]\{4\}\)\|\(([0-9]\{3\})[0-9]\{3\}\-[0-9]\{4\}\)\|\([0-9]\{10\}\)\|\([0-9]\{3\}\s[0-9]\{3\}\s[0-9]\{4\}\)')
tel=$(echo $input | sed -e 's/-//g' -e 's/ //g' -e 's/(//g' -e 's/)//g' -e 's/\.//g')
tel=$(echo $tel | grep -Po '([0|\+[0-9]{1,5})?([0-9]{10})' | grep -Po '[0-9]{10}$') # remove the country code

if [ -z "$tel" ]; then
    notify-send "no phone number found"
    exit 1
else
    notify-send "calling ${tel}"
fi

url=https://voice.google.com/u/0/calls?a=nc,%2B${country_code}${tel}

xdg-open $url
