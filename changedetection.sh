#!/bin/bash

# monitor.sh - Monitors a web page for changes
# sends an email notification if the file change

URL=$1

for (( ; ; )); do
    mv new.html old.html 2> /dev/null
    curl $URL -L --compressed -s | tail -n +30 > new.html
    DIFF_OUTPUT="$(diff new.html old.html)"
    if [ "0" != "${#DIFF_OUTPUT}" ]; then
        echo "$DIFF_OUTPUT"
        echo "Sefaratt changed visit: $URL  $DIFF_OUTPUT" | mail -s "Change Detected" secret@gmail.com
        sleep 1800
    fi
done
