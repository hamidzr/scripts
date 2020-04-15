#!/bin/bash -xe

# ssh into a running Jenkins instance hosted on EC2

ssh_keypair_path=$1
instance_id=$2

ssh -i $ssh_keypair_path  -o StrictHostKeyChecking=no ubuntu@$(aws-instance-ip.sh $instance_id)
