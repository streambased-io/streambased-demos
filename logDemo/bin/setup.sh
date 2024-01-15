#! /bin/bash

CURR_DIR=`pwd`
PART_FILE=$CURR_DIR/logDemo_docker-compose.part
OUT_FILE=$CURR_DIR/docker-compose.yml

cd ../../base/bin
./make_docker_compose.sh $PART_FILE $OUT_FILE

cd $CURR_DIR
