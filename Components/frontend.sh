#!/bin/bash

set -e 

source Components/common.sh

Component=nginx

echo -n "Intalling Nginx : "
yum install $Component -y >> /tmp/frontend
Status $?

Sysctl $Component $? frontend

echo -n "Download the content : "
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip" 
Status $?

cd /usr/share/$Component/html
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
mv localhost.conf /etc/$Component/default.d/roboshop.conf
Status $?

echo -n "Restarting the Nginx"
systemctl restart $Component
Status $?

echo -e "Creation of Frontend : \e[32m Success \e[0m"

echo -n "Updating proxy file with catalogue: "
for component in catalogue ; do 
    sed -i -e '/$component/s/localhost/172.31.17.151/' /etc/nginx/default.d/roboshop.conf  &> /tmp/frontend
    Status $?
done

echo -n "Restarting the Nginx"
systemctl restart $Component
Status $?