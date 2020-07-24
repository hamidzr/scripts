#!/bin/bash -x

mute=${1:-1}

sources=$(pacmd list-sources | grep -Pi '((?<=device.description = )".*"|(?<=index: )\d+)' | paste -s -d ' \n')
indecies=$(echo -e "${sources}" | grep -Pio '(?<=index: )\d+')

for sink_index in ${indecies}; do
  echo $sink_index
  pacmd set-source-mute ${sink_index} $mute
done
