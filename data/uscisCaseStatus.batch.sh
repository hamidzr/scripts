#!/bin/bash -ex

output_dir=$1
case_prefix=$2
start_range=$3
end_range=$4
parallel_requests=$5

mkdir -p $output_dir

seq $start_range $end_range | sed "s/^/$case_prefix/" | xargs -n1 -P$parallel_requests -I{} sh -c "./uscisCaseStatus.sh {} >> ${output_dir}/{}.log"
