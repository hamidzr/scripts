#!/bin/bash -x

# ssh into a running jenkins instance

ssh_keypair_path=$1
instance_id=$2

ssh -i $ssh_keypair_path  -o StrictHostKeyChecking=no ubuntu@$(awsInstanceIp.sh $instance_id)
