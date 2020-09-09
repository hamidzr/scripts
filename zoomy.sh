#!/bin/bash

# link samples
# https://applications.zoom.us/event/callback/slack/96111111113?startUrl=alsdjfls-asdl-alsjdf

# conf_num=$(echo "${1}" | grep zoom.us | grep -ioP '(?<=/j/)\d+')
conf_num=$(echo "${1}" | grep zoom.us | grep -ioP '\d{10,11}')

[[ -z $conf_num ]] && exit 1

[ -f $HOME/.zshrc ] && source $HOME/.zshrc

command -v notify-send >/dev/null && notify-send "Joining zoom meeting: $conf_num"
xdg-open "zoommtg://zoom.us/join?action=join&confno=$conf_num"
