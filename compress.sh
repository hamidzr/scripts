#!/bin/bash

input=$1

original_name=$(echo $input | grep -Po '[^\/]+$')
target=$original_name-$(dateString.sh).txz

echo "compressing to $PWD/$target.."
tar -cJf $target $input

