#!/bin/bash

game_dir=world-of-warcraft
wow_dir=$PWD/wow
wow_executable=launcher_freakz-64.exe

ln -s $wow_dir "$PWD/$game_dir/drive_c/Program Files (x86)/Battle.net"
ln -s $wow_dir/$wow_executable "$wow_dir/Battle.net Launcher.exe"
