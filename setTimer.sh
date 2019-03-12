#!/bin/bash

# timer, notifier

if [ ! $2 ]; then
  echo pass in seconds and msg
  exit 1
fi

seconds=$1
msg="$2 @ $(date)"

set -e

sleep $seconds
notify-send -u critical "$msg"
cowsay "$msg" || echo $msg
