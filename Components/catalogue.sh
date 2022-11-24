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
cd /home/$Fuser 
unzip -o /tmp/$Component.zip >> /tmp/$Component && mv $Component-main $Component
Status $?

echo -n "Changing ownership : "
chown -R $Fuser:$Fuser $Component/  >> /tmp/$Component
Status $?

cd /home/$Fuser/$Component
npm install >> /tmp/$Component

echo -n "Setting up systemd service : "
sed -i -e 's/MONGO_DNSNAME/172.31.24.78/' /home/$Fuser/$Component/systemd.service >> /tmp/$Component && mv /home/$Fuser/$Component/systemd.service /etc/systemd/system/$Component.service >> /tmp/$Component
Status $?

echo -n "Restarting the service : "
systemctl daemon-reload   >> /tmp/$Component
systemctl start catalogue  >>  /tmp/$Component
systemctl enable catalogue  >> /tmp/$Component
Status $? 