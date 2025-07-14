FROM ubuntu:jammy

RUN apt-get update && apt-get install -y --no-install-recommends python3-pip build-essential python3-dev curl
RUN pip install jupyterlab
RUN pip install jupysql
RUN pip install duckdb
RUN pip install duckdb-engine
RUN pip install pandas
RUN pip install numpy scipy scikit-learn matplotlib
RUN pip install pyiceberg

ENTRYPOINT jupyter lab --ip='*' --port=8889 --no-browser --NotebookApp.token='Streambased' --allow-root