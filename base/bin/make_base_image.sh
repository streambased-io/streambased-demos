#! /bin/bash

CURR_DIR=`pwd`

cd ../docker/base
docker build -t local/streambased-demo-base:latest .

cd $CURR_DIR