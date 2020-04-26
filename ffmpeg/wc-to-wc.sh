#!/bin/bash

src=$1
dst=$2

fps=20

## crop filter options
# square
# dim_w=350
# dim_h=350

# vertical
dim_w=240
dim_h=320

# horizontal
# dim_w=320
# dim_h=240

offset_w=164
offset_h=54



# -f video4linux2 -input_format h264 -video_size 640x480 -framerate 20 \

ffmpeg \
  -f video4linux2 -input_format rawvideo -video_size 640x480 -framerate 30 \
  -i $src \
  -filter:v "crop=$dim_w:$dim_h:$offset_w:$offset_h" \
  -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 $dst


