#!/bin/bash

url=$1
get_instance_id=${2:-true}
# url=https://jenkins.determined.ai/blue/organizations/jenkins/determined-webui-tests/detail/PR-142/6/pipeline

pipline_name=$(echo $url | grep -Po 'jenkins/\K[^/]*')
pr=$(echo $url | grep -Po 'PR-\K[^/]*')
run=$(echo $url | grep -Po 'PR-[^/]+/\K[^/]*')


# also get jenkins instance id
# Jenkins (i-0064686a1002f21b6) (executor: 0)
if $get_instance_id; then
  instance_id=$(jenkins-logs.sh $pipline_name $pr $run | grep -Po -m 1 '\(\Ki-[\w]{6,18}')
fi

echo "$instance_id $pipline_name $pr $run" | sed 's/^ *//;s/ *$//'
