#!/bin/bash

set -e 

source Components/common.sh

Component=nginx

echo -n "Intalling Nginx : "
yum install $Component -y >> $Logfile
Status $?

Sysctl $Component $? frontend

echo -n "Download the content : "
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/$Component/archive/main.zip"   
Status $?

cd /usr/share/$Component/html
rm -rf *

echo -n "Unzip the folder : "
unzip -o /tmp/frontend.zip  >> $Logfile
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

echo -n "Updating proxy file with catalogue: "
#for comp in catalogue user; do 
    sed -i -e '/catalogue/s/localhost/catalogue.roboshop.internal/' -e '/user/s/localhost/user.roboshop.internal/' -e '/cart/s/localhost/cart.roboshop.internal/' -e '/shipping/s/localhost/shipping.roboshop.internal/' -e '/payment/s/localhost/payment.roboshop.internal' /etc/nginx/default.d/roboshop.conf  >> /tmp/frontend
    Status $?
#done

echo -n "Restarting the Nginx"
systemctl restart $Component
Status $?