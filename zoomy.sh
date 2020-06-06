#!/bin/bash

conf_num=$(echo "${1}" | grep zoom.us | grep -ioP '(?<=/j/)\d+')

set -e
# [[ -z $conf_num ]] && exit 1

xdg-open "zoommtg://zoom.us/join?action=join&confno=$conf_num"
