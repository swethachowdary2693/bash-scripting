#!/bin/bash

set -e 

source Components/common.sh

Component=rabbitmq

echo -n "Installing Erlang : "
curl -s https://packagecloud.io/install/repositories/$Component/erlang/script.rpm.sh | bash &>> $Logfile
Status $?

echo -n "Setup Yum repository : "
curl -s https://packagecloud.io/install/repositories/$Component/$Component-server/script.rpm.sh | bash &>> $Logfile
Status $?

echo -n "Installing $Component :"
yum install $Component-server -y &>> $Logfile
Status $?

Sysctl $Component-server $?

rabbitmqctl list_users | grep $Fuser  >> $Logfile
if [ $? -ne 0 ]; then
echo -n "Creating $Component application user :"
rabbitmqctl add_user $Fuser roboshop123 &>> $Logfile
Status $?
fi

echo -n "Configuring $Component application user permission : "
rabbitmqctl set_user_tags $Fuser administrator >> $Logfile && rabbitmqctl set_permissions -p / $Fuser ".*" ".*" ".*" >> $Logfile
Status $?



