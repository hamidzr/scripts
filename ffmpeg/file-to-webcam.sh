#!/bin/bash -x

src_file="${1}"
output_device="${2}"

ffmpeg -re -stream_loop -1 -i "${src_file}" -map 0:v -f v4l2 -threads 0 /dev/video3
