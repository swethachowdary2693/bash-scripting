#!/bin/bash

source Components/common.sh

Component=mysql
Password=RoboShop@1

echo -n "Setting up mysql Repo : "
curl -s -L -o /etc/yum.repos.d/$Component.repo https://raw.githubusercontent.com/stans-robot-project/$Component/main/$Component.repo &>> $Logfile
Status $?

echo -n "Install mysql : "
yum install mysql-community-server -y &>> $Logfile
Status $?

Sysctl mysqld $? 

echo -n "Extracting root password : "
DEFAULT_ROOT_PASSWORD=$(grep temp /var/log/mysqld.log | head -n 1 | awk -F " " '{print $NF}') &>> $Logfile
Status $?

echo -n "Changing the password : "
echo show databases | mysql -uroot -p$Password &>> $Logfile
if [ $? -ne 0 ]; then
echo -n "Reset root password : "
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$Password'" | mysql --connect-expired-password -uroot -p"$DEFAULT_ROOT_PASSWORD"  &>>$Logfile
Status $?
fi 
Status $?

echo -n "Uninstalling Plugins : "
echo show plugins | mysql -uroot -p$Password &>> $Logfile | grep validate_password
if [ $? -eq 0 ]; then 
echo -n "Uninstall the plugin : "
echo "uninstall plugin validate_password" | mysql -uroot -p$Password &>>$Logfile
Status $?
fi
Status $?

echo -n "Download the schema : "
curl -s -L -o /tmp/mysql.zip "https://github.com/stans-robot-project/mysql/archive/main.zip" &>> $Logfile
Status $?

echo -n "Loading the schema : "
cd /tmp
unzip -o mysql.zip &>> $Logfile
cd mysql-main                           
mysql -u root -p$Password <shipping.sql    &>> $Logfile
Status $?