#! /bin/sh

# setup db
mysql -h db -u root -pstreambased -D streambased -e 'CREATE TABLE transactions ( storeId varchar(50), amount double(10,3), paymentTermCode varchar(50), paymentTime int, itemCode varchar(50))'
mysql -h db -u root -pstreambased -D streambased -e 'SET GLOBAL local_infile=1'

# submit connector
curl -X POST -H "Content-Type: application/json" --data '@/tmp/connector.json' http://connect:8083/connectors
echo "Submitted Connector"

while true
do
  NEXT_FILE=/tmp/pipeline/$(date +"%H_%M".out --date '1 minutes ago')
  echo "Scanning for ${NEXT_FILE}"
  if [ -f ${NEXT_FILE} ]
  then
    mysql --local_infile=1 -h db -u root -pstreambased -D streambased -e "LOAD DATA LOCAL INFILE '${NEXT_FILE}' INTO TABLE transactions COLUMNS TERMINATED BY ','"
    mv ${NEXT_FILE} ${NEXT_FILE}.processed
    echo "Processed ${NEXT_FILE}"
  fi
  sleep 20
done
