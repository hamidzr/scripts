#!/bin/bash -ex

activation_bytes=$1

input_name=$2

ffmpeg -activation_bytes $activation_bytes -i $input_name.aax -vn -c:a copy $input_name.mp4
