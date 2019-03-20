#!/bin/bash

# downlaods a file if it hasn't been already downloaded. pushed into sub directories
# used for downloading a huge number of files

# usage: thisScript url fileName


# hashes the filename name and retuns the first 2 numbers (hex)
function dirName()
{
  fName=$1
  local dir_name=$(echo $fName  | md5sum | sed 's/\([a-z0-9]\{2\}\).*/\1/')
  echo $dir_name
}


function downloadFile()
{
  local url=$1
  local fName=$2
  local dir_name=$(dirName $fName)
  local file_path=$dir_name/$fName

  # create the dir if needed
  [ ! -d $dir_name ] && mkdir $dir_name

  # download it only if it isn't downloaded yet
  if [ ! -f $file_path ]; then
    curl -s -C - $url -o $file_path
    # wget -O $file_path -q $url
    echo $fName captured
  else
    echo $fName skipped
  fi
}

downloadFile $1 $2

