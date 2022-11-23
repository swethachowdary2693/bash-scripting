#!/bin/bash

ID=$(id -u)

if [ $ID -ne 0 ]; then
    echo "Creating frontend"
    exit 1
fi

yum install nginx -y
