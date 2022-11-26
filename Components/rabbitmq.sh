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
yum install rabbitmq-server -y &>> $Logfile
Status $?

Sysctl rabbitmq-server $?

echo -n "Creating $Component application user :"
rabbitmqctl add_user roboshop roboshop123 &>> $Logfile
Status $?

echo -n "Configuring $Component application user permission : "
rabbitmqctl set_user_tags roboshop administrator >> $Logfile && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" >> $Logfile
Status $?



