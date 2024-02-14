# Streambased Recipes Demo

## What does this demo do?

This demo shows an example use case for Streambased in the Data Science world. The aim is to create a classifier that 
can determine the cuisine of a recipe from it's ingredients.

We have a sample dataset loaded onto the `recipes` topic and will use it in Jupyter to build our classifier. We will 
then apply this classifier to real time data on the `ingredients` topic


## Step 1: Setup and review the environment

First run the setup script, this will configure the resources for the demo.

```bash
./bin/setup.sh
curl https://streambased-demo.s3.eu-north-1.amazonaws.com/recipes.json -o data/recipes.json
```

Our environment consists of the following components:

1. A single node Kafka cluster (containers kafka1 and zookeeper) - for data storage
2. A Schema Registry - for governance
3. Streambased Indexer - to create the indexes Streambased uses to be fast
4. Streambased Server - to make the Kafka data available via JDBC
5. Jupyter - a node with Jupyter Lab installed

## Step 2: Start the environment

To bring up the environment run:

```bash
docker-compose up -d
```

## Step 3: Create Topics

Let's create the Kafka topics we need for this demo. `recipes` will store our source data, a pre prepared set of 
detail around sessions gamers have played on titles on Steam

```bash
docker-compose exec kafka1 kafka-topics \
  --bootstrap-server kafka1:9092 \
  --topic recipes \
  --create \
  --partitions 1
```

## Step 4: Populate our data

Let's fill the recipes topic with data:

First we must create a schema for the recipes. As you can see, this contains a field for every type of ingredient we 
are looking for.

```bash
cat data/recipes.avsc | docker-compose exec -T schema-registry tee -a recipes.avsc
```

All of the ingredient columns are `int` types with 1 signifying the ingredient is used and 0 signifying it is not. 

There are 2 more columns, the cuisine of the recipe and a rating between 0 and 5.

```bash
cat data/recipes.json |
    docker-compose exec -T schema-registry kafka-avro-console-producer \
      --bootstrap-server kafka1:9092 \
      --topic recipes \
      --property schema.registry.url=http://schema-registry:8081 \
      --property value.schema.file=recipes.avsc
```

## Step 5: Explore the data

Head over to the Jupyter Lab at `localhost:8888`. Use password `Streambased`

Run the following:

```text
%load_ext sql
%sql trino://streambased-server:8080/kafka
%sql SELECT * FROM kafka.streambased.recipes WHERE rating = 5 LIMIT 10
```

## Step 6: Performing Data Modelling and Prediction

Once the data has been retrieved from the query, the next step involves data modeling and prediction using machine learning algorithms. To facilitate this process, two files have been provided:

1. **modelling.ipynb**: This Jupyter Notebook contains the code for data modeling. It includes various machine learning algorithms and techniques to analyze the data, build models, and evaluate their performance.

2. **predictor.ipynb**: This Jupyter Notebook is responsible for making predictions based on the models created in the modeling phase. It takes input data and applies the trained models to generate predictions.

These files are located under the `code` directory and can be executed sequentially to perform data modeling and prediction tasks.


## Step 7: Tear down

To complete the demo run the following. This will stop and remove all demo resources:

```bash
docker-compose stop
docker-compsoe rm
```

## Summary

In this demo we created a classifier using Streambased and applied it to some input data.
