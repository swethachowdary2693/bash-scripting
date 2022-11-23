#!/bin/bash

set -e 

source Components/common.sh

echo -n "Intalling Nginx : "
yum install nginx -y >> /tmp/frontend
if [ $? -eq 0 ]; then
    echo -e "\e[32m Success \e[0m"
else    
    echo -e "\e[32m Failed in installing \e[0m"
fi