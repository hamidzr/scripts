#!/bin/zsh

sink_id=$(pick-sink.sh $@)
if [ -z $sink_id ]; then
  exit 1
fi


# change the default
echo pacmd set-default-sink $sink_id
pacmd set-default-sink $sink_id

# active playback streams
playback_streams=$(pacmd list-sink-inputs | grep -Pio '(?<=index: )\d+')

# update the active stream
if [[ ! -z "$playback_streams" ]]; then
  while IFS= read -r stream_index ; do
    echo pacmd move-sink-input $stream_index $sink_id
    pacmd move-sink-input $stream_index $sink_id
  done <<< "${playback_streams}"
fi
