#!/bin/bash

set -e 

source Components/common.sh

echo -n "Intalling Nginx : "
yum install nginx -y >> /tmp/frontend
Status $?

Sysctl nginx $? frontend

echo -n "Download the content : "
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip" 
Status $?

cd /usr/share/nginx/html
rm -rf *

echo -n "Unzip the folder : "
unzip -o /tmp/frontend.zip  >> /tmp/frontend
Status $?

mv frontend-main/* .
mv static/* .

echo -n "Performing cleanup : "
rm -rf frontend-main README.md
Status $?

echo -n "Creating reverse proxy file : "
mv localhost.conf /etc/nginx/default.d/roboshop.conf
Status $?

echo -n "Restarting the Nginx"
systemctl restart nginx
Status $?

echo -e "Creation of Frontend : \e[32m Success \e[0m"