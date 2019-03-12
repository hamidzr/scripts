#!/bin/bash

output=merged.txt
rm $output

refs=$(ag 'link' index.html | grep stylesheet | grep -Eo 'href="[^"]+' | cut -d '"' -f2)

echo $refs
echo merging to $output

for ref in $refs; do
  echo $ref
  if [[ $ref == http* ]]; then
    curl $ref >> $output
  else
    cat $ref >> $output
  fi
done
