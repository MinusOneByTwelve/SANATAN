#!/bin/bash

set -e

clear

CURRENTUSER=$(whoami)
sudo rm -rf /home/$CURRENTUSER/.ssh/known_hosts
sudo rm -rf /root/.ssh/known_hosts
sudo rm -rf /root/.bash_history
sudo rm -rf /home/$CURRENTUSER/.bash_history

RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
LBLUE='\033[1;34m'
DGRAY='\033[1;35m'
PURPLE='\033[0;35m'
RGRAY='\033[1;30m'
BOLD=$(tput bold)
NORM=$(tput sgr0)
ORANGE='\033[1;33m'

DoubleQuotes='"'
NoQuotes=''

BASE="/opt/Matsya"
sudo mkdir -p $BASE
sudo mkdir -p $BASE/tmp
sudo mkdir -p $BASE/Scripts
sudo mkdir -p $BASE/Secrets
sudo mkdir -p $BASE/Resources
sudo mkdir -p $BASE/Output
sudo mkdir -p $BASE/Output/Terraform

if [[ ! -d "$BASE/Output/Pem" ]]; then
	sudo mkdir -p $BASE/Output/Pem
	sudo chmod -R 777 $BASE/Output/Pem
fi

if [[ ! -d "$BASE/Output/Scope" ]]; then
	sudo mkdir -p $BASE/Output/Scope
	sudo chmod -R 777 $BASE/Output/Scope
fi

if [[ ! -d "$BASE/Output/Vision" ]]; then
	sudo mkdir -p $BASE/Output/Vision
	sudo chmod -R 777 $BASE/Output/Vision
fi

source $BASE/Resources/StackVersioningAndMisc

PORTSLIST=()

function GetNewPort {
    local FreshPort=$($BASE/Scripts/GetRandomPort.sh)
    if printf '%s\0' "${PORTSLIST[@]}" | grep -Fxqz -- $FreshPort; then
    	GetNewPort
    fi
    echo $FreshPort
}

echo -e "${ORANGE}=============================================================${NC}"
echo -e "\x1b[1;34mV\x1b[mersatile \x1b[1;34mA\x1b[mutomation \x1b[1;34mM\x1b[managing \x1b[1;34mA\x1b[mssorted \x1b[1;34mN\x1b[metworked \x1b[1;34mA\x1b[mpplications"
echo -e "${GREEN}=============================================================${NC}"
echo ''
echo -e "\x1b[3mV   V  AAAAA  M   M  AAAAA  N   N  AAAAA\x1b[m"
echo -e "\x1b[3mV   V  A   A  MM MM  A   A  NN  N  A   A\x1b[m"
echo -e "\x1b[3mV   V  AAAAA  M M M  AAAAA  N N N  AAAAA\x1b[m"
echo -e "\x1b[3m V V   A   A  M   M  A   A  N  NN  A   A\x1b[m"
echo -e "\x1b[3m  V    A   A  M   M  A   A  N   N  A   A\x1b[m"
echo ''
echo -e "\x1b[3m\x1b[4mSTACK MAKER DOCKER BASED\x1b[m"
echo ''

THECHOICE="$1"

if [ "$THECHOICE" == "CORE" ] ; then
# Path to the dynamic instance details file
INSTANCE_DETAILS_FILE="/opt/Matsya/tmp/47Y3ax5kc0Zbhx0/Stack_mBRE2gHRfCtOxbY"
DOCKER_DATA_DIR="/shiva/local/storage/s5jdfdfsdf"
CEPH_DATA_DIR="/shiva/local/storage/khkj5hdfjkh"
CERTS_DIR="/shiva/local/storage/certs"
ADMIN_PASSWORD="qtofCcq519714UdVnqd0j"
THEVISIONID="23"
CLUSTERID="ipifj5odpi"

if [[ ! -d "$BASE/Output/Vision/V$THEVISIONID" ]]; then
	sudo mkdir -p "$BASE/Output/Vision/V$THEVISIONID"
	sudo chmod -R 777 "$BASE/Output/Vision/V$THEVISIONID"
fi

HASHED_PASSWORD=$(python3 -c "from bcrypt import hashpw, gensalt; print(hashpw(b'$ADMIN_PASSWORD', gensalt()).decode())")
PortainerAPort=$(GetNewPort) && PORTSLIST+=("$PortainerAPort")
PortainerSPort=$(GetNewPort) && PORTSLIST+=("$PortainerSPort")
STACKNAME="v""$THEVISIONID""c""$CLUSTERID"
UNLOCKFILEPATH="$BASE/Output/Vision/V$THEVISIONID/$STACKNAME.dsuk"
MJTFILEPATH="$BASE/Output/Vision/V$THEVISIONID/$STACKNAME.dsmjt"
WJTFILEPATH="$BASE/Output/Vision/V$THEVISIONID/$STACKNAME.dswjt"
REVERSED_PASSWORD=$(echo "$ADMIN_PASSWORD" | rev)
	
# Arrays to hold manager and worker details
declare -a MANAGER_IPS
declare -a WORKER_IPS
declare -A PEM_FILES
declare -A PORTS
declare -A OS_TYPES
declare -A LOGIN_USERS
declare -A APP_MEM
declare -A APP_CORE

# Function to parse the instance details file
parse_instance_details() {
    while IFS='├' read -r IP HOSTNAME PORT PEM ROLE OS U1SER M1EM C1ORE; do
        PEM_FILES["$IP"]="$PEM"
        PORTS["$IP"]="$PORT"
        OS_TYPES["$IP"]="$OS"
        LOGIN_USERS["$IP"]="$U1SER"
        APP_MEM["$IP"]="$M1EM"
        APP_CORE["$IP"]="$C1ORE"     
        if [ "$ROLE" == "MANAGER" ]; then
            MANAGER_IPS+=("$IP")
        elif [ "$ROLE" == "WORKER" ]; then
            WORKER_IPS+=("$IP")
        fi
    done < "$INSTANCE_DETAILS_FILE"
}

# Function to run commands on remote hosts
run_remote() {
    local IP=$1
    local CMD=$2
    local PORT=${PORTS[$IP]}
    local THEREQUSER=${LOGIN_USERS[$IP]}
    ssh -i "${PEM_FILES[$IP]}" -o StrictHostKeyChecking=no -p $PORT $THEREQUSER@$IP "$CMD"
}

# Function to generate SSL certificates based on OS type
generate_ssl_certificates() {
    local IP=$1
    local OS=${OS_TYPES[$IP]}
    
    if [[ "$OS" == "UBU" ]]; then
        run_remote $IP "sudo NEEDRESTART_MODE=a apt-get install -y openssl"
    elif [[ "$OS" == "AZL" ]]; then
        run_remote $IP "sudo yum install -y openssl"
    elif [[ "$OS" == "ROCKY" || "$OS" == "ALMA" ]]; then
        run_remote $IP "sudo dnf install -y openssl"
    fi
    
    local IPHF=$(echo "$IP" | sed 's/\./-/g')
    
    run_remote $IP "
        sudo mkdir -p $CERTS_DIR && sudo chmod -R 777 $CERTS_DIR && cd $CERTS_DIR
        openssl genpkey -algorithm RSA -out $IPHF-key.pem
        openssl req -x509 -new -nodes -key $IPHF-key.pem -sha256 -days 3650 -out $IPHF.pem -subj '/CN=vamana-swarm'
        openssl genpkey -algorithm RSA -out $IPHF-server-key.pem
        openssl req -new -key $IPHF-server-key.pem -out $IPHF.csr -subj '/CN=$IP'
        openssl x509 -req -in $IPHF.csr -CA $IPHF.pem -CAkey $IPHF-key.pem -CAcreateserial -out $IPHF-server-cert.pem -days 3650 -sha256                
        sudo mkdir -p $CERTS_DIR/docker && sudo chmod -R 777 $CERTS_DIR/docker
        sudo rm -f $CERTS_DIR/docker/*
        sudo cp $IPHF.pem $IPHF-server-cert.pem $IPHF-server-key.pem $CERTS_DIR/docker/
        sudo rm -f $IPHF-key.pem
        sudo rm -f $IPHF.pem
        sudo rm -f $IPHF-server-key.pem
        sudo rm -f $IPHF.csr
        sudo rm -f $IPHF-server-cert.pem
        cd ~
    "
}

# Function to copy SSL certificates to other manager nodes via local machine
copy_ssl_certificates() {
    local SRC_IP=$1
    local IPHF=$(echo "$SRC_IP" | sed 's/\./-/g')
    local THESRCUSER=${LOGIN_USERS[$SRC_IP]}

    sudo rm -f $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker.pem
    sudo rm -f $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker-server-cert.pem
    sudo rm -f $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker-server-key.pem
        
    # Download certificates from the first manager to the local machine
    run_remote $SRC_IP "
        sudo chmod 644 $CERTS_DIR/docker/$IPHF.pem
        sudo chmod 644 $CERTS_DIR/docker/$IPHF-server-cert.pem
        sudo chmod 644 $CERTS_DIR/docker/$IPHF-server-key.pem
    "    
    scp -i ${PEM_FILES[$SRC_IP]} -P ${PORTS[$SRC_IP]} -o StrictHostKeyChecking=no $THESRCUSER@$SRC_IP:$CERTS_DIR/docker/$IPHF.pem $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker.pem
    scp -i ${PEM_FILES[$SRC_IP]} -P ${PORTS[$SRC_IP]} -o StrictHostKeyChecking=no $THESRCUSER@$SRC_IP:$CERTS_DIR/docker/$IPHF-server-cert.pem $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker-server-cert.pem
    scp -i ${PEM_FILES[$SRC_IP]} -P ${PORTS[$SRC_IP]} -o StrictHostKeyChecking=no $THESRCUSER@$SRC_IP:$CERTS_DIR/docker/$IPHF-server-key.pem $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker-server-key.pem
    run_remote $SRC_IP "
        sudo chown root:root $CERTS_DIR/docker/$IPHF.pem
        sudo chown root:root $CERTS_DIR/docker/$IPHF-server-cert.pem
        sudo chown root:root $CERTS_DIR/docker/$IPHF-server-key.pem    
        sudo chmod 644 $CERTS_DIR/docker/$IPHF.pem
        sudo chmod 644 $CERTS_DIR/docker/$IPHF-server-cert.pem
        sudo chmod 600 $CERTS_DIR/docker/$IPHF-server-key.pem
    " 
        
    # Upload certificates to each of the other manager nodes
    sudo chmod 777 $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker.pem
    sudo chmod 777 $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker-server-cert.pem
    sudo chmod 777 $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker-server-key.pem
    for IP in "${MANAGER_IPS[@]:1}" "${WORKER_IPS[@]}"; do
        local THEREQUSER=${LOGIN_USERS[$IP]}
        
        scp -i "${PEM_FILES[$IP]}" -P "${PORTS[$IP]}" -o StrictHostKeyChecking=no $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker.pem $THEREQUSER@$IP:/home/$THEREQUSER/$IPHF.pem
        scp -i "${PEM_FILES[$IP]}" -P "${PORTS[$IP]}" -o StrictHostKeyChecking=no $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker-server-cert.pem $THEREQUSER@$IP:/home/$THEREQUSER/$IPHF-server-cert.pem
        scp -i "${PEM_FILES[$IP]}" -P "${PORTS[$IP]}" -o StrictHostKeyChecking=no $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker-server-key.pem $THEREQUSER@$IP:/home/$THEREQUSER/$IPHF-server-key.pem
        
        # Move the certificates to the correct location on the target manager
        I1PHF="$STACKNAME"
        run_remote $IP "
            sudo mkdir -p $CERTS_DIR/docker && sudo chmod -R 777 $CERTS_DIR/docker 
            sudo rm -f $CERTS_DIR/docker/*           
            sudo mv /home/$THEREQUSER/$IPHF.pem $CERTS_DIR/docker/$I1PHF.pem
            sudo mv /home/$THEREQUSER/$IPHF-server-key.pem $CERTS_DIR/docker/$I1PHF-server-key.pem
            sudo mv /home/$THEREQUSER/$IPHF-server-cert.pem $CERTS_DIR/docker/$I1PHF-server-cert.pem
            sudo chown root:root $CERTS_DIR/docker/$I1PHF.pem
            sudo chown root:root $CERTS_DIR/docker/$I1PHF-server-cert.pem
            sudo chown root:root $CERTS_DIR/docker/$I1PHF-server-key.pem                        
            sudo chmod 644 $CERTS_DIR/docker/$I1PHF.pem
            sudo chmod 644 $CERTS_DIR/docker/$I1PHF-server-cert.pem
            sudo chmod 600 $CERTS_DIR/docker/$I1PHF-server-key.pem            
            sudo rm -f /home/$THEREQUSER/$IPHF.pem
            sudo rm -f /home/$THEREQUSER/$IPHF-server-key.pem
            sudo rm -f /home/$THEREQUSER/$IPHF-server-cert.pem            
        "
    done
    MGR=$(echo "${MANAGER_IPS[0]}" | sed 's/\./-/g')
    run_remote ${MANAGER_IPS[0]} "
            sudo mv $CERTS_DIR/docker/$MGR.pem $CERTS_DIR/docker/$STACKNAME.pem
            sudo mv $CERTS_DIR/docker/$MGR-server-key.pem $CERTS_DIR/docker/$STACKNAME-server-key.pem
            sudo mv $CERTS_DIR/docker/$MGR-server-cert.pem $CERTS_DIR/docker/$STACKNAME-server-cert.pem
    "      
    
    # Clean up local files
    sudo rm -f $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker.pem
    sudo rm -f $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker-server-cert.pem
    sudo rm -f $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker-server-key.pem
}

# Function to create an encrypted overlay network
create_encrypted_overlay_network() {
    run_remote ${MANAGER_IPS[0]} "
        docker network create \
          --driver overlay \
          --attachable \
          --opt encrypted \
          $STACKNAME-encrypted-overlay
    "
}

# Function to setup Docker
install_docker() {
    local IP=$2
    local MACTYPE=$1
    
    local OS=${OS_TYPES[$IP]}
    local P1ORT=${PORTS[$IP]}
    local THE1REQUSER=${LOGIN_USERS[$IP]}
    local THE1REQPEM=${PEM_FILES[$IP]}
        
    TLSSTUFF=""
    local IPHF="$STACKNAME"
    if [ "$MACTYPE" == "M" ] ; then
    	TLSSTUFF="--tlsverify --tlscacert=$CERTS_DIR/docker/$IPHF.pem --tlscert=$CERTS_DIR/docker/$IPHF-server-cert.pem --tlskey=$CERTS_DIR/docker/$IPHF-server-key.pem "
    fi
    if [ "$MACTYPE" == "W" ] ; then
    	TLSSTUFF="--tlsverify --tlscacert=$CERTS_DIR/docker/$IPHF.pem --tlscert=$CERTS_DIR/docker/$IPHF-server-cert.pem --tlskey=$CERTS_DIR/docker/$IPHF-server-key.pem "
    fi
        
    DOCKERTEMPLATE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
    sudo cp $BASE/Resources/DockerSetUpTemplate $BASE/tmp/$DOCKERTEMPLATE

    sed -i -e s~"THEREQOS"~"$OS"~g $BASE/tmp/$DOCKERTEMPLATE
    sed -i -e s~"THEREQDDD"~"$DOCKER_DATA_DIR"~g $BASE/tmp/$DOCKERTEMPLATE
    sed -i -e s~"THEREQGDD"~"$CEPH_DATA_DIR"~g $BASE/tmp/$DOCKERTEMPLATE    
    sed -i -e s~"THEREQTLS"~"$TLSSTUFF"~g $BASE/tmp/$DOCKERTEMPLATE
    sed -i -e s~"THEREQAPORT"~"$PortainerAPort"~g $BASE/tmp/$DOCKERTEMPLATE
    sed -i -e s~"THEREQSPORT"~"$PortainerSPort"~g $BASE/tmp/$DOCKERTEMPLATE
    
    sudo chmod 777 $BASE/tmp/$DOCKERTEMPLATE
     
    max_attempts=5
    attempt=0
    while true; do
    	attempt=$((attempt + 1))
        scp -i "$THE1REQPEM" -o StrictHostKeyChecking=no -P $P1ORT "$BASE/tmp/$DOCKERTEMPLATE" "$THE1REQUSER@$IP:/home/$THE1REQUSER"
        status=$?
        if [ $status -eq 0 ]; then
            ssh -i "$THE1REQPEM" -o StrictHostKeyChecking=no -p $P1ORT $THE1REQUSER@$IP "sudo rm -f /home/$THE1REQUSER/SetUpDocker.sh && sudo mv /home/$THE1REQUSER/$DOCKERTEMPLATE /home/$THE1REQUSER/SetUpDocker.sh && sudo chmod 777 /home/$THE1REQUSER/SetUpDocker.sh && /home/$THE1REQUSER/SetUpDocker.sh"
            sudo rm -f $BASE/tmp/$DOCKERTEMPLATE
            break
        else
            if [ $attempt -ge $max_attempts ]; then
                echo "Maximum attempts reached. Exiting."
                exit 1
            fi
            sleep 5
        fi
    done        
}

# Parse instance details
parse_instance_details

# Generate SSL certificates on the first manager node
generate_ssl_certificates ${MANAGER_IPS[0]}

# Copy SSL certificates to the other manager nodes
copy_ssl_certificates ${MANAGER_IPS[0]}

# Install Docker on all nodes
for IP in "${MANAGER_IPS[@]}"; do
    install_docker "M" $IP
done
for IP in "${WORKER_IPS[@]}"; do
    install_docker "W" $IP
done

# Initialize Docker Swarm with custom ports and autolock on the first manager node
run_remote ${MANAGER_IPS[0]} "docker swarm init --advertise-addr ${MANAGER_IPS[0]} --autolock"

sudo rm -f $UNLOCKFILEPATH
sudo rm -f $MJTFILEPATH
sudo rm -f $WJTFILEPATH

SWARM_UNLOCK_KEY=$(run_remote ${MANAGER_IPS[0]} "docker swarm unlock-key -q")
ULFP_FILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
ULFP1_FILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
echo $SWARM_UNLOCK_KEY > $BASE/tmp/$ULFP1_FILE
$BASE/Scripts/SecretsFile-Encrypter "$BASE/tmp/$ULFP1_FILE├$UNLOCKFILEPATH├$ADMIN_PASSWORD├$ULFP_FILE"
sudo chmod 777 $UNLOCKFILEPATH
sudo rm -f $BASE/tmp/$ULFP1_FILE

# Get the join token for manager and worker nodes
MANAGER_JOIN_TOKEN=$(run_remote ${MANAGER_IPS[0]} "docker swarm join-token manager -q")
WORKER_JOIN_TOKEN=$(run_remote ${MANAGER_IPS[0]} "docker swarm join-token worker -q")
MJTFP_FILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
MJTFP1_FILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
echo $MANAGER_JOIN_TOKEN > $BASE/tmp/$MJTFP1_FILE
$BASE/Scripts/SecretsFile-Encrypter "$BASE/tmp/$MJTFP1_FILE├$MJTFILEPATH├$ADMIN_PASSWORD├$MJTFP_FILE"
sudo chmod 777 $MJTFILEPATH
sudo rm -f $BASE/tmp/$MJTFP1_FILE
WJTFP_FILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
WJTFP1_FILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
echo $WORKER_JOIN_TOKEN > $BASE/tmp/$WJTFP1_FILE
$BASE/Scripts/SecretsFile-Encrypter "$BASE/tmp/$WJTFP1_FILE├$WJTFILEPATH├$ADMIN_PASSWORD├$WJTFP_FILE"
sudo chmod 777 $WJTFILEPATH
sudo rm -f $BASE/tmp/$WJTFP1_FILE

# Join remaining manager nodes to the Swarm
for IP in "${MANAGER_IPS[@]:1}"; do
    run_remote $IP "docker swarm join --token $MANAGER_JOIN_TOKEN ${MANAGER_IPS[0]}:2377"
done

# Join worker nodes to the Swarm
for IP in "${WORKER_IPS[@]}"; do
    run_remote $IP "docker swarm join --token $WORKER_JOIN_TOKEN ${MANAGER_IPS[0]}:2377"
done

create_encrypted_overlay_network

DOCKER_VOLUME_NAME="$STACKNAME""portainerdata"

P1O1R1T=${PORTS[${MANAGER_IPS[0]}]}
THE1R1E1QUSE1R=${LOGIN_USERS[${MANAGER_IPS[0]}]}
SUBNET=$(ssh -i "${PEM_FILES[${MANAGER_IPS[0]}]}" -o StrictHostKeyChecking=no -p $P1O1R1T $THE1R1E1QUSE1R@${MANAGER_IPS[0]} "docker network inspect ${STACKNAME}-encrypted-overlay | grep -m 1 -oP '(?<=\"Subnet\": \")[^\"]+'")
echo "Using Subnet $SUBNET ..."

open_firewall_ports_for_seaweedfs() {
    local filer_port_start=8888
    local filer_port_end=$((filer_port_start + ${#MANAGER_IPS[@]} - 1))
    local volume_port_start=8080
    local volume_port_end=$((volume_port_start + ${#MANAGER_IPS[@]} + ${#WORKER_IPS[@]} - 1))
    local volume_meta_port_start=18080
    local volume_meta_port_end=$((volume_meta_port_start + ${#MANAGER_IPS[@]} + ${#WORKER_IPS[@]} - 1))
    local master_port_start=9333
    local master_port_end=$((master_port_start + ${#MANAGER_IPS[@]} - 1))
    local raft_port_start=9383
    local raft_port_end=$((raft_port_start + ${#MANAGER_IPS[@]} - 1))

    for IP in "${MANAGER_IPS[@]}" "${WORKER_IPS[@]}"; do
        run_remote $IP "
            sudo firewall-cmd --zone=public --permanent --add-port=${master_port_start}-${master_port_end}/tcp
            sudo firewall-cmd --zone=public --permanent --add-port=${volume_port_start}-${volume_port_end}/tcp
            sudo firewall-cmd --zone=public --permanent --add-port=${volume_meta_port_start}-${volume_meta_port_end}/tcp
            sudo firewall-cmd --zone=public --permanent --add-port=${filer_port_start}-${filer_port_end}/tcp
            sudo firewall-cmd --zone=public --permanent --add-port=${raft_port_start}-${raft_port_end}/tcp
            sudo firewall-cmd --reload
        "
    done
}
get_node_id() {
    local ip=$1
    local node_id=$(ssh -i "${PEM_FILES[${MANAGER_IPS[0]}]}" -o StrictHostKeyChecking=no -p ${PORTS[${MANAGER_IPS[0]}]} ${LOGIN_USERS[${MANAGER_IPS[0]}]}@${MANAGER_IPS[0]} "docker node ls --format '{{.ID}} {{.Hostname}}' | grep \$(getent hosts $ip | awk '{ print \$2 }') | awk '{ print \$1 }'")
    echo $node_id
}
label_nodes() {
    local index=1
    for IP in "${MANAGER_IPS[@]}"; do
        node_id=$(get_node_id $IP)
        ssh -i "${PEM_FILES[${MANAGER_IPS[0]}]}" -o StrictHostKeyChecking=no -p ${PORTS[${MANAGER_IPS[0]}]} ${LOGIN_USERS[${MANAGER_IPS[0]}]}@${MANAGER_IPS[0]} "echo \"camehere1\" && hostname && docker node update --label-add seaweedfs.master=true --label-add seaweedfs.index=$index $node_id"
        index=$((index+1))
    done

    index=1
    for IP in "${MANAGER_IPS[@]}" "${WORKER_IPS[@]}"; do
        node_id=$(get_node_id $IP)
        ssh -i "${PEM_FILES[${MANAGER_IPS[0]}]}" -o StrictHostKeyChecking=no -p ${PORTS[${MANAGER_IPS[0]}]} ${LOGIN_USERS[${MANAGER_IPS[0]}]}@${MANAGER_IPS[0]} "echo \"camehere2\" && hostname && docker node update --label-add seaweedfs.volume=true --label-add seaweedfs.index=$index $node_id"
        index=$((index+1))
    done
}
deploy_seaweedfs_master() {
    local master_ips=(${MANAGER_IPS[@]})
    local master_ip_count=${#master_ips[@]}
    local master_peers=""
    local index=0

    for IP in "${master_ips[@]}"; do
        master_peers+="$IP:$((9383 + index)),"
        index=$((index+1))
    done
    master_peers=${master_peers%,}

    index=0
    for IP in "${MANAGER_IPS[@]}"; do
        ssh -i "${PEM_FILES[${MANAGER_IPS[0]}]}" -o StrictHostKeyChecking=no -p ${PORTS[${MANAGER_IPS[0]}]} ${LOGIN_USERS[${MANAGER_IPS[0]}]}@${MANAGER_IPS[0]} "
            echo \"camehere3\" && hostname && docker service create \
                --name seaweedfs-master-$index \
                --network $STACKNAME-encrypted-overlay \
                --replicas 1 \
                --constraint 'node.labels.seaweedfs.master == true' \
                --publish $((9333 + index)):$((9333 + index)) \
                --publish $((9383 + index)):$((9383 + index)) \
                chrislusf/seaweedfs:latest master -ip $IP -peers $master_peers
        "
        index=$((index+1))
    done
}
deploy_seaweedfs_volume() {
    local master_mounts=""
    local index=0
    for IP in "${MANAGER_IPS[@]}"; do
        master_mounts+="$IP:$((9333 + index)),"
        index=$((index+1))
    done
    master_mounts=${master_mounts%,}

    index=0
    for IP in "${MANAGER_IPS[@]}" "${WORKER_IPS[@]}"; do
        ssh -i "${PEM_FILES[${MANAGER_IPS[0]}]}" -o StrictHostKeyChecking=no -p ${PORTS[${MANAGER_IPS[0]}]} ${LOGIN_USERS[${MANAGER_IPS[0]}]}@${MANAGER_IPS[0]} "
            echo \"camehere4\" && hostname && docker service create \
                --name seaweedfs-volume-$index \
                --network $STACKNAME-encrypted-overlay \
                --mode global \
                --constraint 'node.labels.seaweedfs.volume == true' \
                --publish $((8080 + index)):8080 \
                --publish $((18080 + index)):18080 \
                --mount type=bind,src=/mnt/seaweedfs/data,dst=/data \
                chrislusf/seaweedfs:latest volume -mserver $master_mounts -ip $IP
        "
        index=$((index+1))
    done
}
deploy_seaweedfs_filer() {
    local master_mounts=""
    local index=0
    for IP in "${MANAGER_IPS[@]}"; do
        master_mounts+="$IP:$((9333 + index)),"
        index=$((index+1))
    done
    master_mounts=${master_mounts%,}

    index=0
    for IP in "${MANAGER_IPS[@]}"; do
        local port=$((8888 + index))
        ssh -i "${PEM_FILES[${MANAGER_IPS[0]}]}" -o StrictHostKeyChecking=no -p ${PORTS[${MANAGER_IPS[0]}]} ${LOGIN_USERS[${MANAGER_IPS[0]}]}@${MANAGER_IPS[0]} "
            echo \"camehere5\" && hostname && docker service create \
                --name seaweedfs-filer-$index \
                --network $STACKNAME-encrypted-overlay \
                --replicas 1 \
                --constraint 'node.labels.seaweedfs.master == true' \
                --publish ${port}:${port} \
                chrislusf/seaweedfs:latest filer -master=$master_mounts -port=${port}
        "
        index=$((index+1))
    done
}
create_fuse_mount() {
    for ip in "${MANAGER_IPS[@]}" "${WORKER_IPS[@]}"; do
        ssh -i "${PEM_FILES[$ip]}" -o StrictHostKeyChecking=no -p ${PORTS[$ip]} ${LOGIN_USERS[$ip]}@$ip "sudo apt-get update -y && sudo apt-get install -y fuse && sudo modprobe fuse && sudo groupadd fuse && sudo usermod -aG fuse \$(whoami) && sudo rm -f /usr/local/bin/weed && THEVERSION=\$(curl -s https://api.github.com/repos/seaweedfs/seaweedfs/releases/latest | grep tag_name | cut -d '\"' -f 4) && wget https://github.com/seaweedfs/seaweedfs/releases/download/\$THEVERSION/linux_amd64.tar.gz && tar xf linux_amd64.tar.gz && rm -f linux_amd64.tar.gz && sudo mv weed /usr/local/bin/weed && sudo chmod +x /usr/local/bin/weed && sudo mkdir -p /mnt/seaweedfs/fuse && sudo chmod -R 777 /mnt/seaweedfs/fuse"
    done
    local filer_mounts=""
    local index=0
    for IP in "${MANAGER_IPS[@]}"; do
        local port=$((8888 + index))
        filer_mounts+="${IP}:${port},"
        index=$((index+1))
    done
    filer_mounts=${filer_mounts%,}

    for IP in "${MANAGER_IPS[@]}" "${WORKER_IPS[@]}"; do
        run_remote $IP "sudo weed mount -filer=${filer_mounts} -dir=/mnt/seaweedfs/fuse -filer.path=/fuse"
    done
}

open_firewall_ports_for_seaweedfs
label_nodes
deploy_seaweedfs_master
deploy_seaweedfs_volume
deploy_seaweedfs_filer
create_fuse_mount

#NUM_MANAGERS=${#MANAGER_IPS[@]}
NUM_MANAGERS="1"
THEMANGIP="${MANAGER_IPS[0]}"
THE1RAM=${APP_MEM[$THEMANGIP]}
R1AM=$( [[ $THE1RAM == *,* ]] && echo "${THE1RAM#*,}" || echo "$THE1RAM" )
THE1CORE=${APP_CORE[$THEMANGIP]}
C1ORE=$( [[ $THE1CORE == *,* ]] && echo "${THE1CORE#*,}" || echo "$THE1CORE" ) 
    
for IP in "${MANAGER_IPS[@]}"; do
	NODE_ID=$(run_remote $IP "docker info -f '{{.Swarm.NodeID}}'")
	if [ -n "$NODE_ID" ]; then
	    run_remote $IP "docker node update --label-add $STACKNAME""portainerreplica=true $NODE_ID"
	else
	    echo "Node $IP is not part of a Swarm"
	fi
done

echo "" && echo "Install Portainer..."
# Deploy Portainer on the manager nodes with HTTPS --mount type=volume,src=$DOCKER_VOLUME_NAME,dst=/data \
run_remote ${MANAGER_IPS[0]} "
    docker service create \
        --name $STACKNAME""portainer \
        --network $STACKNAME-encrypted-overlay \
        --replicas $NUM_MANAGERS \
        --publish $PortainerSPort:9443 \
        --constraint 'node.labels.$STACKNAME""portainerreplica == true' \
        --constraint 'node.role == manager' \
        --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
        --mount type=bind,src=/mnt/seaweedfs/fuse,dst=/data \
        --mount type=bind,src=$CERTS_DIR/docker/$STACKNAME.pem,dst=/certs/sca.pem,readonly \
        --mount type=bind,src=$CERTS_DIR/docker/$STACKNAME-server-cert.pem,dst=/certs/scert.pem,readonly \
        --mount type=bind,src=$CERTS_DIR/docker/$STACKNAME-server-key.pem,dst=/certs/skey.pem,readonly \
        --limit-cpu $C1ORE --limit-memory $R1AM""M -e \"AGENT_PORT=$PortainerAPort\" portainer/portainer-ce --ssl --sslcert /certs/scert.pem --sslkey /certs/skey.pem --agent-secret $REVERSED_PASSWORD"

PORTAINER_URL="https://${MANAGER_IPS[0]}:$PortainerSPort/api"
USERNAME="admin"
MAX_RETRIES=100
SLEEP_INTERVAL=5
THENEW1ENV="$STACKNAME"
set_admin_password() {
    curl -k -X POST "$PORTAINER_URL/users/admin/init" \
    -H "Content-Type: application/json" \
    --data "{\"Username\": \"$USERNAME\", \"Password\": \"$ADMIN_PASSWORD\"}"
}
is_portainer_up() {
    curl -k -s -o /dev/null -w "%{http_code}" "$PORTAINER_URL/status" | grep -q "200"
}
rename_environment() {
	THEORG1ENV="local"    
	THEREQ1TOKEN=$(curl -k -s -X POST "$PORTAINER_URL/auth" \
    -H "Content-Type: application/json" \
    --data "{\"Username\": \"$USERNAME\", \"Password\": \"$ADMIN_PASSWORD\"}" | jq -r '.jwt')    
	echo $THEREQ1TOKEN
	THEREQ1ENV=$(curl -k -s -X GET "$PORTAINER_URL/endpoints" \
        -H "Content-Type: application/json" \
        --header "Authorization: Bearer $THEREQ1TOKEN" | jq -r '.[] | select(.Name=="local").Id')  
	echo $THEREQ1ENV
	curl -k -X PUT "$PORTAINER_URL/endpoints/$THEREQ1ENV" \
    -H "Content-Type: application/json" \
    --header "Authorization: Bearer $THEREQ1TOKEN" \
    --data "{\"Name\": \"$THENEW1ENV\"}"
}
echo "Waiting for Portainer to be ready..."
RETRIES=0
until is_portainer_up || [ $RETRIES -eq $MAX_RETRIES ]; do
    echo "Portainer is not up yet. Retrying in $SLEEP_INTERVAL seconds..."
    sleep $SLEEP_INTERVAL
    RETRIES=$((RETRIES+1))
done
if [ $RETRIES -eq $MAX_RETRIES ]; then
    echo "Portainer did not become ready in time. Exiting."
    exit 1
fi

set_admin_password

echo "" && echo "Install Portainer Agent..."
# Deploy Portainer agent on all nodes (both managers and workers)
for IP in "${MANAGER_IPS[0]}"; do
    IPHF="$STACKNAME"
    IWP="${WORKER_IPS[0]}"
    THE1RAM=${APP_MEM[$IWP]}
    R1AM=$( [[ $THE1RAM == *,* ]] && echo "${THE1RAM#*,}" || echo "$THE1RAM" )
    THE1CORE=${APP_CORE[$IWP]}
    C1ORE=$( [[ $THE1CORE == *,* ]] && echo "${THE1CORE#*,}" || echo "$THE1CORE" )    
    run_remote $IP "
        docker service create \
            --name $STACKNAME""portaineragent \
            --network $STACKNAME-encrypted-overlay \
            --mode global \
            --publish $PortainerAPort:9001 \
            --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
            --limit-cpu $C1ORE \
            --limit-memory $R1AM""M portainer/agent --secret $REVERSED_PASSWORD"
done

#run_remote ${MANAGER_IPS[0]} "docker service update --replicas 3 --constraint-add 'node.labels.$STACKNAME""portainerreplica == true' $STACKNAME""portainer"

echo "Docker Swarm setup completed successfully.Ports List ${PORTSLIST[@]}.URL : https://${MANAGER_IPS[0]}:$PortainerSPort"

simulate_first_login() {
    TOKEN=$(curl -k -s -X POST "$PORTAINER_URL/auth" \
    -H "Content-Type: application/json" \
    --data "{\"Username\": \"$USERNAME\", \"Password\": \"$ADMIN_PASSWORD\"}" | jq -r '.jwt')
    curl -k -s -X GET "$PORTAINER_URL/endpoints" \
        -H "Content-Type: application/json" \
        --header "Authorization: Bearer $TOKEN"
}
is_environment_ready() {
	TOKEN=$(curl -k -s -X POST "$PORTAINER_URL/auth" \
    -H "Content-Type: application/json" \
    --data "{\"Username\": \"$USERNAME\", \"Password\": \"$ADMIN_PASSWORD\"}" | jq -r '.jwt')    
	ENV_ID=$(curl -k -s -X GET "$PORTAINER_URL/endpoints" \
        -H "Content-Type: application/json" \
        --header "Authorization: Bearer $TOKEN" | jq -r '.[] | select(.Name=="local").Id')   
    if [ -z "$ENV_ID" ]; then
        return 1
    else
        return 0
    fi
}
simulate_first_login
echo "Waiting for the local environment to be ready..."
RETRIES=0
until is_environment_ready || [ $RETRIES -eq $MAX_RETRIES ]; do
    echo "Local environment is not ready yet. Retrying in $SLEEP_INTERVAL seconds..."
    sleep $SLEEP_INTERVAL
    RETRIES=$((RETRIES+1))
done
if [ $RETRIES -eq $MAX_RETRIES ]; then
    echo "Local environment did not become ready in time. Exiting."
    exit 1
fi
rename_environment
fi

sudo rm -rf /root/.bash_history
sudo rm -rf /home/$CURRENTUSER/.bash_history

