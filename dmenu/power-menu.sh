#!/bin/bash

# script for controlling the os? power menu!

declare options=("kill-wm
lock
reboot
shutdown
suspend")

confirm_suffix="? are you sure?"

choice=$(echo -e "${options[@]}" | dmenu -matching fuzzy -i -p 'How can I help?')

case "$choice" in
 kill-wm)
   prompt "$choice $confirm_suffix" && killall awesome
 ;;
 lock)
   slock
 ;;
 reboot)
   prompt "$choice $confirm_suffix" && reboot
 ;;
 shutdown)
   prompt "$choice $confirm_suffix" && shutdown now
 ;;
 suspend)
   prompt "$choice $confirm_suffix" && systemctl suspend
 ;;
 *)
  exit 1
 ;;
esac
