#!/bin/bash

APP="$1"
P1ATH="$2"

LOCATION="THEFILELOC"
LOGTEMPLATE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)

pushd $LOCATION
echo "- type: log
  enabled: true
  paths:
    - $P1ATH
  fields:
    app: $APP
  fields_under_root: true
  ignore_older: 48h" | tee $LOGTEMPLATE.yml > /dev/null
sudo chown root:root $LOGTEMPLATE.yml
sudo chmod go-w $LOGTEMPLATE.yml
popd
