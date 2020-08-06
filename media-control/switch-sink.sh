#!/bin/zsh

sink_id=$1

if [[ -z $sink_id ]]; then
  sinks=$(pacmd list-sinks | grep -Pi '((?<=device.description = )".*"|(?<=index: )\d+)' | paste -s -d ' \n')
  default_sink=$(echo ${sinks} | grep '*' | grep -Pio '((?<=device.description = )".*"|(?<=index: )\d+)' | paste -s -d ' \n')
  other_sinks=$(echo ${sinks} | grep -v '*' | grep -Pio '((?<=device.description = )".*"|(?<=index: )\d+)' | paste -s -d ' \n')
  selected=$(echo -e "${default_sink}\n${other_sinks}" | dmenu -p 'Pick a sink/output/speaker' -i)
  sink_id=$(awk '{print $1}' <<< $selected)
fi

if [[ -z $sink_id ]]; then
  echo no sink selected. exiting.
  exit 0
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
