#!/bin/bash

# lock and suspend (if on battery) the system after some inactivity

notificationMsg="about to lock the screen"
lockInactivityTime=3 # minutes
killInactivityTime=5 # minutes

# add -detectsleep to account for suspended state

exec xautolock
  -time $lockInactivityTime \
  -locker "slock" \
  -notify 30 \
  -notifier "notify-send -u critical -t 10000 -- $notificationMsg"
  -killtime $killInactivityTime 
  -killer "notify-send 'suspended the system due to inactivity'; systemctl suspend"
