#!/bin/bash

nDaysAgo=$(date --date="3 days ago" +"%Y-%m-%d");
dirPath=/root/backups/data/credit-mysql/

getCurrentDate=$(date +"%Y-%m-%d")
logFilePath=/root/backups/logs/"${getCurrentDate}"/
logFileName="removal.log"

#if log dir not exist then make it
[[ -d "$logFilePath" ]] || mkdir -p ${logFilePath}

#check DIR is exist and not empty
if [[ -d ${dirPath} && ! -z "$(ls -A ${dirPath})" ]]; then
    removeCounter=0;
    # For each DIR in backups directory
    for DIR in ${dirPath}/*; do
        dirName="$(basename -- ${DIR})";
        #remove all DIR that older than n days (include the nth one)
        if [[ $(date -d "${dirName}" +%s) -le $(date -d "${nDaysAgo}" +%s) ]]; then
            rm -rf ${dirPath}/${dirName};
            echo "${dirName} deleted at $(date +"%Y-%m-%d %H:%M:%S")" | tee -a "${logFilePath}${logFileName}";
            ((removeCounter=${removeCounter} + 1));
        fi
    done

    [[ ${removeCounter} -gt 0 ]] && echo "${removeCounter} directories removed" || echo "no old backup files to remove" | tee -a "${logFilePath}${logFileName}";
    exit 0;
else
    echo "${dirPath} does not exist or it's empty" | tee -a "${logFilePath}${logFileName}";
    exit 1;
fi
