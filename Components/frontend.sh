#!/bin/bash

set -e 

source Components/common.sh

echo -n "Intalling Nginx : "
yum install nginx -y >> /tmp/frontend
Status $?