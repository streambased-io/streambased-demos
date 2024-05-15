#! /bin/bash

CURR_DIR=`pwd`
PART_FILE=$CURR_DIR/retailDemo_docker-compose.part
OUT_FILE=$CURR_DIR/docker-compose.yml



cd ../base/bin
echo "Creating docker-compose.yml..."
./make_docker_compose.sh $PART_FILE $OUT_FILE false
echo "Creating docker base image..."
./make_base_image.sh

echo "setup complete"

cd $CURR_DIR
