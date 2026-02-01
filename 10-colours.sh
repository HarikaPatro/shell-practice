#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

USERID=$(id -u)


if [ $USERID -ne 0 ]; then
    echo "error::please run with root access"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo "installing $2 is $R failed $N"
        exit 1
    else
        echo "installing $2 is $G success $N"
    fi
}

dnf list installed mysql
if [ $? -ne 0 ];then
    dnf install mysql -y
    VALIDATE $? "Mysql"
else
    echo "mysql already exists..... $Y skipping $Y"
fi

dnf list installed nginx
if [ $? -ne 0 ];then
    dnf install nginx -y
    VALIDATE $? "Nginx"
else
    echo "nginx already exists..... $Y skipping $Y"
fi