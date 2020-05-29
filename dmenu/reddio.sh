#!/bin/bash
#  ____ _____
# |  _ \_   _|  Derek Taylor (DistroTube)
# | | | || |    http://www.youtube.com/c/DistroTube
# | |_| || |    http://www.gitlab.com/dwt1/
# |____/ |_|
#
# script for reddio - a command line Reddit viewer.


declare -a options=("r/archlinux
r/bash
r/commandline
r/linux
r/linux4noobs
r/linuxmasterrace
r/linuxquestions
r/unixporn
r/vim
quit")

choice=$(echo -e "${options[@]}" | dmenu -matching fuzzy -l 10  -i -p 'Last 10 Posts From Reddit')

case "$choice" in
	quit)
		echo "Program terminated." && exit 1
	;;
	r/*)
		reddio print -l 15 "$choice" | sed 's/\x1b\[[0-9;]*m//g' \
			| dmenu -matching fuzzy -l 15 -i -p "$choice"
		exec $TERMINAL -e $SHELL -c "reddio print -l 10 $choice;$SHELL"
	;;
	*)
		exit 1
	;;
esac
