#!/bin/bash

aws ec2 describe-instances --instance-ids $1 --query 'Reservations[*].Instances[*].{instance:InstanceId,ip:PublicIpAddress}' | jq '.[0][0].ip' -r 
