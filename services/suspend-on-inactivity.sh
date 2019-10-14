#!/bin/bash

# suspend the system after inactivity

notificationMsg="about to suspend the system"
inactivityTime=3 # minutes

exec xautolock
  -time $inactivityTime -locker "systemctl suspend" \
  -notify 30 \
  -notifier "notify-send -u critical -t 10000 -- $notificationMsg"
