#!/bin/bash

set -e 

Component=$1 

#if $1 input is not given then it throw an error
if [ -z  "$1" ]; then
    echo -e '\e[31m Input machine name \e[0m'
    exit 1
fi    

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId' | sed -e 's/"//g')
Security_grp="sg-0ab962e577f534c99"

echo "The AMI ID is $AMI_ID"

echo -n "Launch EC2 instances : "
IPAddress=$(aws ec2 run-instances --image-id $AMI_ID --instance-type t2.micro --security-group-ids $Security_grp --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$Component}]" | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')
echo "Private IP address for created Machine $IPAddress" 

echo "Creating Route53 record : "
sed -e "s/Private_IP/$IPAddress/" -e "s/Component/$Component/" r53.json > /tmp/route53.json
aws route53 change-resource-record-sets --hosted-zone-id Z045368932D85CAY0T44S --change-batch file:///tmp/route53.json | jq