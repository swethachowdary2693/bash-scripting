#!/bin/bash

source Components/common.sh

Component=mysql

echo -n "Setting up mysql Repo : "
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo >> $Logfile
Status $?

echo -n "Install mysql : "
yum install mysql-community-server -y >> $Logfile
Status $?

Sysctl mysqld $? 

