#!/bin/bash

set -e 

source Components/common.sh

Component=redis


echo -n "Get the repository of redis : "
curl -sL https://raw.githubusercontent.com/stans-robot-project/$Component/main/$Component.repo >> $Logfile -o /etc/yum.repos.d/$Component.repo >> $Logfile
Status $?

echo -n "Installing redis : "
yum install $Component-6.2.7 -y >> $Logfile
Status $?

echo -n "Changing the Bind ip to allow all :"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/$Component.conf >> $Logfile
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/$Component/$Component.conf >> $Logfile
Status $?

echo -n "Starting $Component : "
Sysctl $Component $? $Component  >> $Logfile
Status $?
