# Demo of Iceberg cold + hot set union where cold set is served from physical S3 compatible filesystem (MinIo in this case) and hot set is a virtual Iceberg view over Kafka.

## Steps

### Content of this example
The example - docker-compose and configuration files are prepared for starting a self-contained demo instance with following services:
- `directstream` - Streambased Iceberg catalog and storage gateway - serves virtual Iceberg / hot-set
- `spark-iceberg` - spark instance with iceberg libraries - has spark SQL, console and Jupyter.
- `zookeper`, `kafka`, `schema-registry` - Kafka infrastructure
- `shadowtraffic` - demo data producer
- `minio` and `mc` physical S3 compatible filesystem for cold-set
- `iceberg-rest` - simple Rest Iceberg catalog for cold-set

### Step 1: Start the environment

To start the environment run:

```bash
./bin/start.sh 9_Iceberg_Union
```

### Step 2: Open PySpark Notebook
Open [demo steps in notebook](http://localhost:8888/notebooks/notebooks/ISK-union.ipynb) 

### Additional tools

- For Kafka topic checks / manipulation AKHQ at http://locahost:9090
- For spark job execution - spark console on http://localhost:4041 and have a look at job planning, execution etc. - note that port might be different but in range of 4040-4050.
- Minio UI at http://localhost:9001 with `admin` / `password` credentials

### Shutting down

To stop the environment run:

```bash
./bin/stop.sh
```