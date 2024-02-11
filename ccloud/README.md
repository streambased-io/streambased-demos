# Streambased Confluent Cloud Demo

## What does this demo do?

This demo demonstrates the acceleration that Streambased can provide for an existing data set held in managed Kafka. 
In this case our dataset is held in Confluent Cloud.

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

## Step 3: ensure indexes have been loaded

You can use the Streambased REST API to determine whether indexes have been loaded for our cloud dataset. Query this 
API using the command below:

```bash
curl localhost:8084/surfboards/customers_name/customers/0
```

You should see an output ending something like this:

```
...
"859276-860275","86000-86999","860276-861275","861276-862275","862276-863275","863276-864275","864276-865275","865276-866275",
"866276-867275","867276-868275","868276-869275","869276-870275","87000-87999","870276-871275","871276-872275","872276-873275",
"873276-874275","874276-875275","875276-876275","876276-877275","877276-878275","878276-879275","879276-880275","88000-88999",
"880276-881275","881276-882275","882276-883275","883276-884275","884276-885275","885276-886275","886276-887275","887276-888275",
"888276-889275","889276-890275","89000-89999","890276-891275","891276-892275","892276-893275","893276-894275","894276-895275",
"895276-896275","896276-897275","897276-898275","898276-899275","9000-9999","90000-90999","91000-91999","92000-92999",
"93000-93999","94000-94999","95000-95999","96000-96999","97000-97999","98000-98999","99000-99999"]
```

Note: depending on your proximity to the Kafka environment (located in California) it can take up to 90 seconds for the 
index server to load.

## Step 5: Open superset

Now we can query the collected data and demonstrate the Streambased effect. 

From a web browser navigate to `localhost:8088`. 

## Step 6: Query with Streambased

Next from the menu at the top select `SQL -> SQL Lab`, you will see a familiar SQL query interface. In the query entry 
area add the following:

```
use kafka.streambased;
select * from customers where name='TOM SCOTT';
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

In this demo we have introduced Streambased acceleration to a simple topic in Confluent Cloud and reaped the benefits in 
adhoc SQL queries against the dataset.
