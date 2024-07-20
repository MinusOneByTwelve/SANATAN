#!/bin/bash

BASE="/opt/Matsya"

CLOUD_OS="$1"
THEACTION="$2"
THEREQPEM="$3"
THEREQUSR="$4"
THEREQMAC="$5"
THEREQPRT="$6"

if [ "$CLOUD_OS" == "GCP_UBU" ]; then
	if [ "$THEACTION" == "A" ]; then
		THEREQJLF="$7"
		THEREQBUC="$8"
		THEREQGBK="$9"
				
		ssh $THEREQUSR@$THEREQMAC -p $THEREQPRT -o StrictHostKeyChecking=no -i "$THEREQPEM" "sudo touch /opt/CLD && sudo chmod 777 /opt/CLD && echo \"GCP_UBU\" | sudo tee -a /opt/CLD > /dev/null && sudo touch /opt/LCL && sudo chmod 777 /opt/LCL && echo \"$THEREQBUC\" | sudo tee -a /opt/LCL > /dev/null && sudo touch /opt/GBL && sudo chmod 777 /opt/GBL && echo \"$THEREQGBK\" | sudo tee -a /opt/GBL > /dev/null && sudo touch /opt/VPC && sudo chmod 777 /opt/VPC && echo \"$THEREQGBK\" | sudo tee -a /opt/VPC > /dev/null && sudo touch /opt/EXEC1ON && sudo chmod 777 /opt/EXEC1ON && sudo mkdir -p /shiva && sudo chmod -R 777 /shiva && sudo mkdir -p /shiva/bdd && sudo chown -R root:root /shiva/bdd && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/bdd && sudo mkdir -p /shiva/bdd/storage && sudo chown -R root:root /shiva/bdd/storage && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/bdd/storage && sudo mkdir -p /shiva/local && sudo chown -R root:root /shiva/local && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/local && sudo mkdir -p /shiva/local/storage && sudo chown -R root:root /shiva/local/storage && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/local/storage && sudo mkdir -p /shiva/local/bucket && sudo chown -R root:root /shiva/local/bucket && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/local/bucket && sudo mkdir -p /shiva/global && sudo chown -R root:root /shiva/global && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/global && sudo mkdir -p /shiva/global/bucket && sudo chown -R root:root /shiva/global/bucket && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/global/bucket && sudo ln -s /shiva/global/bucket /shiva/global/storage && echo \"deb [signed-by=/usr/share/keyrings/cloud.google.asc] https://packages.cloud.google.com/apt gcsfuse-jammy main\" | sudo tee /etc/apt/sources.list.d/gcsfuse.list > /dev/null && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo tee /usr/share/keyrings/cloud.google.asc && sudo apt-get update -y && sudo apt-get install gcsfuse -y && sudo gcsfuse --file-mode 777 --dir-mode 777 $THEREQBUC \"/shiva/local/bucket\" && sudo gcsfuse --file-mode 777 --dir-mode 777 $THEREQGBK \"/shiva/global/bucket\" && sudo touch /shiva/local/bucket/$THEREQBUC && sudo touch /shiva/global/bucket/$THEREQGBK && sudo mv /opt/EXEC1ON /opt/EXEC1DONE"
		
		sudo rm -f $BASE/tmp/$THEREQJLF-CIE.out
	fi	
fi

if [ "$CLOUD_OS" == "GCP_ALMA" ]; then
	if [ "$THEACTION" == "A" ]; then
		THEREQJLF="$7"
		THEREQBUC="$8"
		THEREQGBK="$9"
				
		ssh $THEREQUSR@$THEREQMAC -p $THEREQPRT -o StrictHostKeyChecking=no -i "$THEREQPEM" "sudo touch /opt/EXEC1ON && sudo chmod 777 /opt/EXEC1ON && sudo mkdir -p /shiva && sudo chmod -R 777 /shiva && sudo mkdir -p /shiva/local && sudo chown -R matsya:matsya /shiva/local && sudo chmod -R u=rwx,g=,o= /shiva/local && sudo mkdir -p /shiva/local/storage && sudo chown -R matsya:matsya /shiva/local/storage && sudo chmod -R u=rwx,g=,o= /shiva/local/storage && sudo mkdir -p /shiva/global && sudo chown -R matsya:matsya /shiva/global && sudo chmod -R u=rwx,g=,o= /shiva/global && sudo mkdir -p /shiva/global/storage && sudo chown -R matsya:matsya /shiva/global/storage && sudo chmod -R u=rwx,g=,o= /shiva/global/storage && echo \"[gcsfuse]
name=gcsfuse (packages.cloud.google.com)
baseurl=https://packages.cloud.google.com/yum/repos/gcsfuse-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
      https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg\" | sudo tee /etc/yum.repos.d/gcsfuse.repo > /dev/null && sudo yum install fuse gcsfuse -y && gcsfuse $THEREQBUC \"/shiva/local/storage\" && gcsfuse $THEREQGBK \"/shiva/global/storage\" && sudo mv /opt/EXEC1ON /opt/EXEC1DONE"
		
		sudo rm -f $BASE/tmp/$THEREQJLF-CIE.out
	fi	
fi

if [ "$CLOUD_OS" == "GCP_ROCKY" ]; then
	if [ "$THEACTION" == "A" ]; then
		THEREQJLF="$7"
		THEREQBUC="$8"
		THEREQGBK="$9"
				
		ssh $THEREQUSR@$THEREQMAC -p $THEREQPRT -o StrictHostKeyChecking=no -i "$THEREQPEM" "sudo touch /opt/EXEC1ON && sudo chmod 777 /opt/EXEC1ON && sudo mkdir -p /shiva && sudo chmod -R 777 /shiva && sudo mkdir -p /shiva/local && sudo chown -R matsya:matsya /shiva/local && sudo chmod -R u=rwx,g=,o= /shiva/local && sudo mkdir -p /shiva/local/storage && sudo chown -R matsya:matsya /shiva/local/storage && sudo chmod -R u=rwx,g=,o= /shiva/local/storage && sudo mkdir -p /shiva/global && sudo chown -R matsya:matsya /shiva/global && sudo chmod -R u=rwx,g=,o= /shiva/global && sudo mkdir -p /shiva/global/storage && sudo chown -R matsya:matsya /shiva/global/storage && sudo chmod -R u=rwx,g=,o= /shiva/global/storage && echo \"[gcsfuse]
name=gcsfuse (packages.cloud.google.com)
baseurl=https://packages.cloud.google.com/yum/repos/gcsfuse-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
      https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg\" | sudo tee /etc/yum.repos.d/gcsfuse.repo > /dev/null && sudo yum install fuse gcsfuse -y && gcsfuse $THEREQBUC \"/shiva/local/storage\" && gcsfuse $THEREQGBK \"/shiva/global/storage\" && sudo mv /opt/EXEC1ON /opt/EXEC1DONE"
		
		sudo rm -f $BASE/tmp/$THEREQJLF-CIE.out
	fi	
fi

if [ "$CLOUD_OS" == "AZURE_ALMA" ]; then
	if [ "$THEACTION" == "A" ]; then
		THEREQJLF="$7"
		THEREQLSC="$8"
		THEREQGSC="$9"
				
		ssh $THEREQUSR@$THEREQMAC -p $THEREQPRT -o StrictHostKeyChecking=no -i "$THEREQPEM" "sudo touch /opt/EXEC1ON && sudo chmod 777 /opt/EXEC1ON && sudo mkdir -p /shiva && sudo chmod -R 777 /shiva && sudo mkdir -p /shiva/local && sudo chown -R matsya:matsya /shiva/local && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/local && sudo mkdir -p /shiva/global && sudo chown -R matsya:matsya /shiva/global && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/global && sudo mkdir -p /shiva/filecachelocal && sudo chown -R matsya:matsya /shiva/filecachelocal && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/filecachelocal && sudo mkdir -p /shiva/filecacheglobal && sudo chown -R matsya:matsya /shiva/filecacheglobal && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/filecacheglobal && sudo rpm -Uvh https://packages.microsoft.com/config/rhel/8/packages-microsoft-prod.rpm && sudo yum install -y blobfuse2 && sudo touch /opt/localSC.yaml && echo \"
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
		
		sudo rm -f $BASE/tmp/$THEREQJLF-CIE.out
	fi	
fi

if [ "$CLOUD_OS" == "AZURE_UBU" ]; then
	if [ "$THEACTION" == "A" ]; then
		THEREQJLF="$7"
		THEREQLSC="$8"
		THEREQGSC="$9"
				
		ssh $THEREQUSR@$THEREQMAC -p $THEREQPRT -o StrictHostKeyChecking=no -i "$THEREQPEM" "sudo touch /opt/CLD && sudo chmod 777 /opt/CLD && echo \"AZURE_UBU\" | sudo tee -a /opt/CLD > /dev/null && sudo touch /opt/LCL && sudo chmod 777 /opt/LCL && echo \"$THEREQLSC\" | sudo tee -a /opt/LCL > /dev/null && sudo touch /opt/GBL && sudo chmod 777 /opt/GBL && echo \"$THEREQGSC\" | sudo tee -a /opt/GBL > /dev/null && sudo touch /opt/VPC && sudo chmod 777 /opt/VPC && echo \"$THEREQGSC\" | sudo tee -a /opt/VPC > /dev/null && sudo touch /opt/EXEC1ON && sudo chmod 777 /opt/EXEC1ON && sudo mkdir -p /shiva && sudo chmod -R 777 /shiva && sudo mkdir -p /shiva/bdd && sudo chown -R root:root /shiva/bdd && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/bdd && sudo mkdir -p /shiva/bdd/storage && sudo chown -R root:root /shiva/bdd/storage && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/bdd/storage && sudo mkdir -p /shiva/local && sudo chown -R root:root /shiva/local && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/local && sudo mkdir -p /shiva/global && sudo chown -R root:root /shiva/global && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/global && sudo mkdir -p /shiva/filecachelocal && sudo chown -R root:root /shiva/filecachelocal && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/filecachelocal && sudo mkdir -p /shiva/filecacheglobal && sudo chown -R root:root /shiva/filecacheglobal && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/filecacheglobal && sudo mkdir -p /shiva/local/storage && sudo chown -R root:root /shiva/local/storage && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/local/storage && sudo mkdir -p /shiva/global/storage && sudo chown -R root:root /shiva/global/storage && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/global/storage && sudo touch /opt/localSC.yaml && echo \"
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
  type: adls
  account-name: $THEREQLSC
  endpoint: https://$THEREQLSC.dfs.core.windows.net
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
  type: adls
  account-name: $THEREQGSC
  endpoint: https://$THEREQGSC.dfs.core.windows.net
  mode: MSI
\" | sudo tee -a /opt/globalSC.yaml > /dev/null && sudo chmod 777 /opt/localSC.yaml && sudo chmod 777 /opt/globalSC.yaml && sudo wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb && sudo dpkg -i packages-microsoft-prod.deb && sudo rm -f packages-microsoft-prod.deb && sudo apt-get update -y && sudo apt-get install libfuse3-dev fuse3 blobfuse2 cifs-utils jq -y && sudo mv /home/ubuntu/EDN /opt/EDN && sudo chmod 777 /opt/EDN && /opt/EDN && sudo blobfuse2 mount all /shiva/global --config-file=/opt/globalSC.yaml && sudo blobfuse2 mount all /shiva/local --config-file=/opt/localSC.yaml && sudo mv /opt/EXEC1ON /opt/EXEC1DONE"
		
		sudo rm -f $BASE/tmp/$THEREQJLF-CIE.out
	fi	
fi

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
				
		ssh $THEREQUSR@$THEREQMAC -p $THEREQPRT -o StrictHostKeyChecking=no -i "$THEREQPEM" "getent group vamana >/dev/null || sudo groupadd vamana && sudo usermod -a -G vamana root && sudo usermod -a -G vamana ubuntu && sudo touch /opt/CLD && sudo chmod 777 /opt/CLD && echo \"AWS_UBU\" | sudo tee -a /opt/CLD > /dev/null && sudo touch /opt/LCL && sudo chmod 777 /opt/LCL && echo \"$THEREQBUC\" | sudo tee -a /opt/LCL > /dev/null && sudo touch /opt/GBL && sudo chmod 777 /opt/GBL && echo \"$THEREQGBK\" | sudo tee -a /opt/GBL > /dev/null && sudo touch /opt/VPC && sudo chmod 777 /opt/VPC && echo \"$THEREQGBK\" | sudo tee -a /opt/VPC > /dev/null && sudo touch /opt/EXEC1ON && sudo chmod 777 /opt/EXEC1ON && echo \"sudo apt-get update -y && sudo NEEDRESTART_MODE=a apt-get install -y automake fuse gcc g++ git libcurl4-openssl-dev libfuse-dev libxml2-dev make pkg-config libssl-dev s3fs awscli nfs-common && sudo mkdir -p /shiva && sudo chmod -R 777 /shiva && sudo mkdir -p /shiva/bdd && sudo chown -R root:root /shiva/bdd && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/bdd && sudo mkdir -p /shiva/bdd/storage && sudo chown -R root:root /shiva/bdd/storage && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/bdd/storage && sudo mkdir -p /shiva/local && sudo chown -R root:root /shiva/local && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/local && sudo mkdir -p /shiva/local/storage && sudo chown -R root:root /shiva/local/storage && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/local/storage && sudo mkdir -p /shiva/local/bucket && sudo chown -R root:root /shiva/local/bucket && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/local/bucket && sudo -H -u root bash -c 's3fs $THEREQBUC /shiva/local/bucket -o iam_role=auto -o url=https://s3.$THEREQREG.amazonaws.com -o use_path_request_style -o umask=0000 -o uid=\$(id -u root) -o gid=\$(getent group vamana | cut -d: -f3) -o allow_other' && sudo mkdir -p /shiva/global && sudo chown -R root:root /shiva/global && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/global && sudo mkdir -p /shiva/global/storage && sudo chown -R root:root /shiva/global/storage && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/global/storage && sudo mkdir -p /shiva/global/bucket && sudo chown -R root:root /shiva/global/bucket && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/global/bucket && sudo -H -u root bash -c 's3fs $THEREQGBK /shiva/global/bucket -o iam_role=auto -o url=https://s3.$THEREQREG.amazonaws.com -o use_path_request_style -o umask=0000 -o uid=\$(id -u root) -o gid=\$(getent group vamana | cut -d: -f3) -o allow_other' && sudo mv /home/ubuntu/EDN /opt/EDN && sudo chmod 777 /opt/EDN && sudo mv /opt/EXEC1ON /opt/EXEC1DONE\" | sudo tee -a /opt/EXEC1ON > /dev/null && sudo chmod 777 /opt/EXEC1ON && /opt/EXEC1ON"
		
		sudo rm -f $BASE/tmp/$THEREQJLF-CIE.out
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
				
		ssh $THEREQUSR@$THEREQMAC -p $THEREQPRT -o StrictHostKeyChecking=no -i "$THEREQPEM" "sudo touch /opt/LCL && sudo chmod 777 /opt/LCL && echo \"$THEREQBUC\" | sudo tee -a /opt/LCL > /dev/null && sudo touch /opt/GBL && sudo chmod 777 /opt/GBL && echo \"$THEREQGBK\" | sudo tee -a /opt/GBL > /dev/null && sudo touch /opt/EXEC1ON && sudo chmod 777 /opt/EXEC1ON && echo \"sudo yum update -y && sudo yum install -y automake fuse fuse-devel gcc-c++ git libcurl-devel libxml2-devel make openssl-devel aws-cli && wget https://github.com/MinusOneByTwelve/SANATAN/raw/main/Resources/s3fs-fuse.tar.gz && tar xf s3fs-fuse.tar.gz && cd s3fs-fuse && sudo make install && cd .. && sudo rm -rf s3fs-fuse* && sudo mkdir -p /shiva && sudo chmod -R 777 /shiva && sudo mkdir -p /shiva/local && sudo chown -R ec2-user:ec2-user /shiva/local && sudo chmod -R u=rwx,g=,o= /shiva/local && sudo mkdir -p /shiva/local/storage && sudo chown -R ec2-user:ec2-user /shiva/local/storage && sudo chmod -R u=rwx,g=,o= /shiva/local/storage && sudo -H -u ec2-user bash -c 's3fs $THEREQBUC /shiva/local/storage -o iam_role=auto -o url=https://s3.$THEREQREG.amazonaws.com -o use_path_request_style -o sigv4 -o endpoint=$THEREQREG' && sudo mkdir -p /shiva/global && sudo chown -R ec2-user:ec2-user /shiva/global && sudo chmod -R u=rwx,g=,o= /shiva/global && sudo mkdir -p /shiva/global/storage && sudo chown -R ec2-user:ec2-user /shiva/global/storage && sudo chmod -R u=rwx,g=,o= /shiva/global/storage && sudo -H -u ec2-user bash -c 's3fs $THEREQGBK /shiva/global/storage -o iam_role=auto -o url=https://s3.$THEREQREG.amazonaws.com -o use_path_request_style -o sigv4 -o endpoint=$THEREQREG' && sudo mv /opt/EXEC1ON /opt/EXEC1DONE\" | sudo tee -a /opt/EXEC1ON > /dev/null && sudo chmod 777 /opt/EXEC1ON && /opt/EXEC1ON"		
		
		sudo rm -f $BASE/tmp/$THEREQJLF-CIE.out
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
				
		ssh $THEREQUSR@$THEREQMAC -p $THEREQPRT -o StrictHostKeyChecking=no -i "$THEREQPEM" "sudo touch /opt/EXEC1ON && sudo chmod 777 /opt/EXEC1ON && sudo dnf update -y && sudo dnf install -y automake fuse gcc-c++ git libcurl-devel libxml2-devel make openssl-devel && sudo dnf --enablerepo=crb install fuse-devel -y && sudo dnf install unzip -y && sudo rm -rf awscliv2.zip && sudo rm -rf aws && curl \"https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip\" -o \"awscliv2.zip\" && unzip awscliv2.zip && sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update && sudo rm -rf awscliv2.zip && sudo rm -rf aws && git clone https://github.com/s3fs-fuse/s3fs-fuse.git && cd s3fs-fuse && ./autogen.sh && ./configure --prefix=/usr --with-openssl && make && sudo make install && cd .. && sudo rm -rf s3fs-fuse && sudo mkdir -p /shiva && sudo chmod -R 777 /shiva && sudo mkdir -p /shiva/local && sudo chown -R ec2-user:ec2-user /shiva/local && sudo chmod -R u=rwx,g=,o= /shiva/local && sudo mkdir -p /shiva/local/storage && sudo chown -R ec2-user:ec2-user /shiva/local/storage && sudo chmod -R u=rwx,g=,o= /shiva/local/storage && sudo -H -u ec2-user bash -c 's3fs $THEREQBUC /shiva/local/storage -o iam_role=auto -o url=https://s3.$THEREQREG.amazonaws.com -o use_path_request_style -o sigv4 -o endpoint=$THEREQREG' && sudo mkdir -p /shiva/global && sudo chown -R ec2-user:ec2-user /shiva/global && sudo chmod -R u=rwx,g=,o= /shiva/global && sudo mkdir -p /shiva/global/storage && sudo chown -R ec2-user:ec2-user /shiva/global/storage && sudo chmod -R u=rwx,g=,o= /shiva/global/storage && sudo -H -u ec2-user bash -c 's3fs $THEREQGBK /shiva/global/storage -o iam_role=auto -o url=https://s3.$THEREQREG.amazonaws.com -o use_path_request_style -o sigv4 -o endpoint=$THEREQREG' && sudo mv /opt/EXEC1ON /opt/EXEC1DONE"
		
		sudo rm -f $BASE/tmp/$THEREQJLF-CIE.out
	fi
	
	if [ "$THEACTION" == "B" ]; then
		THEREQBUC="$7"		
		ssh $THEREQUSR@$THEREQMAC -p $THEREQPRT -o StrictHostKeyChecking=no -i "$THEREQPEM" "aws s3 rm s3://$THEREQBUC --recursive"
	fi	
fi

