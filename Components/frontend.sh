#!/bin/bash

ID=$(id -u)

if($ID = 0); then
    echo "hey my id" : $ID
else
    echo "hey execute as root user"
fi
