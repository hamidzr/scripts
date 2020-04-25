#!/bin/bash -x
modprobe v4l2loopback exclusive_caps=1 video_nr=3 card_label="v4l-hamid"
