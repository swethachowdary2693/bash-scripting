#!/bin/bash

set -e 

source Components/common.sh

Component=payment

echo -n "Install Python 3 : "
yum install python36 gcc python3-devel -y &>> $Logfile
Status $?

Useradd

DownloadExtract

echo -n "Install the dependencies : "
cd /home/roboshop/payment 
pip3 install -r requirements.txt &>> $Logfile
Status $?

User_ID=$(id -u roboshop)
Group_ID=$(id -g roboshop)

echo -n "Updating the ID's in $Component.ini file"
sed -i -e "/^uid/ c uid=$User_ID" -e "/^gid/ c gid=$Group_ID" $Component.ini 
Status $?

Settingsystemd

StartingService 