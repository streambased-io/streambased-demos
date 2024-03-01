#! /bin/bash

docker-compose exec kafka1 kafka-topics \
  --bootstrap-server kafka1:9092 \
  --topic finance_markers \
  --if-not-exists \
  --create \
  --partitions 1
docker-compose exec kafka1 kafka-topics \
  --bootstrap-server kafka1:9092 \
  --topic gaming_markers \
  --if-not-exists \
  --create \
  --partitions 1
docker-compose exec kafka1 kafka-topics \
  --bootstrap-server kafka1:9092 \
  --topic healthcare_markers \
  --if-not-exists \
  --create \
  --partitions 1
docker-compose exec kafka1 kafka-topics \
  --bootstrap-server kafka1:9092 \
  --topic manufacturing_markers \
  --if-not-exists \
  --create \
  --partitions 1
docker-compose exec kafka1 kafka-topics \
  --bootstrap-server kafka1:9092 \
  --topic retail_markers \
  --if-not-exists \
  --create \
  --partitions 1
docker-compose exec kafka1 kafka-topics \
  --bootstrap-server kafka1:9092 \
  --topic tech_markers \
  --if-not-exists \
  --create \
  --partitions 1
docker-compose exec kafka1 kafka-topics \
  --bootstrap-server kafka1:9092 \
  --topic transactions \
  --if-not-exists \
  --create \
  --partitions 1


cat data/Finance.avsc | docker-compose exec -T schema-registry tee -a Finance.avsc
cat data/Gaming.avsc | docker-compose exec -T schema-registry tee -a Gaming.avsc
cat data/Healthcare.avsc | docker-compose exec -T schema-registry tee -a Healthcare.avsc
cat data/Manufacturing.avsc | docker-compose exec -T schema-registry tee -a Manufacturing.avsc
cat data/Retail.avsc | docker-compose exec -T schema-registry tee -a Retail.avsc
cat data/Tech.avsc | docker-compose exec -T schema-registry tee -a Tech.avsc
cat data/transactions.avsc | docker-compose exec -T schema-registry tee -a transactions.avsc


tar -xvzf data/transactions.tar.gz -C data
cat data/transactions.txt |
    docker-compose exec -T schema-registry kafka-avro-console-producer \
      --bootstrap-server kafka1:9092 \
      --topic transactions \
      --producer-property linger.ms=10 \
      --producer-property batch.size=1000 \
      --property schema.registry.url=http://schema-registry:8081 \
      --property value.schema.file=transactions.avsc

#for a in {1..10}
#do
cat data/Finance.json |
    docker-compose exec -T schema-registry kafka-avro-console-producer \
      --bootstrap-server kafka1:9092 \
      --topic finance_markers \
      --property schema.registry.url=http://schema-registry:8081 \
      --property value.schema.file=Finance.avsc
cat data/Gaming.json |
    docker-compose exec -T schema-registry kafka-avro-console-producer \
      --bootstrap-server kafka1:9092 \
      --topic gaming_markers \
      --property schema.registry.url=http://schema-registry:8081 \
      --property value.schema.file=Gaming.avsc
cat data/Healthcare.json |
    docker-compose exec -T schema-registry kafka-avro-console-producer \
      --bootstrap-server kafka1:9092 \
      --topic healthcare_markers \
      --property schema.registry.url=http://schema-registry:8081 \
      --property value.schema.file=Healthcare.avsc
cat data/Manufacturing.json |
    docker-compose exec -T schema-registry kafka-avro-console-producer \
      --bootstrap-server kafka1:9092 \
      --topic manufacturing_markers \
      --property schema.registry.url=http://schema-registry:8081 \
      --property value.schema.file=Manufacturing.avsc
cat data/Retail.json |
    docker-compose exec -T schema-registry kafka-avro-console-producer \
      --bootstrap-server kafka1:9092 \
      --topic retail_markers \
      --property schema.registry.url=http://schema-registry:8081 \
      --property value.schema.file=Retail.avsc
cat data/Tech.json |
    docker-compose exec -T schema-registry kafka-avro-console-producer \
      --bootstrap-server kafka1:9092 \
      --topic tech_markers \
      --property schema.registry.url=http://schema-registry:8081 \
      --property value.schema.file=Tech.avsc
#done