#!/bin/bash
#  ____ _____ 
# |  _ \_   _|  Derek Taylor (DistroTube)
# | | | || |    http://www.youtube.com/c/DistroTube
# | |_| || |    http://www.gitlab.com/dwt1/ 
# |____/ |_| 
#
# script for launching surfaw, a command line search utility.

cmd="dmenu -i"

while [ -z "$engine" ]; do
  engine=$(sr -elvi | gawk '{if (NR!=1) { print $1 }}' | $cmd -p "Select a search engine?") || exit
done

while [ -z "$query" ]; do
  query=$(echo "" | $cmd -p "Searching $engine") || exit
done

$TERMINAL -e sr "$engine" "$query"
