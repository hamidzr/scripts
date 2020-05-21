#!/bin/bash

while true; do
  echo "###" $(date) "###"
  iwlist bitrate 2>/dev/null | grep -iPo '(?<=rate.)\d.*$'
  sleep ${EVERY:-10}
done
