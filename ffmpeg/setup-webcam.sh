#!/bin/bash -x
sudo modprobe v4l2loopback exclusive_caps=1 video_nr=3 card_label="v4l"
