#!/bin/bash -x

# create a loopback video device
# modprobe v4l2loopback exclusive_caps=1 video_nr=3 card_label="Fake"
# check with ls /dev/video*

# get window info
# wmctrl -l

# list video devices
# v4l2-ctl --list-devices

# capture the whole screen and output to webcam device
fps=30
video_device="${1}"

ffmpeg -f x11grab -show_region 1 -r $fps -s 2560x1440 -i :0.0+0,0 -vcodec rawvideo -pix_fmt yuv420p -threads 0 \
  -f v4l2 $video_device
  # -f v4l2 -vf scale=320:-1 $video_device

# check video device
# ffplay $video_device
