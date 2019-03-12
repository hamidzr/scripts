#!/bin/bash

input=input.mp4 # path
output=output.mp4


# qscale => variable rate
# x:v x:a video or audio
# -b:500k bitrate
# transpose=1 rotate 90deg


ffmpeg -i $input -qscale:v 3 -threads 0 -vf "transpose=1,scale=480:854" $output
