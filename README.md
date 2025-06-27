# Streambased Demos

This repository holds public demos of Streambased technology. This repo simulates business and architectural problems 
common with modern data infrastrcture and demonstrates how Streambased technology can be applied to them.

## The Cases

Each business/architectural case is documented in it's own directory in `/cases/`. Each directory has a README that 
will explain the case further.

## Executing a case

To execute a demo run:

```bash
./bin/start.sh [case directory name e.g. 1_slow_data ]
```

Then follow the steps from the README in the `/cases/[case name]` directory

## Demo Cases

This repository holds the following cases:

1. Slow Data - What is the e2e latency of your data? By this we mean after a datapoint is created, how long does it
   take for it to be available for analytics? Hours? Days? Weeks? If it's larger than zero you need
   Streambased.
2. Real-time FOMO - Are your competitors benefiting from datasets you can't see? Real-time data powers the world but
   only a fraction of it is available for analytics. If you want the full, current view of the data
   inside your business you need Streambased.
3. Kafka is a Black Box - Kafka is opaque! Messages go in and messages come out but what happens in the middle is largely
   invisible. How do you find that poison pill? How do you know which is the bad actor client? How do
   you assemble usage reports for billing? Streambased opens the box and shines a light on your Kafka
   data.
4. Two Generals - The two generals problem https://en.wikipedia.org/wiki/Two_Generals%27_Problem is a popular CS
   exercise where two actors must make a decision (whether to attack) based on potentially different
   information sets. This exercise is played out daily in your data estate with the operational
   general (in charge of online apps) and the analytical general (in charge of offline) working on
   different views of the world. As the emperor, which of these you do you trust when they advise
   different things? With Streambased there is only one source of truth and a consistent view for
   both online and offline workloads.
5. Making Kafka do Batch - I have an external customer who's specced a daily batch fetch job for my data. The data is in Kafka,
   how do I give to them?
6. Introducing Iceberg - This all in one demos shows the entire Streambased product suite including Kafka as a 
   filesystem, Kafka as Iceberg and Kafka directly to BI tools.