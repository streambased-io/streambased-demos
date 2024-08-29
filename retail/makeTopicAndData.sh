
#MESSAGE_VAL='{ "unnested": "message-0", "level0": [ { "nested": "nested-string", "level1": [ {  "l1-string": "{{uniqId}}",  "l1-boolean": true,  "l1-long": 11,  "l1-double": 11.11 } ] } ] }'
#echo $MESSAGE_VAL | sed -e "s/{{uniqId}}/1234-1234-1234-1234/g" > /tmp/data.json
#for a in {0..100000}
#do
#  echo $MESSAGE_VAL | sed -e "s/{{uniqId}}/$RANDOM-$RANDOM-$RANDOM-$RANDOM/g" >> /tmp/data.json
#done

docker-compose exec kafka1 kafka-topics --bootstrap-server kafka1:9092 --create --topic nested --replication-factor 1 --partitions 1

cat /tmp/data.json |
    docker-compose exec -T schema-registry kafka-json-schema-console-producer \
      --bootstrap-server kafka1:9092 \
      --topic nested \
      --property schema.registry.url=http://schema-registry:8081 \
      --property value.schema='{
    "$schema": "http://json-schema.org/draft-04/schema#",
    "type": "object",
    "properties": {
        "unnested": {
            "type": "string"
        },
        "level0": {
            "type": "array",
            "items": {
                "type": "object",
                "properties": {
                    "nested": {
                        "type": "string"
                    },
                    "level1": {
                        "type": "array",
                        "items": {
                            "type": "object",
                            "properties": {
                                "l1-string": {
                                    "type": "string"
                                },
                                "l1-boolean": {
                                    "type": "boolean"
                                },
                                "l1-long": {
                                    "type": "integer"
                                },
                                "l1-double": {
                                    "type": "number"
                                }
                            },
                            "required": [
                                "l1-string",
                                "l1-boolean",
                                "l1-long",
                                "l1-double"
                            ]
                        }
                    }
                },
                "required": [
                    "nested",
                    "level1"
                ]
            }
        }
    },
    "required": [
        "unnested",
        "level0"
    ]
}'
  