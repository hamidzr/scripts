#!/bin/bash

set -ex

declare instructions=(
"click 1"
"mousedown 1"
"mousemove_relative 100 0"
"mousemove_relative 0 100"
"mousemove_relative -- -100 0"
"mousemove_relative -- 0 -100 "
"mouseup 1"
)

for cmd in "${instructions[@]}"; do
  # xdotool click 1
  # xdotool mousedown 1
  xdotool $cmd
  sleep 0.1
done
