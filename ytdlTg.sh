#!/bin/bash
url=$1
name=$2
frmt=$3
# add check if file exists to speed up
touch /tmp/$name.$frmt

if [ $frmt = "mp3" ]; then
	#statements
	#[ ! -f "/tmp/$name.mp3" ] && youtube-dl -f bestaudio --max-filesize 10m $url -o /tmp/$name.mp3 #not playable in mobile
	#youtube-dl --extract-audio --audio-format mp3 --ffmpeg-location --max-filesize 10m /root/ffmpeg-3.0.2-64bit-static/ $url
	[ ! -f "/tmp/$name.mp3" ] && youtube-dl --extract-audio --audio-format mp3 --ffmpeg-location /root/ffmpeg-3.0.2-64bit-static/ --max-filesize 10m $url -o '/tmp/%(id)s.%(ext)s'
else
	[ ! -f "/tmp/$name.mp4" ] && youtube-dl -f 18/5/36/worst --max-filesize 25m $url -o /tmp/$name.mp4
	[ ! -f "/tmp/$name.mp4" ] && youtube-dl -f 5/36/worst --max-filesize 15m $url -o /tmp/$name.mp4
	[ ! -f "/tmp/$name.mp4" ] && youtube-dl -f 36 --max-filesize 13m $url -o /tmp/$name.mp4
	# [ ! -f "/tmp/$name.mp4" ] && youtube-dl -f worst --max-filesize 10m $url -o /tmp/$name.mp4
fi
