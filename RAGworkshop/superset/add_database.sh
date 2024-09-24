#! /bin/bash

for attempt in {1..100}; do
  # grab an api token
  echo "Fetching API token..." >> /tmp/app_db.log
  export TOKEN=`curl -X POST -H "Content-Type: application/json" localhost:8088/api/v1/security/login -d '{
    "password": "admin",
    "provider": "db",
    "refresh": true,
    "username": "admin"
  }' | awk -F':' '{print $2}' | awk -F',' '{print $1}' | sed -e 's/"//g'`
  echo "Discovered token: $TOKEN" >> /tmp/app_db.log
  # check the token is set
  if [[ $TOKEN == ey* ]]; then
    # make the db call
    echo "Adding DB" >> /tmp/app_db.log
    curl -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" -X POST localhost:8088/api/v1/database/ -d'
    {
      "allow_ctas": false,
      "allow_cvas": false,
      "allow_dml": true,
      "allow_file_upload": false,
      "allow_run_async": false,
      "cache_timeout": 0,
      "configuration_method": "sqlalchemy_form",
      "database_name": "Streambased-ASK",
      "driver": "rest",
      "engine": "trino",
      "expose_in_sqllab": true,
      "external_url": "",
      "extra": "{\"allows_virtual_table_explore\":true,\"engine_params\":{\"connect_args\":{\"session_properties\":{\"use_streambased\":true, \"streambased_connection\":\"{  \\\"bootstrap.servers\\\": \\\"pkc-l6wr6.europe-west2.gcp.confluent.cloud:9092\\\",  \\\"security.protocol\\\": \\\"SASL_SSL\\\",  \\\"sasl.jaas.config\\\": \\\"org.apache.kafka.common.security.plain.PlainLoginModule required username='"'"'4OOK2MI6TA37CC4K'"'"' password='"'"'0mzIsqc1Soz2thm9EutDuAkARY8CZqaNzJ5IF/KboX3l58XN/LZ+yQeuG3LmheIc'"'"';\\\",  \\\"sasl.mechanism\\\": \\\"PLAIN\\\",  \\\"schema.registry.url\\\":\\\"https://psrc-571d82.europe-west2.gcp.confluent.cloud\\\",  \\\"basic.auth.credentials.source\\\":\\\"USER_INFO\\\",  \\\"basic.auth.user.info\\\":\\\"FM36ASJ3BX2SWVXV:gKeS/p/CyfQYfd9/9diFwU6LsauvJ4mtmnPAv68ro7Bm81aZp29QOTXkV5yuv8af\\\"}\"},\"http_scheme\":\"https\",\"schema\":\"streambased\"}}}",
      "force_ctas_schema": "",
      "impersonate_user": false,
      "is_managed_externally": false,
      "masked_encrypted_extra": "",
      "parameters": {},
      "server_cert": "",
      "sqlalchemy_uri": "trino://streambased.cloud:8443/kafka",
      "ssh_tunnel": {
      },
      "uuid": "ee65473b-7501-4846-bc40-f09883b64911"
    }'
    DB_COUNT=`curl -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" localhost:8088/api/v1/database/ | jq '.count'`
    echo New DB count: $DB_COUNT >> /tmp/app_db.log
    if [[ $DB_COUNT = 1 ]]; then
      exit 0
    fi
  fi
  sleep 5
done