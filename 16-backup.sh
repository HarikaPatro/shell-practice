#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGS_FOLDER="/var/log/shell-script"
SCRIPT_NAME="$( echo $0 | cut -d "." -f1 )"
#LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log" #MODIFIED to run the script as command
SOURCE_DIR=$1
DEST_DIR=$2
DAYS=${3:-14}

mkdir -p $LOGS_FOLDER
echo "script started execution at: $(date)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]; then
    echo "error::please run with root access"
    exit 1
fi


USAGE(){
    echo -e " $R USAGE:: sudo sh 16-backup.sh <SOURCE_DIR> <DEST_DIR> <DAYS>[optional, defualt 14 days] $N"
    exit 1
}

### Check SOURCE_DIR and DEST_DIR passed or not ###
if [ $# -lt 2 ]; then
    USAGE
fi

### check source_dir exist or not ###
if [ ! -d $SOURCE_DIR ]; then
    echo -e "$R source $SOURCE_DIR doesnot exist $N"
    exit 1
fi

### check dest_dir exist or not ###
if [ ! -d $DEST_DIR ]; then
    echo -e "$R destination $DEST_DIR doesnot exist $N"
    exit 1
fi

### Find the files ###
FILES=$(find $SOURCE_DIR -name "*.log" -type f -mtime +$DAYS)

### Check the files are empty or not ###
if [ ! -z "${FILES}" ]; then
    ####start archiving ###
    echo "files found: $FILES"
    TIMESTAMP=$(date +%F-%H-%M)
    ZIP_FILE_NAME="$DEST_DIR/app-logs-$TIMESTAMP.zip"
    echo "zip file name: $ZIP_FILE_NAME"
    find $SOURCE_DIR -name "*.log" -type f -mtime +$DAYS | zip -@ -j "$ZIP_FILE_NAME"

### check archiving is success or not ###
    if [ -f $ZIP_FILE_NAME ]; then
        echo -e "Archival......$G success $N"

        ### deleting the files ###
        while IFS= read -r filepath
        do
            echo "Deleting the file: $filepath"
            rm -rf $filepath
            echo "Deleted the file: $filepath"
        done <<< $FILES
    else
        echo -e "Archiving.....$R failure $N"
        exit 1
    fi
else
    echo -e "No files to archive....$Y skipping $N"
fi



