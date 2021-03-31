#!/bin/bash

# get the default output (where we wanna hear the "play" part
DEFAULT_OUTPUT=$(pacmd list-sinks | grep -A1 "* index" | grep -oP "<\K[^ >]+")

# setup a temp sink to record from (set apps to route their audio to this sink)
recording_sink_name=record-n-play

pactl load-module module-combine-sink \
  sink_name=$recording_sink_name slaves=$DEFAULT_OUTPUT \
  sink_properties=device.description="Record-and-Play"

# record from the temp sink
parec --format=s16le -d ${recording_sink_name}.monitor | \
  lame -r --quiet -q 3 --lowpass 17 --abr 192 - "temp.mp3"


# https://gist.githubusercontent.com/ramast/4be3314bc73f28f55e3604497188b007/raw/7052d20e286b599860d2884a645d8a506bf3c4da/pulse-recorder.bash
