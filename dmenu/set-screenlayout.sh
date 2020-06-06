#!/bin/bash

# script for setting screen layouts

dir="$HOME/.screenlayout/"
cd $dir

# FIXME..
declare -a options="auto\n"
layouts=$(ls *.sh |xargs -n1 echo)
options+=$layouts

choice=$(echo -e "${options[@]}" | dmenu -matching fuzzy -p "Screenlayout?") || exit

case "$choice" in
	auto)
		xrandr --auto
	;;
	*)
    bash $choice
	;;
esac
