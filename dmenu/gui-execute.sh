#!/bin/bash

# gui to execute executables in the scripts directory
cd $SCRIPTS_DIR
script=$(fd --type x . | dmenu -i -p 'What do you wanna execute?')

[[ -z $script ]] && exit 1

./${script}
