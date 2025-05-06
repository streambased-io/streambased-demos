#! /bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# start services
cd $SCRIPT_DIR/../environment
docker-compose stop
docker-compose rm

# clean dirs
if [ -d "$SCRIPT_DIR/../environment/shadowtraffic" ]
then
    rm -rf $SCRIPT_DIR/../environment/shadowtraffic
fi
if [ -d "$SCRIPT_DIR/../environment/streambased" ]
then
    rm -rf $SCRIPT_DIR/../environment/streambased
fi
if [ -d "$SCRIPT_DIR/../environment/scripts" ]
then
    rm -rf $SCRIPT_DIR/../environment/scripts
fi
rm -rf $SCRIPT_DIR/../environment/pipeline/*
if [ -d "$SCRIPT_DIR/../environment/pipeline" ]
then
    rm -rf $SCRIPT_DIR/../environment/pipeline
fi

