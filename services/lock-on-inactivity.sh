#!/bin/bash

# lock the system after some inactivity

notificationMsg="about to lock the screen"
inactivityTime=3 # minutes

# add -detectsleep to account for suspended state

exec xautolock
  -time $inactivityTime -locker "slock" \
  -notify 30 \
  -notifier "notify-send -u critical -t 10000 -- $notificationMsg"
