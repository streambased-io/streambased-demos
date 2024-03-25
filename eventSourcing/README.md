# Streambased Log Shipping Demo

## What does this demo do?

This demo simulates one of the core use cases for Apache Kafka: Log shipping. We will run a sample application that 
creates log data that flows through Kafka.

On top of this we will use Streambased technology to analyze the captured logs in order to perform investigative tasks.

## Step 1: Setup and review the environment

First run the setup script, this will configure the resources for the demo.

```bash
./bin/setup.sh
tar -xvzf data/transactions.tar.gz -C data 
```

Our environment consists of the following components:

1. A single node Kafka cluster (containers kafka1 and zookeeper) - for data storage
2. A Schema Registry - for governance
3. Streambased Indexer - to create the indexes Streambased uses to be fast
4. Streambased Server - to make the Kafka data available via JDBC
5. Superset - a popular and easy to use database client

## Step 2: Start the environment

To bring up the environment run:

```bash
docker-compose up -d
```

## Step 3: Create Topics

Let's create the Kafka topics we need for this demo. `transactions` will store deposit or withdrawal events for our 
simulated customers.

```bash
docker-compose exec kafka1 kafka-topics --bootstrap-server kafka1:9092 --topic transactions --create --partitions 1
```

## Step 4: Add an existing set of events

```bash
cat data/transactions.txt |
    docker-compose exec -T schema-registry kafka-avro-console-producer \
      --bootstrap-server kafka1:9092 \
      --topic transactions \
      --property schema.registry.url=http://schema-registry:8081 \
      --producer-property linger.ms=10 \
      --producer-property batch.size=1000 \
      --property value.schema='{
          "name": "transaction",
          "type": "record",
          "fields": [
              { 
                "name":"name",
                "type":"string"
              },
              { 
                "name":"transactionId",
                "type":"string"
              },
              { 
                "name":"timestamp",
                "type":"long"
              },
              { 
                "name":"accountId",
                "type":"int"
              },
              { 
                "name":"depositAmount",
                "type":"double"
              },
              { 
                "name":"depositLatitude",
                "type":"int"
              },
              { 
                "name":"depositLongitude",
                "type":"int"
              },
              { 
                "name":"depositReason",
                "type":"string"
              }
          ]
      }'
```

## Step 5: Check Streambased has finished collecting metadata

Because we are bulk loading data Streambased metadata can lag behind the loaded data. Ensure there is no lag on the 
Streambased consumer group below. 

```bash
docker-compose exec kafka1 kafka-consumer-groups \
  --bootstrap-server kafka1:9092 \
  --describe \
  --group Streambased-Indexer
```

In a normal deployement we would not have to do this as we would have scaled indexing nodes to match the incoming 
message load. 

## Step 6: Open superset

Now we can query the collected data and demonstrate the Streambased effect. 

From a web browser navigate to `localhost:8088` 

Log in using credentials `admin:admin`

## Step 7: Query with Streambased

Next from the menu at the top select `SQL -> SQL Lab`, you will see a familiar SQL query interface. In the query entry 
area add the following:

```
use kafka.streambased;
set session use_streambased=true;
select sum(depositAmount) as currentBalance from transactions where name = 'JACK SMITH';
```

and click `RUN`

## Step 8: Compare with no Streambased acceleration

You can see how long the query will take without Streambased by disabling acceleration. Run the following to disable 
acceleration and then run the query above:

```
set session use_streambased=false;
```

Depending on how much data has been written you should see around a 10x performance degradation. 

To re-enable acceleration run:

```
set session use_streambased=true;
```

## Step 9: Let's do some time travelling

Because we have a historical set of events, we can look at the current balance for any earlier timestamp simply by 
introducing a where constraint on the timestamp column.

```
use kafka.streambased;
set session use_streambased=true;
select sum(depositamount) as currentBalance from transactions where name = 'JACK SMITH' and timestamp < 1500000000000
```

## Step 10: Explore!

Feel free to run other queries against this dataset with or without Streambased acceleration enabled

## Step 11: (optional) introduce some latency 

Our demo isn't very realistic as there is no latency between the Kafka cluster and the Streambased server. We can 
introduce some with Pumba:

```bash
docker-compose up -d pumba
```

Now rerun from Step 7 onwards.

## Step 12: Tear down

To complete the demo run the following. This will stop and remove all demo resources:

```bash
docker-compose stop
docker-compsoe rm
```

## Summary

In this demo we have introduced Streambased acceleration to an event sourced log in Kafka. Streambased acceleration 
allows this log to perform filtering and aggregate tasks that would normally require a second data store and an ELT 
process. 
