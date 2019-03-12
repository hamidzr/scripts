#!/bin/bash

# edit below to configure the monitors
# keeps checking the websites and notifies

interval=5
timeout=2 # secs

checkUrl () {
  url=$1
  expect=$2
  curl -s -connect-timeout $timeout $url | grep -i $expect > /dev/null || notify-send -u critical "$url down $(date)"
}

echo testing the notification method. You should receive a notification now
notify-send -u critical 'Testing notification method'

while [[ 1 ]]; do

  echo checking..`date`

  # configure websites here
  checkUrl https://editor.netsblox.org SERVER_URL
  checkUrl https://dev.netsblox.org SERVER_URL
  checkUrl https://netsblox.org html

  sleep $interval

done
