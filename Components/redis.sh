#!/bin/bash

set -e 

source Components/common.sh

Component=redis


echo -n "Get the repository of redis : "
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/$Component.repo -o /etc/yum.repos.d/$Component.repo >>/tmp/$Component
Status $?

echo -n "Installing redis : "
yum install $Component-6.2.7 -y >> /tmp/$Component
Status $?

echo -n "Changing the Bind ip to allow all :"
sed -i -e 's/127.0.0.1/0.0.0.0' /etc/redis.conf >> /tmp/$Component
Status $?

echo -n "Starting $Component : "
sysctl $Component $? $Component
Status $?
