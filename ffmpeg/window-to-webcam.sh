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


declare typical_resolutions=("4096x2160
3840x2160
2048x1080
1920x1080
1280x720
1024x768
800x600
720x486
720x480
720x576
618x618
408x408
300x300")

outres=$(echo -e "${typical_resolutions[@]}" | dmenu -i -p 'pick output resolution')

echo "sizing: ($inres, $xo, $yo, $outres)"
ffmpeg -f x11grab -show_region 1 -r $fps -s $inres -i :0.0+$xo,$yo -vcodec rawvideo -pix_fmt yuv420p -s $outres -threads 0 \
  -f v4l2 $video_device
  # -f v4l2 -vf scale=320:-1 $video_device

# check video device
# ffplay $video_device
