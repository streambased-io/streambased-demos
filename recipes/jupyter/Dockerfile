FROM ubuntu:jammy

RUN apt-get update && apt-get install -y --no-install-recommends python3-pip git build-essential python3-dev
RUN pip install "numpy<1.24"
RUN pip install jupyterlab
RUN pip install jupysql
RUN pip install sqlalchemy-trino
RUN pip install pandas
RUN pip install Cython
RUN pip install -U git+https://github.com/scikit-multiflow/scikit-multiflow

ENTRYPOINT jupyter lab --ip='*' --port=8888 --no-browser --NotebookApp.token='Streambased' --allow-root