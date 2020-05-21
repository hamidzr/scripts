#!/bin/bash

# input <url> <grep expression>
# keeps checking the websites and notifies

interval=5
url=$1
expect=$2
timeout=2

echo testing the notificatoin method. You should receive a notification now
notify-send -u critical 'Testing notification method'

while [[ 1 ]]; do
  sleep $interval
  echo checking..`date`
  curl --connect-timeout $timeout -s $url | grep -i $2 > /dev/null || notify-send -u critical "$url down"
done

# watch -n $interval -d $url
