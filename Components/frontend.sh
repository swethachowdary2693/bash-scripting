#!/bin/bash

set -e 

source Components/common.sh

echo -n "Intalling Nginx : "
yum install nginx -y >> /tmp/frontend
Status $?

echo -n "Enable Nginx : "
systemctl enable nginx  >> /tmp/frontend
Status $?

echo -n "Start Nginx : "
systemctl start nginx >> /tmp/frontend
Status $?

echo -n "Download the content : "
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip" 
Status $?

cd /usr/share/nginx/html
rm -rf *
unzip -o /tmp/frontend.zip  >> /tmp/frontend 
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

echo -n "\e[32m Completed \e[0m"