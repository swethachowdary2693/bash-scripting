#!/bin/bash

source Components/common.sh

Component=mysql
Password=RoboShop@1

echo -n "Setting up mysql Repo : "
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo &>> $Logfile
Status $?

echo -n "Install mysql : "
yum install mysql-community-server -y &>> $Logfile
Status $?

Sysctl mysqld $? 

echo -n "Extracting root password : "
DEFAULT_ROOT_PASSWORD=$(grep temp /var/log/mysqld.log | head -n 1 | awk -F " " '{print $NF}') &>> $Logfile
Status $?

echo -n "Changing the password : "
echo show databases | mysql -uroot -p$Password &>>Logfile
if [ $? -ne 0 ]; then
echo -n "Reset root password : "
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$Password'" | mysql --connect-expired-password -uroot -p"$DEFAULT_ROOT_PASSWORD"  &>>$Logfile
Status $?
fi 

echo -n "Uninstall the plugin : "
echo "uninstall plugin validate_password" | mysql -uroot -p$Password &>>$Logfile
Status $?
