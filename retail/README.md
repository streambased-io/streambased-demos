# Streambased Retail Demo

## What does this demo do?

## Step 1: Setup and review the environment

First run the setup script, this will configure the resources for the demo.

```bash
./bin/setup.sh
```

Our environment consists of the following components:

1. A single node Kafka cluster (containers kafka1 and zookeeper) - for data storage
2. A Schema Registry - for governance
4. Streambased Server - to make the Kafka data available via JDBC
5. Superset - a popular and easy to use database client

## Step 2: Start the environment

To bring up the environment run:

```bash
docker-compose up -d
```

## Step 3: Create the topics

We use single partition topics because the data size is so small

```bash
docker-compose exec kafka1 kafka-topics --bootstrap-server kafka1:9092 --topic truck --create
docker-compose exec kafka1 kafka-topics --bootstrap-server kafka1:9092 --topic store --create
docker-compose exec kafka1 kafka-topics --bootstrap-server kafka1:9092 --topic item --create
docker-compose exec kafka1 kafka-topics --bootstrap-server kafka1:9092 --topic delivery --create
docker-compose exec kafka1 kafka-topics --bootstrap-server kafka1:9092 --topic sale --create
```



## Summary

In this demo we have introduced Streambased acceleration to a simple log collection pipeline and reaped the benefits in 
adhoc SQL queries against the log dataset.
