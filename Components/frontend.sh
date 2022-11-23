#!/bin/bash

set -e 

source Components/common.sh

echo -n "Intalling Nginx : "
yum install nginx -y
if [ $? -eq 0]; then
    echo -e "\e[32m Success[0m"
else    
    echo -e "\e[32m Failed in installing[0m"
fi