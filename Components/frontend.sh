#!/bin/bash

set -e 

source Components/common.sh

echo -n "Intalling Nginx : "
yum install nginx -y >> /tmp/frontend
Status $?

Sysctl nginx $?

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

echo -e "Completed the installation : \e[32m Success \e[0m"