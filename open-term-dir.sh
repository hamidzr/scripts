#!/bin/sh

# a compatible way of opening various terminals in a target dir

$TERMINAL -e "sh -c 'cd $1 && $SHELL'"
