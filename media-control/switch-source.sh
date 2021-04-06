#!/bin/zsh

source_id=$(pick-source.sh $@)
if [ -z $source_id ]; then
  exit 1
fi

# change the default
echo pacmd set-default-source $source_id
pacmd set-default-source $source_id

pactl set-source-volume @DEFAULT_SOURCE@ 100%

# active recording streams
active_streams=$(pacmd list-source-outputs | grep -Pio '(?<=index: )\d+')

# update the active stream
if [[ ! -z "$active_streams" ]]; then
  while IFS= read -r stream_index ; do
    echo pacmd move-source-input $stream_index $source_id
    pacmd move-source-output $stream_index $source_id
  done <<< "${active_streams}"
fi
