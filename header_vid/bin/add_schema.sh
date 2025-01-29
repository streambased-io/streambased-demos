cat > /tmp/survey_schema.avsc <<- EOM
{
           "schema":
             "{
                 \"type\":\"record\",
                 \"name\":\"surveyHeaders\",
                 \"fields\": [
                   {
                     \"name\":\"appversion\",
                     \"type\":\"string\"
                   },{
                     \"name\":\"surveyor\",
                     \"type\":\"string\"}
                 ]
             }",
           "schemaType": "AVRO"
}
EOM
curl -X POST -H "Content-Type":"application/json" "http://localhost:8081/subjects/surveys-headers/versions" -d @/tmp/survey_schema.avsc