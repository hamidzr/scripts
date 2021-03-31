#!/bin/bash

ffmpeg -f v4l2 -framerate 30 -video_size 1280x720 -input_format mjpeg -i /dev/video2 out.mkv
