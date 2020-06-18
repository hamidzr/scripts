#!/bin/bash

source_id=$1

if [[ -z $source_id ]]; then
  sources=$(pacmd list-sources | grep -Pio '((?<=device.description = )".*"|(?<=index: )\d+)' | paste -s -d ' \n')
  selected=$(echo "${sources}" | dmenu -i)
  source_id=$(awk '{print $1}' <<< $selected)
fi

# active recording streams
record_streams=$(pacmd list-source-inputs | grep -Pio '(?<=index: )\d+')

# update the active stream
if [[ ! -z $record_streams ]]; then
  for stream_index in "${record_streams}"; do
    echo pacmd move-source-input $stream_index $source_id
    pacmd move-source-input $stream_index $source_id
  done
fi

# change the default
echo pacmd set-default-source $source_id
pacmd set-default-source $source_id
