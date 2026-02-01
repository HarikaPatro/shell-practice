#!/bin/bash

USERID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-script"
SCRIPT_NAME="$( echo $0 | cut -d "." -f1 )"
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

if [ $USERID -ne 0 ]; then
    echo "error:: please run with root access"
    exit 1
fi

mkdir -p $LOGS_FOLDER
echo "script started execution at: $(date)" | tee -a $LOG_FILE

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "error:: installing $2 is $R failed $N" | tee -a $LOG_FILE
        exit 1
    else
        echo -e "installing $2 is $G success $N" | tee -a $LOG_FILE
    fi
}

dnf list installed mysql &>>$LOG_FILE
if [ $? -ne 0 ];then
    dnf install mysql -y &>>$LOG_FILE
    VALIDATE $? "Mysql"
else
    echo -e "mysql already exists..... $Y skipping $Y" | tee -a $LOG_FILE
fi

dnf list installed nginx &>>$LOG_FILE
if [ $? -ne 0 ];then
    dnf install nginx -y &>>$LOG_FILE
    VALIDATE $? "Nginx"
else
    echo -e "nginx already exists..... $Y skipping $Y" | tee -a $LOG_FILE
fi

