#!/bin/bash
# Credit: This code is based on answers provided by Waschtl and KrisWebDev
# https://askubuntu.com/questions/60837/record-a-programs-output-with-pulseaudio
# NOTE: An improved script written in python can be found here https://gist.github.com/ramast/c47bd5e57586e9c2deb74975e27089f0

cleanup(){
    if [ -z "$module_id" ]
    then
        exit 3
    fi
    # Revert the input sink back to it's original value
    pactl move-sink-input $index $curr_sink
    # Unload the module I've previously loaded
    pactl unload-module $module_id
    exit 0
}

# Call cleanup function when user press ctrl+c
trap "cleanup" SIGINT SIGTERM

if ! default_output=$(pacmd list-sinks | grep -A1 "* index" | grep -oP "<\K[^ >]+")
then
    echo "Can't seem to find proper output sink, are you using pulseaudio?"
    exit 1
fi

pacmd list-sink-inputs|grep -E '(index|application.name)'
while read -p "Choose recording index: " index
do
    if [ "$index" = "exit" ]
    then
        exit 0
    fi
    curr_sink=$(pacmd list-sink-inputs|grep -EA 8 "index: $index\b"|grep sink|sed -E 's/.*sink:\s*([0-9]+)\s*.*/\1/')
    if echo "$curr_sink"|grep -qE '^[0-9]+$'
    then
        break
    fi
    echo 'Invalid index, type exit to quit'
    echo '-------------------------------'
    pacmd list-sink-inputs|grep -E '(index|application.name)'
done

if [ -f "temp.mp3" ]
then
    read -p "temp.mp3 file already exist, replace (y/n)? " ans
    if [ "$ans" != "y" ]
    then
       exit 1
    fi
fi

module_id=$(pactl load-module module-combine-sink sink_name=record-n-play slaves=$default_output sink_properties=device.description="Record-and-Play")

pactl move-sink-input $index record-n-play 
parec --format=s16le -d record-n-play.monitor | lame -r -q 3 --lowpass 17 --abr 192 - "temp.mp3"
# export my variables so that cleanup function can access them
export index,curr_sink,module_id
cleanup
