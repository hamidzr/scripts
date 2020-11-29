#!/bin/bash -ex

url=$1
quality=$2
start_time=$3
end_time=$4
output=$5

youtube-dl -f ${quality} -o /tmp/ytdl.video ${url}

ffmpeg -i /tmp/ytdl.video -ss ${start_time} -to ${end_time} -c:v copy -c:a copy ${output}
