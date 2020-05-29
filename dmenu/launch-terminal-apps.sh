#!/bin/bash

# script for running spawning terminal software

declare options=("alsamixer
glances
htop
pianobar
ranger
vifm")

choice=$(echo -e "${options[@]}" | dmenu -matching fuzzy -i -p 'Launch terminall app')

# case "$choice" in
#  alsamixer)
#    cmd=$choice
#  ;;
#  *)
#   exit 1
#  ;;
# esac

$TERMINAL -e ${choice}
