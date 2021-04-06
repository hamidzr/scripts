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
  >&2 echo no sink selected.
  exit 1
fi

echo $sink_id
