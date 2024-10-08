# Using Streambased to query Conduktor Gateway audit logs

This demo set up a simple environment using Conduktor Gateway and generates some audit messages around actions performed 
through the Gateway. We then use Streambased to query these logs using a simple SQL interface via JDBC.

## Step 1: Setup

Start the environment as follows:

```
docker-compose up -d
```

## Step 2: Generate some test audit events

### 1. Generate virtual cluster teamA with service account sa

```
token=$(curl \
--request POST "http://localhost:8888/admin/vclusters/v1/vcluster/teamA/username/sa" \
--header 'Content-Type: application/json' \
--user 'admin:conduktor' \
--silent \
--data-raw '{"lifeTimeSeconds": 7776000}' | jq -r ".token")
```

### 2. Create access file

```
echo  """
bootstrap.servers=localhost:6969
security.protocol=SASL_PLAINTEXT
sasl.mechanism=PLAIN
sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username='sa' password='$token';
""" > kafka/teamA-sa.properties
```

### 3. Create a safeguarding interceptor

```
curl  --request POST "http://localhost:8888/admin/interceptors/v1/vcluster/teamA/interceptor/guard-on-produce" \
--header 'Content-Type: application/json' \
--user 'admin:conduktor' \
--silent \
--data '{
    "pluginClass": "io.conduktor.gateway.interceptor.safeguard.ProducePolicyPlugin",
    "priority": 100,
    "config": {
        "acks": {
            "value": [
                -1
            ],
            "action": "BLOCK"
        },
        "compressions": {
            "value": [
                "NONE",
                "GZIP"
            ],
            "action": "BLOCK"
        }
    }
}'

curl --request GET 'http://localhost:8888/admin/interceptors/v1/vcluster/teamA' \
  --header 'Content-Type: application/json' \
  --user 'admin:conduktor' \
  --silent | jq
```

### 4. Generate audited actions

```
docker-compose exec kafka1 kafka-topics \
  --bootstrap-server gateway:6969 \
  --command-config /tmp/kafka/teamA-sa.properties \
  --replication-factor 1 \
  --partitions 1 \
  --create \
  --if-not-exists \
  --topic cars

docker-compose exec kafka1 /bin/sh -c 'echo {"type":"Fiat","color":"red","price":-1} | kafka-console-producer \
  --bootstrap-server gateway:6969 \
  --producer.config /tmp/kafka/teamA-sa.properties \
  --request-required-acks 1 \
  --compression-codec snappy \
  --topic cars'
```

## Step 3: Use Streambased to evaluate events

We can now connect Streambased to the cluster and use generic SQL to query the audit log.

### 1. Create a schema

Gateway audit logs are not written with a schema, we must impose one to generate a table=like structure

```
docker-compose exec kafka1 curl -X POST -H "Content-Type: application/vnd.schemaregistry.v1+json" schema-registry:8081/subjects/_conduktor_gateway_auditlogs-value/versions -d '{"schema":"{\"type\": \"object\",\"properties\": {\"id\": {\"type\": \"string\"},\"source\": {\"type\": \"string\"},\"type\": {\"type\": \"string\"},\"authenticationPrincipal\": {\"type\": \"string\"},\"userName\": {\"type\": \"string\"},\"connection\": {\"type\": \"object\",\"properties\": {\"localAddress\": {\"type\": \"string\"},\"remoteAddress\": {\"type\": \"string\"}}},\"specVersion\": {\"type\": \"string\"},\"time\": {\"type\": \"string\"},\"eventData\": {\"type\": \"object\",\"properties\": {\"level\": {\"type\": \"string\"},\"plugin\": {\"type\": \"string\"},\"message\": {\"type\": \"string\"}}}}}","schemaType": "JSON"}'
```
### 2. Query from Superset

This demo includes the open source Superset client but any JDBC/ODBC/SQL Alchemy based tool can be used to connect to #
Streambased.

Access it from `localhost:8088` with credentials `admin:admin` and navigate to SQL -> SQL Lab.

Running the following will show the audit log records:

```
select * from _conduktor_gateway_auditlogs;
```

## Step 4: Streambased acceleration

Streambased can accelerate queries with filters. Unfortunately we cannot see this effect on the tiny amount of records 
we have so far, and it is impractical to generate enough events to demo this functionality using the method we have used 
previously. Instead, we will start a data generator (Shadowtraffic) to generate 1m+ events of a similar structure to the 
audit logs Generated by Gateway

```
docker-compose up -d shadowtraffic
```

Streambased will index fields in the background in order to make queries faster, an example of the configuration 
involved in this can be found in `serverConfig/client.properties`:

```
indexed.topics=_conduktor_gateway_auditlogs

indexed.topics._conduktor_gateway_auditlogs.extractor.class=io.streambased.index.extractor.JsonValueFieldsExtractor
indexed.topics._conduktor_gateway_auditlogs.grouping.fields=type
indexed.topics._conduktor_gateway_auditlogs.aggregate.fields=type

indexed.topics._conduktor_gateway_auditlogs.field.id.type=STRING
indexed.topics._conduktor_gateway_auditlogs.field.id.jsonpath=$.id

indexed.topics._conduktor_gateway_auditlogs.field.eventdata_level.type=STRING
indexed.topics._conduktor_gateway_auditlogs.field.eventdata_level.jsonpath=$.eventData.level

indexed.topics._conduktor_gateway_auditlogs.field.type.type=STRING
indexed.topics._conduktor_gateway_auditlogs.field.type.jsonpath=$.type

indexed.topics._conduktor_gateway_auditlogs.field.username.type=STRING
indexed.topics._conduktor_gateway_auditlogs.field.username.jsonpath=$.userName
```

Now when running queries filtered by these fields we see results produced fast: 

```
select * from _conduktor_gateway_auditlogs where eventdata_level='error';
```

to compare these to an unaccelerated query we can disable Streambased as below:

```
set session use_streambased=false;
```

typically queries run 10x-30x slower in this mode, to re-enable acceleration just run:

```
set session use_streambased=true;
```

## Step 5: explore!

Feel free to explore this dataset or to edit the connection properties in `client.properties` to point the demo to your 
own data.


