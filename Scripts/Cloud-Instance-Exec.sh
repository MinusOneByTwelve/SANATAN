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

if [ "$CLOUD_OS" == "AZURE_ALMA" ]; then
	if [ "$THEACTION" == "A" ]; then
		THEREQJLF="$7"
		THEREQLSC="$8"
		THEREQGSC="$9"
				
		ssh $THEREQUSR@$THEREQMAC -p $THEREQPRT -o StrictHostKeyChecking=no -i "$THEREQPEM" "sudo touch /opt/EXEC1ON && sudo chmod 777 /opt/EXEC1ON && sudo mkdir /shiva && sudo chmod -R 777 /shiva && sudo mkdir -p /shiva/local && sudo chown -R matsya:matsya /shiva/local && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/local && sudo mkdir -p /shiva/global && sudo chown -R matsya:matsya /shiva/global && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/global && sudo mkdir -p /shiva/filecachelocal && sudo chown -R matsya:matsya /shiva/filecachelocal && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/filecachelocal && sudo mkdir -p /shiva/filecacheglobal && sudo chown -R matsya:matsya /shiva/filecacheglobal && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/filecacheglobal && sudo rpm -Uvh https://packages.microsoft.com/config/rhel/8/packages-microsoft-prod.rpm && sudo yum install -y blobfuse2 && sudo touch /opt/localSC.yaml && echo \"
allow-other: true

logging:
  type: syslog
  level: log_err

components:
  - libfuse
  - file_cache
  - attr_cache
  - azstorage

libfuse:
  attribute-expiration-sec: 120
  entry-expiration-sec: 120
  negative-entry-expiration-sec: 240

file_cache:
  path: /shiva/filecachelocal/
  timeout-sec: 120
  max-size-mb: 4096

attr_cache:
  timeout-sec: 7200

azstorage:
  type: block
  account-name: $THEREQLSC
  endpoint: https://$THEREQLSC.blob.core.windows.net
  mode: MSI
\" | sudo tee -a /opt/localSC.yaml > /dev/null && sudo touch /opt/globalSC.yaml && echo \"
allow-other: true

logging:
  type: syslog
  level: log_err

components:
  - libfuse
  - file_cache
  - attr_cache
  - azstorage

libfuse:
  attribute-expiration-sec: 120
  entry-expiration-sec: 120
  negative-entry-expiration-sec: 240

file_cache:
  path: /shiva/filecacheglobal/
  timeout-sec: 120
  max-size-mb: 4096

attr_cache:
  timeout-sec: 7200

azstorage:
  type: block
  account-name: $THEREQGSC
  endpoint: https://$THEREQGSC.blob.core.windows.net
  mode: MSI
\" | sudo tee -a /opt/globalSC.yaml > /dev/null && sudo chmod 777 /opt/localSC.yaml && sudo chmod 777 /opt/globalSC.yaml && sudo blobfuse2 mount all /shiva/local --config-file=/opt/localSC.yaml && sudo blobfuse2 mount all /shiva/global --config-file=/opt/globalSC.yaml && sudo mv /opt/EXEC1ON /opt/EXEC1DONE"
		
		sudo rm -f $BASE/tmp/$THEREQJLF-JOBLOG.out
	fi	
fi

if [ "$CLOUD_OS" == "AZURE_UBU" ]; then
	if [ "$THEACTION" == "A" ]; then
		THEREQJLF="$7"
		THEREQLSC="$8"
		THEREQGSC="$9"
				
		ssh $THEREQUSR@$THEREQMAC -p $THEREQPRT -o StrictHostKeyChecking=no -i "$THEREQPEM" "sudo touch /opt/EXEC1ON && sudo chmod 777 /opt/EXEC1ON && sudo mkdir /shiva && sudo chmod -R 777 /shiva && sudo mkdir -p /shiva/local && sudo chown -R matsya:matsya /shiva/local && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/local && sudo mkdir -p /shiva/global && sudo chown -R matsya:matsya /shiva/global && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/global && sudo mkdir -p /shiva/filecachelocal && sudo chown -R matsya:matsya /shiva/filecachelocal && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/filecachelocal && sudo mkdir -p /shiva/filecacheglobal && sudo chown -R matsya:matsya /shiva/filecacheglobal && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/filecacheglobal && sudo wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb && sudo dpkg -i packages-microsoft-prod.deb && sudo rm -f packages-microsoft-prod.deb && sudo apt-get update -y && sudo apt-get install libfuse3-dev fuse3 blobfuse2 -y && sudo touch /opt/localSC.yaml && echo \"
allow-other: true

logging:
  type: syslog
  level: log_err

components:
  - libfuse
  - file_cache
  - attr_cache
  - azstorage

libfuse:
  attribute-expiration-sec: 120
  entry-expiration-sec: 120
  negative-entry-expiration-sec: 240

file_cache:
  path: /shiva/filecachelocal/
  timeout-sec: 120
  max-size-mb: 4096

attr_cache:
  timeout-sec: 7200

azstorage:
  type: block
  account-name: $THEREQLSC
  endpoint: https://$THEREQLSC.blob.core.windows.net
  mode: MSI
\" | sudo tee -a /opt/localSC.yaml > /dev/null && sudo touch /opt/globalSC.yaml && echo \"
allow-other: true

logging:
  type: syslog
  level: log_err

components:
  - libfuse
  - file_cache
  - attr_cache
  - azstorage

libfuse:
  attribute-expiration-sec: 120
  entry-expiration-sec: 120
  negative-entry-expiration-sec: 240

file_cache:
  path: /shiva/filecacheglobal/
  timeout-sec: 120
  max-size-mb: 4096

attr_cache:
  timeout-sec: 7200

azstorage:
  type: block
  account-name: $THEREQGSC
  endpoint: https://$THEREQGSC.blob.core.windows.net
  mode: MSI
\" | sudo tee -a /opt/globalSC.yaml > /dev/null && sudo chmod 777 /opt/localSC.yaml && sudo chmod 777 /opt/globalSC.yaml && sudo blobfuse2 mount all /shiva/local --config-file=/opt/localSC.yaml && sudo blobfuse2 mount all /shiva/global --config-file=/opt/globalSC.yaml && sudo mv /opt/EXEC1ON /opt/EXEC1DONE"
		
		sudo rm -f $BASE/tmp/$THEREQJLF-JOBLOG.out
	fi	
fi
	
if [ "$CLOUD_OS" == "AWS_UBU" ]; then
	if [ "$THEACTION" == "A" ]; then
		THEREQJLF="$7"
		THEREQBUC="$8"
		THEREQREG="$9"
		THEREQGBK="${10}"
				
		ssh $THEREQUSR@$THEREQMAC -p $THEREQPRT -o StrictHostKeyChecking=no -i "$THEREQPEM" "sudo touch /opt/EXEC1ON && sudo chmod 777 /opt/EXEC1ON && sudo apt-get update -y && sudo NEEDRESTART_MODE=a apt-get install -y automake fuse gcc g++ git libcurl4-openssl-dev libfuse-dev libxml2-dev make pkg-config libssl-dev s3fs awscli && sudo mkdir /shiva && sudo chmod -R 777 /shiva && sudo mkdir -p /shiva/local && sudo chown -R ubuntu:ubuntu /shiva/local && sudo chmod -R u=rwx,g=,o= /shiva/local && sudo mkdir -p /shiva/local/storage && sudo chown -R ubuntu:ubuntu /shiva/local/storage && sudo chmod -R u=rwx,g=,o= /shiva/local/storage && sudo -H -u ubuntu bash -c 's3fs $THEREQBUC /shiva/local/storage -o iam_role=auto -o url=https://s3.$THEREQREG.amazonaws.com -o use_path_request_style' && sudo mkdir -p /shiva/global && sudo chown -R ubuntu:ubuntu /shiva/global && sudo chmod -R u=rwx,g=,o= /shiva/global && sudo mkdir -p /shiva/global/storage && sudo chown -R ubuntu:ubuntu /shiva/global/storage && sudo chmod -R u=rwx,g=,o= /shiva/global/storage && sudo -H -u ubuntu bash -c 's3fs $THEREQGBK /shiva/global/storage -o iam_role=auto -o url=https://s3.$THEREQREG.amazonaws.com -o use_path_request_style' && sudo mv /opt/EXEC1ON /opt/EXEC1DONE"
		
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
				
		ssh $THEREQUSR@$THEREQMAC -p $THEREQPRT -o StrictHostKeyChecking=no -i "$THEREQPEM" "sudo touch /opt/EXEC1ON && sudo chmod 777 /opt/EXEC1ON && sudo yum update -y && sudo yum install -y automake fuse fuse-devel gcc-c++ git libcurl-devel libxml2-devel make openssl-devel aws-cli && git clone https://github.com/s3fs-fuse/s3fs-fuse.git && cd s3fs-fuse && ./autogen.sh && ./configure --prefix=/usr --with-openssl && make && sudo make install && cd .. && sudo rm -rf s3fs-fuse && sudo mkdir /shiva && sudo chmod -R 777 /shiva && sudo mkdir -p /shiva/local && sudo chown -R ec2-user:ec2-user /shiva/local && sudo chmod -R u=rwx,g=,o= /shiva/local && sudo mkdir -p /shiva/local/storage && sudo chown -R ec2-user:ec2-user /shiva/local/storage && sudo chmod -R u=rwx,g=,o= /shiva/local/storage && sudo -H -u ec2-user bash -c 's3fs $THEREQBUC /shiva/local/storage -o iam_role=auto -o url=https://s3.$THEREQREG.amazonaws.com -o use_path_request_style -o sigv4 -o endpoint=$THEREQREG' && sudo mkdir -p /shiva/global && sudo chown -R ec2-user:ec2-user /shiva/global && sudo chmod -R u=rwx,g=,o= /shiva/global && sudo mkdir -p /shiva/global/storage && sudo chown -R ec2-user:ec2-user /shiva/global/storage && sudo chmod -R u=rwx,g=,o= /shiva/global/storage && sudo -H -u ec2-user bash -c 's3fs $THEREQGBK /shiva/global/storage -o iam_role=auto -o url=https://s3.$THEREQREG.amazonaws.com -o use_path_request_style -o sigv4 -o endpoint=$THEREQREG' && sudo mv /opt/EXEC1ON /opt/EXEC1DONE"
		
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
				
		ssh $THEREQUSR@$THEREQMAC -p $THEREQPRT -o StrictHostKeyChecking=no -i "$THEREQPEM" "sudo touch /opt/EXEC1ON && sudo chmod 777 /opt/EXEC1ON && sudo dnf update -y && sudo dnf install -y automake fuse gcc-c++ git libcurl-devel libxml2-devel make openssl-devel && sudo dnf --enablerepo=crb install fuse-devel -y && sudo dnf install unzip -y && sudo rm -rf awscliv2.zip && sudo rm -rf aws && curl \"https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip\" -o \"awscliv2.zip\" && unzip awscliv2.zip && sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update && sudo rm -rf awscliv2.zip && sudo rm -rf aws && git clone https://github.com/s3fs-fuse/s3fs-fuse.git && cd s3fs-fuse && ./autogen.sh && ./configure --prefix=/usr --with-openssl && make && sudo make install && cd .. && sudo rm -rf s3fs-fuse && sudo mkdir /shiva && sudo chmod -R 777 /shiva && sudo mkdir -p /shiva/local && sudo chown -R ec2-user:ec2-user /shiva/local && sudo chmod -R u=rwx,g=,o= /shiva/local && sudo mkdir -p /shiva/local/storage && sudo chown -R ec2-user:ec2-user /shiva/local/storage && sudo chmod -R u=rwx,g=,o= /shiva/local/storage && sudo -H -u ec2-user bash -c 's3fs $THEREQBUC /shiva/local/storage -o iam_role=auto -o url=https://s3.$THEREQREG.amazonaws.com -o use_path_request_style -o sigv4 -o endpoint=$THEREQREG' && sudo mkdir -p /shiva/global && sudo chown -R ec2-user:ec2-user /shiva/global && sudo chmod -R u=rwx,g=,o= /shiva/global && sudo mkdir -p /shiva/global/storage && sudo chown -R ec2-user:ec2-user /shiva/global/storage && sudo chmod -R u=rwx,g=,o= /shiva/global/storage && sudo -H -u ec2-user bash -c 's3fs $THEREQGBK /shiva/global/storage -o iam_role=auto -o url=https://s3.$THEREQREG.amazonaws.com -o use_path_request_style -o sigv4 -o endpoint=$THEREQREG' && sudo mv /opt/EXEC1ON /opt/EXEC1DONE"
		
		sudo rm -f $BASE/tmp/$THEREQJLF-JOBLOG.out
	fi
	
	if [ "$THEACTION" == "B" ]; then
		THEREQBUC="$7"		
		ssh $THEREQUSR@$THEREQMAC -p $THEREQPRT -o StrictHostKeyChecking=no -i "$THEREQPEM" "aws s3 rm s3://$THEREQBUC --recursive"
	fi	
fi

