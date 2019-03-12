#!/bin/bash

# pass in a list of urls to dl

urlList=$1

[ -z $urlList ] && exit 1

while read url; do
    axel $url
done < $urlList
