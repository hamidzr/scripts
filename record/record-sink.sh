#!/bin/zsh

sink_id=$(pick-sink.sh $@)

outdir=${HOME}/tmp/recording
mkdir -p ${outdir}
outfile="${outdir}/sink-$(dateString.sh).mp3"

if [ -z $sink_id ]; then
  exit 1
fi

cleanup(){
    if [ -z "$module_id" ]
    then
        exit 3
    fi
    # set the output for everything back to target sink_id
    # switch-sink.sh $sink_id
    # unload the module we added.
    pactl unload-module $module_id
    exit 0
}

# call cleanup function on these signals
trap "cleanup" SIGINT SIGTERM

# setup a temp sink to record from (set apps to route their audio to this sink)
recording_sink_name=record-n-play

module_id=$(pactl load-module module-combine-sink \
  sink_name=$recording_sink_name slaves=$sink_id \
  sink_properties=device.description="Record-and-Play")

echo "point the target playback stream to sink '${recording_sink_name}'"
# record from the temp sink
parec --format=s16le -d ${recording_sink_name}.monitor | \
  lame -r --quiet -q 3 --lowpass 17 --abr 192 - $outfile


# export variables so that cleanup function can access them
export sink_id,module_id
cleanup


# https://gist.githubusercontent.com/ramast/4be3314bc73f28f55e3604497188b007/raw/7052d20e286b599860d2884a645d8a506bf3c4da/pulse-recorder.bash


# record from a source, aka mic

# pacmd list-sources | egrep '^\s+name:.*\.monitor'
# Once you know the name of the stream you want to record, run
# parec --channels=1 -d STREAM_NAME filename.wav

# pactl unload-module 24

