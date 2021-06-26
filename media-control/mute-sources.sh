#!/bin/bash

mute=${1}

# if no input is proved toggle
if [ -z ${mute} ]; then
  declare -i cur=$(is-mic-mute.py)
  mute=$(( $cur ^ 1)) # toggle current mute status
fi

sources=$(pacmd list-sources | grep -Pi '((?<=device.description = )".*"|(?<=index: )\d+)' | paste -s -d ' \n')
indecies=$(echo -e "${sources}" | grep -Pio '(?<=index: )\d+')

for sink_index in ${indecies}; do
  pacmd set-source-mute ${sink_index} $mute
done

if [ $mute == 0 ]; then
  echo sources activated
else
  echo sources muted
fi
