#!/bin/sh

TERMINAL=${TERMINAL:-termite}
# run in terminal
# $TERMINAL -e "sh -c '${@}'"
$TERMINAL -e "sh -c 'sleep 0.050; ${1}'"
# $TERMINAL -e "sh -c '${1}'"
# $TERMINAL -e "/bin/bash -c '${1}'"

# open a directory in your terminal emulator
# $TERMINAL -e "cd ${dir} && zsh"

# a more widely supported way of opening various terminals in a target dir
# $TERMINAL -e "sh -c 'cd $1 && $SHELL'"

