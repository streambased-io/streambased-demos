#! /bin/bash

for attempt in {1..100}; do
  # grab an api token
  export TOKEN=`curl -X POST -H "Content-Type: application/json" localhost:8088/api/v1/security/login -d '{
    "password": "admin",
    "provider": "db",
    "refresh": true,
    "username": "admin"
  }' | awk -F':' '{print $2}' | awk -F',' '{print $1}' | sed -e 's/"//g'`
  # check the token is set
  if [[ $TOKEN == ey* ]]; then
    # make the db call
    curl -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" -X POST localhost:8088/api/v1/database/ -d'
    {
      "allow_ctas": false,
      "allow_cvas": false,
      "allow_dml": true,
      "allow_file_upload": false,
      "allow_run_async": false,
      "cache_timeout": 0,
      "configuration_method": "sqlalchemy_form",
      "database_name": "Streambased",
      "driver": "rest",
      "engine": "trino",
      "expose_in_sqllab": true,
      "external_url": "",
      "extra": "",
      "force_ctas_schema": "",
      "impersonate_user": false,
      "is_managed_externally": false,
      "masked_encrypted_extra": "",
      "parameters": {},
      "server_cert": "",
      "sqlalchemy_uri": "trino://streambased-server:8080/kafka",
      "ssh_tunnel": {
      },
      "uuid": "ee65473b-7501-4846-bc40-f09883b64911"
    }'
    exit 0
  fi
  sleep 5
done