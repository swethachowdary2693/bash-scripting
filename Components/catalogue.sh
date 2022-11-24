#!/bin/bash

set -e 

source Components/common.sh

Component=catalogue
Fuser=roboshop

echo -n "Installing NodeJs : "
curl -sL https://rpm.nodesource.com/setup_16.x | bash >> /tmp/$Component
yum install nodejs -y  >> /tmp/$Component
Status $?

echo -n "Create Application user :"
id $Fuser >> /tmp/$Component|| useradd $Fuser
Status $?

echo -n "Download the catalogue :"
curl -s -L -o /tmp/$Component.zip "https://github.com/stans-robot-project/$Component/archive/main.zip" >> /tmp/$Component
rm -rf /home/$Fuser/$Component >> /tmp/$Component
cd /home/$Fuser && unzip -o /tmp/$Component.zip >> /tmp/$Component && mv $Component-main $Component

chown -R $Fuser:$Fuser $Component/
cd /home/$Fuser/$Component
npm install >> /tmp/$Component

