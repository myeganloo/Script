# set timezone IRAN
#cp /usr/share/zoneinfo/Asia/Tehran /etc/localtime
source /root/backups/credit/credit-mongodb/config.sh
 
getCurrentDate=$(date +"%Y-%m-%d")
getCurrentTime=$(date +"%H-%M-%S")
storeDumpPath=~/backups/data/credit-mongodb/"${getCurrentDate}"/
logFilePath=~/backups/logs/credit-mongodb/"${getCurrentDate}"/
logFileName="${getCurrentTime}.log"
storeDumpName="credit-${getCurrentDate}-${getCurrentTime}.dump"
#if log dir not exist then make it
[[ -d "$logFilePath" ]] || mkdir -p ${logFilePath}
[[ -d "$storeDumpPath" ]] || mkdir -p ${storeDumpPath}
docker exec -i ${CONTAINER_NAME} mongodump --username ${MONGO_USER} --password ${MONGO_PASSWORD} --authenticationDatabase admin --db ${dbName}  --archive >  "${storeDumpPath}${storeDumpName}" 2>&1 | tee -a "${logFilePath}${logFileName}"
# docker exec -i credit-credit-mongo-1 mongodump  --username root --password root --authenticationDatabase admin --db credit --archive > $(date +'%Y_%m_%d_%H_%M_%S')_mydb.sql.dump

  if [[ $? -eq 0 ]]
    then
        echo "$dbName Dump successfully" 2>&1 | tee -a "${logFilePath}${logFileName}"
        exit 0
    fi
        echo "mongo dump failed for db ${dbName}" | tee -a "${logFilePath}${logFileName}"
        exit 1
