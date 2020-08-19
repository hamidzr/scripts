#!/bin/zsh

# active recording streams
active_streams=$(pacmd list-source-outputs | grep -Pio '(?<=index: )\d+')

# update the active stream
if [[ ! -z "$active_streams" ]]; then
  while IFS= read -r stream_index ; do
    pacmd move-source-output $stream_index @DEFAULT_SOURCE@
  done <<< "${active_streams}"
fi

# active recording streams
active_streams=$(pacmd list-sink-inputs | grep -Pio '(?<=index: )\d+')

# update the active stream
if [[ ! -z "$active_streams" ]]; then
  while IFS= read -r stream_index ; do
    pacmd move-sink-input $stream_index @DEFAULT_SINK@
  done <<< "${active_streams}"
fi
