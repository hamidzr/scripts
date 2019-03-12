#!/bin/bash

mkdir $HOME/.git
cd $HOME/.git
ln -s $HOME/dotfiles/git-templates/hooks hooks

git config --global core.hooksPath /path/to/my/centralized/hooks
