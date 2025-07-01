FROM apache/superset:4.1.2

USER root

RUN apt update && apt install -y pkg-config gcc python3-dev default-libmysqlclient-dev build-essential
RUN pip install trino mysqlclient pyecharts
ENV ADMIN_USERNAME $ADMIN_USERNAME
ENV ADMIN_EMAIL $ADMIN_EMAIL
ENV ADMIN_PASSWORD $ADMIN_PASSWORD

COPY ./superset-init.sh /superset-init.sh
COPY ./add_database.sh /add_database.sh

COPY superset_config.py /app/
ENV SUPERSET_CONFIG_PATH /app/superset_config.py

USER superset
ENTRYPOINT [ "/superset-init.sh" ]