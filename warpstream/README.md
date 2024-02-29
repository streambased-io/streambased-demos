# Streambased Warpstream Demo

## What does this demo do?

This demo demonstrates the acceleration that Streambased can provide for an existing data set held in managed Kafka. 
In this case our dataset is held in Warpstream.

Note: We provide some very restricted credentials for access to this dataset. No SLA is provided for access to this 
data and no optimisation has been done on the dataset hosted.

## Step 1: Setup and review the environment

First run the setup script, this will configure the resources for the demo.

```bash
./bin/setup.sh
```

Our environment consists of the following components:

1. Streambased Indexer - to create the indexes Streambased uses to be fast
2. Streambased Server - to make the Kafka data available via JDBC
3. Superset - a popular and easy to use database client

## Step 2: Start the environment

To bring up the environment run:

```bash
docker-compose up -d
```

## Step 3: Open superset

Now we can query the collected data and demonstrate the Streambased effect. 

From a web browser navigate to `localhost:8088`. 

Log in with credentials `admin:admin`

## Step 4: Query with Streambased

Next from the menu at the top select `SQL -> SQL Lab`, you will see a familiar SQL query interface. In the query entry 
area add the following:

```
use kafka.streambased;
select * from customers where name='TOM SCOTT';
```

and click `RUN`

## Step 5: Compare with no Streambased acceleration

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

## Step 6: Explore!

Feel free to run other queries against this dataset with or without Streambased acceleration enabled

## Step 7: Tear down

To complete the demo run the following. This will stop and remove all demo resources:

```bash
docker-compose stop
docker-compsoe rm
```

## Summary

In this demo we have introduced Streambased acceleration to a data set hosted in Warpstream 
adhoc SQL queries against the customers dataset.
