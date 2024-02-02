# Streambased Dbt Demo

## What does this demo do?

This demo shows a simple integration of DBT with Streambased. We will configure a Streambased Server with DBT and a 
simple model to extract some data from Kafka

## Step 1: Setup and review the environment

First run the setup script, this will configure the resources for the demo.

```bash
./bin/setup.sh
```

Our environment consists of the following components:

1. A single node Kafka cluster (containers kafka1 and zookeeper) - for data storage
2. A Schema Registry - for governance
3. Streambased Indexer - to create the indexes Streambased uses to be fast
4. Streambased Server - to make the Kafka data available via JDBC
5. DBT - a node with DBT packages installed
6. kafka-client - a node with Kafka client libraries installed

## Step 2: Start the environment

To bring up the environment run:

```bash
docker-compose up -d
```

## Step 3: Create Topics

Let's create the Kafka topics we need for this demo. `gamerSessions` will store our source data, a pre prepared set of 
detail around sessions gamers have played on titles on Steam

```bash
docker-compose exec kafka1 kafka-topics \
  --bootstrap-server kafka1:9092 \
  --topic gamersessions \
  --create \
  --partitions 1
```

## Step 4: Populate our data

Let's fill the gamerSessions topic with data:

```bash
cat data/gamersessions.txt |
    docker-compose exec -T schema-registry kafka-avro-console-producer \
      --bootstrap-server kafka1:9092 \
      --topic gamersessions \
      --property schema.registry.url=http://schema-registry:8081 \
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

## Step 5: Create a DBT project

We create a new DBT project in our dbt container:

```bash
docker-compose exec dbt dbt init
``` 

enter the project name: `streambased_dbt` and choose the `trino` database

## Step 6: Create a profile

Next we define how DBT connects to Streambased, for simplicity we have included a pre-configured profile with this demo:

```yaml
streambased_dbt:
  target: dev
  outputs:
    dev:
      type: trino
      method: none
      user: e30=
      database: kafka
      host: localhost
      port: 8080
      schema: streambased
      threads: 1
```

let's copy it into our new project

```bash
docker compose exec dbt cp /etc/dbtConfig/profiles.yml streambased_dbt
```

## Step 7: Create a model

Now let's run some SQL, again we have included a sample model with a simple query in this demo:

```roomsql
SELECT * FROM kafka.streambased.gamersessions WHERE name = 'HUGH PRUE-GEORGE'
```

As with the profile we can copy it into our project

```bash
docker-compose exec dbt cp /etc/dbtConfig/src_gamersessions.sql streambased_dbt/models
```

## Step 8: Select some data

Now let's ask DBT to simulate a run and show us what the output would be:

```bash
docker-compose exec --workdir /streambased_dbt dbt dbt show --select models/src_gamersessions.sql
```

You should see something like the below:

```bash
/streambased-demos/dbt$ docker-compose exec --workdir /streambased_dbt dbt dbt show --select models/src_gamersessions.sql
18:08:11  Running with dbt=1.7.6
18:08:12  Registered adapter: trino=1.7.1
18:08:12  Found 3 models, 4 tests, 0 sources, 0 exposures, 0 metrics, 421 macros, 0 groups, 0 semantic models
18:08:12  
18:08:13  Concurrency: 1 threads (target='dev')
18:08:13  
18:08:17  Previewing node 'src_gamersessions':
| unindexed_name   | name             | game           | sessiontimemins | rating | countrycode | ... |
| ---------------- | ---------------- | -------------- | --------------- | ------ | ----------- | --- |
| HUGH PRUE-GEORGE | HUGH PRUE-GEORGE | Lilith Odyssey |              17 |      4 | TV          | ... |
| HUGH PRUE-GEORGE | HUGH PRUE-GEORGE | Dismantled     |             103 |      4 | KN          | ... |

```

## Step 9: Explore!

Feel free to add models and build this demo into a more complex pipeline

## Step 10: Tear down

To complete the demo run the following. This will stop and remove all demo resources:

```bash
docker-compose stop
docker-compsoe rm
```

## Summary

In this demo we used DBT to access a dataset in Kafka by leveraging Streambased. We also took advantage of Streambased 
acceleration to enable interactive speed access to this dataset
