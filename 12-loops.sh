#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGS_FOLDER="/var/log/shell-script"
SCRIPT_NAME="$( echo $0 | cut -d "." -f1 )"
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOGS_FOLDER
echo "script started execution at: $(date)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]; then
    echo "error::please run with root access"
    exit1
fi

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "error::installing $2 is $R failed $N" | tee -a $LOG_FILE
        exit1
    else
        echo -e "installing $2 is $G success $N" |tee -a $LOG_FILE
    fi
}

for package in $@
do
    dnf list installed $package &>>$LOG_FILE

    if [ $? -ne 0 ]; then
        dnf install $package &>>$LOG_FILE
        VALIDATE $? "$package"
    else
        echo -e "$package is already installed.... $Y skipping $N" | tee -a $LOG_FILE
    fi
done
