#!/bin/bash
# download a list of image urls

theUrl=$1


# download
function download() {
  # get url
  url=$1
  # comeup with a unique name
  id=`echo $url | grep -Eo [0-9]+ | head -n 1`
  # dl
  curl -o $id.jpg $url
}

download $theUrl



######### batch it!

###### using parallel
# cat $fileLoc | parallel -a - downloadScript {}


###### using xargs FIXME
# cat $fileLoc | xargs -i -P 8 curl --output {} 
# URL=$@
# filename=ssso
# cat $fileLoc | xargs -n 1 -P 10 curl -r 0-50000 {} -o $filename
