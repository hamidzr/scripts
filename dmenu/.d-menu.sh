#!/bin/bash

# dmenu for dmenu menus

cd $SCRIPTS_DIR/dmenu

choice=$(ls | dmenu -matching fuzzy -p 'What menu?')

[ ! -z "${choice}" ] && bash ${choice}
