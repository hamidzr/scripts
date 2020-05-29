#!/bin/bash

# script for setting screen layouts

dir="$HOME/.screenlayout/"

cd $dir
layout=$(ls | dmenu -matching fuzzy -p "Screenlayout?") || exit

bash $layout
