#!/bin/bash

Component=$1 

#if $1 input is not given then it throw an error
if [ -z  $1 ]; then
    echo -e '\e[32m Input machi name \e[0m'
    exit 1
fi    

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId' | sed -e 's/"//g')
Security_grp="sg-0ab962e577f534c99"

echo "The AMI ID is $AMI_ID"

echo -n "Launch EC2 instances : "
aws ec2 run-instances --image-id $AMI_ID --instance-type t2.micro --security-group-ids $Security_grp --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$Component}]" | jq >> /tmp/instance
