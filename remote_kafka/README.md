# Streambased Confluent Cloud Demo

## What does this demo do?

This demo demonstrates the acceleration that Streambased can provide for an existing data set held in managed Kafka. 
In this case our dataset is held in Confluent Cloud.

Note: We provide some very restricted credentials for access to this dataset. No SLA is provided for access to this 
data and no optimisation has been done on the dataset hosted.

## Step 1: Setup and review the environment

Let's take a look at our environment, it consists of the following components:

1. Streambased Server - our wonder tool to make the Kafka data available via SQL/JDBC
2. Superset - a popular and easy to use database client

## Step 2: Start the environment

To bring up the environment run:

```bash
docker-compose up -d
```

## Step 3: Open superset

Now we can query the collected data and demonstrate the Streambased effect. 

From a web browser navigate to `localhost:8088`.

Log in with credentials `admin:admin`

## Step 4: Explore the data with Streambased

Next from the menu at the top select `SQL -> SQL Lab`, you will see a familiar SQL query interface. We can use this 
interface to perform many of the common Kafka tasks that would normally require specialist tooling:

Listing topics:

```bash
use kafka.streambased;
show tables;
```

See how many messages are on a topic:

```bash
select count(*) from demo_transactions;
```

and see a topic structure:

```bash
describe demo_transactions;
```

This is a much easier to use interface with far less risky than the overly powerful console tools.

## Step 6: Fetch some data

Now let's perform a common task, fetching the details for a single transaction:

```
use kafka.streambased;
select * from demo_transactions where transactionid='1234-1234-1234-1234';
```

and click `RUN`

Streambased indexing drastically reduces the amount of data required to be read from Confluent for this query, 
increasing performance and lowering costs. 

## Step 7: Compare with no Streambased acceleration

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

## Step 8: A more complex query.

The Streambased server contains a fully features SQL engine that can handle even the most complex of queries. Let's 
run something more exciting and get the total of transactions for deposit grouped by account type:

```
select 
    a.accounttype, 
    count(t.transactionamount) as deposit_count, 
    sum(t.transactionamount) as deposit_total 
from 
    demo_transactions t 
join 
    demo_accounts a 
on 
    t.accountId = a.accountId 
where 
    t.transactiontype='Deposit' group by accounttype;
```

## Step 9: Explore

Feel free to run other queries against this dataset with or without Streambased acceleration enabled.

## Step 7: Tear down

To complete the demo run the following. This will stop and remove all demo resources:

```bash
docker-compose stop
docker-compsoe rm
```

## Summary

In this demo we have introduced Streambased acceleration to a data set hosted in Confluent Cloud and executed
adhoc SQL queries against the dataset.
