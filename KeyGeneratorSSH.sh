#!/bin/bash
# Get the key path from the script's first argument
KEY_PATH="$1"
if [ ! -f "$KEY_PATH" ]; then
  #ssh-keygen -t rsa -b 2048 -f $KEY_PATH -q -N ''
  echo -e  'y\n'|ssh-keygen -b 2048 -t rsa -P '' -f $KEY_PATH -q
  sudo chmod 400 $KEY_PATH 
fi
echo "{\"public_key\": \"$(cat ${KEY_PATH}.pub)\"}"

