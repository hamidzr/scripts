#!/bin/bash

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

window_id=$(wmctrl -l | dmenu -i | cut -d ' ' -f1)
window_info=$(xwininfo -id $window_id)
inres=$(echo "$window_info" | grep -P '(?<=geometry )[\d,x]+' -o)
xo=$(echo "$window_info" | grep -i 'absolute.*x:' | grep -Po '\d+')
yo=$(echo "$window_info" | grep -i 'absolute.*y:' | grep -Po '\d+')


declare resolution_opts=("2560x1440
1920x1080
1600x900
1280x720
1024x576
854x480
640x360
720x1280
480x854
360x640
500x500
300x300
input")

outres=$(echo -e "${resolution_opts[@]}" | dmenu -i -p "pick output resolution (inp: $inres)")
[[ "${outres}" == "input" ]] && outres=$inres

echo "sizing: ($inres, $xo, $yo, $outres)"
ffmpeg -f x11grab -show_region 1 -r $fps -s $inres -i :0.0+$xo,$yo -vcodec rawvideo -pix_fmt yuv420p -s $outres -threads 0 \
  -f v4l2 $video_device
  # -f v4l2 -vf scale=320:-1 $video_device

# check video device
# ffplay $video_device
