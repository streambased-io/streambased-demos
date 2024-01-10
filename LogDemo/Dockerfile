FROM ubuntu:jammy

RUN apt-get update && apt-get install -y --no-install-recommends openjdk-17-jdk openjdk-17-jre curl
RUN curl -O https://downloads.apache.org/kafka/3.6.1/kafka_2.13-3.6.1.tgz
RUN tar xzf kafka_2.13-3.6.1.tgz