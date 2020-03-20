#!/bin/bash -xe

set -ex

window=$1
keys=$2

if [ -z "$keys" ]; then
  echo missing parameters.
  echo "call with <window_id> <keys>"
  exit 1
fi

while true; do
  for x in $(seq 1 100); do
    sleep 1
    echo x: $x
    xdotool search --name $window key --delay 300 $keys

    # xdotool key --delay 300 --window $window_id $keys
    # xdotool key --delay 300 --window $window_id Left
    # sleep 1
    # xdotool key --delay 300 --window $window_id $keys
    # xdotool key --delay 300 --window $window_id Right
    # sleep 1
    # xdotool key --delay 300 --window $window_id $keys
    # xdotool key --delay 300 --window $window_id Right
    # sleep 1
    # xdotool key --delay 300 --window $window_id $keys
    # xdotool key --delay 300 --window $window_id Left
  done
  sleep 20 
done



