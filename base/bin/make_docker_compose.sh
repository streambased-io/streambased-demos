#! /bin/bash

# This script builds a docker-compose from the base .part file and a supplied demo .part file

if [[ $# -ne 3 ]]; then
    echo "This script requires 2 parameters: <demo part file> <output file>"
    exit 1
fi

# first arg is the demo .part file
DEMO_PART=$1

# second arg is the output file
OUTPUT_FILE=$2

# third argument is ignore base
IGNORE_BASE=$3

# headers first
echo "version: '3.7'" > $OUTPUT_FILE
echo "services:" >> $OUTPUT_FILE

# now base
echo "ignoring base: $IGNORE_BASE"
if [[ "$IGNORE_BASE" == "false" ]]; then
  cat ../conf/base_docker-compose.part >> $OUTPUT_FILE
fi

# now demo
cat $DEMO_PART >> $OUTPUT_FILE

exit 0
