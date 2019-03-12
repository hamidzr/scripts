#!/bin/bash

date_str=`date +%y-%m-%d--%H-%M-%S`
echo taking an image $(date)
fswebcam -r 1920x1080 -S 15 $HOME/storage/datasets/webcam/myface/lab_$date_str.jpg
