#!/bin/bash

set -e 

source Components/common.sh

Component=shipping

echo -n "Installing Maven : "
yum install maven -y >> $Logfile
Status $?

Useradd

DownloadExtract

echo -n "Generating the artifact : "
cd /home/$Fuser/$Component
mvn clean package 
mv target/shipping-1.0.jar shipping.jar
Status $?

Settingsystemd

StartingService
