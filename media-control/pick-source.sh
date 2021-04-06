#!/bin/zsh

source_id=$1

if [[ -z $source_id ]]; then
  sources=$(pacmd list-sources | grep -Pi '((?<=device.description = )".*"|(?<=index: )\d+)' | paste -s -d ' \n' | grep -v "Monitor of")
  default_source=$(echo ${sources} | grep '*' | grep -Pio '((?<=device.description = )".*"|(?<=index: )\d+)' | paste -s -d ' \n')
  other_sources=$(echo ${sources} | grep -v '*' | grep -Pio '((?<=device.description = )".*"|(?<=index: )\d+)' | paste -s -d ' \n')
  selected=$(echo -e "${default_source}\n${other_sources}" | dmenu -p 'Pick a source/input/mic' -i)
  source_id=$(awk '{print $1}' <<< $selected)
fi

if [[ -z $source_id ]]; then
  >&2 echo "no source selected"
  exit 1
fi

echo $source_id
