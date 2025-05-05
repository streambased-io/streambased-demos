#! /bin/sh

# setup db
mysql -h db -u root -pstreambased -D streambased -e 'CREATE TABLE purchases ( customerId varchar(50), amount double(10,3), itemCode varchar(50))'

# submit connector
curl -X POST -H "Content-Type: application/json" --data '@/tmp/connector.json' http://connect:8083/connectors
echo "Submitted Connector"

# wait before we inject chaos
sleep 60

while true
do
  for CUSTOMER_NUMBER in {1000..2000}
  do
    mysql -h db -u root -pstreambased -D streambased -e "INSERT INTO purchases VALUES ( 'CU-$CUSTOMER_NUMBER', $RANDOM.0, '96385074')"
  done
  sleep 20
done