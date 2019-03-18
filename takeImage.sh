#!/bin/bash

date_str=`date +%y-%m-%d--%H-%M-%S`
dataset_path=$1
echo taking an image $(date)
fswebcam -r 1920x1080 -S 15 $dataset_path/lab_$date_str.jpg 2>&1
