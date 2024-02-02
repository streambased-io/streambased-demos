FROM ubuntu:jammy

RUN apt-get update && apt-get install -y --no-install-recommends python3-pip
RUN pip install jupyterlab
RUN pip install jupysql
RUN pip install sqlalchemy-trino
RUN pip install pandas

ENTRYPOINT jupyter lab --ip='*' --port=8888 --no-browser --NotebookApp.token='Streambased' --allow-root