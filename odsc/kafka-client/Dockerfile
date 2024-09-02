FROM confluentinc/cp-kafka:7.5.0

USER root

RUN yum install -y vim

COPY client.properties /home/appuser/client.properties

USER appuser

CMD sleep infinity