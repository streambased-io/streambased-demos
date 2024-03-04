s# Streambased Verticals Demo

## What does this demo do?

This demo shows an example use case for Streambased in the Data Science world. The aim is to create a classifier that 
can determine the class of a row once trained by a dataset from a particular vertical.

We have a sample dataset loaded onto the `finance_markers` topic and will use it in Jupyter to build our classifier. We will 
then apply this classifier to real time data.


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
5. Jupyter - a node with Jupyter Lab installed
6. Superset - a node with Superset installed

## Step 2: Start the environment

To bring up the environment run:

```bash
docker-compose up -d
```

## Step 4: Populate our data

```bash
bin/load_data.sh
```

## Step 5: Explore the data

Head over to the Jupyter Lab at `localhost:8888`. Use password `Streambased`

Run the following:

```text
%load_ext sql
%sql trino://streambased-server:8080/kafka
%sql SELECT * FROM kafka.streambased.finance_markers WHERE rating = 5 LIMIT 10
```

Or head over to Superset at `localhost:8088`. Use credentials `admin:admin`

```text
USE kafka.streambased;
SET SESSION use_streambased = true;
SELECT * from finance_markers where investigationState = 'Complete';
```


## Step 6: Performing Data Modelling and Prediction

Once the data has been retrieved from the query, the next step involves data modeling and prediction using machine learning algorithms. To facilitate this process, two files have been provided:

1. **modelling.ipynb**: This Jupyter Notebook contains the code for data modeling. It includes various machine learning algorithms and techniques to analyze the data, build models, and evaluate their performance.

2. **predictor.ipynb**: This Jupyter Notebook is responsible for making predictions based on the models created in the modeling phase. It takes input data and applies the trained models to generate predictions.

3. **verticalSets.ipynb**: This Jupyter Notebook holds variables for configuring the different vertical datasets.

These files are located under the `notebooks` directory and can be executed sequentially to perform data modeling and prediction tasks.

## Step 7: Tear down

To complete the demo run the following. This will stop and remove all demo resources:

```bash
docker-compose stop
docker-compsoe rm
```

## Summary

In this demo we created a classifier using Streambased and applied it to some input data.
