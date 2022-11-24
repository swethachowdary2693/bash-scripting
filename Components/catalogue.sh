#!/bin/bash

set -e 

source Components/common.sh

Component=catalogue
Fuser = roboshop

echo -n "Installing NodeJs : "
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - >> /tmp/$Component
yum install nodejs -y  >> /tmp/$Component
Status $?

echo -n "Create Application user :"
id $Fuser || useradd $Fuser
Status $?

echo -n "Download the catalogue :"
curl -s -L -o /tmp/$Component.zip "https://github.com/stans-robot-project/$Component/archive/main.zip" >> /tmp/$Component
cd /home/$Fuser && unzip -o /tmp/$Component.zip >> /tmp/$Component && mv $Component-main $Component

chown -r $Fuser:$Fuser $Component
cd /home/$Fuser/$Component
npm install >> /tmp/$Component

