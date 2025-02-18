#!/bin/bash

source /root/backups/credit/credit-mariadb/config.sh

getCurrentDate=$(date +"%Y-%m-%d")
getCurrentTime=$(date +"%H-%M-%S")
storeDumpPath=/root/backups/data/credit-mysql/"${getCurrentDate}"/
storeDumpName="credit-${getCurrentDate}-${getCurrentTime}.sql"
logFilePath=/root/backups/logs/credit-mysql/"${getCurrentDate}"/
logFileName="${getCurrentTime}.log"

#if dir not exist then make it
[[ -d "$logFilePath" ]] || mkdir -p ${logFilePath}
[[ -d "$storeDumpPath" ]] || mkdir -p ${storeDumpPath}

docker exec ${CONTAINER_NAME} mysqldump -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${DATABASE_NAME} --default-character-set=utf8mb4 > "${storeDumpPath}${storeDumpName}" 2>&1 | tee -a "${logFilePath}${logFileName}"

EXITSTATUS=${PIPESTATUS[0]}

  if [[ ${EXITSTATUS} -eq 0 ]]
    then
        echo "${DATABASE_NAME} Dump successfully" 2>&1 | tee -a "${logFilePath}${logFileName}"
        exit 0
    fi
        rm "${storeDumpPath}${storeDumpName}"
        echo "mariadb dump failed for db ${DATABASE_NAME}" 2>&1 | tee -a "${logFilePath}${logFileName}"
        exit 1
