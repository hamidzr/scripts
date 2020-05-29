#!/usr/bin/env bash

# dmenu theming
lines="-l 20"
font="-fn Inconsolata-13"
colors="-nb #2C323E -nf #9899a0 -sb #BF616A -sf #2C323E"

selected="$(ps -a -u $USER | \
            dmenu -i -p "Type to search and select process to kill" \
            $lines $colors $font | \
            awk '{print $1" "$4}')"; 

if [[ ! -z $selected ]]; then

    answer="$(echo -e "No\nYes\nkillall\nRestart" | \
            dmenu -i -p "$selected will be killed, are you sure?" \
            $lines $colors $font )"

    if [[ $answer == "Yes" ]]; then
        selpid="$(awk '{print $1}' <<< $selected)"
        kill -9 $selpid
    fi
    case "$answer" in
     Yes)
       selpid="$(awk '{print $1}' <<< $selected)"
       kill -SIGTERM $selpid
     ;;
     killall)
       selname="$(awk '{print $2}' <<< $selected)"
       killall -SIGTERM $selname
     ;;
     Restart)
       selpid="$(awk '{print $1}' <<< $selected)"
       selname="$(awk '{print $2}' <<< $selected)"
       killall -SIGTERM $selname
       $selname &
       disown
     ;;
     *)
      exit 1
     ;;
    esac
fi

exit 0
