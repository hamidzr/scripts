#!/bin/bash -e

exit_status=$?

prefix=$1

context="on $(git branch --show-current) - $(pwd) - $(date) "
msg="${prefix} exit(${exit_status}) [${context}]"

if [ "${exit_status}" == "0" ]; then
  notify-send -t 6000000 -u normal "${msg}"
else
  notify-send -t 6000000 -u critical "${msg}"
fi
