# Streambased Aiven Demo

## What does this demo do?

This demo demonstrates the acceleration that Streambased can provide for an existing data set held in managed Kafka. 
In this case our dataset is held in Aiven.

## Step 1: Setup and review the environment

First run the setup script, this will configure the resources for the demo.

```bash
./bin/setup.sh
```

We must now configure the demo for our Aiven environments. Modify `/serverConfig/aiven_client.properties` and replace 
`{Service URI}`,`{User}`,`{Password}`,`{Host}` and `{Port}` with the correct values from your Aiven console.

Our environment consists of the following components:

1. Streambased Indexer - to create the indexes Streambased uses to be fast
2. Streambased Server - to make the Kafka data available via JDBC
3. Superset - a popular and easy to use database client



## Step 2: Start the environment

To bring up the environment run:

```bash
docker-compose up -d
```

We also need to set some things up for the clients:

```bash
export BOOTSTRAP_SERVERS=`grep consumer.bootstrap.servers serverConfig/aiven_client.properties | sed -e s/consumer.bootstrap.servers=//g`
export SCHEMA_REGISTRY_URL=`grep schema.registry.schema.registry.url serverConfig/aiven_client.properties | sed -e s/schema.registry.schema.registry.url=//g`
export SCHEMA_REGISTRY_USER_INFO=`grep schema.registry.basic.auth.user.info serverConfig/aiven_client.properties | sed -e s/schema.registry.basic.auth.user.info=//g`
```

## Step 3: Create a topic

```bash
docker-compose exec -T kafka-client kafka-topics --bootstrap-server $BOOTSTRAP_SERVERS \
--command-config /etc/streambased/etc/aiven_client.properties \
--topic gamersessions \
--create \
--partitions 1
```

## Step 4: Load some data

```bash
cat data/gamersessions.txt |
    docker-compose exec -T schema-registry kafka-avro-console-producer \
      --bootstrap-server $BOOTSTRAP_SERVERS \
      --producer.config /etc/streambased/etc/aiven_client.properties \
      --topic gamersessions \
      --property schema.registry.url=$SCHEMA_REGISTRY_URL \
      --property basic.auth.credentials.source=USER_INFO \
      --property basic.auth.user.info=$SCHEMA_REGISTRY_USER_INFO \
      --property value.schema='{
          "name": "gamersession",
          "type": "record",
          "fields": [
              { 
                "name":"unindexed_name",
                "type":"string"
              },
              { 
                "name":"name",
                "type":"string"
              },
              { 
                "name":"game",
                "type":"string"
              },
              { 
                "name":"sessionTimeMins",
                "type":"int"
              },
              { 
                "name":"rating",
                "type":"int"
              },
              { 
                "name":"countryCode",
                "type":"string"
              },
              { 
                "name":"isOnlineSession",
                "type":"boolean"
              }
          ]
      }'
```

## Step 5: ensure indexes have been loaded

Streambased builds indexes by consuming from the source topic using a regular consumer group. We can look at the status 
of this consumer group to determine indexes have been loaded.

```bash
  docker-compose exec -T kafka-client kafka-consumer-groups \
    --bootstrap-server $BOOTSTRAP_SERVERS \
    --command-config /etc/streambased/etc/aiven_client.properties \
    --describe --group Streambased-Indexer
```

This group should show 0 lag when all indexes are loaded.

## Step 6: Open superset

Now we can query the collected data and demonstrate the Streambased effect. 

From a web browser navigate to `localhost:8088`. 

## Step 7: Query with Streambased

Next from the menu at the top select `SQL -> SQL Lab`, you will see a familiar SQL query interface. In the query entry 
area add the following:

```
use kafka.streambased;
select * from gamersessions where rating=5;
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

## Step 9: Explore!

Feel free to run other queries against this dataset with or without Streambased acceleration enabled

## Step 10: Tear down

To complete the demo run the following. This will stop and remove all demo resources:

```bash
docker-compose stop
docker-compsoe rm
```

## Summary

In this demo we have introduced Streambased acceleration to a simple topic in Aiven and reaped the benefits in 
adhoc SQL queries against the dataset.
