#!/bin/bash

clear

BASE="/opt/Matsya"

CLOUD_OS="$1"
THEACTION="$2"
THEREQPEM="$3"
THEREQUSR="$4"
THEREQMAC="$5"
THEREQPRT="$6"

if [ "$CLOUD_OS" == "AWS_UBU" ]; then
	if [ "$THEACTION" == "A" ]; then
		THEREQJLF="$7"
		THEREQBUC="$8"
		THEREQREG="$9"		
		ssh $THEREQUSR@$THEREQMAC -p $THEREQPRT -o StrictHostKeyChecking=no -i "$THEREQPEM" "sudo apt-get update -y && sudo NEEDRESTART_MODE=a apt-get install -y automake fuse gcc g++ git libcurl4-openssl-dev libfuse-dev libxml2-dev make pkg-config libssl-dev s3fs awscli && sudo mkdir /SHIVA && sudo chmod -R 777 /SHIVA && sudo mkdir -p /SHIVA/Self && sudo chown -R ubuntu:ubuntu /SHIVA/Self && sudo chmod -R u=rwx,g=,o= /SHIVA/Self && sudo -H -u ubuntu bash -c 's3fs $THEREQBUC /SHIVA/Self -o iam_role=auto -o url=https://s3.$THEREQREG.amazonaws.com -o use_path_request_style'"
		
		sudo rm -f $BASE/tmp/$THEREQJLF-JOBLOG.out
	fi
	
	if [ "$THEACTION" == "B" ]; then
		THEREQBUC="$7"		
		ssh $THEREQUSR@$THEREQMAC -p $THEREQPRT -o StrictHostKeyChecking=no -i "$THEREQPEM" "aws s3 rm s3://$THEREQBUC --recursive"
	fi	
fi

