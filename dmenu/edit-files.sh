#!/bin/bash

# script for editing common files

declare options=("notes-today
work-today
scratchpad
aliases
awesome
neovim
package-list
surf
variables
vifm
vim
vim
vscode
shortcuts
xresources
zsh")

choice=$(echo -e "${options[@]}" | dmenu -matching fuzzy -i -p 'Edit file')

case "$choice" in
 notes-today)
   config_path="$HOME/notes/today.md"
 ;;
 work-today)
   config_path="$HOME/notes/da/work-today.md"
 ;;
 scratchpad)
   config_path="$HOME/notes/scratchpad.md"
 ;;
 aliases)
   config_path="$DOTFILES_DIR/aliases.sh"
 ;;
 awesome)
   config_path="$HOME/.config/awesome/rc.lua"
 ;;
 bash)
   config_path="$HOME/.bashrc"
 ;;
 neovim)
   config_path="$HOME/.config/nvim/"
 ;;
 package-list)
   config_path="$DOTFILES_DIR/package-lists/$(hostname).list"
 ;;
 surf)
   config_path="$HOME/surf-distrotube/config.h"
 ;;
 variables)
   config_path="$DOTFILES_DIR/variables.sh"
 ;;
 vifm)
   config_path="$HOME/.config/vifm/vifmrc"
 ;;
 vim)
   config_path="$HOME/.vimrc"
 ;;
 vimb)
   config_path="$XDG_CONFIG_HOME/vimb/config"
 ;;
 xresources)
   config_path="$HOME/.Xresources"
 ;;
 shortcuts)
   config_path="$XDG_CONFIG_HOME/sxhkd/sxhkdrc"
 ;;
 vscode)
   config_path="$XDG_CONFIG_HOME/Code\ -\ OSS"
 ;;
 zsh)
   config_path="$HOME/.zshrc"
 ;;
 *)
  exit 1
 ;;
esac
run-in-term.sh "sleep 0.100; eval $(resize); $EDITOR ${config_path}"
