FROM apache/superset:latest

USER root

RUN apt update
RUN apt install -y jq
RUN pip install trino

ARG NODE_VERSION="20"
ARG ALPINE_VERSION="3.20"

ENV ADMIN_USERNAME $ADMIN_USERNAME
ENV ADMIN_EMAIL $ADMIN_EMAIL
ENV ADMIN_PASSWORD $ADMIN_PASSWORD

COPY ./superset-init.sh /superset-init.sh
COPY ./add_database.sh /add_database.sh

COPY superset_config.py /app/
ENV SUPERSET_CONFIG_PATH /app/superset_config.py

USER superset
ENTRYPOINT [ "/superset-init.sh" ]