#!/bin/bash

sink_id=$1

if [[ -z $sink_id ]]; then
  sinks=$(pacmd list-sinks | grep -Pio '((?<=device.description = )".*"|(?<=index: )\d+)' | paste -s -d ' \n')
  selected=$(echo "${sinks}" | dmenu -i)
  sink_id=$(awk '{print $1}' <<< $selected)
fi

# active playback streams
playback_streams=$(pacmd list-sink-inputs | grep -Pio '(?<=index: )\d+')

# update the active stream
if [[ ! -z "$playback_streams" ]]; then
  while IFS= read -r stream_index ; do
    echo pacmd move-sink-input $stream_index $sink_id
    pacmd move-sink-input $stream_index $sink_id
  done <<< "${playback_streams}"
fi

# change the default
echo pacmd set-default-sink $sink_id
pacmd set-default-sink $sink_id
