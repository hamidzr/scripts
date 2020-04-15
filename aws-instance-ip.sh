#!/bin/bash

# for this to work you need to be set up with using aws cli.
# https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html

aws ec2 describe-instances --output json --instance-ids $1 --query 'Reservations[*].Instances[*].{instance:InstanceId,ip:PublicIpAddress}[0].ip' | grep -oP '[\d\.]+'
