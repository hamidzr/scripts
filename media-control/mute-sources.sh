#!/bin/bash -x

mute=${1}

# if no input is proved toggle
if [ -z ${mute} ]; then
  declare -i cur=$(is-mic-mute.py)
  mute=$(( $cur ^ 1)) # toggle current mute status
  echo $(is-mic-mute.py)
fi

sources=$(pacmd list-sources | grep -Pi '((?<=device.description = )".*"|(?<=index: )\d+)' | paste -s -d ' \n')
indecies=$(echo -e "${sources}" | grep -Pio '(?<=index: )\d+')

for sink_index in ${indecies}; do
  echo $sink_index
  pacmd set-source-mute ${sink_index} $mute
done
