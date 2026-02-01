#!/bin/bash

USERID=$(id -u)


if [ $USERID -ne 0 ]; then
    echo "error::please run with root access"
    exit 1
fi

dnf install mysql -y

if [ $? -ne 0 ]; then
    echo "installation is failed"
    exit 1
else
    echo "installation is success"
fi