#!/bin/sh

# open a directory in your terminal emulator
# $TERMINAL -e "cd ${dir} && zsh"

# a more widely supported way of opening various terminals in a target dir
$TERMINAL -e "sh -c 'cd $1 && $SHELL'"
