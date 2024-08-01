#!/bin/bash

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

function GetNewPortRange {
    local FreshPortRange=$($BASE/Scripts/GetRandomPortRange.sh 10000 12000)
    if printf '%s\0' "${PORTSLIST[@]}" | grep -Fxqz -- $FreshPortRange; then
    	GetNewPortRange
    fi
    echo $FreshPortRange
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
THEARGS="$2"

if [ "$THECHOICE" == "CORE" ] ; then
IFS='├' read -r -a THE_ARGS <<< $THEARGS
INSTANCE_DETAILS_FILE="${THE_ARGS[0]}"
VISION_KEY="${THE_ARGS[1]}"
ADMIN_PASSWORD="${THE_ARGS[2]}"
THEVISIONID="${THE_ARGS[3]}"
CLUSTERID="${THE_ARGS[4]}"
STACKPRETTYNAME="${THE_ARGS[5]}"
ISAUTOMATED="${THE_ARGS[6]}"
THENOHUPFILE="${THE_ARGS[7]}"
WEBSSH_PASSWORD="${THE_ARGS[8]}"
REQUNQ="${THE_ARGS[9]}"

if [[ ! -d "$BASE/Output/Vision/V$THEVISIONID" ]]; then
	sudo mkdir -p "$BASE/Output/Vision/V$THEVISIONID"
	sudo chmod -R 777 "$BASE/Output/Vision/V$THEVISIONID"
fi

HASHED_PASSWORD=$(python3 -c "from bcrypt import hashpw, gensalt; print(hashpw(b'$ADMIN_PASSWORD', gensalt()).decode())")

PortainerAPort=$(GetNewPort) && PORTSLIST+=("$PortainerAPort")
PortainerSPort=$(GetNewPort) && PORTSLIST+=("$PortainerSPort")
VarahaPort1=$(GetNewPortRange) && PORTSLIST+=("$VarahaPort1")
VarahaPort2=$(GetNewPort) && PORTSLIST+=("$VarahaPort2")
VarahaPort3=$(GetNewPort) && PORTSLIST+=("$VarahaPort3")
VarahaPort4=$(GetNewPort) && PORTSLIST+=("$VarahaPort4")
BDDPort1=$(GetNewPort) && PORTSLIST+=("$BDDPort1")
BDDPort2=$(GetNewPort) && PORTSLIST+=("$BDDPort2")
WEBSSHPort1=$(GetNewPort) && PORTSLIST+=("$WEBSSHPort1")
ChitraGuptaPort1=$(GetNewPortRange) && PORTSLIST+=("$ChitraGuptaPort1")
ChitraGuptaPort2=$(GetNewPortRange) && PORTSLIST+=("$ChitraGuptaPort2")
ChitraGuptaPort3=$(GetNewPortRange) && PORTSLIST+=("$ChitraGuptaPort3")
ChitraGuptaPort4=$(GetNewPortRange) && PORTSLIST+=("$ChitraGuptaPort4")
ChitraGuptaPort5=$(GetNewPort) && PORTSLIST+=("$ChitraGuptaPort5")
ChitraGuptaPort6=$(GetNewPort) && PORTSLIST+=("$ChitraGuptaPort6")
ChitraGuptaPort7=$(GetNewPort) && PORTSLIST+=("$ChitraGuptaPort7")
ChitraGuptaPort8=$(GetNewPortRange) && PORTSLIST+=("$ChitraGuptaPort8")
ChitraGuptaPortU1=$(GetNewPortRange) && PORTSLIST+=("$ChitraGuptaPortU1")
ChitraGuptaPortV1=$(GetNewPortRange) && PORTSLIST+=("$ChitraGuptaPortV1")
ChitraGuptaPortW1=$(GetNewPortRange) && PORTSLIST+=("$ChitraGuptaPortW1")
ChitraGuptaPortY1=$(GetNewPort) && PORTSLIST+=("$ChitraGuptaPortY1")
ChitraGuptaPortZ1=$(GetNewPort) && PORTSLIST+=("$ChitraGuptaPortZ1")
ChitraGuptaPortLDP1=$(GetNewPortRange) && PORTSLIST+=("$ChitraGuptaPortLDP1")
ChitraGuptaPortLDP2=$(GetNewPortRange) && PORTSLIST+=("$ChitraGuptaPortLDP2")
ChitraGuptaPortLDP3=$(GetNewPortRange) && PORTSLIST+=("$ChitraGuptaPortLDP3")
ChitraGuptaPortLDP4=$(GetNewPort) && PORTSLIST+=("$ChitraGuptaPortLDP4")
ChitraGuptaPortLDP5=$(GetNewPort) && PORTSLIST+=("$ChitraGuptaPortLDP5")
ChitraGuptaPortKERB1=$(GetNewPortRange) && PORTSLIST+=("$ChitraGuptaPortKERB1")
ChitraGuptaPortKERB2=$(GetNewPortRange) && PORTSLIST+=("$ChitraGuptaPortKERB2")
ChitraGuptaPortKERB3=$(GetNewPort) && PORTSLIST+=("$ChitraGuptaPortKERB3")
ChitraGuptaPortKERB4=$(GetNewPort) && PORTSLIST+=("$ChitraGuptaPortKERB4")
MINPortIO1=$(GetNewPortRange) && PORTSLIST+=("$MINPortIO1")
MINPortIO2=$(GetNewPortRange) && PORTSLIST+=("$MINPortIO2")
MINPortIO3=$(GetNewPort) && PORTSLIST+=("$MINPortIO3")
MINPortIO4=$(GetNewPort) && PORTSLIST+=("$MINPortIO4")
FLBRPortIO1=$(GetNewPortRange) && PORTSLIST+=("$FLBRPortIO1")
FLBRPortIO2=$(GetNewPort) && PORTSLIST+=("$FLBRPortIO2")

STACKNAME="v""$THEVISIONID""c""$CLUSTERID"
UNLOCKFILEPATH="$BASE/Output/Vision/V$THEVISIONID/$STACKNAME.dsuk"
MJTFILEPATH="$BASE/Output/Vision/V$THEVISIONID/$STACKNAME.dsmjt"
WJTFILEPATH="$BASE/Output/Vision/V$THEVISIONID/$STACKNAME.dswjt"
REVERSED_PASSWORD=$(echo "$ADMIN_PASSWORD" | rev)
DOCKER_DATA_DIR="/shiva/local/storage/docker$STACKNAME"
DFS_DATA_DIR="/shiva/local/storage/dfs$STACKNAME"
DFS_DATA2_DIR="/shiva/local/storage/dfs$STACKNAME"
DFS_CLUSTER_DIR="/shiva/bdd/storage/$STACKNAME"
CERTS_DIR="/shiva/local/storage/certs$STACKNAME"
STACK_PRETTY_NAME=$(echo "$STACKPRETTYNAME" | tr '[:upper:]' '[:lower:]')
EXECUTESCRIPT=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1) && touch $BASE/tmp/$EXECUTESCRIPT && sudo chmod 777 $BASE/tmp/$EXECUTESCRIPT
EXECUTE1SCRIPT='#!/bin/bash'"
"
echo "$EXECUTE1SCRIPT" | sudo tee -a $BASE/tmp/$EXECUTESCRIPT > /dev/null
		
# Arrays to hold manager and worker details
declare -a BRAHMA_IPS
declare -a VISHVAKARMA_IPS
declare -a INDRA_IPS
declare -a KRISHNA_IPS
declare -a SAMPOORNA_IPS
declare -A HOST_NAMES
declare -A HOST_ALT_NAMES
declare -A PEM_FILES
declare -A PORTS
declare -A OS_TYPES
declare -A LOGIN_USERS
declare -A APP_MEM
declare -A APP_CORE
declare -A CLUSTER_TYPE
declare -A JIVA_IPS
declare -A ROLE_TYPE
NATIVE="1"
CHITRAGUPTA=""
CHITRAGUPTA_DET=""
MIN_IO_DET=""

# Function to prepare swarm dynamically
create_instance_details() {
    input_file="$1"
    output_file="$2"
    thereqmode="$3"
    
    # Read the file into an array
    mapfile -t lines < "$input_file"

    # Check if the number of lines is less than 3
    if [ ${#lines[@]} -lt 3 ]; then
        echo "Swarm setup not possible. Minimum 3 rows required."
        exit 1
    fi

    # Create an array to track which lines have been updated
    declare -A updated_lines

    manager_count=0
    worker_count=0
    router_count=0

    # Assign one manager, one worker, and one router first
    for i in "${!lines[@]}"; do
        if [ $manager_count -eq 0 ]; then
            updated_lines[$i]="BRAHMA"
            manager_count=$((manager_count + 1))
        elif [ $worker_count -eq 0 ]; then
            updated_lines[$i]="VISHVAKARMA"
            worker_count=$((worker_count + 1))
        elif [ $router_count -eq 0 ]; then
            updated_lines[$i]="INDRA"
            router_count=$((router_count + 1))
        fi

        # Exit the loop once we have at least one of each
        if [ $manager_count -eq 1 ] && [ $worker_count -eq 1 ] && [ $router_count -eq 1 ]; then
            break
        fi
    done

    # Assign remaining managers and workers
    for i in "${!lines[@]}"; do
        if [ -z "${updated_lines[$i]}" ]; then
            if [ $manager_count -lt 3 ]; then
                updated_lines[$i]="BRAHMA"
                manager_count=$((manager_count + 1))
            else
                updated_lines[$i]="VISHVAKARMA"
                worker_count=$((worker_count + 1))
            fi
        fi
    done

    # Process each line
    for i in "${!lines[@]}"; do
        line="${lines[$i]}"
        IFS=',' read -ra columns <<< "$line"
        
        uppercase_text=$(echo "${columns[8]}" | tr '[:lower:]' '[:upper:]')
        columns[8]="$uppercase_text"
        columns4=$(NARASIMHA "decrypt" "${columns[4]}" "$VISION_KEY")
        columns5=$(NARASIMHA "decrypt" "${columns[5]}" "$VISION_KEY")
        columns7=$(NARASIMHA "decrypt" "${columns[7]}" "$VISION_KEY")
        columns[4]="$columns4"
        columns[5]="$columns5"
        columns[7]="$columns7"
        
        if [[ "$thereqmode" == "Y" ]]; then
            if [[ "${updated_lines[$i]}" == "BRAHMA" ]]; then
                columns[9]="BRAHMA"
                columns[10]="1280"
                columns[11]="1"
            elif [[ "${updated_lines[$i]}" == "INDRA" ]]; then
                columns[9]="INDRA"
                columns[10]="1024"
                columns[11]="1"
            else
                columns[9]="VISHVAKARMA"
                columns[10]="512"
                columns[11]="0.5"
            fi
        fi
        
        # Reconstruct the line
        lines[$i]=$(IFS=','; echo "${columns[*]}")
    done

    # Write the updated lines to the output file
    printf "%s\n" "${lines[@]}" > "$output_file"
    echo "Updated file saved as $output_file"
}

if [[ "$ISAUTOMATED" == "Y" ]]; then
	terminator -e "bash -c 'tail -f $THENOHUPFILE; exec bash'"
	# CREATE FILE FOR STACKMAKER
	header=$(head -n 1 $INSTANCE_DETAILS_FILE)
	csv_data=$(tail -n +2 $INSTANCE_DETAILS_FILE)
	JSNDT1=$(echo "$csv_data" | awk -v header="$header" 'BEGIN { FS=","; OFS=","; split(header, keys, ","); print "[" } { print "{"; for (i=1; i<=NF; i++) { printf "\"%s\":\"%s\"", keys[i], $i; if (i < NF) printf ","; } print "},"; } END { print "{}]"; }' | sed '$s/,$//')
	JSNDT2=$(echo "$JSNDT1" | jq 'map(select(.IP != null and .IP != ""))')
	JSNDT3=$(echo "$JSNDT2" | jq 'map(select(.IP != "TBD"))')
	JSNDT4=$(echo "$JSNDT3" | jq 'map(select(.Encrypted != "N"))')
	JSNDT5=$(echo "$JSNDT4" | jq 'map(select(.Deleted != "Y"))')	
	JSNDT6=$(echo "$JSNDT5" | jq 'map(select(.InstanceType != "NA"))')	
		
	THESFTSTK_FILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)	
	THESFTSTKFILE="$BASE/tmp/Stack_$THESFTSTK_FILE.csv"
	header=$(echo "$JSNDT6" | jq -r '.[0] | keys_unsorted | join(",")')
	echo "$header" > "$THESFTSTKFILE"
	echo "$JSNDT6" | jq -c '.[]' | while IFS= read -r obj; do
	    record=$(echo "$obj" | jq -r 'map(.) | @csv')
	    echo "$record" >> "$THESFTSTKFILE"
	done	
	sudo chmod 777 $THESFTSTKFILE
	sed -i 's/""//g' "$THESFTSTKFILE"
	sed -i 's/"//g' "$THESFTSTKFILE"	
	# CREATE FILE FOR STACKMAKER
	
	# CREATE FILE FOR INSTANCE INPUT FOR STACKMAKER
	THE1SFTSTK_FILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)	
	THE1SFTSTKFILE="$BASE/tmp/Stack_$THE1SFTSTK_FILE.csv"
	columns="1,2,7,17,24,26,18,23,3"
	awk -F',' -v columns="$columns" '
BEGIN {
    split(columns, col, ",")
    col_count = length(col)
}
NR > 1 {
    output = ""
    for (i = 1; i <= col_count; i++) {
        output = output (i == 1 ? "" : ",") $col[i]
    }
    output = output ",TBD,TBD,TBD"
    print output
}
' "$THESFTSTKFILE" > "$THE1SFTSTKFILE"
	THE1SFTSTK2_FILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)	
	THE1SFTSTK1FILE="$BASE/tmp/Stack_$THE1SFTSTK2_FILE.csv"
	create_instance_details "$THE1SFTSTKFILE" "$THE1SFTSTK1FILE" "Y"	
	# CREATE FILE FOR INSTANCE INPUT FOR STACKMAKER
	
	sudo rm -f $THESFTSTKFILE
	sudo rm -f $THE1SFTSTKFILE
	
	INSTANCE_DETAILS_FILE="$THE1SFTSTK1FILE"
else
	THE1SFTSTK2_FILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)	
	THE1SFTSTK1FILE="$BASE/tmp/Stack_$THE1SFTSTK2_FILE.csv"
	create_instance_details "$INSTANCE_DETAILS_FILE" "$THE1SFTSTK1FILE" "N"
	INSTANCE_DETAILS_FILE="$THE1SFTSTK1FILE"					
fi

THEGUACA_SQL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
THEGUACASQL="$BASE/tmp/THEGUACA_SQL_$THEGUACA_SQL.sql" && touch $THEGUACASQL && sudo chmod 777 $THEGUACASQL

# Function to parse the instance details file
parse_instance_details() {
    echo 'sudo -H -u root bash -c "echo \"\" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTESCRIPT > /dev/null
    echo 'sudo -H -u root bash -c "echo \"#VAMANA => '"$STACKPRETTYNAME"' START \" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTESCRIPT > /dev/null 
    COUNTxER=0
    COUNTvER=0
    while IFS=',' read -r SCPID INSTID IP HOSTNAME PORT PEM OS U1SER C1TYPE ROLE M1EM C1ORE; do
        PEM_FILES["$IP"]="$PEM"
        PORTS["$IP"]="$PORT"
        OS_TYPES["$IP"]="$OS"
        LOGIN_USERS["$IP"]="$U1SER"
        APP_MEM["$IP"]="$M1EM"
        APP_CORE["$IP"]="$C1ORE" 
        CLUSTER_TYPE["$IP"]="$C1TYPE"
        hyphenated_ip="${IP//./-}"
        lowercase_text="${C1TYPE,,}"
        ROLE_TYPE["$IP"]="$ROLE"
        
        if [[ "$C1TYPE" == "ONPREM" ]]; then
        	echo "KRISHNA NA"
        else
        	KRISHNA_IPS+=("$IP,$PORT,$PEM,$U1SER")
        fi
        
        SAMPOORNA_IPS+=("$IP,$PORT,$PEM,$U1SER")
                       
        echo 'sudo -H -u root bash -c "sed -i -e s~'"$IP"'~#'"$IP"'~g /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTESCRIPT > /dev/null                     
        if [ "$ROLE" == "BRAHMA" ]; then
            BRAHMA_IPS+=("$IP")
            HOST_NAMES["$IP"]="$lowercase_text-$hyphenated_ip-v$THEVISIONID""-s$SCPID""-i$INSTID""-c$CLUSTERID-b"
            HOST_ALT_NAMES["$IP"]="alt-$lowercase_text-$hyphenated_ip-v$THEVISIONID""-s$SCPID""-i$INSTID""-c$CLUSTERID-b"
            echo 'sudo -H -u root bash -c "echo \"'"$IP"' '"$lowercase_text-$hyphenated_ip-v$THEVISIONID""-s$SCPID""-i$INSTID""-c$CLUSTERID-b"'\" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTESCRIPT > /dev/null            
        elif [ "$ROLE" == "VISHVAKARMA" ]; then
            VISHVAKARMA_IPS+=("$IP")
            if (( $COUNTvER == 0 )) ; then
		    HOST_NAMES["$IP"]="$lowercase_text-$hyphenated_ip-v$THEVISIONID""-s$SCPID""-i$INSTID""-c$CLUSTERID-c"
		    HOST_ALT_NAMES["$IP"]="alt-$lowercase_text-$hyphenated_ip-v$THEVISIONID""-s$SCPID""-i$INSTID""-c$CLUSTERID-c"
		    echo 'sudo -H -u root bash -c "echo \"'"$IP"' '"$lowercase_text-$hyphenated_ip-v$THEVISIONID""-s$SCPID""-i$INSTID""-c$CLUSTERID-c"'\" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTESCRIPT > /dev/null
		    CHITRAGUPTA="$IP"
		    CHITRAGUPTA_DET="$CHITRAGUPTA_DET""$IP,$PORT,$PEM,$U1SER"		                
            else
		    HOST_NAMES["$IP"]="$lowercase_text-$hyphenated_ip-v$THEVISIONID""-s$SCPID""-i$INSTID""-c$CLUSTERID-v"
		    HOST_ALT_NAMES["$IP"]="alt-$lowercase_text-$hyphenated_ip-v$THEVISIONID""-s$SCPID""-i$INSTID""-c$CLUSTERID-v"
		    echo 'sudo -H -u root bash -c "echo \"'"$IP"' '"$lowercase_text-$hyphenated_ip-v$THEVISIONID""-s$SCPID""-i$INSTID""-c$CLUSTERID-v"'\" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTESCRIPT > /dev/null
            fi
            COUNTvER=$((COUNTvER + 1))
        elif [ "$ROLE" == "INDRA" ]; then
            INDRA_IPS+=("$IP")
            HOST_NAMES["$IP"]="$lowercase_text-$hyphenated_ip-v$THEVISIONID""-s$SCPID""-i$INSTID""-c$CLUSTERID-i"
            HOST_ALT_NAMES["$IP"]="alt-$lowercase_text-$hyphenated_ip-v$THEVISIONID""-s$SCPID""-i$INSTID""-c$CLUSTERID-i"
            echo 'sudo -H -u root bash -c "echo \"'"$IP"' '"$lowercase_text-$hyphenated_ip-v$THEVISIONID""-s$SCPID""-i$INSTID""-c$CLUSTERID-i"'\" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTESCRIPT > /dev/null            
        fi        
        
        ls -l $PEM
        sudo chown $CURRENTUSER:$CURRENTUSER $PEM
        sudo chmod 600 $PEM
        ls -l $PEM
                
        echo "
insert into guacamole_connection (connection_name,protocol) values (\"${HOST_NAMES[$IP]}\",\"ssh\");
SET @conid$COUNTxER = (select connection_id from guacamole_connection where connection_name = '${HOST_NAMES[$IP]}');
insert into guacamole_connection_parameter values(@conid$COUNTxER,\"hostname\",\"$IP\");
insert into guacamole_connection_parameter values(@conid$COUNTxER,\"port\",\"$PORT\");
insert into guacamole_connection_parameter values(@conid$COUNTxER,\"font-name\",\"Courier New, monospace\");
insert into guacamole_connection_parameter values(@conid$COUNTxER,\"font-size\",\"12\");
insert into guacamole_connection_parameter values(@conid$COUNTxER,\"private-key\",\"" | sudo tee -a $THEGUACASQL > /dev/null
	cat $PEM >> $THEGUACASQL 
        echo "\");
insert into guacamole_connection_parameter values(@conid$COUNTxER,\"color-scheme\",\"" | sudo tee -a $THEGUACASQL > /dev/null
	cat $BASE/Resources/ColourSchemeWebSSH >> $THEGUACASQL 
        echo "\");        
insert into guacamole_connection_parameter values(@conid$COUNTxER,\"username\",\"$U1SER\");
insert into guacamole_connection_permission values(@entityid,@conid$COUNTxER,\"READ\");
insert into guacamole_connection_permission values(@entityid,@conid$COUNTxER,\"UPDATE\");
insert into guacamole_connection_permission values(@entityid,@conid$COUNTxER,\"DELETE\");
insert into guacamole_connection_permission values(@entityid,@conid$COUNTxER,\"ADMINISTER\");
" | sudo tee -a $THEGUACASQL > /dev/null 
	COUNTxER=$((COUNTxER + 1))
	              
    done < "$INSTANCE_DETAILS_FILE"
    echo 'sudo -H -u root bash -c "echo \"#VAMANA => '"$STACKPRETTYNAME"' END \" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTESCRIPT > /dev/null 
    echo 'sudo -H -u root bash -c "echo \"\" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTESCRIPT > /dev/null
    
    for ip in "${!CLUSTER_TYPE[@]}"; do
        if [[ "${CLUSTER_TYPE[$ip]}" == "ONPREM" ]]; then
            NATIVE="2"
            break
        fi
    done 
    
    if [[ "$ISAUTOMATED" == "N" ]]; then
    	sudo rm -f $INSTANCE_DETAILS_FILE 
    fi 
    if [[ "$ISAUTOMATED" == "Y" ]]; then
    	sudo rm -f $INSTANCE_DETAILS_FILE 
    fi               
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
    local ip=$1
    local OS=${OS_TYPES[$IP]}
    local THEIPNAME=${HOST_NAMES[$IP]}
    
    if [[ "$OS" == "UBU" ]]; then
        EXECUTE21SCRIPT=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
        sudo cp $BASE/Resources/UbuntuPreInstallSanitize $BASE/tmp/$EXECUTE21SCRIPT    
        scp -i "${PEM_FILES[$ip]}" -o StrictHostKeyChecking=no -P ${PORTS[$ip]} "$BASE/tmp/$EXECUTE21SCRIPT" "${LOGIN_USERS[$ip]}@$ip:/home/${LOGIN_USERS[$ip]}"
        ssh -i "${PEM_FILES[$ip]}" -o StrictHostKeyChecking=no -p ${PORTS[$ip]} ${LOGIN_USERS[$ip]}@$ip "sudo chmod 777 /home/${LOGIN_USERS[$ip]}/$EXECUTE21SCRIPT && /home/${LOGIN_USERS[$ip]}/$EXECUTE21SCRIPT && sudo rm -f /home/${LOGIN_USERS[$ip]}/$EXECUTE21SCRIPT" 
        sudo rm -f $BASE/tmp/$EXECUTE21SCRIPT           
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
        openssl req -x509 -new -nodes -key $IPHF-key.pem -sha256 -days 3650 -out $IPHF.pem -subj '/CN=$STACK_PRETTY_NAME-swarm'
        openssl genpkey -algorithm RSA -out $IPHF-server-key.pem
        openssl req -new -key $IPHF-server-key.pem -out $IPHF.csr -subj '/CN=$THEIPNAME'
        openssl x509 -req -in $IPHF.csr -CA $IPHF.pem -CAkey $IPHF-key.pem -CAcreateserial -out $IPHF-server-cert.pem -days 3650 -sha256  
        cat $IPHF-server-cert.pem $IPHF-server-key.pem > $IPHF-VARAHA.pem
                      
        sudo mkdir -p $CERTS_DIR/docker && sudo chmod -R 777 $CERTS_DIR/docker
        sudo rm -f $CERTS_DIR/docker/*
        sudo cp $IPHF.pem $IPHF-server-cert.pem $IPHF-server-key.pem $IPHF-VARAHA.pem $CERTS_DIR/docker/
        sudo rm -f $IPHF-key.pem
        sudo rm -f $IPHF.pem
        sudo rm -f $IPHF-server-key.pem
        sudo rm -f $IPHF.csr
        sudo rm -f $IPHF-server-cert.pem
        sudo rm -f $IPHF-VARAHA.pem        
        cd ~
        
        sudo mkdir -p $CERTS_DIR && sudo chmod -R 777 $CERTS_DIR && cd $CERTS_DIR
        openssl genpkey -algorithm RSA -out $IPHF-share-key.pem
        openssl req -x509 -new -nodes -key $IPHF-share-key.pem -sha256 -days 3650 -out $IPHF-share.pem -subj '/CN=$STACK_PRETTY_NAME-share'
        openssl genpkey -algorithm RSA -out $IPHF-share-server-key.pem
        openssl req -new -key $IPHF-share-server-key.pem -out $IPHF-share.csr -subj '/CN=$THEIPNAME'
        openssl x509 -req -in $IPHF-share.csr -CA $IPHF-share.pem -CAkey $IPHF-share-key.pem -CAcreateserial -out $IPHF-share-server-cert.pem -days 3650 -sha256  
        cat $IPHF-share-server-cert.pem $IPHF-share-server-key.pem > $IPHF-share-VARAHA.pem
                      
        sudo mkdir -p $CERTS_DIR/common && sudo chmod -R 777 $CERTS_DIR/common
        sudo rm -f $CERTS_DIR/common/*
        sudo cp $IPHF-share.pem $IPHF-share-server-cert.pem $IPHF-share-server-key.pem $IPHF-share-VARAHA.pem $CERTS_DIR/common/
        sudo rm -f $IPHF-share-key.pem
        sudo rm -f $IPHF-share.pem
        sudo rm -f $IPHF-share-server-key.pem
        sudo rm -f $IPHF-share.csr
        sudo rm -f $IPHF-share-server-cert.pem
        sudo rm -f $IPHF-share-VARAHA.pem        
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
    sudo rm -f $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker-VARAHA.pem
    sudo rm -f $BASE/Output/Vision/V$THEVISIONID/$IPHF-share-VARAHA.pem
    sudo rm -f $BASE/Output/Vision/V$THEVISIONID/$IPHF-share.pem
                
    # Download certificates from the first manager to the local machine
    run_remote $SRC_IP "
        sudo chmod 644 $CERTS_DIR/docker/$IPHF.pem
        sudo chmod 644 $CERTS_DIR/docker/$IPHF-server-cert.pem
        sudo chmod 644 $CERTS_DIR/docker/$IPHF-server-key.pem
        sudo chmod 644 $CERTS_DIR/docker/$IPHF-VARAHA.pem 
        sudo chmod 644 $CERTS_DIR/common/$IPHF-share-VARAHA.pem 
        sudo chmod 644 $CERTS_DIR/common/$IPHF-share.pem                      
    "    
    scp -i ${PEM_FILES[$SRC_IP]} -P ${PORTS[$SRC_IP]} -o StrictHostKeyChecking=no $THESRCUSER@$SRC_IP:$CERTS_DIR/docker/$IPHF.pem $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker.pem
    scp -i ${PEM_FILES[$SRC_IP]} -P ${PORTS[$SRC_IP]} -o StrictHostKeyChecking=no $THESRCUSER@$SRC_IP:$CERTS_DIR/docker/$IPHF-server-cert.pem $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker-server-cert.pem
    scp -i ${PEM_FILES[$SRC_IP]} -P ${PORTS[$SRC_IP]} -o StrictHostKeyChecking=no $THESRCUSER@$SRC_IP:$CERTS_DIR/docker/$IPHF-server-key.pem $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker-server-key.pem
    scp -i ${PEM_FILES[$SRC_IP]} -P ${PORTS[$SRC_IP]} -o StrictHostKeyChecking=no $THESRCUSER@$SRC_IP:$CERTS_DIR/docker/$IPHF-VARAHA.pem $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker-VARAHA.pem
    scp -i ${PEM_FILES[$SRC_IP]} -P ${PORTS[$SRC_IP]} -o StrictHostKeyChecking=no $THESRCUSER@$SRC_IP:$CERTS_DIR/common/$IPHF-share-VARAHA.pem $BASE/Output/Vision/V$THEVISIONID/$IPHF-share-VARAHA.pem
    scp -i ${PEM_FILES[$SRC_IP]} -P ${PORTS[$SRC_IP]} -o StrictHostKeyChecking=no $THESRCUSER@$SRC_IP:$CERTS_DIR/common/$IPHF-share.pem $BASE/Output/Vision/V$THEVISIONID/$IPHF-share.pem        
    run_remote $SRC_IP "
        sudo chown root:root $CERTS_DIR/docker/$IPHF.pem
        sudo chown root:root $CERTS_DIR/docker/$IPHF-server-cert.pem
        sudo chown root:root $CERTS_DIR/docker/$IPHF-server-key.pem  
        sudo chown root:root $CERTS_DIR/docker/$IPHF-VARAHA.pem 
        sudo chown root:root $CERTS_DIR/common/$IPHF-share-VARAHA.pem    
        sudo chown root:root $CERTS_DIR/common/$IPHF-share.pem              
        sudo chmod 644 $CERTS_DIR/docker/$IPHF.pem
        sudo chmod 644 $CERTS_DIR/docker/$IPHF-server-cert.pem
        sudo chmod 644 $CERTS_DIR/docker/$IPHF-VARAHA.pem
        sudo chmod 644 $CERTS_DIR/common/$IPHF-share-VARAHA.pem
        sudo chmod 644 $CERTS_DIR/common/$IPHF-share.pem                
        sudo chmod 600 $CERTS_DIR/docker/$IPHF-server-key.pem
    " 
        
    # Upload certificates to each of the other manager nodes
    sudo chmod 777 $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker.pem
    sudo chmod 777 $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker-server-cert.pem
    sudo chmod 777 $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker-server-key.pem
    sudo chmod 777 $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker-VARAHA.pem
    sudo chmod 777 $BASE/Output/Vision/V$THEVISIONID/$IPHF-share-VARAHA.pem 
    sudo chmod 777 $BASE/Output/Vision/V$THEVISIONID/$IPHF-share.pem           
    for IP in "${BRAHMA_IPS[@]:1}" "${VISHVAKARMA_IPS[@]}" "${INDRA_IPS[@]}"; do
        local THEREQUSER=${LOGIN_USERS[$IP]}
        
        scp -i "${PEM_FILES[$IP]}" -P "${PORTS[$IP]}" -o StrictHostKeyChecking=no $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker.pem $THEREQUSER@$IP:/home/$THEREQUSER/$IPHF.pem
        scp -i "${PEM_FILES[$IP]}" -P "${PORTS[$IP]}" -o StrictHostKeyChecking=no $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker-server-cert.pem $THEREQUSER@$IP:/home/$THEREQUSER/$IPHF-server-cert.pem
        scp -i "${PEM_FILES[$IP]}" -P "${PORTS[$IP]}" -o StrictHostKeyChecking=no $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker-server-key.pem $THEREQUSER@$IP:/home/$THEREQUSER/$IPHF-server-key.pem
        scp -i "${PEM_FILES[$IP]}" -P "${PORTS[$IP]}" -o StrictHostKeyChecking=no $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker-VARAHA.pem $THEREQUSER@$IP:/home/$THEREQUSER/$IPHF-VARAHA.pem
        scp -i "${PEM_FILES[$IP]}" -P "${PORTS[$IP]}" -o StrictHostKeyChecking=no $BASE/Output/Vision/V$THEVISIONID/$IPHF-share-VARAHA.pem $THEREQUSER@$IP:/home/$THEREQUSER/$IPHF-share-VARAHA.pem
                        
        # Move the certificates to the correct location on the target manager
        I1PHF="$STACKNAME"
        run_remote $IP "
            sudo mkdir -p $CERTS_DIR/docker && sudo chmod -R 777 $CERTS_DIR/docker
            sudo mkdir -p $CERTS_DIR/self && sudo chmod -R 777 $CERTS_DIR/self 
            sudo mkdir -p $CERTS_DIR/cluster && sudo chmod -R 777 $CERTS_DIR/cluster
            sudo mkdir -p $CERTS_DIR/cluster/ca && sudo chmod -R 777 $CERTS_DIR/cluster/ca
            sudo mkdir -p $CERTS_DIR/cluster/full && sudo chmod -R 777 $CERTS_DIR/cluster/full
            sudo rm -f $CERTS_DIR/docker/*           
            sudo mv /home/$THEREQUSER/$IPHF.pem $CERTS_DIR/docker/$I1PHF.pem
            sudo mv /home/$THEREQUSER/$IPHF-server-key.pem $CERTS_DIR/docker/$I1PHF-server-key.pem
            sudo mv /home/$THEREQUSER/$IPHF-server-cert.pem $CERTS_DIR/docker/$I1PHF-server-cert.pem
            sudo mv /home/$THEREQUSER/$IPHF-VARAHA.pem $CERTS_DIR/docker/$I1PHF-VARAHA.pem  
            sudo mv /home/$THEREQUSER/$IPHF-share-VARAHA.pem $CERTS_DIR/docker/$I1PHF-share-VARAHA.pem                       
            sudo chown root:root $CERTS_DIR/docker/$I1PHF.pem
            sudo chown root:root $CERTS_DIR/docker/$I1PHF-server-cert.pem
            sudo chown root:root $CERTS_DIR/docker/$I1PHF-server-key.pem       
            sudo chown root:root $CERTS_DIR/docker/$I1PHF-VARAHA.pem  
            sudo chown root:root $CERTS_DIR/docker/$I1PHF-share-VARAHA.pem                                         
            sudo chmod 644 $CERTS_DIR/docker/$I1PHF.pem
            sudo chmod 644 $CERTS_DIR/docker/$I1PHF-server-cert.pem
            sudo chmod 600 $CERTS_DIR/docker/$I1PHF-server-key.pem    
            sudo chmod 644 $CERTS_DIR/docker/$I1PHF-VARAHA.pem 
            sudo chmod 644 $CERTS_DIR/docker/$I1PHF-share-VARAHA.pem                                
            sudo rm -f /home/$THEREQUSER/$IPHF.pem
            sudo rm -f /home/$THEREQUSER/$IPHF-server-key.pem
            sudo rm -f /home/$THEREQUSER/$IPHF-server-cert.pem 
            sudo rm -f /home/$THEREQUSER/$IPHF-VARAHA.pem     
            sudo rm -f /home/$THEREQUSER/$IPHF-share-VARAHA.pem                               
        "
    done
    MGR=$(echo "${BRAHMA_IPS[0]}" | sed 's/\./-/g')
    run_remote ${BRAHMA_IPS[0]} "
            sudo mv $CERTS_DIR/docker/$MGR.pem $CERTS_DIR/docker/$STACKNAME.pem
            sudo mv $CERTS_DIR/docker/$MGR-server-key.pem $CERTS_DIR/docker/$STACKNAME-server-key.pem
            sudo mv $CERTS_DIR/docker/$MGR-server-cert.pem $CERTS_DIR/docker/$STACKNAME-server-cert.pem
            sudo mv $CERTS_DIR/docker/$MGR-VARAHA.pem $CERTS_DIR/docker/$STACKNAME-VARAHA.pem
            sudo mv $CERTS_DIR/common/$MGR-share-VARAHA.pem $CERTS_DIR/docker/$STACKNAME-share-VARAHA.pem            
    "      
    
    # Clean up local files
    sudo rm -f $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker.pem
    sudo rm -f $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker-server-cert.pem
    sudo rm -f $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker-server-key.pem
    sudo rm -f $BASE/Output/Vision/V$THEVISIONID/$IPHF-docker-VARAHA.pem
    sudo mv $BASE/Output/Vision/V$THEVISIONID/$IPHF-share-VARAHA.pem $BASE/Output/Vision/V$THEVISIONID/$STACKPRETTYNAME-share-VARAHA.pem 
    sudo mv $BASE/Output/Vision/V$THEVISIONID/$IPHF-share.pem $BASE/Output/Vision/V$THEVISIONID/$STACKPRETTYNAME-share.pem   
}

# Function to setup Docker
install_docker() {
    local IP=$2
    local MACTYPE=$1
    
    local OS=${OS_TYPES[$IP]}
    local P1ORT=${PORTS[$IP]}
    local THE1REQUSER=${LOGIN_USERS[$IP]}
    local THE1REQPEM=${PEM_FILES[$IP]}
    local THE1HOST1NAME=${HOST_NAMES[$IP]}
        
    TLSSTUFF=""
    TheReqRL=""
    local IPHF="$STACKNAME"
    if [ "$MACTYPE" == "B" ] ; then
    	TLSSTUFF="--tlsverify --tlscacert=$CERTS_DIR/docker/$IPHF.pem --tlscert=$CERTS_DIR/docker/$IPHF-server-cert.pem --tlskey=$CERTS_DIR/docker/$IPHF-server-key.pem "
    	TheReqRL="B"
    fi
    if [ "$MACTYPE" == "V" ] ; then
    	TLSSTUFF="--tlsverify --tlscacert=$CERTS_DIR/docker/$IPHF.pem --tlscert=$CERTS_DIR/docker/$IPHF-server-cert.pem --tlskey=$CERTS_DIR/docker/$IPHF-server-key.pem "
    	TheReqRL="V"
    fi
    if [ "$MACTYPE" == "I" ] ; then
    	TLSSTUFF="--tlsverify --tlscacert=$CERTS_DIR/docker/$IPHF.pem --tlscert=$CERTS_DIR/docker/$IPHF-server-cert.pem --tlskey=$CERTS_DIR/docker/$IPHF-server-key.pem "
    	TheReqRL="I"
    fi
            
    DOCKERTEMPLATE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
    sudo cp $BASE/Resources/DockerSetUpTemplate $BASE/tmp/$DOCKERTEMPLATE

    if [ "$NATIVE" -lt 2 ]; then
    	ALLHOSTS=$(IFS=','; echo "${HOST_ALT_NAMES[*]}") 
    else
	ALLHOSTS=$(IFS=','; echo "${HOST_NAMES[*]}")
    fi
    echo "ALLHOSTS : $ALLHOSTS"
    
    sed -i -e s~"THEREQIP"~"$IP"~g $BASE/tmp/$DOCKERTEMPLATE
    sed -i -e s~"THEREQHOSTNAME"~"$THE1HOST1NAME"~g $BASE/tmp/$DOCKERTEMPLATE
    sed -i -e s~"THEREQOS"~"$OS"~g $BASE/tmp/$DOCKERTEMPLATE
    sed -i -e s~"THEREQDDD"~"$DOCKER_DATA_DIR"~g $BASE/tmp/$DOCKERTEMPLATE
    sed -i -e s~"THEREQDFS"~"$DFS_DATA_DIR"~g $BASE/tmp/$DOCKERTEMPLATE 
    sed -i -e s~"THEREQCD2FS"~"$DFS_DATA2_DIR"~g $BASE/tmp/$DOCKERTEMPLATE 
    sed -i -e s~"THEREQCDFS"~"$DFS_CLUSTER_DIR"~g $BASE/tmp/$DOCKERTEMPLATE   
    sed -i -e s~"THEREQTLS"~"$TLSSTUFF"~g $BASE/tmp/$DOCKERTEMPLATE
    sed -i -e s~"THEREQAPORT"~"$PortainerAPort"~g $BASE/tmp/$DOCKERTEMPLATE
    sed -i -e s~"THEREQSPORT"~"$PortainerSPort"~g $BASE/tmp/$DOCKERTEMPLATE
    sed -i -e s~"THECURSTACK"~"$STACKNAME"~g $BASE/tmp/$DOCKERTEMPLATE 
    sed -i -e s~"THECURPNSTACK"~"$STACKPRETTYNAME"~g $BASE/tmp/$DOCKERTEMPLATE
    sed -i -e s~"VP1"~"$VarahaPort1"~g $BASE/tmp/$DOCKERTEMPLATE
    sed -i -e s~"VP2"~"$VarahaPort2"~g $BASE/tmp/$DOCKERTEMPLATE
    sed -i -e s~"VP3"~"$VarahaPort3"~g $BASE/tmp/$DOCKERTEMPLATE
    sed -i -e s~"VP4"~"$VarahaPort4"~g $BASE/tmp/$DOCKERTEMPLATE
    sed -i -e s~"THEREQROLE"~"$TheReqRL"~g $BASE/tmp/$DOCKERTEMPLATE
    sed -i -e s~"BDDPASSWORD"~"$ADMIN_PASSWORD"~g $BASE/tmp/$DOCKERTEMPLATE  
    sed -i -e s~"BDD1"~"$BDDPort1"~g $BASE/tmp/$DOCKERTEMPLATE
    sed -i -e s~"BDD2"~"$BDDPort2"~g $BASE/tmp/$DOCKERTEMPLATE 
    sed -i -e s~"BDDHOSTS"~"$ALLHOSTS"~g $BASE/tmp/$DOCKERTEMPLATE 
    sed -i -e s~"THECERTS"~"$CERTS_DIR"~g $BASE/tmp/$DOCKERTEMPLATE
    sed -i -e s~"WSP1"~"$WEBSSHPort1"~g $BASE/tmp/$DOCKERTEMPLATE  
    sed -i -e s~"WSP2"~"$WEBSSH_PASSWORD"~g $BASE/tmp/$DOCKERTEMPLATE 
    sed -i -e s~"WSP3"~"$DFS_DATA_DIR/Misc$STACKNAME/webssh"~g $BASE/tmp/$DOCKERTEMPLATE 
    sed -i -e s~"WSP4"~"$THEWEBSSHIDLELIMIT"~g $BASE/tmp/$DOCKERTEMPLATE 
    sed -i -e s~"WSP5"~"${CLUSTERAPPSMAPPING["WEBSSH"]}"~g $BASE/tmp/$DOCKERTEMPLATE 
    sed -i -e s~"WSP6"~"${CLUSTER_APPS_MAPPING["WEBSSH"]}"~g $BASE/tmp/$DOCKERTEMPLATE 
    sed -i -e s~"THEREVPWD"~"$ADMIN_PASSWORD"~g $BASE/tmp/$DOCKERTEMPLATE
    
    BUCKETCLIENT="${CLUSTER_APPS_MAPPING["BUCKETCLIENT"]}.${CLUSTERAPPSMAPPING["BUCKETCLIENT"]}"
    scp -i "$THE1REQPEM" -o StrictHostKeyChecking=no -P $P1ORT "$BASE/Resources/$BUCKETCLIENT" "$THE1REQUSER@$IP:/home/$THE1REQUSER/mc"
    MIOTEMPLATE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
    sudo cp $BASE/Resources/MountSBBTemplate $BASE/tmp/$MIOTEMPLATE
    sed -i -e s~"MNIO1"~"$STACK_PRETTY_NAME"~g $BASE/tmp/$MIOTEMPLATE
    sed -i -e s~"MNIO2"~"/shiva/bdd/bucket/$STACKNAME"~g $BASE/tmp/$MIOTEMPLATE 
    sed -i -e s~"MNIO3"~"$DFS_DATA_DIR/MINIO/.$STACK_PRETTY_NAME"~g $BASE/tmp/$MIOTEMPLATE 
    sed -i -e s~"MNIO4"~"https://${HOST_NAMES[${INDRA_IPS[0]}]}:$MINPortIO3"~g $BASE/tmp/$MIOTEMPLATE 
    sed -i -e s~"MNIO5"~"$STACK_PRETTY_NAME"~g $BASE/tmp/$MIOTEMPLATE 
    sed -i -e s~"MNIO6"~"$CERTS_DIR/cluster/ca/${HOST_NAMES[${INDRA_IPS[0]}]}.pem"~g $BASE/tmp/$MIOTEMPLATE

    scp -i "$THE1REQPEM" -o StrictHostKeyChecking=no -P $P1ORT "$BASE/tmp/$MIOTEMPLATE" "$THE1REQUSER@$IP:/home/$THE1REQUSER/MountSBB.sh"
    sudo rm -f $BASE/tmp/$MIOTEMPLATE
    
    if [[ "$ELIGIBLEFORKRISHNA" == "Y" ]]; then
    	sed -i -e s~"GETVP"~"Y"~g $BASE/tmp/$DOCKERTEMPLATE
    else
    	sed -i -e s~"GETVP"~"N"~g $BASE/tmp/$DOCKERTEMPLATE
    fi
    if [ "$NATIVE" -lt 2 ]; then
    	sed -i -e s~"BDDCURRHOST"~"${HOST_ALT_NAMES[$IP]}"~g $BASE/tmp/$DOCKERTEMPLATE
    else
	sed -i -e s~"BDDCURRHOST"~"${HOST_NAMES[$IP]}"~g $BASE/tmp/$DOCKERTEMPLATE
    fi       

    if [[ "$IP" == "$CHITRAGUPTA" ]]; then
    	echo "IP $IP : CHITRAGUPTA $CHITRAGUPTA"   	
    	CHITRAGUPTA_DET="$CHITRAGUPTA_DET""■$ChitraGuptaPort1,$ChitraGuptaPort2,$ChitraGuptaPort3,$ChitraGuptaPort4,$ChitraGuptaPort5,$ChitraGuptaPort6,$ChitraGuptaPort7,$ChitraGuptaPortZ1■guacamole_$STACK_PRETTY_NAME,guacamole_$STACK_PRETTY_NAME,$ADMIN_PASSWORD,admin_$STACK_PRETTY_NAME,$WEBSSH_PASSWORD,${CLUSTER_APPS_MAPPING["CHITRAGUPTA1"]}:${CLUSTERAPPSMAPPING["CHITRAGUPTA1"]},${CLUSTER_APPS_MAPPING["CHITRAGUPTA2"]}:${CLUSTERAPPSMAPPING["CHITRAGUPTA2"]},${CLUSTER_MEMORYCORES_MAPPING["CHITRAGUPTA1"]},${CLUSTER_MEMORYCORES_MAPPING["CHITRAGUPTA2"]}■${CLUSTER_APPS_MAPPING["CHITRAGUPTA3"]}:${CLUSTERAPPSMAPPING["CHITRAGUPTA3"]},${CLUSTER_MEMORYCORES_MAPPING["CHITRAGUPTA3"]},$REVERSED_PASSWORD■${CLUSTER_APPS_MAPPING["CHITRAGUPTA4"]}:${CLUSTERAPPSMAPPING["CHITRAGUPTA4"]},${CLUSTER_MEMORYCORES_MAPPING["CHITRAGUPTA4"]},$REVERSED_PASSWORD■$ADMIN_PASSWORD,$ChitraGuptaPort8,$ChitraGuptaPortU1,$ChitraGuptaPortV1,$ChitraGuptaPortW1,$ChitraGuptaPortY1,${CLUSTER_APPS_MAPPING["CHITRAGUPTA5"]}:${CLUSTERAPPSMAPPING["CHITRAGUPTA5"]},${CLUSTER_MEMORYCORES_MAPPING["CHITRAGUPTA5"]},${CLUSTER_APPS_MAPPING["CHITRAGUPTA6"]}:${CLUSTERAPPSMAPPING["CHITRAGUPTA6"]},${CLUSTER_MEMORYCORES_MAPPING["CHITRAGUPTA6"]},${CLUSTER_APPS_MAPPING["CHITRAGUPTA7"]}:${CLUSTERAPPSMAPPING["CHITRAGUPTA7"]},${CLUSTER_MEMORYCORES_MAPPING["CHITRAGUPTA7"]},${CLUSTER_APPS_MAPPING["CHITRAGUPTA8"]}:${CLUSTERAPPSMAPPING["CHITRAGUPTA8"]},${CLUSTER_MEMORYCORES_MAPPING["CHITRAGUPTA8"]}■$ADMIN_PASSWORD,$ChitraGuptaPortLDP1,$ChitraGuptaPortLDP2,$ChitraGuptaPortLDP3,$ChitraGuptaPortLDP4,$ChitraGuptaPortLDP5,$STACKPRETTYNAME,${CLUSTER_APPS_MAPPING["CHITRAGUPTA9"]}:${CLUSTERAPPSMAPPING["CHITRAGUPTA9"]},${CLUSTER_MEMORYCORES_MAPPING["CHITRAGUPTA9"]},${CLUSTER_APPS_MAPPING["CHITRAGUPTA10"]}:${CLUSTERAPPSMAPPING["CHITRAGUPTA10"]},${CLUSTER_MEMORYCORES_MAPPING["CHITRAGUPTA10"]}■$ADMIN_PASSWORD,$ChitraGuptaPortKERB1,$ChitraGuptaPortKERB2,$ChitraGuptaPortKERB3,$ChitraGuptaPortKERB4,$STACKPRETTYNAME,${CLUSTER_APPS_MAPPING["CHITRAGUPTA11"]}:${CLUSTERAPPSMAPPING["CHITRAGUPTA11"]},${CLUSTER_MEMORYCORES_MAPPING["CHITRAGUPTA11"]}"
		  	
	CGSQLTEMPLATE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	sudo cp $BASE/Resources/ChitraGupta.sql $BASE/tmp/$CGSQLTEMPLATE
	echo "Acamehere1"
	sed -i -e s~"GUACAMOLEADMIN"~"admin"~g $BASE/tmp/$CGSQLTEMPLATE
	echo "Bcamehere2"
	sed -i -e s~"GUACAMOLEPWD"~"$WEBSSH_PASSWORD"~g $BASE/tmp/$CGSQLTEMPLATE
	echo "Ccamehere3"
	cat $THEGUACASQL >> $BASE/tmp/$CGSQLTEMPLATE
	   	
   	scp -i "$THE1REQPEM" -o StrictHostKeyChecking=no -P $P1ORT "$BASE/tmp/$CGSQLTEMPLATE" "$THE1REQUSER@$IP:/home/$THE1REQUSER/initdb-redux.sql"
   	scp -i "$THE1REQPEM" -o StrictHostKeyChecking=no -P $P1ORT "$BASE/Resources/boodark.tar.gz" "$THE1REQUSER@$IP:/home/$THE1REQUSER/boodark.tar.gz"
   	scp -i "$THE1REQPEM" -o StrictHostKeyChecking=no -P $P1ORT "$BASE/Resources/1860_rev37.json" "$THE1REQUSER@$IP:/home/$THE1REQUSER/1860_rev37.json" 
   	scp -i "$THE1REQPEM" -o StrictHostKeyChecking=no -P $P1ORT "$BASE/Resources/container-metrics.json" "$THE1REQUSER@$IP:/home/$THE1REQUSER/container-metrics.json"
   	scp -i "$THE1REQPEM" -o StrictHostKeyChecking=no -P $P1ORT "$BASE/Resources/node-metrics.json" "$THE1REQUSER@$IP:/home/$THE1REQUSER/node-metrics.json"  	   	
   	sudo rm -f $BASE/tmp/$CGSQLTEMPLATE
   	sudo rm -f $THEGUACASQL
   	
   	echo "Dcamehere4"
    	sed -i -e s~"GGEPO"~"$CHITRAGUPTA_DET"~g $BASE/tmp/$DOCKERTEMPLATE
    	echo "Ecamehere5"
    	echo "$CHITRAGUPTA_DET"
    	#exit 
    else
    	sed -i -e s~"GGEPO"~"NA"~g $BASE/tmp/$DOCKERTEMPLATE
    fi
        
    sudo chmod 777 $BASE/tmp/$DOCKERTEMPLATE

    if [ "$MACTYPE" == "I" ] ; then
	    DOCKER1TEMPLATE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	    sudo cp $BASE/Resources/ImageMaker.py $BASE/tmp/$DOCKER1TEMPLATE
	    sed -i -e s~"THEREQHEADER"~"$STACKPRETTYNAME"~g $BASE/tmp/$DOCKER1TEMPLATE
	    sed -i -e s~"THEREQFONT"~"/home/$THE1REQUSER/CoreFont.ttf"~g $BASE/tmp/$DOCKER1TEMPLATE
	    sed -i -e s~"THEREQLOC"~"$DFS_DATA2_DIR/Static$STACKNAME/Logo$STACKNAME.png"~g $BASE/tmp/$DOCKER1TEMPLATE        
	    sudo chmod 777 $BASE/tmp/$DOCKER1TEMPLATE
	    scp -i "$THE1REQPEM" -o StrictHostKeyChecking=no -P $P1ORT "$BASE/tmp/$DOCKER1TEMPLATE" "$THE1REQUSER@$IP:/home/$THE1REQUSER"
	    scp -i "$THE1REQPEM" -o StrictHostKeyChecking=no -P $P1ORT "$BASE/Resources/CoreFont.ttf" "$THE1REQUSER@$IP:/home/$THE1REQUSER/CoreFont.ttf"
	    ssh -i "$THE1REQPEM" -o StrictHostKeyChecking=no -p $P1ORT $THE1REQUSER@$IP "sudo rm -f /home/$THE1REQUSER/ImageMaker.py && sudo mv /home/$THE1REQUSER/$DOCKER1TEMPLATE /home/$THE1REQUSER/ImageMaker.py && sudo chmod 777 /home/$THE1REQUSER/ImageMaker.py"
	    sudo rm -f $BASE/tmp/$DOCKER1TEMPLATE
    fi
    
    max_attempts=5
    attempt=0
    while true; do
    	attempt=$((attempt + 1))
        scp -i "$THE1REQPEM" -o StrictHostKeyChecking=no -P $P1ORT "$BASE/tmp/$EXECUTESCRIPT" "$THE1REQUSER@$IP:/home/$THE1REQUSER"
        status=$?
        if [ $status -eq 0 ]; then
            ssh -i "$THE1REQPEM" -o StrictHostKeyChecking=no -p $P1ORT $THE1REQUSER@$IP "sudo rm -f /home/$THE1REQUSER/SetUpHosts.sh && sudo mv /home/$THE1REQUSER/$EXECUTESCRIPT /home/$THE1REQUSER/SetUpHosts.sh && sudo chmod 777 /home/$THE1REQUSER/SetUpHosts.sh && /home/$THE1REQUSER/SetUpHosts.sh"
            break
        else
            if [ $attempt -ge $max_attempts ]; then
                echo "Maximum attempts reached. Exiting."
                exit 1
            fi
            sleep 5
        fi
    done
     
    max_attempts=5
    attempt=0
    while true; do
    	attempt=$((attempt + 1))
        scp -i "$THE1REQPEM" -o StrictHostKeyChecking=no -P $P1ORT "$BASE/tmp/$DOCKERTEMPLATE" "$THE1REQUSER@$IP:/home/$THE1REQUSER"
        status=$?
        if [ $status -eq 0 ]; then
            ssh -i "$THE1REQPEM" -o StrictHostKeyChecking=no -p $P1ORT $THE1REQUSER@$IP "sudo rm -f /home/$THE1REQUSER/SetUpDocker.sh && sudo mv /home/$THE1REQUSER/$DOCKERTEMPLATE /home/$THE1REQUSER/SetUpDocker.sh && sudo chmod 777 /home/$THE1REQUSER/SetUpDocker.sh && nohup /home/$THE1REQUSER/SetUpDocker.sh > /home/$THE1REQUSER/DSULog$STACKNAME.out 2>&1 &" < /dev/null > /dev/null 2>&1 &
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

# Function to create an encrypted overlay network
create_encrypted_overlay_network() {
    run_remote ${BRAHMA_IPS[0]} "
        docker network create \
          --driver overlay \
          --attachable \
          --opt encrypted \
          $STACKNAME-encrypted-overlay
    "
}

THEFINALVOLUMENAME="$STACKNAME"
   
# Function to create a GlusterFS volume cluster with retry logic
create_glusterfs_volume_cluster() {
    peer_probe_cmds=""
    volume_create_cmd=""
    retry_count=0
    max_retries=10
    success=false
    S1TA1CKN1AME="$1"
    DFS1_CLUSTER1_DIR="$2"
    
    ALL_IPS=("${BRAHMA_IPS[@]:1}" "${VISHVAKARMA_IPS[@]}" "${INDRA_IPS[@]}")
    total_nodes=${#ALL_IPS[@]}
    max_nodes=$(( (total_nodes / 2) * 2 ))
    responsive_peer_ips=()
    
    # Function to check if GlusterFS is running and installed on a peer
    check_glusterfs_status() {
        local ip=$1
        glusterd_status=$(ssh -i "${PEM_FILES[$ip]}" -o ConnectTimeout=5 -o StrictHostKeyChecking=no -p ${PORTS[$ip]} ${LOGIN_USERS[$ip]}@$ip "sudo systemctl is-active glusterd")
        gluster_command_status=$(ssh -i "${PEM_FILES[$ip]}" -o ConnectTimeout=5 -o StrictHostKeyChecking=no -p ${PORTS[$ip]} ${LOGIN_USERS[$ip]}@$ip "which gluster")
        if [[ "$glusterd_status" == "active" ]] && [[ -n "$gluster_command_status" ]]; then
            return 0
        else
            return 1
        fi
    }
    
    # Filter responsive peers
    for ip in "${ALL_IPS[@]}"; do
        if check_glusterfs_status $ip; then
            responsive_peer_ips+=("$ip")
        else
            echo "Skipping unresponsive or improperly configured peer: $ip"
        fi
    done

    # Ensure there are enough responsive peers to create a volume
    if [ ${#responsive_peer_ips[@]} -lt 2 ]; then
        echo "Not enough responsive peers to create a replica 2 volume."
        return 1
    fi
    
    # Select peers for the volume creation
    peer_ips=($(shuf -e "${responsive_peer_ips[@]}" -n $max_nodes))            
        
    # Retry logic for probing and volume creation
    while [ $retry_count -lt $max_retries ] && [ "$success" = false ]; do
        echo "Attempting to probe peers and create volume, Attempt: $((retry_count + 1))"

        TMPRNDM=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 6 | head -n 1)
        THEFINALVOLUMENAME="$S1TA1CKN1AME""$TMPRNDM"
        peer_probe_cmds=""
        volume_create_cmd="" 
               
        # Prepare peer probing commands
        for ip in "${peer_ips[@]}"; do
            HOST=${HOST_NAMES[$ip]}
            if [ "$NATIVE" -lt 2 ]; then
                HOST=${JIVA_IPS[$ip]}
            fi
            peer_probe_cmds+="sudo gluster peer probe $HOST; "
        done
            
        # Prepare volume creation command
        volume_create_cmd="sudo gluster volume create $THEFINALVOLUMENAME replica 2 "
        for ip in "${peer_ips[@]}"; do
		HOST=${HOST_NAMES[$ip]}
		if [ "$NATIVE" -lt 2 ]; then
		    HOST=${JIVA_IPS[$ip]}
		fi
		volume_create_cmd+="$HOST:$DFS_DATA2_DIR/$S1TA1CKN1AME "
        done
        volume_create_cmd+="force"        
	echo "create_glusterfs_volume_cluster : $peer_probe_cmds"
	echo "create_glusterfs_volume_cluster : $volume_create_cmd"        
        # Run the peer probing and volume creation commands
        run_remote ${BRAHMA_IPS[0]} "
            $peer_probe_cmds
            $volume_create_cmd
            sudo gluster volume start $THEFINALVOLUMENAME
        "

        # Check if the volume is started successfully
        if run_remote ${BRAHMA_IPS[0]} "sudo gluster volume info $THEFINALVOLUMENAME"; then
            success=true
            echo "Volume created and started successfully."
            break
        else
            echo "Failed to create/start volume, retrying..."
            sleep 10  # Wait before retrying
        fi
        retry_count=$((retry_count + 1))
    done

    if [ "$success" = false ]; then
        echo "Failed to create/start volume after $max_retries attempts."
    else
	    # Mount the volume on all IPs
	    glusterfs_addresses=""
	    for ip in "${peer_ips[@]}"; do
		HOST=${HOST_NAMES[$ip]}
		if [ "$NATIVE" -lt 2 ]; then
		    HOST=${JIVA_IPS[$ip]}
		fi
		glusterfs_addresses+="$HOST,"
	    done
	    glusterfs_addresses=${glusterfs_addresses%,}  # Remove trailing comma

	    ALL2_IPS=("${BRAHMA_IPS[@]}" "${VISHVAKARMA_IPS[@]}" "${INDRA_IPS[@]}")
	    for IP in "${ALL2_IPS[@]}"; do
		run_remote $IP "hostname && sudo mount -t glusterfs $glusterfs_addresses:/$THEFINALVOLUMENAME $DFS1_CLUSTER1_DIR -o log-level=DEBUG,log-file=/var/log/glusterfs/$THEFINALVOLUMENAME-mount.log"
	    done    
    fi
}

THEFINALVOLUME1NAME="$STACKNAME"

# Function to create portainer glusterfs volume
create_glusterfs_volume_portainer() {
	primary_ip=${BRAHMA_IPS[0]}
	peer_ips=("${BRAHMA_IPS[@]:1}")	
	retry_count=0
	max_retries=10
	success=false	
	
	# Retry logic for probing and volume creation
	while [ $retry_count -lt $max_retries ] && [ "$success" = false ]; do
		echo "Attempting to probe peers and create Portainer volume, Attempt: $((retry_count + 1))"
		
		TMPRNDM=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 6 | head -n 1)
		THEFINALVOLUME1NAME="$STACKNAME""$TMPRNDM"		
		
		peer_probe_cmds=""	
		for ip in "${peer_ips[@]}"; do
			H1O1S1T=${HOST_NAMES[$ip]}
			if [ "$NATIVE" -lt 2 ]; then
				H1O1S1T=${JIVA_IPS[$ip]}
			fi
			peer_probe_cmds+="sudo gluster peer probe $H1O1S1T; "
		done
		volume_create_cmd="sudo gluster volume create Portainer$THEFINALVOLUME1NAME replica ${#BRAHMA_IPS[@]} "
		for ip in "${BRAHMA_IPS[@]}"; do
			H1O1S11T=${HOST_NAMES[$ip]}
			if [ "$NATIVE" -lt 2 ]; then
				H1O1S11T=${JIVA_IPS[$ip]}
			fi
			volume_create_cmd+="$H1O1S11T:$DFS_DATA_DIR/Portainer$STACKNAME "
		done
		volume_create_cmd+="force" 
		echo "create_glusterfs_volume_portainer : $peer_probe_cmds"
		echo "create_glusterfs_volume_portainer : $volume_create_cmd" 
		run_remote ${BRAHMA_IPS[0]} "
		$peer_probe_cmds
		$volume_create_cmd
		sudo gluster volume start Portainer$THEFINALVOLUME1NAME
		"
		if run_remote ${BRAHMA_IPS[0]} "sudo gluster volume info Portainer$THEFINALVOLUME1NAME"; then
		    success=true
		    echo "Portainer Volume created and started successfully."
		    break
		else
		    echo "Portainer Failed to create/start volume, retrying..."
		    sleep 10
		fi
		retry_count=$((retry_count + 1))
	done
    	
	if [ "$success" = false ]; then
		echo "Failed to create/start Portainer volume after $max_retries attempts."
		sudo mv $THENOHUPFILE $BASE/Output/Logs/$REQUNQ-VAMANA-FATAL_ERROR-$STACKPRETTYNAME.out
		exit
	else    	
		glusterfs_addresses=""
		for ip in "${BRAHMA_IPS[@]}"; do
			H11O1S11T=${HOST_NAMES[$ip]}
			if [ "$NATIVE" -lt 2 ]; then
				H11O1S11T=${JIVA_IPS[$ip]}
			fi
			glusterfs_addresses+="$H11O1S11T,"
		done
		glusterfs_addresses=${glusterfs_addresses%,}
		for IP in "${BRAHMA_IPS[@]}"; do
		    run_remote $IP "hostname && sudo mount -t glusterfs $glusterfs_addresses:/Portainer$THEFINALVOLUME1NAME $DFS_DATA_DIR/PortainerMnt$STACKNAME -o log-level=DEBUG,log-file=/var/log/glusterfs/Portainer$STACKNAME-mount.log"
		done
	fi
}

# Function to create swarm labels
create_swarm_labels() {
	for IP in "${BRAHMA_IPS[@]}"; do
		NODE_ID=$(run_remote $IP "docker info -f '{{.Swarm.NodeID}}'")
		if [ -n "$NODE_ID" ]; then
		    run_remote $IP "docker node update --label-add $STACKNAME""BRAHMAreplica=true $NODE_ID"
		else
		    echo "Node $IP is not part of a Swarm"
		fi
	done
	for IP in "${INDRA_IPS[@]}"; do
		NODE_ID=$(run_remote $IP "docker info -f '{{.Swarm.NodeID}}'")
		if [ -n "$NODE_ID" ]; then
		    run_remote ${BRAHMA_IPS[0]} "docker node update --label-add $STACKNAME""INDRAreplica=true $NODE_ID"
		else
		    echo "Node $IP is not part of a Swarm"
		fi
	done
	for IP in "${VISHVAKARMA_IPS[@]}"; do
		NODE_ID=$(run_remote $IP "docker info -f '{{.Swarm.NodeID}}'")
		if [ -n "$NODE_ID" ]; then
		    if [[ "$IP" == "$CHITRAGUPTA" ]]; then
			run_remote ${BRAHMA_IPS[0]} "docker node update --label-add $STACKNAME""CHITRAGUPTAreplica=true $NODE_ID"
		    fi
		    run_remote ${BRAHMA_IPS[0]} "docker node update --label-add $STACKNAME""VISHVAKARMAreplica=true $NODE_ID"		
		else
		    echo "Node $IP is not part of a Swarm"
		fi
	done			
}

# Function to create cluster level cdn & proxy
create_cluster_cdn_proxy() {
    DOCKERTEMPLATE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
    sudo cp $BASE/Scripts/VARAHA.sh $BASE/tmp/$DOCKERTEMPLATE

    MGRIPS=$(IFS=','; echo "${BRAHMA_IPS[*]}")
    THECFGPATH=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
    THEDCYPATH=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)    
    IWP="${INDRA_IPS[0]}"
    THE1RAM=${APP_MEM[$IWP]}
    R2AM=$( [[ $THE1RAM == *,* ]] && echo "${THE1RAM#*,}" || echo "$THE1RAM" )
    THE1CORE=${APP_CORE[$IWP]}
    C2ORE=$( [[ $THE1CORE == *,* ]] && echo "${THE1CORE#*,}" || echo "$THE1CORE" ) 

    THEREQINDRA="${INDRA_IPS[0]}"
    SYNCWITHIFCONFIG="N"
    if [ "$NATIVE" -lt 2 ]; then
    	THEREQINDRA="${JIVA_IPS[${INDRA_IPS[0]}]}"
    	SYNCWITHIFCONFIG="Y"
    fi
   
    sudo chmod 777 $BASE/tmp/$DOCKERTEMPLATE
    
    MIN_IO_DET="$REVERSED_PASSWORD,$MINPortIO1,$MINPortIO2,$MINPortIO3,$MINPortIO4,$DFS_DATA_DIR/MINIO/EntryPoint.sh,$DFS_DATA_DIR/MINIODATA,${CLUSTER_APPS_MAPPING["BUCKET"]}:${CLUSTERAPPSMAPPING["BUCKET"]},${CLUSTER_MEMORYCORES_MAPPING["BUCKET"]},$FLBRPortIO2"
     
    max_attempts=5
    attempt=0
    while true; do
    	attempt=$((attempt + 1))
        scp -i "${PEM_FILES[${BRAHMA_IPS[0]}]}" -o StrictHostKeyChecking=no -P ${PORTS[${BRAHMA_IPS[0]}]} "$BASE/tmp/$DOCKERTEMPLATE" "${LOGIN_USERS[${BRAHMA_IPS[0]}]}@${BRAHMA_IPS[0]}:/home/${LOGIN_USERS[${BRAHMA_IPS[0]}]}"
        status=$?
        if [ $status -eq 0 ]; then
            ssh -i "${PEM_FILES[${BRAHMA_IPS[0]}]}" -o StrictHostKeyChecking=no -p ${PORTS[${BRAHMA_IPS[0]}]} ${LOGIN_USERS[${BRAHMA_IPS[0]}]}@${BRAHMA_IPS[0]} "sudo rm -f /home/${LOGIN_USERS[${BRAHMA_IPS[0]}]}/VARAHA.sh && sudo mv /home/${LOGIN_USERS[${BRAHMA_IPS[0]}]}/$DOCKERTEMPLATE /home/${LOGIN_USERS[${BRAHMA_IPS[0]}]}/VARAHA.sh && sudo chmod 777 /home/${LOGIN_USERS[${BRAHMA_IPS[0]}]}/VARAHA.sh && /home/${LOGIN_USERS[${BRAHMA_IPS[0]}]}/VARAHA.sh \"CORE\" \"$MGRIPS\" \"$STACKNAME\" \"$STACKPRETTYNAME\" \"$DFS_DATA2_DIR/Static$STACKNAME\" \"$VarahaPort1\" \"$VarahaPort2\" \"$DFS_DATA_DIR/Tmp$STACKNAME/$THECFGPATH.cfg\" \"$VarahaPort3\" \"$VarahaPort4\" \"$ADMIN_PASSWORD\" \"$PortainerSPort\" \"$DFS_DATA_DIR/Tmp$STACKNAME/$THEDCYPATH.yml\" \"$C2ORE\" \"$R2AM\" \"$CERTS_DIR\" \"$DFS_DATA_DIR/Errors$STACKNAME\" \"$DFS_DATA_DIR/Misc$STACKNAME/RunHAProxy\" \"$THEREQINDRA\" \"${CLUSTERAPPSMAPPING["INDRA"]}\" \"${CLUSTER_APPS_MAPPING["INDRA"]}\" \"$SYNCWITHIFCONFIG\" \"$WEBSSHPort1\" \"$WEBSSH_PASSWORD\" \"$DFS_DATA_DIR/Misc$STACKNAME/webssh\" \"$THEWEBSSHIDLELIMIT\" \"${CLUSTERAPPSMAPPING["WEBSSH"]}\" \"${CLUSTER_APPS_MAPPING["WEBSSH"]}\" \"$CHITRAGUPTA_DET\" \"$MIN_IO_DET\" \"${HOST_NAMES[${INDRA_IPS[0]}]}\" && sudo rm -f /home/${LOGIN_USERS[${BRAHMA_IPS[0]}]}/VARAHA.sh"
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

# Function to get the VPC
get_vpc2() {
    local ip="$1"
    local pem_file="${PEM_FILES[$ip]}"
    local port="${PORTS[$ip]}"
    local theuser="${LOGIN_USERS[$ip]}"

    ssh -i "$pem_file" -o StrictHostKeyChecking=no -p "$port" "$theuser@$ip" "head -n 1 /opt/VPC"
}
get_vpc() {
    local ip="$1"
    local pem_file="${PEM_FILES[$ip]}"
    local port="${PORTS[$ip]}"
    local theuser="${LOGIN_USERS[$ip]}"

    ssh -i "$pem_file" -o StrictHostKeyChecking=no -p "$port" "$theuser@$ip" "
        if [ -f /opt/VPC ]; then
            head -n 1 /opt/VPC
        else
            cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1
        fi
    "
}

# Parse instance details
parse_instance_details

# Generate SSL certificates on the first manager node
generate_ssl_certificates ${BRAHMA_IPS[0]}

# Copy SSL certificates to the other manager nodes
copy_ssl_certificates ${BRAHMA_IPS[0]}

# Check If KRISHNA Required
declare -a VPCDET
for ip in "${BRAHMA_IPS[@]}" "${VISHVAKARMA_IPS[@]}" "${INDRA_IPS[@]}"; do
    VPCDET+=("$(get_vpc "$ip")")
done
declare -A unique_counts
for detail in "${VPCDET[@]}"; do
    ((unique_counts["$detail"]++))
done
ELIGIBLEFORKRISHNA="N"
if [ "${#unique_counts[@]}" -gt 1 ]; then
    ELIGIBLEFORKRISHNA="Y"
fi
echo "Eligible for KRISHNA: $ELIGIBLEFORKRISHNA"
if [[ "$ELIGIBLEFORKRISHNA" == "Y" ]]; then
	KRISHNATEMPLATE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	sudo cp $BASE/Resources/KRISHNA $BASE/tmp/$KRISHNATEMPLATE
	
	THEKRISHNAIPDET=$(IFS='|'; echo "${KRISHNA_IPS[*]}")
	sed -i -e s~"THEIPLIST"~"$THEKRISHNAIPDET"~g $BASE/tmp/$KRISHNATEMPLATE
	sed -i -e s~"THENIC"~"$STACKNAME"~g $BASE/tmp/$KRISHNATEMPLATE
	sed -i -e s~"THEWGPATH"~"/etc/wireguard"~g $BASE/tmp/$KRISHNATEMPLATE
	THEKRISHNAPORT=$($BASE/Scripts/GetRandomPortRange.sh 51000 52000)
	sed -i -e s~"THEKRISHNAPORT"~"$THEKRISHNAPORT"~g $BASE/tmp/$KRISHNATEMPLATE
	num1=$((RANDOM % 241 + 10))
	num2=$((RANDOM % 241 + 10))
	num3=$((RANDOM % 241 + 10))
	THESUBNET="${num1}.${num2}.${num3}"	
	sed -i -e s~"THESUBNET"~"$THESUBNET"~g $BASE/tmp/$KRISHNATEMPLATE
	sudo chmod 777 $BASE/tmp/$KRISHNATEMPLATE
	$BASE/tmp/$KRISHNATEMPLATE
	sudo rm -f $BASE/tmp/$KRISHNATEMPLATE	
fi

# Install Docker on all nodes
for IP in "${BRAHMA_IPS[@]}"; do
    install_docker "B" $IP
done
for IP in "${VISHVAKARMA_IPS[@]}"; do
    install_docker "V" $IP
done
for IP in "${INDRA_IPS[@]}"; do
    install_docker "I" $IP
done
sudo chmod 777 $BASE/tmp/$EXECUTESCRIPT
$BASE/tmp/$EXECUTESCRIPT
sudo rm -f $BASE/tmp/$EXECUTESCRIPT

create_cert_for_all() {
    sudo mkdir -p $BASE/Output/Vision/V$THEVISIONID/CERTS
    sudo chmod -R 777 $BASE/Output/Vision/V$THEVISIONID/CERTS
    sudo mkdir -p $BASE/Output/Vision/V$THEVISIONID/CERTS/CA
    sudo chmod -R 777 $BASE/Output/Vision/V$THEVISIONID/CERTS/CA
    sudo mkdir -p $BASE/Output/Vision/V$THEVISIONID/CERTS/FULL
    sudo chmod -R 777 $BASE/Output/Vision/V$THEVISIONID/CERTS/FULL
            
    ALL_CERT_IPS=("${BRAHMA_IPS[@]}" "${VISHVAKARMA_IPS[@]}" "${INDRA_IPS[@]}")

    for ip in "${ALL_CERT_IPS[@]}"; do
        local pem_file="${PEM_FILES[$ip]}"
        local port="${PORTS[$ip]}"
        local user="${LOGIN_USERS[$ip]}"
        local THEIPNAME=${HOST_NAMES[$ip]}
        local IPHF=$(echo "$ip" | sed 's/\./-/g')
        
        ssh -i "$pem_file" -p "$port" -o StrictHostKeyChecking=no "$user@$ip" "        
        sudo mkdir -p $CERTS_DIR && sudo chmod -R 777 $CERTS_DIR
        sudo mkdir -p $CERTS_DIR/self && sudo chmod -R 777 $CERTS_DIR/self 
        sudo mkdir -p $CERTS_DIR/cluster && sudo chmod -R 777 $CERTS_DIR/cluster
        sudo mkdir -p $CERTS_DIR/cluster/ca && sudo chmod -R 777 $CERTS_DIR/cluster/ca
        sudo mkdir -p $CERTS_DIR/cluster/full && sudo chmod -R 777 $CERTS_DIR/cluster/full         
        cd $CERTS_DIR
        openssl genpkey -algorithm RSA -out $IPHF-key.pem
        openssl req -x509 -new -nodes -key $IPHF-key.pem -sha256 -days 3650 -out $IPHF.pem -subj '/CN=$STACK_PRETTY_NAME-self'
        openssl genpkey -algorithm RSA -out $IPHF-server-key.pem
        openssl req -new -key $IPHF-server-key.pem -out $IPHF.csr -subj '/CN=$THEIPNAME'
        openssl x509 -req -in $IPHF.csr -CA $IPHF.pem -CAkey $IPHF-key.pem -CAcreateserial -out $IPHF-server-cert.pem -days 3650 -sha256  
        cat $IPHF-server-cert.pem $IPHF-server-key.pem > $IPHF-VARAHA.pem
                      
        sudo mkdir -p $CERTS_DIR/self && sudo chmod -R 777 $CERTS_DIR/self
        sudo rm -f $CERTS_DIR/self/*
        sudo cp $IPHF.pem $IPHF-server-cert.pem $IPHF-server-key.pem $IPHF-VARAHA.pem $CERTS_DIR/self/
        sudo rm -f $IPHF-key.pem
        sudo rm -f $IPHF.pem
        sudo rm -f $IPHF-server-key.pem
        sudo rm -f $IPHF.csr
        sudo rm -f $IPHF-server-cert.pem
        sudo rm -f $IPHF-VARAHA.pem        
        cd ~
        sudo chmod 644 $CERTS_DIR/self/$IPHF.pem
        sudo chmod 644 $CERTS_DIR/self/$IPHF-VARAHA.pem"

        scp -i "$pem_file" -P "$port" -o StrictHostKeyChecking=no "$user@$ip:$CERTS_DIR/self/$IPHF.pem" "$BASE/Output/Vision/V$THEVISIONID/CERTS/CA/$THEIPNAME.pem"
        scp -i "$pem_file" -P "$port" -o StrictHostKeyChecking=no "$user@$ip:$CERTS_DIR/self/$IPHF-VARAHA.pem" "$BASE/Output/Vision/V$THEVISIONID/CERTS/FULL/$THEIPNAME.pem"
    done 
    
    sudo chmod -R 777 $BASE/Output/Vision/V$THEVISIONID/CERTS/*

	pushd $BASE/Output/Vision/V$THEVISIONID
	tar -czf "CERTS.tar.gz" "CERTS"
	sudo chmod 777 CERTS.tar.gz
	popd
	    	
	for ip in "${ALL_CERT_IPS[@]}"; do
	    scp -i "${PEM_FILES[$ip]}" -o StrictHostKeyChecking=no -P ${PORTS[$ip]} "$BASE/Output/Vision/V$THEVISIONID/CERTS.tar.gz" "${LOGIN_USERS[$ip]}@$ip:/home/${LOGIN_USERS[$ip]}"
	    ssh -i "${PEM_FILES[$ip]}" -o StrictHostKeyChecking=no -p ${PORTS[$ip]} ${LOGIN_USERS[$ip]}@$ip "sudo rm -rf CERTS && tar -xzf \"CERTS.tar.gz\" && sudo mv CERTS/CA/* $CERTS_DIR/cluster/ca && sudo mv CERTS/FULL/* $CERTS_DIR/cluster/full && sudo rm -rf CERTS && sudo rm -f CERTS.tar.gz"
	done
    
    sudo rm -f $BASE/Output/Vision/V$THEVISIONID/CERTS.tar.gz       
}
create_cert_for_all

ALL1_IPS=("${BRAHMA_IPS[@]}" "${VISHVAKARMA_IPS[@]}" "${INDRA_IPS[@]}")
check_status() {
    local ip=$1
    local pem_file=${PEM_FILES[$ip]}
    local port=${PORTS[$ip]}
    local user=${LOGIN_USERS[$ip]}
    ssh -o StrictHostKeyChecking=no -i "$pem_file" -p "$port" "$user@$ip" "[ -f /opt/DSUDONE$STACKNAME ]"
    if [ $? -eq 0 ]; then
        echo "$ip - completed"
    else
        echo "$ip - in progress"
    fi
}
get_remote_dsu_log() {
	local ip=$1
	local pem_file=${PEM_FILES[$ip]}
	local port=${PORTS[$ip]}
	local user=${LOGIN_USERS[$ip]}
	local FILE_PATH_1="/home/$user/DSULog$STACKNAME.out"
	local FILE_PATH_2="/opt/DSULog$STACKNAME.out"
	local FILE_COPIED=false
	local hyphenated_ip="${ip//./-}"
	
	ssh -o StrictHostKeyChecking=no -i "$pem_file" -p "$port" "$user@$ip" "[ -f $FILE_PATH_1 ]"
	if [ $? -eq 0 ]; then
		echo "File found at $FILE_PATH_1 for $ip"
		scp -i "$pem_file" -P "$port" -o StrictHostKeyChecking=no $user@$ip:$FILE_PATH_1 $BASE/Output/Logs/$REQUNQ-VAMANA-$STACKPRETTYNAME-$hyphenated_ip-DSU-ERROR.out
	    	FILE_COPIED=true
	fi
    	
    	if [ "$FILE_COPIED" = false ]; then
		ssh -o StrictHostKeyChecking=no -i "$pem_file" -p "$port" "$user@$ip" "[ -f $FILE_PATH_2 ]"
		if [ $? -eq 0 ]; then
			echo "File found at $FILE_PATH_2 for $ip"
			scp -i "$pem_file" -P "$port" -o StrictHostKeyChecking=no $user@$ip:$FILE_PATH_2 $BASE/Output/Logs/$REQUNQ-VAMANA-$STACKPRETTYNAME-$hyphenated_ip-DSU.out
		    	FILE_COPIED=true
		fi    	
    	fi
}
COUNTER=0
PROCSOS="N"
while true; do
    echo ""
    echo "-----------------------" 
    echo "COUNTER : $COUNTER"
    echo "-----------------------"    
    all_done=true

    for ip in "${ALL1_IPS[@]}"; do
        status=$(check_status "$ip")
        echo "$status"
        if [[ $status == *"in progress"* ]]; then
            all_done=false
        fi
    done

    if [ "$all_done" = true ]; then
        echo "jobdone"
        break
    fi
    echo "-----------------------" 
    COUNTER=$((COUNTER + 1))
    if (( $COUNTER == 40 )) ; then
        echo "something is wrong..."
        PROCSOS="Y"
        break    	
    fi
    sleep 15
done
COUNTER=0
for ip in "${ALL1_IPS[@]}"; do
	get_remote_dsu_log "$ip"
done
if [[ "$PROCSOS" == "Y" ]]; then
	sudo mv $THENOHUPFILE $BASE/Output/Logs/$REQUNQ-VAMANA-FATAL_ERROR-$STACKPRETTYNAME.out
	exit
fi

ALL5_IPS=("${BRAHMA_IPS[@]}" "${VISHVAKARMA_IPS[@]}" "${INDRA_IPS[@]}")
for ip in "${ALL5_IPS[@]}"; do
    DOCKER2TEMPLATE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
    sudo cp $BASE/Resources/DockerRestartJoinTemplate $BASE/tmp/$DOCKER2TEMPLATE
    scp -i "${PEM_FILES[$ip]}" -o StrictHostKeyChecking=no -P ${PORTS[$ip]} "$BASE/tmp/$DOCKER2TEMPLATE" "${LOGIN_USERS[$ip]}@$ip:/home/${LOGIN_USERS[$ip]}"
    ssh -i "${PEM_FILES[$ip]}" -o StrictHostKeyChecking=no -p ${PORTS[$ip]} ${LOGIN_USERS[$ip]}@$ip "sudo rm -f $DFS_DATA_DIR/Misc$STACKNAME/DockerRestartJoinTemplate && sudo mv /home/${LOGIN_USERS[$ip]}/$DOCKER2TEMPLATE $DFS_DATA_DIR/Misc$STACKNAME/DockerRestartJoinTemplate$STACKNAME && sudo chmod 777 $DFS_DATA_DIR/Misc$STACKNAME/DockerRestartJoinTemplate$STACKNAME"
    sudo rm -f $BASE/tmp/$DOCKER2TEMPLATE
done

ALL8_IPS=("${BRAHMA_IPS[@]}" "${VISHVAKARMA_IPS[@]}" "${INDRA_IPS[@]}")
for ip in "${ALL8_IPS[@]}"; do
    DOCKER2TEMPLATE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
    sudo cp $BASE/Resources/DockerCleanUpTemplate $BASE/tmp/$DOCKER2TEMPLATE
    scp -i "${PEM_FILES[$ip]}" -o StrictHostKeyChecking=no -P ${PORTS[$ip]} "$BASE/tmp/$DOCKER2TEMPLATE" "${LOGIN_USERS[$ip]}@$ip:/home/${LOGIN_USERS[$ip]}"
    ssh -i "${PEM_FILES[$ip]}" -o StrictHostKeyChecking=no -p ${PORTS[$ip]} ${LOGIN_USERS[$ip]}@$ip "sudo rm -f $DFS_DATA_DIR/Misc$STACKNAME/DockerCleanUpTemplate && sudo mv /home/${LOGIN_USERS[$ip]}/$DOCKER2TEMPLATE $DFS_DATA_DIR/Misc$STACKNAME/DockerCleanUpTemplate$STACKNAME && sudo chmod 777 $DFS_DATA_DIR/Misc$STACKNAME/DockerCleanUpTemplate$STACKNAME"
    sudo rm -f $BASE/tmp/$DOCKER2TEMPLATE
done

fetch_internal_ip() {
    local IP=$1
    local PORT=${PORTS[$IP]}
    local THEREQUSER=${LOGIN_USERS[$IP]}
    if [[ "$ELIGIBLEFORKRISHNA" == "Y" ]]; then
    	local internal_ip=$(ssh -i "${PEM_FILES[$IP]}" -o StrictHostKeyChecking=no -p $PORT $THEREQUSER@$IP "cat /opt/WHOAMI3") 
    else
    	local internal_ip=$(ssh -i "${PEM_FILES[$IP]}" -o StrictHostKeyChecking=no -p $PORT $THEREQUSER@$IP "cat /opt/WHOAMI2") 
    fi        
    echo $internal_ip   
}

if [ "$NATIVE" -lt 2 ]; then
	EXECUTE2SCRIPT=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1) && touch $BASE/tmp/$EXECUTE2SCRIPT && sudo chmod 777 $BASE/tmp/$EXECUTE2SCRIPT
	EXECUTE3SCRIPT='#!/bin/bash'"
	"
	echo "$EXECUTE3SCRIPT" | sudo tee -a $BASE/tmp/$EXECUTE2SCRIPT > /dev/null
	echo 'sudo -H -u root bash -c "echo \"\" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTE2SCRIPT > /dev/null
	echo 'sudo -H -u root bash -c "echo \"#VAMANA ALT => '"$STACKPRETTYNAME"' START \" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTE2SCRIPT > /dev/null
	for ip in "${BRAHMA_IPS[@]}" "${VISHVAKARMA_IPS[@]}" "${INDRA_IPS[@]}"; do
	    internal_ip=$(fetch_internal_ip $ip)
	    JIVA_IPS["$ip"]="$internal_ip"
	    echo 'sudo -H -u root bash -c "sed -i -e s~'"$internal_ip"'~#'"$internal_ip"'~g /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTE2SCRIPT > /dev/null  
	    echo 'sudo -H -u root bash -c "echo \"'"$internal_ip"' '"${HOST_ALT_NAMES[$ip]}"'\" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTE2SCRIPT > /dev/null	    
	done
	for ip in "${!JIVA_IPS[@]}"; do
	    echo "$ip : ${JIVA_IPS[$ip]}"
	done
	echo 'sudo -H -u root bash -c "echo \"#VAMANA ALT => '"$STACKPRETTYNAME"' END \" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTE2SCRIPT > /dev/null 
	echo 'sudo -H -u root bash -c "echo \"\" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTE2SCRIPT > /dev/null
	#echo 'sudo systemctl enable BDDMinio'"$STACKNAME" | sudo tee -a $BASE/tmp/$EXECUTE2SCRIPT > /dev/null
	#echo 'sudo systemctl start BDDMinio'"$STACKNAME" | sudo tee -a $BASE/tmp/$EXECUTE2SCRIPT > /dev/null

	ALL_IPS=("${BRAHMA_IPS[@]}" "${VISHVAKARMA_IPS[@]}" "${INDRA_IPS[@]}")
	for ip in "${ALL_IPS[@]}"; do
		scp -i "${PEM_FILES[$ip]}" -o StrictHostKeyChecking=no -P ${PORTS[$ip]} "$BASE/tmp/$EXECUTE2SCRIPT" "${LOGIN_USERS[$ip]}@$ip:/home/${LOGIN_USERS[$ip]}"
		ssh -i "${PEM_FILES[$ip]}" -o StrictHostKeyChecking=no -p ${PORTS[$ip]} ${LOGIN_USERS[$ip]}@$ip "sudo chmod 777 /home/${LOGIN_USERS[$ip]}/$EXECUTE2SCRIPT && /home/${LOGIN_USERS[$ip]}/$EXECUTE2SCRIPT && sudo rm -f /home/${LOGIN_USERS[$ip]}/$EXECUTE2SCRIPT"
	done

	sudo rm -f $BASE/tmp/$EXECUTE2SCRIPT	  
fi

# Initialize Docker Swarm with custom ports and autolock on the first manager node
run_remote ${BRAHMA_IPS[0]} "docker swarm init --advertise-addr ${BRAHMA_IPS[0]} --autolock"

sudo rm -f $UNLOCKFILEPATH
sudo rm -f $MJTFILEPATH
sudo rm -f $WJTFILEPATH

SWARM_UNLOCK_KEY=$(run_remote ${BRAHMA_IPS[0]} "docker swarm unlock-key -q")
ULFP_FILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
ULFP1_FILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
echo $SWARM_UNLOCK_KEY > $BASE/tmp/$ULFP1_FILE
$BASE/Scripts/SecretsFile-Encrypter "$BASE/tmp/$ULFP1_FILE├$UNLOCKFILEPATH├$ADMIN_PASSWORD├$ULFP_FILE"
sudo chmod 777 $UNLOCKFILEPATH
sudo rm -f $BASE/tmp/$ULFP1_FILE
MGR1IPS=$(IFS=','; echo "${BRAHMA_IPS[*]}")

# Get the join token for manager and worker nodes
BRAHMA_JOIN_TOKEN=$(run_remote ${BRAHMA_IPS[0]} "docker swarm join-token manager -q")
VISHVAKARMA_JOIN_TOKEN=$(run_remote ${BRAHMA_IPS[0]} "docker swarm join-token worker -q")
MJTFP_FILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
MJTFP1_FILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
echo $BRAHMA_JOIN_TOKEN > $BASE/tmp/$MJTFP1_FILE
$BASE/Scripts/SecretsFile-Encrypter "$BASE/tmp/$MJTFP1_FILE├$MJTFILEPATH├$ADMIN_PASSWORD├$MJTFP_FILE"
sudo chmod 777 $MJTFILEPATH
sudo rm -f $BASE/tmp/$MJTFP1_FILE
WJTFP_FILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
WJTFP1_FILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
echo $VISHVAKARMA_JOIN_TOKEN > $BASE/tmp/$WJTFP1_FILE
$BASE/Scripts/SecretsFile-Encrypter "$BASE/tmp/$WJTFP1_FILE├$WJTFILEPATH├$ADMIN_PASSWORD├$WJTFP_FILE"
sudo chmod 777 $WJTFILEPATH
sudo rm -f $BASE/tmp/$WJTFP1_FILE

echo "$DFS_DATA_DIR/Misc$STACKNAME/DockerRestartJoinTemplate$STACKNAME '$MGR1IPS' '$STACKNAME' '$DFS_DATA_DIR/Misc$STACKNAME'"
# Join remaining manager nodes to the Swarm
for IP in "${BRAHMA_IPS[@]:1}"; do
    run_remote $IP "sudo rm -f /var/lib/.dsuk$STACKNAME && echo '$SWARM_UNLOCK_KEY' | sudo tee /var/lib/.dsuk$STACKNAME > /dev/null && sudo rm -f /var/lib/.dsjt$STACKNAME && echo '$BRAHMA_JOIN_TOKEN' | sudo tee /var/lib/.dsjt$STACKNAME > /dev/null && docker swarm join --token $BRAHMA_JOIN_TOKEN --advertise-addr $IP ${BRAHMA_IPS[0]}:2377 && $DFS_DATA_DIR/Misc$STACKNAME/DockerRestartJoinTemplate$STACKNAME '$MGR1IPS' '$STACKNAME' '$DFS_DATA_DIR/Misc$STACKNAME' && $DFS_DATA_DIR/Misc$STACKNAME/DockerCleanUpTemplate$STACKNAME '$STACKNAME' '$DFS_DATA_DIR/Misc$STACKNAME'"    
done

for IP in "${BRAHMA_IPS[0]}"; do
    run_remote $IP "sudo rm -f /var/lib/.dsuk$STACKNAME && echo '$SWARM_UNLOCK_KEY' | sudo tee /var/lib/.dsuk$STACKNAME > /dev/null && sudo rm -f /var/lib/.dsjt$STACKNAME && echo '$BRAHMA_JOIN_TOKEN' | sudo tee /var/lib/.dsjt$STACKNAME > /dev/null && $DFS_DATA_DIR/Misc$STACKNAME/DockerRestartJoinTemplate$STACKNAME '$MGR1IPS' '$STACKNAME' '$DFS_DATA_DIR/Misc$STACKNAME' && $DFS_DATA_DIR/Misc$STACKNAME/DockerCleanUpTemplate$STACKNAME '$STACKNAME' '$DFS_DATA_DIR/Misc$STACKNAME'"    
done

# Join worker nodes to the Swarm
for IP in "${VISHVAKARMA_IPS[@]}"; do
    run_remote $IP "sudo rm -f /var/lib/.dsuk$STACKNAME && echo '$SWARM_UNLOCK_KEY' | sudo tee /var/lib/.dsuk$STACKNAME > /dev/null && sudo rm -f /var/lib/.dsjt$STACKNAME && echo '$VISHVAKARMA_JOIN_TOKEN' | sudo tee /var/lib/.dsjt$STACKNAME > /dev/null && docker swarm join --token $VISHVAKARMA_JOIN_TOKEN --advertise-addr $IP ${BRAHMA_IPS[0]}:2377 && $DFS_DATA_DIR/Misc$STACKNAME/DockerRestartJoinTemplate$STACKNAME '$MGR1IPS' '$STACKNAME' '$DFS_DATA_DIR/Misc$STACKNAME' && $DFS_DATA_DIR/Misc$STACKNAME/DockerCleanUpTemplate$STACKNAME '$STACKNAME' '$DFS_DATA_DIR/Misc$STACKNAME'"
done

# Join router nodes to the Swarm
for IP in "${INDRA_IPS[@]}"; do
    run_remote $IP "sudo rm -f /var/lib/.dsuk$STACKNAME && echo '$SWARM_UNLOCK_KEY' | sudo tee /var/lib/.dsuk$STACKNAME > /dev/null && sudo rm -f /var/lib/.dsjt$STACKNAME && echo '$VISHVAKARMA_JOIN_TOKEN' | sudo tee /var/lib/.dsjt$STACKNAME > /dev/null && docker swarm join --token $VISHVAKARMA_JOIN_TOKEN --advertise-addr $IP ${BRAHMA_IPS[0]}:2377 && $DFS_DATA_DIR/Misc$STACKNAME/DockerRestartJoinTemplate$STACKNAME '$MGR1IPS' '$STACKNAME' '$DFS_DATA_DIR/Misc$STACKNAME' && $DFS_DATA_DIR/Misc$STACKNAME/DockerCleanUpTemplate$STACKNAME '$STACKNAME' '$DFS_DATA_DIR/Misc$STACKNAME'"
done

create_encrypted_overlay_network

THEMANGIP="${BRAHMA_IPS[0]}"
THE1RAM=${APP_MEM[$THEMANGIP]}
R1AM=$( [[ $THE1RAM == *,* ]] && echo "${THE1RAM#*,}" || echo "$THE1RAM" )
THE1CORE=${APP_CORE[$THEMANGIP]}
C1ORE=$( [[ $THE1CORE == *,* ]] && echo "${THE1CORE#*,}" || echo "$THE1CORE" ) 
P1O1R1T=${PORTS[${BRAHMA_IPS[0]}]}
THE1R1E1QUSE1R=${LOGIN_USERS[${BRAHMA_IPS[0]}]}
SUBNET=$(ssh -i "${PEM_FILES[${BRAHMA_IPS[0]}]}" -o StrictHostKeyChecking=no -p $P1O1R1T $THE1R1E1QUSE1R@${BRAHMA_IPS[0]} "docker network inspect ${STACKNAME}-encrypted-overlay | grep -m 1 -oP '(?<=\"Subnet\": \")[^\"]+'")
echo "Using Subnet $SUBNET ..."

create_glusterfs_volume_cluster "$STACKNAME" "$DFS_CLUSTER_DIR"
create_glusterfs_volume_cluster "miniogdata" "$DFS_DATA_DIR/MINIODATA"
create_glusterfs_volume_cluster "nextgcloud" "$DFS_DATA_DIR/NEXTCLOUD"

if [ ${#BRAHMA_IPS[@]} -lt 2 ]; then
	echo "No need for Portainer HA"
else
	create_glusterfs_volume_portainer
fi
    
create_swarm_labels

final_nodes_list() {
	declare -a FNL_IPS
	ALL9_IPS=("${BRAHMA_IPS[@]}" "${VISHVAKARMA_IPS[@]}" "${INDRA_IPS[@]}")
	ALL92_IPS=("${BRAHMA_IPS[@]}" "${INDRA_IPS[@]}" "${VISHVAKARMA_IPS[0]}")
	
	for ip in "${ALL9_IPS[@]}"; do
		FNL_IPS+=("$ip,${PORTS[$ip]},${PEM_FILES[$ip]},${LOGIN_USERS[$ip]},${HOST_NAMES[$ip]},${HOST_ALT_NAMES[$ip]},${JIVA_IPS[$ip]},${ROLE_TYPE[$ip]}")	
	done

	DOCKER9TEMPLATE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	for item in "${FNL_IPS[@]}"; do
	    echo "$item" >> "$BASE/tmp/$DOCKER9TEMPLATE"
	done	

	sudo mkdir -p $BASE/tmp/Folder$DOCKER9TEMPLATE
	pem_files=$(awk -F ',' '{print $3}' "$BASE/tmp/$DOCKER9TEMPLATE" | sort | uniq)
	echo "Distinct PEM files:"
	for pem_file in $pem_files
	do
	    echo "$pem_file"
	    filenamePEM="${pem_file##*/}"
	    sudo cp $pem_file $BASE/tmp/Folder$DOCKER9TEMPLATE/$filenamePEM
	    sudo chmod 777 $BASE/tmp/Folder$DOCKER9TEMPLATE/$filenamePEM
	    sudo chown root:root $BASE/tmp/Folder$DOCKER9TEMPLATE/$filenamePEM
	done
	sudo chown root:root -R $BASE/tmp/Folder$DOCKER9TEMPLATE
	sudo chmod 777 -R $BASE/tmp/Folder$DOCKER9TEMPLATE
	pushd $BASE/tmp
	tar -czf "Folder$DOCKER9TEMPLATE.tar.gz" "Folder$DOCKER9TEMPLATE"
	sudo chmod 777 Folder$DOCKER9TEMPLATE.tar.gz
	popd
	    	
	for ip in "${ALL92_IPS[@]}"; do
	    scp -i "${PEM_FILES[$ip]}" -o StrictHostKeyChecking=no -P ${PORTS[$ip]} "$BASE/tmp/Folder$DOCKER9TEMPLATE.tar.gz" "${LOGIN_USERS[$ip]}@$ip:/home/${LOGIN_USERS[$ip]}"
	    scp -i "${PEM_FILES[$ip]}" -o StrictHostKeyChecking=no -P ${PORTS[$ip]} "$BASE/tmp/$DOCKER9TEMPLATE" "${LOGIN_USERS[$ip]}@$ip:/home/${LOGIN_USERS[$ip]}"
	    ssh -i "${PEM_FILES[$ip]}" -o StrictHostKeyChecking=no -p ${PORTS[$ip]} ${LOGIN_USERS[$ip]}@$ip "sudo rm -f $DFS_DATA_DIR/Misc$STACKNAME/webssh/.Nodes && sudo mv /home/${LOGIN_USERS[$ip]}/$DOCKER9TEMPLATE $DFS_DATA_DIR/Misc$STACKNAME/webssh/.Nodes && sudo chmod 777 $DFS_DATA_DIR/Misc$STACKNAME/webssh/.Nodes && tar -xzf \"Folder$DOCKER9TEMPLATE.tar.gz\" && sudo mv Folder$DOCKER9TEMPLATE/* $DFS_DATA_DIR/Misc$STACKNAME/webssh/PEMS && pushd $DFS_DATA_DIR/Misc$STACKNAME/webssh/PEMS && chmod 400 *.pem && popd && sudo rm -rf Folder$DOCKER9TEMPLATE && sudo rm -f Folder$DOCKER9TEMPLATE.tar.gz"
	done
	
	sudo rm -rf $BASE/tmp/Folder$DOCKER9TEMPLATE
	sudo rm -rf $BASE/tmp/Folder$DOCKER9TEMPLATE.tar.gz
	
	FNNPATH="$BASE/Output/Vision/V$THEVISIONID/$STACKNAME.normal"
	if [[ "$ELIGIBLEFORKRISHNA" == "Y" ]]; then
		FNNPATH="$BASE/Output/Vision/V$THEVISIONID/Nodes$STACKNAME.vpn"		
	fi

	FNN_FILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	$BASE/Scripts/SecretsFile-Encrypter "$BASE/tmp/$DOCKER9TEMPLATE├$FNNPATH├$ADMIN_PASSWORD├$FNN_FILE"
	sudo chmod 777 $FNNPATH
	sudo rm -f $BASE/tmp/$FNN_FILE
	sudo rm -f $BASE/tmp/$DOCKER9TEMPLATE
}

final_nodes_list

ALL3_IPS=("${BRAHMA_IPS[@]}" "${VISHVAKARMA_IPS[@]}" "${INDRA_IPS[@]}")
for ip in "${ALL3_IPS[@]}"; do
	ssh -i "${PEM_FILES[$ip]}" -o StrictHostKeyChecking=no -p ${PORTS[$ip]} ${LOGIN_USERS[$ip]}@$ip "sudo gluster volume heal $THEFINALVOLUMENAME full"
done

DOCKERCGTEMPLATE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
RNDM_=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
sudo cp $BASE/Resources/CHITRAGUPTA $BASE/tmp/$DOCKERCGTEMPLATE
sed -i -e s~"THECGVALS"~"$CHITRAGUPTA_DET"~g $BASE/tmp/$DOCKERCGTEMPLATE
sed -i -e s~"THECGFOLDER"~"$DFS_DATA_DIR/CHITRAGUPTA$STACKNAME"~g $BASE/tmp/$DOCKERCGTEMPLATE
sed -i -e s~"THEBRAHMAIPDET"~"${PEM_FILES[${BRAHMA_IPS[0]}]},${PORTS[${BRAHMA_IPS[0]}]},${LOGIN_USERS[${BRAHMA_IPS[0]}]},${BRAHMA_IPS[0]}"~g $BASE/tmp/$DOCKERCGTEMPLATE
sed -i -e s~"TEMPDPLOC"~"$BASE/tmp"~g $BASE/tmp/$DOCKERCGTEMPLATE
sed -i -e s~"THECURSTACK"~"$STACKNAME"~g $BASE/tmp/$DOCKERCGTEMPLATE
sed -i -e s~"LOGFILE"~"$BASE/tmp/CHITRAGUPTA-$STACKNAME-$RNDM_.out"~g $BASE/tmp/$DOCKERCGTEMPLATE
sed -i -e s~"SELFME"~"$BASE/tmp/$DOCKERCGTEMPLATE"~g $BASE/tmp/$DOCKERCGTEMPLATE
sed -i -e s~"UNQREQ"~"$REQUNQ"~g $BASE/tmp/$DOCKERCGTEMPLATE

echo "" && echo "Install Guacamole & MySql..."
echo "$ChitraGuptaPort1,$ChitraGuptaPort2,$ChitraGuptaPort3,$ChitraGuptaPort4,$ChitraGuptaPort5,$ChitraGuptaPort6,$ChitraGuptaPort7"
echo "" && echo "Install Prometheus, Grafana, Node Exporter & cAdvisor..."
echo "$ChitraGuptaPort8,$ChitraGuptaPortU1,$ChitraGuptaPortV1,$ChitraGuptaPortW1,$ChitraGuptaPortY1"
nohup $BASE/tmp/$DOCKERCGTEMPLATE > $BASE/tmp/CHITRAGUPTA-$STACKNAME-$RNDM_.out 2>&1 &

create_cluster_cdn_proxy

DOCKERPTEMPLATE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
sudo cp $BASE/Resources/DockerPortainer.yml $BASE/tmp/$DOCKERPTEMPLATE
sed -i -e s~"PortainerSPort"~"$PortainerSPort"~g $BASE/tmp/$DOCKERPTEMPLATE
sed -i -e s~"PortainerAPort"~"$PortainerAPort"~g $BASE/tmp/$DOCKERPTEMPLATE
sed -i -e s~"REVERSED_PASSWORD"~"$REVERSED_PASSWORD"~g $BASE/tmp/$DOCKERPTEMPLATE
sed -i -e s~"STACKNAME"~"$STACKNAME"~g $BASE/tmp/$DOCKERPTEMPLATE
sed -i -e s~"C1ORE"~"$C1ORE"~g $BASE/tmp/$DOCKERPTEMPLATE
sed -i -e s~"R1AM"~"$R1AM"~g $BASE/tmp/$DOCKERPTEMPLATE
sed -i -e s~"DOCKER_VOLUME_NAME"~"$DFS_DATA_DIR/PortainerMnt$STACKNAME"~g $BASE/tmp/$DOCKERPTEMPLATE
sed -i -e s~"CERTS_DIR"~"$CERTS_DIR"~g $BASE/tmp/$DOCKERPTEMPLATE
sed -i -e s~"INDRANAME"~"${HOST_NAMES[${INDRA_IPS[0]}]}"~g $BASE/tmp/$DOCKERPTEMPLATE
sed -i -e s~"INDRAPORT"~"$VarahaPort2"~g $BASE/tmp/$DOCKERPTEMPLATE
sed -i -e s~"WRKRVER"~"${CLUSTERAPPSMAPPING["VISHVAKARMA"]}"~g $BASE/tmp/$DOCKERPTEMPLATE
sed -i -e s~"MGRVER"~"${CLUSTERAPPSMAPPING["BRAHMA"]}"~g $BASE/tmp/$DOCKERPTEMPLATE
sed -i -e s~"WRKR1VER"~"${CLUSTER_APPS_MAPPING["VISHVAKARMA"]}"~g $BASE/tmp/$DOCKERPTEMPLATE
sed -i -e s~"MGR1VER"~"${CLUSTER_APPS_MAPPING["BRAHMA"]}"~g $BASE/tmp/$DOCKERPTEMPLATE

sed -i -e s~"MIN_IO_VAL_1"~"${CLUSTER_APPS_MAPPING["BUCKET"]}:${CLUSTERAPPSMAPPING["BUCKET"]}"~g $BASE/tmp/$DOCKERPTEMPLATE
sed -i -e s~"MIN_IO_VAL_2"~"$DFS_DATA_DIR/MINIODATA"~g $BASE/tmp/$DOCKERPTEMPLATE
sed -i -e s~"MIN_IO_VAL_3"~"$DFS_DATA_DIR/MINIO/EntryPoint.sh"~g $BASE/tmp/$DOCKERPTEMPLATE
sed -i -e s~"MIN_IO_VAL_4"~"$ADMIN_PASSWORD"~g $BASE/tmp/$DOCKERPTEMPLATE
IFS=':' read -r -a _MK1T7 <<< "${CLUSTER_MEMORYCORES_MAPPING["BUCKET"]}"
MK1T7_M="${_MK1T7[0]}"
MK1T7_C="${_MK1T7[1]}"
sed -i -e s~"MIN_IO_VAL_5"~"$MK1T7_C"~g $BASE/tmp/$DOCKERPTEMPLATE
sed -i -e s~"MIN_IO_VAL_6"~"$MK1T7_M"~g $BASE/tmp/$DOCKERPTEMPLATE
sed -i -e s~"MIN_IO_VAL_7"~"$MINPortIO1"~g $BASE/tmp/$DOCKERPTEMPLATE
sed -i -e s~"MIN_IO_VAL_8"~"$MINPortIO2"~g $BASE/tmp/$DOCKERPTEMPLATE

sed -i -e s~"FL_BR_VAL_1"~"${CLUSTER_APPS_MAPPING["CLOUDCOMMANDER"]}:${CLUSTERAPPSMAPPING["CLOUDCOMMANDER"]}"~g $BASE/tmp/$DOCKERPTEMPLATE
sed -i -e s~"FL_BR_VAL_2"~"$DFS_CLUSTER_DIR"~g $BASE/tmp/$DOCKERPTEMPLATE
sed -i -e s~"FL_BR_VAL_3"~"$DFS_DATA_DIR/NEXTCLOUD/CONTENT"~g $BASE/tmp/$DOCKERPTEMPLATE
sed -i -e s~"FL_BR_VAL_4"~"$ADMIN_PASSWORD"~g $BASE/tmp/$DOCKERPTEMPLATE
IFS=':' read -r -a _MK11T7 <<< "${CLUSTER_MEMORYCORES_MAPPING["CLOUDCOMMANDER"]}"
MK11T7_M="${_MK11T7[0]}"
MK11T7_C="${_MK11T7[1]}"
sed -i -e s~"FL_BR_VAL_5"~"$MK11T7_C"~g $BASE/tmp/$DOCKERPTEMPLATE
sed -i -e s~"FL_BR_VAL_6"~"$MK11T7_M"~g $BASE/tmp/$DOCKERPTEMPLATE
sed -i -e s~"FL_BR_VAL_7"~"$FLBRPortIO1"~g $BASE/tmp/$DOCKERPTEMPLATE

IWP="${VISHVAKARMA_IPS[0]}"
THE1RAM=${APP_MEM[$IWP]}
R2AM=$( [[ $THE1RAM == *,* ]] && echo "${THE1RAM#*,}" || echo "$THE1RAM" )
THE1CORE=${APP_CORE[$IWP]}
C2ORE=$( [[ $THE1CORE == *,* ]] && echo "${THE1CORE#*,}" || echo "$THE1CORE" ) 
sed -i -e s~"C2ORE"~"$C2ORE"~g $BASE/tmp/$DOCKERPTEMPLATE
sed -i -e s~"R2AM"~"$R2AM"~g $BASE/tmp/$DOCKERPTEMPLATE

sudo chmod 777 $BASE/tmp/$DOCKERPTEMPLATE
READYTOROCK="NO"
max_attempts=5
attempt=0
while true; do
attempt=$((attempt + 1))
scp -i "${PEM_FILES[${BRAHMA_IPS[0]}]}" -o StrictHostKeyChecking=no -P ${PORTS[${BRAHMA_IPS[0]}]} "$BASE/tmp/$DOCKERPTEMPLATE" "${LOGIN_USERS[${BRAHMA_IPS[0]}]}@${BRAHMA_IPS[0]}:/home/${LOGIN_USERS[${BRAHMA_IPS[0]}]}"
status=$?
if [ $status -eq 0 ]; then
    READYTOROCK="YES"
    sudo rm -f $BASE/tmp/$DOCKERPTEMPLATE
    break
else
    if [ $attempt -ge $max_attempts ]; then
        echo "Maximum attempts reached. Exiting."
        exit 1
    fi
    sleep 5
fi
done
    
echo "" && echo "Install Portainer & Agent..."
# Deploy Portainer on the manager nodes with HTTPS
if [ "$READYTOROCK" == "YES" ] ; then
	run_remote ${BRAHMA_IPS[0]} "sudo mkdir -p $DFS_CLUSTER_DIR/NextcloudShared && sudo chown -R root:root $DFS_CLUSTER_DIR/NextcloudShared && sudo chmod -R u=rwx,g=rwx,o=rwx $DFS_CLUSTER_DIR/NextcloudShared && sudo mkdir -p $DFS_DATA_DIR/NEXTCLOUD/CONTENT && sudo chown -R root:root $DFS_DATA_DIR/NEXTCLOUD/CONTENT && sudo chmod -R u=rwx,g=rwx,o=rwx $DFS_DATA_DIR/NEXTCLOUD/CONTENT && sudo rm -f /home/${LOGIN_USERS[${BRAHMA_IPS[0]}]}/Portainer.yml && sudo mv /home/${LOGIN_USERS[${BRAHMA_IPS[0]}]}/$DOCKERPTEMPLATE /home/${LOGIN_USERS[${BRAHMA_IPS[0]}]}/Portainer.yml && cat /home/${LOGIN_USERS[${BRAHMA_IPS[0]}]}/Portainer.yml && docker stack deploy --compose-file /home/${LOGIN_USERS[${BRAHMA_IPS[0]}]}/Portainer.yml $STACKNAME""_GANESHA && sudo rm -f /home/${LOGIN_USERS[${BRAHMA_IPS[0]}]}/Portainer.yml"
fi

echo "Portainer Proxy : https://${HOST_NAMES[${INDRA_IPS[0]}]}:$VarahaPort3"
echo "Portainer Admin : https://${HOST_NAMES[${INDRA_IPS[0]}]}:$VarahaPort4"
echo "Static Global : https://${HOST_NAMES[${INDRA_IPS[0]}]}:$VarahaPort2"
if [[ "$ISAUTOMATED" == "Y" ]]; then
	google-chrome "https://${HOST_NAMES[${INDRA_IPS[0]}]}:$VarahaPort3" "https://${HOST_NAMES[${INDRA_IPS[0]}]}:$VarahaPort4" "https://${HOST_NAMES[${INDRA_IPS[0]}]}:$VarahaPort2" "https://${HOST_NAMES[${INDRA_IPS[0]}]}:$ChitraGuptaPort5/guacamole/" "https://${HOST_NAMES[${INDRA_IPS[0]}]}:$ChitraGuptaPort6" "https://${HOST_NAMES[${INDRA_IPS[0]}]}:$ChitraGuptaPortY1" "https://${HOST_NAMES[${INDRA_IPS[0]}]}:$ChitraGuptaPortZ1" "https://${HOST_NAMES[${INDRA_IPS[0]}]}:$ChitraGuptaPortLDP4" "https://${HOST_NAMES[${INDRA_IPS[0]}]}:$MINPortIO4" "https://${HOST_NAMES[${INDRA_IPS[0]}]}:$FLBRPortIO2" &
fi

FNN2PATH="$BASE/Output/Vision/V$THEVISIONID/$STACKNAME.json"
echo "[
  {
    \"Portainer\": \"https://${HOST_NAMES[${INDRA_IPS[0]}]}:$VarahaPort3\"
  },
  {
    \"MinIO\": \"https://${HOST_NAMES[${INDRA_IPS[0]}]}:$MINPortIO4\"
  },
  {
    \"Cloud Commander\": \"https://${HOST_NAMES[${INDRA_IPS[0]}]}:$FLBRPortIO2\"
  },
  {
    \"Prometheus\": \"https://${HOST_NAMES[${INDRA_IPS[0]}]}:$ChitraGuptaPortZ1\"
  },
  {
    \"Grafana\": \"https://${HOST_NAMES[${INDRA_IPS[0]}]}:$ChitraGuptaPortY1\"
  },
  {
    \"Guacamole\": \"https://${HOST_NAMES[${INDRA_IPS[0]}]}:$ChitraGuptaPort5/guacamole/\"
  },
  {
    \"phpMyAdmin\": \"https://${HOST_NAMES[${INDRA_IPS[0]}]}:$ChitraGuptaPort6\"
  },
  {
    \"phpLDAPadmin\": \"https://${HOST_NAMES[${INDRA_IPS[0]}]}:$ChitraGuptaPortLDP4\"
  },
  {
    \"Static Hosting\": \"https://${HOST_NAMES[${INDRA_IPS[0]}]}:$VarahaPort2\"
  },
  {
    \"HAProxy Admin\": \"https://${HOST_NAMES[${INDRA_IPS[0]}]}:$VarahaPort4\"
  },
  {
    \"MySQL\": \"${HOST_NAMES[${INDRA_IPS[0]}]}:$ChitraGuptaPort7\"
  },
  {
    \"OpenLDAP\": \"ldaps://${HOST_NAMES[${INDRA_IPS[0]}]}:$ChitraGuptaPortLDP5\"
  },
  {
    \"Kerberos KDC\": \"${HOST_NAMES[${INDRA_IPS[0]}]}:$ChitraGuptaPortKERB3\"
  },
  {
    \"Kerberos Admin\": \"${HOST_NAMES[${INDRA_IPS[0]}]}:$ChitraGuptaPortKERB4\"
  }
]" >> "$FNN2PATH"

PORTAINER_URL="https://${BRAHMA_IPS[0]}:$PortainerSPort/api"
PORTAINER_URL="https://${HOST_NAMES[${INDRA_IPS[0]}]}:$VarahaPort3/api"
USERNAME="admin"
MAX_RETRIES=100
SLEEP_INTERVAL=5
THENEW1ENV="$STACKPRETTYNAME"
set_admin_password() {
    curl -k -X POST "$PORTAINER_URL/users/admin/init" \
    -H "Content-Type: application/json" \
    --data "{\"Username\": \"$USERNAME\", \"Password\": \"$ADMIN_PASSWORD\"}"
}
is_portainer_up() {
    curl -k -s -o /dev/null -w "%{http_code}" "$PORTAINER_URL/system/status" | grep -q "200"
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

PortainerGUI=$(ssh -i "${PEM_FILES[${BRAHMA_IPS[0]}]}" -o StrictHostKeyChecking=no -p $P1O1R1T $THE1R1E1QUSE1R@${BRAHMA_IPS[0]} "docker service ps $STACKNAME""_portainer --filter 'desired-state=running' --format '{{.Node}} {{.CurrentState}}' | grep 'Running' | sort -k2 -r | head -n 1 | awk '{print \$1}'")

echo "Docker Swarm setup completed successfully.Ports List ${PORTSLIST[@]}.URL : https://$PortainerGUI:$PortainerSPort"

simulate_first_login() {
    echo "camehere1"
    TOKEN=$(curl -k -s -X POST "$PORTAINER_URL/auth" \
    -H "Content-Type: application/json" \
    --data "{\"Username\": \"$USERNAME\", \"Password\": \"$ADMIN_PASSWORD\"}" | jq -r '.jwt')
    echo "camehere2 $TOKEN"
    if [ -z "$TOKEN" ]; then
    curl -k -s -X GET "$PORTAINER_URL/endpoints" \
        -H "Content-Type: application/json" \
        --header "Authorization: Bearer $TOKEN"
    fi
}
is_environment_ready() {
	echo "camehere3"
	TOKEN=$(curl -k -s -X POST "$PORTAINER_URL/auth" \
    -H "Content-Type: application/json" \
    --data "{\"Username\": \"$USERNAME\", \"Password\": \"$ADMIN_PASSWORD\"}" | jq -r '.jwt') 
    echo "camehere4 $TOKEN"   
	ENV_ID=$(curl -k -s -X GET "$PORTAINER_URL/endpoints" \
        -H "Content-Type: application/json" \
        --header "Authorization: Bearer $TOKEN" | jq -r '.[] | select(.Name=="local").Id')  
        echo "camehere5 $ENV_ID" 
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
    sudo mv $THENOHUPFILE $BASE/Output/Logs/$REQUNQ-VAMANA-$STACKPRETTYNAME.out
    exit 1
fi
rename_environment

sudo mv $THENOHUPFILE $BASE/Output/Logs/$REQUNQ-VAMANA-$STACKPRETTYNAME.out
fi

sudo rm -rf /home/$CURRENTUSER/.ssh/known_hosts
sudo rm -rf /root/.ssh/known_hosts
sudo rm -rf /root/.bash_history
sudo rm -rf /home/$CURRENTUSER/.bash_history

#https://github.com/portainer/portainer/issues/523
#https://github.com/portainer/portainer/issues/1205
#https://www.portainer.io/blog/monitoring-a-swarm-cluster-with-prometheus-and-grafana
#https://portainer-notes.readthedocs.io/en/latest/deployment.html

