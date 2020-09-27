#!/bin/bash

# script for opening common directories in terminal

declare options=("awesome
dmenu
dotfiles
config
notes
scripts")

choice=$(echo -e "${options[@]}" | dmenu -matching fuzzy -i -p 'Open shell in directory')

case "$choice" in
  awesome)
  dir="$DOTFILES_DIR/awesome"
 ;;
  dmenu)
  dir="$DOTFILES_DIR/dmenu"
 ;;
  dotfiles)
  dir="$DOTFILES_DIR"
 ;;
  config)
  dir="$DOTFILES_DIR/home/.config"
 ;;
  notes)
  dir="$HOME/notes"
 ;;
  scripts)
  dir="$HOME/scripts"
 ;;
 *)
  exit 1
 ;;
esac
# $TERMINAL -e "cd ${dir} && zsh"
run-in-term.sh "cd ${dir} && zsh"
