#!/bin/bash

src=$1
dst=$2
orientation=${3:-vertical}

fps=20

offset_w=164
offset_h=54

## crop filter options
if [[ "${orientation}" == "vertical" ]]; then
  # vertical
  dim_w=240
  dim_h=360
  offset_w=164
  offset_h=54
elif [[ "${orientation}" == "horizontal"  ]]; then
  # horizontal
  dim_w=360
  dim_h=240
  offset_w=100
  offset_h=100
else
  echo "unsupported orientation"
  exit 1
fi




# -f video4linux2 -input_format h264 -video_size 640x480 -framerate 20 \

ffmpeg \
  -f video4linux2 -input_format rawvideo -video_size 640x480 -framerate 30 \
  -i $src \
  -filter:v "crop=$dim_w:$dim_h:$offset_w:$offset_h" \
  -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 $dst


