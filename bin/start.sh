#! /bin/bash

DEMO_DIR=$1

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# clean dirs
if [ -d "$SCRIPT_DIR/../environment/shadowtraffic" ]
then
    rm -rf $SCRIPT_DIR/../environment/shadowtraffic
fi
mkdir -p $SCRIPT_DIR/../environment/shadowtraffic
if [ -d "$SCRIPT_DIR/../environment/streambased" ]
then
    rm -rf $SCRIPT_DIR/../environment/streambased
fi
mkdir -p $SCRIPT_DIR/../environment/streambased
if [ -d "$SCRIPT_DIR/../environment/scripts" ]
then
    rm -rf $SCRIPT_DIR/../environment/scripts
fi
mkdir -p $SCRIPT_DIR/../environment/scripts
rm -rf $SCRIPT_DIR/../environment/pipeline/*
if [ -d "$SCRIPT_DIR/../environment/pipeline" ]
then
    rm -rf $SCRIPT_DIR/../environment/pipeline
fi
mkdir -p $SCRIPT_DIR/../environment/pipeline


# fetch shadowtraffic license
curl  https://raw.githubusercontent.com/ShadowTraffic/shadowtraffic-examples/refs/heads/master/free-trial-license.env > $SCRIPT_DIR/../environment/shadowtraffic/license.env

# copy in config files
cp $SCRIPT_DIR/../cases/$DEMO_DIR/client.properties $SCRIPT_DIR/../environment/streambased
cp $SCRIPT_DIR/../cases/$DEMO_DIR/datagen.json $SCRIPT_DIR/../environment/shadowtraffic
if [ -f "$SCRIPT_DIR/../cases/$DEMO_DIR/connector.json" ]
then
  cp $SCRIPT_DIR/../cases/$DEMO_DIR/connector.json $SCRIPT_DIR/../environment/scripts/connector.json
fi
if [ -f "$SCRIPT_DIR/../cases/$DEMO_DIR/external.sh" ]
then
  cp $SCRIPT_DIR/../cases/$DEMO_DIR/external.sh $SCRIPT_DIR/../environment/scripts/external.sh
fi

# start services
cd $SCRIPT_DIR/../environment
docker-compose stop
docker-compose rm
docker-compose up -d --build
