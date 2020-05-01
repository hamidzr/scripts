#!/bin/bash -ex

input=$1

bitrate=64k

ffmpeg -i $input -c:a libmp3lame -ac 2 -b:a $bitrate outputfile.mp3

