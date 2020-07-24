#!/bin/bash -x

mute=${1:-1}

sinks=$(pacmd list-sinks | grep -Pi '((?<=device.description = )".*"|(?<=index: )\d+)' | paste -s -d ' \n')
indecies=$(echo -e "${sinks}" | grep -Pio '(?<=index: )\d+')

for sink_index in $indecies; do
  # TODO xargs
  pacmd set-sink-mute ${sink_index} $mute
done
