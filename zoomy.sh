#!/bin/bash

# link samples
# https://applications.zoom.us/event/callback/slack/96111111113?startUrl=alsdjfls-asdl-alsjdf
# https://zoom.us/j/95676333687?pwd%3DbWsadfcHNoQ0Rpd1lJRHNyOGNFNXByQT09&sa=D&source=calendar&ust=1606671225861000&usg=AOvVaw3APw0_fLqBf9FChNWdSk5n

# conf_num=$(echo "${1}" | grep zoom.us | grep -ioP '(?<=/j/)\d+')
conf_num=$(echo "${1}" | grep zoom.us | grep -ioP '\d{10,11}')

[[ -z $conf_num ]] && exit 1

params=$(echo "${1}" | grep -o '\?.*$' | cut -c 2-)

[ -f $HOME/.zshrc ] && source $HOME/.zshrc

command -v notify-send >/dev/null && notify-send "Joining zoom meeting: $conf_num"

xdg_link="zoommtg://zoom.us/join?action=join&confno=${conf_num}&${params}"

xdg-open $xdg_link
