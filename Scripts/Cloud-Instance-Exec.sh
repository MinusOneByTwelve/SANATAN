#!/bin/bash

BASE="/opt/Matsya"

CLOUD_OS="$1"
THEACTION="$2"
THEREQPEM="$3"
THEREQUSR="$4"
THEREQMAC="$5"
THEREQPRT="$6"

if [ "$CLOUD_OS" == "AWS" ]; then
	if [ "$THEACTION" == "GBD" ]; then
		THEREQGBK="$7"		
		ssh $THEREQUSR@$THEREQMAC -p $THEREQPRT -o StrictHostKeyChecking=no -i "$THEREQPEM" "aws s3 rm s3://$THEREQGBK --recursive"		
	fi
fi
	
if [ "$CLOUD_OS" == "AWS_UBU" ]; then
	if [ "$THEACTION" == "A" ]; then
		THEREQJLF="$7"
		THEREQBUC="$8"
		THEREQREG="$9"
		THEREQGBK="${10}"
				
		ssh $THEREQUSR@$THEREQMAC -p $THEREQPRT -o StrictHostKeyChecking=no -i "$THEREQPEM" "sudo touch /opt/EXEC1ON && sudo chmod 777 /opt/EXEC1ON && sudo apt-get update -y && sudo NEEDRESTART_MODE=a apt-get install -y automake fuse gcc g++ git libcurl4-openssl-dev libfuse-dev libxml2-dev make pkg-config libssl-dev s3fs awscli && sudo mkdir /SHIVA && sudo chmod -R 777 /SHIVA && sudo mkdir -p /SHIVA/Self && sudo chown -R ubuntu:ubuntu /SHIVA/Self && sudo chmod -R u=rwx,g=,o= /SHIVA/Self && sudo -H -u ubuntu bash -c 's3fs $THEREQBUC /SHIVA/Self -o iam_role=auto -o url=https://s3.$THEREQREG.amazonaws.com -o use_path_request_style' && sudo mkdir -p /SHIVA/Shared && sudo chown -R ubuntu:ubuntu /SHIVA/Shared && sudo chmod -R u=rwx,g=,o= /SHIVA/Shared && sudo -H -u ubuntu bash -c 's3fs $THEREQGBK /SHIVA/Shared -o iam_role=auto -o url=https://s3.$THEREQREG.amazonaws.com -o use_path_request_style' && sudo mv /opt/EXEC1ON /opt/EXEC1DONE"
		
		sudo rm -f $BASE/tmp/$THEREQJLF-JOBLOG.out
	fi
	
	if [ "$THEACTION" == "B" ]; then
		THEREQBUC="$7"		
		ssh $THEREQUSR@$THEREQMAC -p $THEREQPRT -o StrictHostKeyChecking=no -i "$THEREQPEM" "aws s3 rm s3://$THEREQBUC --recursive"
	fi	
fi

if [ "$CLOUD_OS" == "AWS_AZL" ]; then
	if [ "$THEACTION" == "A" ]; then
		THEREQJLF="$7"
		THEREQBUC="$8"
		THEREQREG="$9"
		THEREQGBK="${10}"
				
		ssh $THEREQUSR@$THEREQMAC -p $THEREQPRT -o StrictHostKeyChecking=no -i "$THEREQPEM" "sudo touch /opt/EXEC1ON && sudo chmod 777 /opt/EXEC1ON && sudo yum update -y && sudo yum install -y automake fuse fuse-devel gcc-c++ git libcurl-devel libxml2-devel make openssl-devel aws-cli && git clone https://github.com/s3fs-fuse/s3fs-fuse.git && cd s3fs-fuse && ./autogen.sh && ./configure --prefix=/usr --with-openssl && make && sudo make install && cd .. && sudo rm -rf s3fs-fuse && sudo mkdir /SHIVA && sudo chmod -R 777 /SHIVA && sudo mkdir -p /SHIVA/Self && sudo chown -R ec2-user:ec2-user /SHIVA/Self && sudo chmod -R u=rwx,g=,o= /SHIVA/Self && sudo -H -u ec2-user bash -c 's3fs $THEREQBUC /SHIVA/Self -o iam_role=auto -o url=https://s3.$THEREQREG.amazonaws.com -o use_path_request_style -o sigv4 -o endpoint=$THEREQREG' && sudo mkdir -p /SHIVA/Shared && sudo chown -R ec2-user:ec2-user /SHIVA/Shared && sudo chmod -R u=rwx,g=,o= /SHIVA/Shared && sudo -H -u ec2-user bash -c 's3fs $THEREQGBK /SHIVA/Shared -o iam_role=auto -o url=https://s3.$THEREQREG.amazonaws.com -o use_path_request_style -o sigv4 -o endpoint=$THEREQREG' && sudo mv /opt/EXEC1ON /opt/EXEC1DONE"
		
		sudo rm -f $BASE/tmp/$THEREQJLF-JOBLOG.out
	fi
	
	if [ "$THEACTION" == "B" ]; then
		THEREQBUC="$7"		
		ssh $THEREQUSR@$THEREQMAC -p $THEREQPRT -o StrictHostKeyChecking=no -i "$THEREQPEM" "aws s3 rm s3://$THEREQBUC --recursive"
	fi	
fi

if [ "$CLOUD_OS" == "AWS_ALMA" ]; then
	if [ "$THEACTION" == "A" ]; then
		THEREQJLF="$7"
		THEREQBUC="$8"
		THEREQREG="$9"
		THEREQGBK="${10}"
				
		ssh $THEREQUSR@$THEREQMAC -p $THEREQPRT -o StrictHostKeyChecking=no -i "$THEREQPEM" "sudo touch /opt/EXEC1ON && sudo chmod 777 /opt/EXEC1ON && sudo dnf update -y && sudo dnf install -y automake fuse gcc-c++ git libcurl-devel libxml2-devel make openssl-devel && sudo dnf --enablerepo=crb install fuse-devel -y && sudo dnf install unzip -y && sudo rm -rf awscliv2.zip && sudo rm -rf aws && curl \"https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip\" -o \"awscliv2.zip\" && unzip awscliv2.zip && sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update && sudo rm -rf awscliv2.zip && sudo rm -rf aws && git clone https://github.com/s3fs-fuse/s3fs-fuse.git && cd s3fs-fuse && ./autogen.sh && ./configure --prefix=/usr --with-openssl && make && sudo make install && cd .. && sudo rm -rf s3fs-fuse && sudo mkdir /SHIVA && sudo chmod -R 777 /SHIVA && sudo mkdir -p /SHIVA/Self && sudo chown -R ec2-user:ec2-user /SHIVA/Self && sudo chmod -R u=rwx,g=,o= /SHIVA/Self && sudo -H -u ec2-user bash -c 's3fs $THEREQBUC /SHIVA/Self -o iam_role=auto -o url=https://s3.$THEREQREG.amazonaws.com -o use_path_request_style -o sigv4 -o endpoint=$THEREQREG' && sudo mkdir -p /SHIVA/Shared && sudo chown -R ec2-user:ec2-user /SHIVA/Shared && sudo chmod -R u=rwx,g=,o= /SHIVA/Shared && sudo -H -u ec2-user bash -c 's3fs $THEREQGBK /SHIVA/Shared -o iam_role=auto -o url=https://s3.$THEREQREG.amazonaws.com -o use_path_request_style -o sigv4 -o endpoint=$THEREQREG' && sudo mv /opt/EXEC1ON /opt/EXEC1DONE"
		
		sudo rm -f $BASE/tmp/$THEREQJLF-JOBLOG.out
	fi
	
	if [ "$THEACTION" == "B" ]; then
		THEREQBUC="$7"		
		ssh $THEREQUSR@$THEREQMAC -p $THEREQPRT -o StrictHostKeyChecking=no -i "$THEREQPEM" "aws s3 rm s3://$THEREQBUC --recursive"
	fi	
fi

