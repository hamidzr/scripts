#!/bin/bash

# ssh into a running Jenkins instance and land in a working directory for a specific pr and test.

ssh_keypair_path=$1
instance_id=$2
test_name=$3
pr=$4

pr_dir="workspace/${test_name}_PR-${pr}"

echo "issue the following to move to the target directory"
echo "cd ${pr_dir}"
ssh-to-jenkins $ssh_keypair_path $instance_id
  # "cd ${pr_dir}; echo 'connected'; sh"
# TODO remove the need for `sh`: don't exit after running the command.
