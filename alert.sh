#!/bin/bash

# tack onto a command to get notified when it's finished.
# eg sleep 10; alert.sh

notify-send "$(dateString.sh) @ $(pwd)"
