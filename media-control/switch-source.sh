#!/bin/bash

source_id=$1

if [[ -z $source_id ]]; then
  sources=$(pacmd list-sources | grep -Pio '((?<=device.description = )".*"|(?<=index: )\d+)' | paste -s -d ' \n' | grep -v "Monitor of")
  selected=$(echo "${sources}" | dmenu -p 'Pick a source/input/mic' -i)
  source_id=$(awk '{print $1}' <<< $selected)
fi

if [[ -z $source_id ]]; then
  echo no source selected. exiting.
  exit 0
fi


# active recording streams
active_streams=$(pacmd list-source-outputs | grep -Pio '(?<=index: )\d+')

# update the active stream
if [[ ! -z "$active_streams" ]]; then
  while IFS= read -r stream_index ; do
    echo pacmd move-source-input $stream_index $source_id
    pacmd move-source-output $stream_index $source_id
  done <<< "${active_streams}"
fi


# change the default
echo pacmd set-default-source $source_id
pacmd set-default-source $source_id
