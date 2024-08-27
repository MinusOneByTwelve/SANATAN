#!/bin/bash

# Wait for Elasticsearch to start up before executing the commands
until curl -u elastic:THEPWD -s "http://localhost:9200" > /dev/null; do
  echo "Waiting for Elasticsearch to start..."
  sleep 5
done

# Create a Kibana user
curl -u elastic:THEPWD -X POST "http://localhost:9200/_security/user/kibanauser" -H "Content-Type: application/json" -d'
{
  "password" : "THEPWD",
  "roles" : [ "kibana_system" ],
  "full_name" : "Kibana User",
  "email" : "kibana@example.com"
}'

# Create a Filebeat user
curl -u elastic:THEPWD -X POST "http://localhost:9200/_security/user/filebeat_user" -H "Content-Type: application/json" -d'
{
  "password" : "THEPWD",
  "roles" : [ "beats_admin" ],
  "full_name" : "Filebeat User",
  "email" : "filebeat@example.com"
}'

# Output the created users
echo "Created Kibana and Filebeat users successfully."

