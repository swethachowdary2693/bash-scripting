#!/bin/bash

set -e

source Components/common.sh

Component=mongodb

echo -n "Settingup $Component repository :"
curl -s -o /etc/yum.repos.d/$Component.repo https://raw.githubusercontent.com/stans-robot-project/$Component/main/mongo.repo  >> $Logfile
Status $?

echo -n "Installing Mongo services :"
yum install -y mongodb-org >> $Logfile
Status $?

Sysctl mongod $? 

echo -n "Updating listen IP :"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf 
Status $?

echo -n "Restarting $Component :"
systemctl restart mongod  >> $Logfile
Status $?

echo -n "Downloading the schema : "
curl -s -L -o /tmp/$Component.zip "https://github.com/stans-robot-project/$Component/archive/main.zip"
Status $?

echo -n "Injecting the Schema : "
cd /tmp && unzip -o mongodb.zip >> /tmp/$Component && cd mongodb-main

mongo < catalogue.js >> $Logfile
mongo < users.js    >>  $Logfile
Status $?

echo -e "Created Mongodb : \e[32m Success \e[0m"

