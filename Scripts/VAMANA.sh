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

function GetNewPort {
    local FreshPort=$($BASE/Scripts/GetRandomPort.sh)
    if printf '%s\0' "${PORTSLIST[@]}" | grep -Fxqz -- $FreshPort; then
    	GetNewPort
    fi
    echo $FreshPort
}
function GetNewPortRange {
    local FreshPortRange=$($BASE/Scripts/GetRandomPortRange.sh $THEGRPR1 $THEGRPR2)
    if printf '%s\0' "${PORTSLIST[@]}" | grep -Fxqz -- $FreshPortRange; then
    	GetNewPortRange
    fi
    echo $FreshPortRange
}

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

#if [ "$THECHOICE" == "CORE" ] ; then
set_NativeApps_details() {
if [[ "$NativeApps" == "NA" ]]; then
    echo "Default Cluster Memory Cores Mapping For NativeApps"
    V_A_MC_MAP_BUCKET="${CLUSTER_MEMORYCORES_MAPPING["BUCKET"]}"
    V_A_MC_MAP_CLOUDCOMMANDER="${CLUSTER_MEMORYCORES_MAPPING["CLOUDCOMMANDER"]}"
    V_A_MC_MAP_PVTCLD="${CLUSTER_MEMORYCORES_MAPPING["PVTCLD"]}"
    V_A_MC_MAP_CHITRAGUPTA1="${CLUSTER_MEMORYCORES_MAPPING["CHITRAGUPTA1"]}"
    V_A_MC_MAP_CHITRAGUPTA2="${CLUSTER_MEMORYCORES_MAPPING["CHITRAGUPTA2"]}"
    V_A_MC_MAP_CHITRAGUPTA3="${CLUSTER_MEMORYCORES_MAPPING["CHITRAGUPTA3"]}"
    V_A_MC_MAP_CHITRAGUPTA4="${CLUSTER_MEMORYCORES_MAPPING["CHITRAGUPTA4"]}"
    V_A_MC_MAP_CHITRAGUPTA5="${CLUSTER_MEMORYCORES_MAPPING["CHITRAGUPTA5"]}"
    V_A_MC_MAP_CHITRAGUPTA6="${CLUSTER_MEMORYCORES_MAPPING["CHITRAGUPTA6"]}"
    V_A_MC_MAP_CHITRAGUPTA7="${CLUSTER_MEMORYCORES_MAPPING["CHITRAGUPTA7"]}"
    V_A_MC_MAP_CHITRAGUPTA8="${CLUSTER_MEMORYCORES_MAPPING["CHITRAGUPTA8"]}"
    V_A_MC_MAP_CHITRAGUPTA9="${CLUSTER_MEMORYCORES_MAPPING["CHITRAGUPTA9"]}"
    V_A_MC_MAP_CHITRAGUPTA10="${CLUSTER_MEMORYCORES_MAPPING["CHITRAGUPTA10"]}"
    V_A_MC_MAP_CHITRAGUPTA11="${CLUSTER_MEMORYCORES_MAPPING["CHITRAGUPTA11"]}"
    V_A_MC_MAP_EFK1="${CLUSTER_MEMORYCORES_MAPPING["EFK1"]}"
    V_A_MC_MAP_EFK2="${CLUSTER_MEMORYCORES_MAPPING["EFK2"]}"
    V_A_MC_MAP_EFK3="${CLUSTER_MEMORYCORES_MAPPING["EFK3"]}"
else
    NativeApps=$(echo "$NativeApps" | xxd -p -r)
    echo "THE VALUE OF NativeAppsDEC : $NativeApps"    
    while read -r info; do
        Name=$(echo "$info" | jq -r '.Name')
        Memory=$(echo "$info" | jq -r '.Memory')
        Cores=$(echo "$info" | jq -r '.Cores')        
        echo "Processing $Name with Memory: $Memory and Cores: $Cores"
        case "$Name" in
            "Minio")
                V_A_MC_MAP_BUCKET="$Memory:$Cores"
                echo "1 $V_A_MC_MAP_BUCKET"
                ;;
            "CloudCommander")
                V_A_MC_MAP_CLOUDCOMMANDER="$Memory:$Cores"
                echo "2 $V_A_MC_MAP_CLOUDCOMMANDER"
                ;;
            "Nextcloud")
                V_A_MC_MAP_PVTCLD="$Memory:$Cores"
                echo "3 $V_A_MC_MAP_PVTCLD"
                ;;
            "Guacamole")
                V_A_MC_MAP_CHITRAGUPTA1="$Memory:$Cores"
                echo "4 $V_A_MC_MAP_CHITRAGUPTA1"
                ;;
            "GuacamoleD")
                V_A_MC_MAP_CHITRAGUPTA2="$Memory:$Cores"
                echo "5 $V_A_MC_MAP_CHITRAGUPTA2"
                ;;
            "MySQL")
                V_A_MC_MAP_CHITRAGUPTA3="$Memory:$Cores"
                echo "6 $V_A_MC_MAP_CHITRAGUPTA3"
                ;;
            "phpMyAdmin")
                V_A_MC_MAP_CHITRAGUPTA4="$Memory:$Cores"
                echo "7 $V_A_MC_MAP_CHITRAGUPTA4"
                ;;
            "Prometheus")
                V_A_MC_MAP_CHITRAGUPTA5="$Memory:$Cores"
                echo "8 $V_A_MC_MAP_CHITRAGUPTA5"
                ;;
            "CAdvisor")
                V_A_MC_MAP_CHITRAGUPTA6="$Memory:$Cores"
                echo "9 $V_A_MC_MAP_CHITRAGUPTA6"
                ;;
            "Grafana")
                V_A_MC_MAP_CHITRAGUPTA7="$Memory:$Cores"
                echo "10 $V_A_MC_MAP_CHITRAGUPTA7"
                ;;
            "NodeExporter")
                V_A_MC_MAP_CHITRAGUPTA8="$Memory:$Cores"
                echo "11 $V_A_MC_MAP_CHITRAGUPTA8"
                ;;
            "OpenLDAP")
                V_A_MC_MAP_CHITRAGUPTA9="$Memory:$Cores"
                echo "12 $V_A_MC_MAP_CHITRAGUPTA9"
                ;;
            "phpLDAPadmin")
                V_A_MC_MAP_CHITRAGUPTA10="$Memory:$Cores"
                echo "13 $V_A_MC_MAP_CHITRAGUPTA10"
                ;;
            "Kerberos")
                V_A_MC_MAP_CHITRAGUPTA11="$Memory:$Cores"
                echo "14 $V_A_MC_MAP_CHITRAGUPTA11"
                ;;
            "ElasticSearch")
                V_A_MC_MAP_EFK1="$Memory:$Cores"
                echo "15 $V_A_MC_MAP_EFK1"
                ;;
            "Kibana")
                V_A_MC_MAP_EFK2="$Memory:$Cores"
                echo "16 $V_A_MC_MAP_EFK2"
                ;;
            "Filebeat")
                V_A_MC_MAP_EFK3="$Memory:$Cores"
                echo "17 $V_A_MC_MAP_EFK3"
                ;;
            *)
                echo "Unknown application: $Name"
                ;;
        esac
    done < <(echo "$NativeApps" | jq -c '.[] | .Info')
    #echo "V_A_MC_MAP_BUCKET $V_A_MC_MAP_BUCKET: V_A_MC_MAP_CLOUDCOMMANDER $V_A_MC_MAP_CLOUDCOMMANDER: V_A_MC_MAP_PVTCLD $V_A_MC_MAP_PVTCLD: V_A_MC_MAP_CHITRAGUPTA1 $V_A_MC_MAP_CHITRAGUPTA1: V_A_MC_MAP_CHITRAGUPTA2 $V_A_MC_MAP_CHITRAGUPTA2: V_A_MC_MAP_CHITRAGUPTA3 $V_A_MC_MAP_CHITRAGUPTA3: V_A_MC_MAP_CHITRAGUPTA4 $V_A_MC_MAP_CHITRAGUPTA4: V_A_MC_MAP_CHITRAGUPTA5 $V_A_MC_MAP_CHITRAGUPTA5: V_A_MC_MAP_CHITRAGUPTA6 $V_A_MC_MAP_CHITRAGUPTA6: V_A_MC_MAP_CHITRAGUPTA7 $V_A_MC_MAP_CHITRAGUPTA7: V_A_MC_MAP_CHITRAGUPTA8 $V_A_MC_MAP_CHITRAGUPTA8: V_A_MC_MAP_CHITRAGUPTA9 $V_A_MC_MAP_CHITRAGUPTA9: V_A_MC_MAP_CHITRAGUPTA10 $V_A_MC_MAP_CHITRAGUPTA10: V_A_MC_MAP_CHITRAGUPTA11 $V_A_MC_MAP_CHITRAGUPTA11: V_A_MC_MAP_EFK1 $V_A_MC_MAP_EFK1: V_A_MC_MAP_EFK2 $V_A_MC_MAP_EFK2: V_A_MC_MAP_EFK3 $V_A_MC_MAP_EFK3"    
fi
#echo "V_A_MC_MAP_BUCKET $V_A_MC_MAP_BUCKET: V_A_MC_MAP_CLOUDCOMMANDER $V_A_MC_MAP_CLOUDCOMMANDER: V_A_MC_MAP_PVTCLD $V_A_MC_MAP_PVTCLD: V_A_MC_MAP_CHITRAGUPTA1 $V_A_MC_MAP_CHITRAGUPTA1: V_A_MC_MAP_CHITRAGUPTA2 $V_A_MC_MAP_CHITRAGUPTA2: V_A_MC_MAP_CHITRAGUPTA3 $V_A_MC_MAP_CHITRAGUPTA3: V_A_MC_MAP_CHITRAGUPTA4 $V_A_MC_MAP_CHITRAGUPTA4: V_A_MC_MAP_CHITRAGUPTA5 $V_A_MC_MAP_CHITRAGUPTA5: V_A_MC_MAP_CHITRAGUPTA6 $V_A_MC_MAP_CHITRAGUPTA6: V_A_MC_MAP_CHITRAGUPTA7 $V_A_MC_MAP_CHITRAGUPTA7: V_A_MC_MAP_CHITRAGUPTA8 $V_A_MC_MAP_CHITRAGUPTA8: V_A_MC_MAP_CHITRAGUPTA9 $V_A_MC_MAP_CHITRAGUPTA9: V_A_MC_MAP_CHITRAGUPTA10 $V_A_MC_MAP_CHITRAGUPTA10: V_A_MC_MAP_CHITRAGUPTA11 $V_A_MC_MAP_CHITRAGUPTA11: V_A_MC_MAP_EFK1 $V_A_MC_MAP_EFK1: V_A_MC_MAP_EFK2 $V_A_MC_MAP_EFK2: V_A_MC_MAP_EFK3 $V_A_MC_MAP_EFK3"
}

function SetAllPorts {
if [[ "$THECLUSTERISMULTICLOUD" == "Y" ]]; then
	#IFS=',' read -r -a I_P_R <<< $CLOUD_INTERNAL_PORT_RANGE
	#THEGRPR1="$THE3GRPR3"
	#THEGRPR2="$THE4GRPR4"
	IFS=',' read -r -a I_P_R <<< $INTERNAL_PORT_RANGE
	echo "THECLUSTERISMULTICLOUD"	
else
	IFS=',' read -r -a I_P_R <<< $INTERNAL_PORT_RANGE
fi
IFS=',' read -r -a E_P_R <<< $EXTERNAL_PORT_RANGE
IFS=',' read -r -a A_P_R <<< $ALTERNATE_PORT_RANGE

# INTERNAL PORTS
VarahaPort1=$([ "$AutoPorts" = "N" ] && echo "${I_P_R[1]}" || GetNewPortRange) && PORTSLIST+=("$VarahaPort1") #1
ChitraGuptaPort1=$([ "$AutoPorts" = "N" ] && echo "${I_P_R[2]}" || GetNewPortRange) && PORTSLIST+=("$ChitraGuptaPort1") #2
ChitraGuptaPort2=$([ "$AutoPorts" = "N" ] && echo "${I_P_R[3]}" || GetNewPortRange) && PORTSLIST+=("$ChitraGuptaPort2") #3
ChitraGuptaPort3=$([ "$AutoPorts" = "N" ] && echo "${I_P_R[4]}" || GetNewPortRange) && PORTSLIST+=("$ChitraGuptaPort3") #4
ChitraGuptaPort4=$([ "$AutoPorts" = "N" ] && echo "${I_P_R[5]}" || GetNewPortRange) && PORTSLIST+=("$ChitraGuptaPort4") #5
ChitraGuptaPort8=$([ "$AutoPorts" = "N" ] && echo "${I_P_R[6]}" || GetNewPortRange) && PORTSLIST+=("$ChitraGuptaPort8") #6
ChitraGuptaPortU1=$([ "$AutoPorts" = "N" ] && echo "${I_P_R[7]}" || GetNewPortRange) && PORTSLIST+=("$ChitraGuptaPortU1") #7
ChitraGuptaPortV1=$([ "$AutoPorts" = "N" ] && echo "${I_P_R[8]}" || GetNewPortRange) && PORTSLIST+=("$ChitraGuptaPortV1") #8
ChitraGuptaPortW1=$([ "$AutoPorts" = "N" ] && echo "${I_P_R[9]}" || GetNewPortRange) && PORTSLIST+=("$ChitraGuptaPortW1") #9
ChitraGuptaPortLDP1=$([ "$AutoPorts" = "N" ] && echo "${I_P_R[10]}" || GetNewPortRange) && PORTSLIST+=("$ChitraGuptaPortLDP1") #10
ChitraGuptaPortLDP2=$([ "$AutoPorts" = "N" ] && echo "${I_P_R[11]}" || GetNewPortRange) && PORTSLIST+=("$ChitraGuptaPortLDP2") #11
ChitraGuptaPortLDP3=$([ "$AutoPorts" = "N" ] && echo "${I_P_R[12]}" || GetNewPortRange) && PORTSLIST+=("$ChitraGuptaPortLDP3") #12
ChitraGuptaPortKERB1=$([ "$AutoPorts" = "N" ] && echo "${I_P_R[13]}" || GetNewPortRange) && PORTSLIST+=("$ChitraGuptaPortKERB1") #13
ChitraGuptaPortKERB2=$([ "$AutoPorts" = "N" ] && echo "${I_P_R[14]}" || GetNewPortRange) && PORTSLIST+=("$ChitraGuptaPortKERB2") #14
MINPortIO1=$([ "$AutoPorts" = "N" ] && echo "${I_P_R[15]}" || GetNewPortRange) && PORTSLIST+=("$MINPortIO1") #15
MINPortIO2=$([ "$AutoPorts" = "N" ] && echo "${I_P_R[16]}" || GetNewPortRange) && PORTSLIST+=("$MINPortIO2") #16
FLBRPortIO1=$([ "$AutoPorts" = "N" ] && echo "${I_P_R[17]}" || GetNewPortRange) && PORTSLIST+=("$FLBRPortIO1") #17
PVTCLDPortIO1=$([ "$AutoPorts" = "N" ] && echo "${I_P_R[18]}" || GetNewPortRange) && PORTSLIST+=("$PVTCLDPortIO1") #18
EFKPort1=$([ "$AutoPorts" = "N" ] && echo "${I_P_R[19]}" || GetNewPortRange) && PORTSLIST+=("$EFKPort1") #19
EFKPort2=$([ "$AutoPorts" = "N" ] && echo "${I_P_R[20]}" || GetNewPortRange) && PORTSLIST+=("$EFKPort2") #20
if [[ "$THECLUSTERISMULTICLOUD" == "Y" ]]; then
	THEIPTO="$VarahaPort1,$ChitraGuptaPort1,$ChitraGuptaPort2,$ChitraGuptaPort3,$ChitraGuptaPort4,$ChitraGuptaPort8,$ChitraGuptaPortU1,$ChitraGuptaPortV1,$ChitraGuptaPortW1,$ChitraGuptaPortLDP1,$ChitraGuptaPortLDP2,$ChitraGuptaPortLDP3,$ChitraGuptaPortKERB1,$ChitraGuptaPortKERB2,$MINPortIO1,$MINPortIO2,$FLBRPortIO1,$PVTCLDPortIO1,$EFKPort1,$EFKPort2"
    echo "1) VarahaPort1:$VarahaPort1,2) ChitraGuptaPort1:$ChitraGuptaPort1,3) ChitraGuptaPort2:$ChitraGuptaPort2,4) ChitraGuptaPort3:$ChitraGuptaPort3,5) ChitraGuptaPort4:$ChitraGuptaPort4,6) ChitraGuptaPort8:$ChitraGuptaPort8,7) ChitraGuptaPortU1:$ChitraGuptaPortU1,8) ChitraGuptaPortV1:$ChitraGuptaPortV1,9) ChitraGuptaPortW1:$ChitraGuptaPortW1,10) ChitraGuptaPortLDP1:$ChitraGuptaPortLDP1,11) ChitraGuptaPortLDP2:$ChitraGuptaPortLDP2,12) ChitraGuptaPortLDP3:$ChitraGuptaPortLDP3,13) ChitraGuptaPortKERB1:$ChitraGuptaPortKERB1,14) ChitraGuptaPortKERB2:$ChitraGuptaPortKERB2,15) MINPortIO1:$MINPortIO1,16) MINPortIO2:$MINPortIO2,17) FLBRPortIO1:$FLBRPortIO1,18) PVTCLDPortIO1:$PVTCLDPortIO1,19) EFKPort1:$EFKPort1,20) EFKPort2:$EFKPort2"
fi

# EXTERNAL PORTS
PortainerAPort=$([ "$AutoPorts" = "N" ] && echo "${E_P_R[1]}" || GetNewPort) && PORTSLIST+=("$PortainerAPort") #21 #1
PortainerSPort=$([ "$AutoPorts" = "N" ] && echo "${E_P_R[2]}" || GetNewPort) && PORTSLIST+=("$PortainerSPort") #22 #2
VarahaPort2=$([ "$AutoPorts" = "N" ] && echo "${E_P_R[3]}" || GetNewPort) && PORTSLIST+=("$VarahaPort2") #23 #3
VarahaPort3=$([ "$AutoPorts" = "N" ] && echo "${E_P_R[4]}" || GetNewPort) && PORTSLIST+=("$VarahaPort3") #24 #4
VarahaPort4=$([ "$AutoPorts" = "N" ] && echo "${E_P_R[5]}" || GetNewPort) && PORTSLIST+=("$VarahaPort4") #25 #5
BDDPort1=$([ "$AutoPorts" = "N" ] && echo "${E_P_R[6]}" || GetNewPort) && PORTSLIST+=("$BDDPort1") #26 #6
BDDPort2=$([ "$AutoPorts" = "N" ] && echo "${E_P_R[7]}" || GetNewPort) && PORTSLIST+=("$BDDPort2") #27 #7
WEBSSHPort1=$([ "$AutoPorts" = "N" ] && echo "${E_P_R[8]}" || GetNewPort) && PORTSLIST+=("$WEBSSHPort1") #28 #8
ChitraGuptaPort5=$([ "$AutoPorts" = "N" ] && echo "${E_P_R[9]}" || GetNewPort) && PORTSLIST+=("$ChitraGuptaPort5") #29 #9
ChitraGuptaPort6=$([ "$AutoPorts" = "N" ] && echo "${E_P_R[10]}" || GetNewPort) && PORTSLIST+=("$ChitraGuptaPort6") #30 #10
ChitraGuptaPort7=$([ "$AutoPorts" = "N" ] && echo "${E_P_R[11]}" || GetNewPort) && PORTSLIST+=("$ChitraGuptaPort7") #31 #11
ChitraGuptaPortY1=$([ "$AutoPorts" = "N" ] && echo "${E_P_R[12]}" || GetNewPort) && PORTSLIST+=("$ChitraGuptaPortY1") #32 #12
ChitraGuptaPortZ1=$([ "$AutoPorts" = "N" ] && echo "${E_P_R[13]}" || GetNewPort) && PORTSLIST+=("$ChitraGuptaPortZ1") #33 #13
ChitraGuptaPortLDP4=$([ "$AutoPorts" = "N" ] && echo "${E_P_R[14]}" || GetNewPort) && PORTSLIST+=("$ChitraGuptaPortLDP4") #34 #14
ChitraGuptaPortLDP5=$([ "$AutoPorts" = "N" ] && echo "${E_P_R[15]}" || GetNewPort) && PORTSLIST+=("$ChitraGuptaPortLDP5") #35 #15
ChitraGuptaPortKERB3=$([ "$AutoPorts" = "N" ] && echo "${E_P_R[16]}" || GetNewPort) && PORTSLIST+=("$ChitraGuptaPortKERB3") #36 #16
ChitraGuptaPortKERB4=$([ "$AutoPorts" = "N" ] && echo "${E_P_R[17]}" || GetNewPort) && PORTSLIST+=("$ChitraGuptaPortKERB4") #37 #17
MINPortIO3=$([ "$AutoPorts" = "N" ] && echo "${E_P_R[18]}" || GetNewPort) && PORTSLIST+=("$MINPortIO3") #38 #18
MINPortIO4=$([ "$AutoPorts" = "N" ] && echo "${E_P_R[19]}" || GetNewPort) && PORTSLIST+=("$MINPortIO4") #39 #19
FLBRPortIO2=$([ "$AutoPorts" = "N" ] && echo "${E_P_R[20]}" || GetNewPort) && PORTSLIST+=("$FLBRPortIO2") #40 #20
PVTCLDPortIO2=$([ "$AutoPorts" = "N" ] && echo "${E_P_R[21]}" || GetNewPort) && PORTSLIST+=("$PVTCLDPortIO2") #41 #21
EFKPort3=$([ "$AutoPorts" = "N" ] && echo "${E_P_R[22]}" || GetNewPort) && PORTSLIST+=("$EFKPort3") #42 #22
EFKPort4=$([ "$AutoPorts" = "N" ] && echo "${E_P_R[23]}" || GetNewPort) && PORTSLIST+=("$EFKPort4") #43 #23

# HA EXTERNAL PORTS
AltIndrhaprt1=$([ "$AutoPorts" = "N" ] && echo "${A_P_R[1]}" || GetNewPort) && PORTSLIST+=("$AltIndrhaprt1") && ALT_INDR_HA_PRT="$AltIndrhaprt1" #44 #24 #1
AltIndrhaprt2=$([ "$AutoPorts" = "N" ] && echo "${A_P_R[2]}" || GetNewPort) && PORTSLIST+=("$AltIndrhaprt2") && ALT_INDR_HA_PRT="$ALT_INDR_HA_PRT"",""$AltIndrhaprt2" #45 #25 #2
AltIndrhaprt3=$([ "$AutoPorts" = "N" ] && echo "${A_P_R[3]}" || GetNewPort) && PORTSLIST+=("$AltIndrhaprt3") && ALT_INDR_HA_PRT="$ALT_INDR_HA_PRT"",""$AltIndrhaprt3" #46 #26 #3
AltIndrhaprt4=$([ "$AutoPorts" = "N" ] && echo "${A_P_R[4]}" || GetNewPort) && PORTSLIST+=("$AltIndrhaprt4") && ALT_INDR_HA_PRT="$ALT_INDR_HA_PRT"",""$AltIndrhaprt4" #47 #27 #4
AltIndrhaprt5=$([ "$AutoPorts" = "N" ] && echo "${A_P_R[5]}" || GetNewPort) && PORTSLIST+=("$AltIndrhaprt5") && ALT_INDR_HA_PRT="$ALT_INDR_HA_PRT"",""$AltIndrhaprt5" #48 #28 #5
AltIndrhaprt6=$([ "$AutoPorts" = "N" ] && echo "${A_P_R[6]}" || GetNewPort) && PORTSLIST+=("$AltIndrhaprt6") && ALT_INDR_HA_PRT="$ALT_INDR_HA_PRT"",""$AltIndrhaprt6" #49 #29 #6
AltIndrhaprt7=$([ "$AutoPorts" = "N" ] && echo "${A_P_R[7]}" || GetNewPort) && PORTSLIST+=("$AltIndrhaprt7") && ALT_INDR_HA_PRT="$ALT_INDR_HA_PRT"",""$AltIndrhaprt7" #50 #30 #7
AltIndrhaprt8=$([ "$AutoPorts" = "N" ] && echo "${A_P_R[8]}" || GetNewPort) && PORTSLIST+=("$AltIndrhaprt8") && ALT_INDR_HA_PRT="$ALT_INDR_HA_PRT"",""$AltIndrhaprt8" #51 #31 #8
AltIndrhaprt9=$([ "$AutoPorts" = "N" ] && echo "${A_P_R[9]}" || GetNewPort) && PORTSLIST+=("$AltIndrhaprt9") && ALT_INDR_HA_PRT="$ALT_INDR_HA_PRT"",""$AltIndrhaprt9" #52 #32 #9
AltIndrhaprt10=$([ "$AutoPorts" = "N" ] && echo "${A_P_R[10]}" || GetNewPort) && PORTSLIST+=("$AltIndrhaprt10") && ALT_INDR_HA_PRT="$ALT_INDR_HA_PRT"",""$AltIndrhaprt10" #53 #33 #10
AltIndrhaprt11=$([ "$AutoPorts" = "N" ] && echo "${A_P_R[11]}" || GetNewPort) && PORTSLIST+=("$AltIndrhaprt11") && ALT_INDR_HA_PRT="$ALT_INDR_HA_PRT"",""$AltIndrhaprt11" #54 #34 #11
AltIndrhaprt12=$([ "$AutoPorts" = "N" ] && echo "${A_P_R[12]}" || GetNewPort) && PORTSLIST+=("$AltIndrhaprt12") && ALT_INDR_HA_PRT="$ALT_INDR_HA_PRT"",""$AltIndrhaprt12" #55 #35 #12
AltIndrhaprt13=$([ "$AutoPorts" = "N" ] && echo "${A_P_R[13]}" || GetNewPort) && PORTSLIST+=("$AltIndrhaprt13") && ALT_INDR_HA_PRT="$ALT_INDR_HA_PRT"",""$AltIndrhaprt13" #56 #36 #13
AltIndrhaprt14=$([ "$AutoPorts" = "N" ] && echo "${A_P_R[14]}" || GetNewPort) && PORTSLIST+=("$AltIndrhaprt14") && ALT_INDR_HA_PRT="$ALT_INDR_HA_PRT"",""$AltIndrhaprt14" #57 #37 #14
AltIndrhaprt15=$([ "$AutoPorts" = "N" ] && echo "${A_P_R[15]}" || GetNewPort) && PORTSLIST+=("$AltIndrhaprt15") && ALT_INDR_HA_PRT="$ALT_INDR_HA_PRT"",""$AltIndrhaprt15" #58 #38 #15
AltIndrhaprt16=$([ "$AutoPorts" = "N" ] && echo "${A_P_R[16]}" || GetNewPort) && PORTSLIST+=("$AltIndrhaprt16") && ALT_INDR_HA_PRT="$ALT_INDR_HA_PRT"",""$AltIndrhaprt16" #59 #39 #16
AltIndrhaprt17=$([ "$AutoPorts" = "N" ] && echo "${A_P_R[17]}" || GetNewPort) && PORTSLIST+=("$AltIndrhaprt17") && ALT_INDR_HA_PRT="$ALT_INDR_HA_PRT"",""$AltIndrhaprt17" #60 #40 #17
AltIndrhaprt18=$([ "$AutoPorts" = "N" ] && echo "${A_P_R[18]}" || GetNewPort) && PORTSLIST+=("$AltIndrhaprt18") && ALT_INDR_HA_PRT="$ALT_INDR_HA_PRT"",""$AltIndrhaprt18" #61 #41 #18
AltIndrhaprt19=$([ "$AutoPorts" = "N" ] && echo "${A_P_R[19]}" || GetNewPort) && PORTSLIST+=("$AltIndrhaprt19") && ALT_INDR_HA_PRT="$ALT_INDR_HA_PRT"",""$AltIndrhaprt19" #62 #42 #19

echo "All Ports SET."
}

# Function to prepare swarm dynamically
create_instance_details() {
    input_file="$1"
    output_file="$2"
    thereqmode="$3"
    
    # Read the file into an array
    mapfile -t lines < "$input_file"
    
    # Create an array to track which lines have been updated
    declare -A updated_lines

    manager_count=0
    worker_count=0
    router_count=0
    
    if [ "$THENATUREOFTHISRUN" == "FIRSTRUN" ] ; then    
	    # Check if the number of lines is less than 3
	    if [ ${#lines[@]} -lt 3 ]; then
		echo "Swarm setup not possible. Minimum 3 rows required."
		exit 1
	    fi

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
		    elif [ $router_count -lt 2 ]; then
		        updated_lines[$i]="INDRA"
		        router_count=$((router_count + 1))                
		    else
		        updated_lines[$i]="VISHVAKARMA"
		        worker_count=$((worker_count + 1))
		    fi
		fi
	    done
    fi
    
    # Process each line
    for i in "${!lines[@]}"; do
        line="${lines[$i]}"
        echo "THE LINE : $line"
        IFS=',' read -ra columns <<< "$line"
        
        uppercase_text=$(echo "${columns[8]}" | tr '[:lower:]' '[:upper:]')
        columns[8]="$uppercase_text"
        
        if [ "$uppercase_text" == "CSMP" ]; then
        	#SCPID INSTID IP HOSTNAME PORT PEM OS U1SER C1TYPE ROLE M1EM C1ORE
        	THE1REQ1PORT="${columns[4]}"
        	echo "THE1REQ1PORT : $THE1REQ1PORT"
		NEW_USER=""
		NEW_PASSWORD=""
		SSH_USER=""
		SSH__PASSWORD=""        	
        	if [ "${columns[5]}" == "NA" ]; then
        		IFS='├' read -r -a columns_7 <<< "${columns[7]}"
        		SSH_USER="${columns_7[0]}"
        		SSH__PASSWORD="${columns_7[1]}"
			NEW_USER=$(cat /dev/urandom | tr -dc 'a-z' | fold -w 10 | head -n 1)
			NEW_USER="u""$NEW_USER"
			NEW_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1) 
			NEW_PEM_NAME=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)       		
        		$BASE/Scripts/PrepCSMP.sh "$NEW_USER├$NEW_PASSWORD├$SSH_USER├NA├$SSH__PASSWORD├""${columns[2]}""├$BASE/Output/Pem/$NEW_PEM_NAME.pem├$THE1REQ1PORT"
			columns[4]="$THE1REQ1PORT"
			columns[5]="$BASE/Output/Pem/$NEW_PEM_NAME.pem"
			columns[7]="$NEW_USER"        		
        	else
        		$BASE/Scripts/PrepCSMP.sh "├├""${columns[7]}""├""${columns[5]}""├├""${columns[2]}""├├$THE1REQ1PORT" 
        	fi		       		
        else
		if [ "$PREP_ONLY" == "N" ]; then
			columns4=$(NARASIMHA "decrypt" "${columns[4]}" "$VISION_KEY")
			columns5=$(NARASIMHA "decrypt" "${columns[5]}" "$VISION_KEY")
			columns7=$(NARASIMHA "decrypt" "${columns[7]}" "$VISION_KEY")
			columns[4]="$columns4"
			columns[5]="$columns5"
			columns[7]="$columns7"
		fi
        fi
        
        if [ "$THENATUREOFTHISRUN" == "FIRSTRUN" ] ; then
		if [[ "$thereqmode" == "Y" ]]; then
		    if [[ "${updated_lines[$i]}" == "BRAHMA" ]]; then
		        columns[9]="BRAHMA"
		        columns[10]="2048"
		        columns[11]="2"
		    elif [[ "${updated_lines[$i]}" == "INDRA" ]]; then
		        columns[9]="INDRA"
		        columns[10]="2048"
		        columns[11]="2"
		    else
		        columns[9]="VISHVAKARMA"
		        columns[10]="512"
		        columns[11]="0.5"
		    fi
		fi
	else
	        columns[9]="VISHVAKARMA"
	        columns[10]="512"
	        columns[11]="0.5"		
        fi      
        
        # Reconstruct the line
        lines[$i]=$(IFS=','; echo "${columns[*]}")
    done

    # Write the updated lines to the output file
    printf "%s\n" "${lines[@]}" > "$output_file"
    echo "Updated file saved as $output_file"
    cat $output_file
}

PORTSLIST=()
THEGRPR1="$THE1GRPR1"
THEGRPR2="$THE2GRPR2"

THECLUSTERISONLYE2E="N"
THECLUSTERISMULTICLOUD="N"
THEIPTO=""
THEINDRA1=""
THEINDRA2=""

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
PREP_ONLY="${THE_ARGS[10]}"
AutoPorts="${THE_ARGS[12]}"
TheNameOfVision="${THE_ARGS[13]}"
THENAMEOFTHELOGFOLDER="${THE_ARGS[14]}"
RND1M_="${THE_ARGS[15]}"
TheClusterFolderForThisRUN="${THE_ARGS[16]}"
NativeApps="${THE_ARGS[17]}"

THENAMEOFTHEMLOGFOLDER="$BASE/Output/Logs/MATSYA/$TheNameOfVision/$REQUNQ"
TheFinalMessageFile="$THENAMEOFTHELOGFOLDER/VAMANA-SUCCESS"

HASHED_PASSWORD=$(python3 -c "from bcrypt import hashpw, gensalt; print(hashpw(b'$ADMIN_PASSWORD', gensalt()).decode())")
ALT_INDR_HA_PRT=""

if [[ "$ISAUTOMATED" == "Y" ]]; then
	terminator -e "bash -c 'tail -f $THENOHUPFILE; exec bash'"
fi
	
SEARCH_DIR="$BASE/tmp/"
SEARCH2_DIR="$BASE/Output/Logs/"
PATTERN="${REQUNQ}*CIE.out"
while true; do
    if ls ${SEARCH_DIR}${PATTERN} 1> /dev/null 2>&1; then
        echo "Terraform Completion in Progress..."
        ls -l ${SEARCH_DIR}${PATTERN}
        sleep 5
    else
        echo "Terraform Completed. Proceeding..."
        sleep 5
        break
    fi
done
sudo mv ${SEARCH2_DIR}${PATTERN} $THENAMEOFTHEMLOGFOLDER
rename 's/'"$REQUNQ"'-//' $THENAMEOFTHEMLOGFOLDER/$REQUNQ-*

STACKNAME="v""$THEVISIONID""c""$CLUSTERID"
UNLOCKFILEPATH="$TheClusterFolderForThisRUN/$STACKNAME.dsuk"
MJTFILEPATH="$TheClusterFolderForThisRUN/$STACKNAME.dsmjt"
WJTFILEPATH="$TheClusterFolderForThisRUN/$STACKNAME.dswjt"
RODFILEPATH="$TheClusterFolderForThisRUN/$STACKNAME.dsrod"
GLUSTERVPATH1="$TheClusterFolderForThisRUN/$STACKNAME.gvp1"
GLUSTERVPATH2="$TheClusterFolderForThisRUN/$STACKNAME.gvp2"
GLUSTERVPATH3="$TheClusterFolderForThisRUN/$STACKNAME.gvp3"
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
declare -a EXISTING_IPS
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
if [[ "$ISAUTOMATED" == "Y" ]]; then
	CHITRAGUPTA=""
else
	CHITRAGUPTA="${THE_ARGS[11]}"
fi
THE_PVT_CLD=""
CHITRAGUPTA_DET=""
CHITRAGUPTA1_DET=""
CGDTD="N"
MIN_IO_DET=""

THENATUREOFTHISRUN="RECURRING"
THEEXISTINGRUNWASVPNBASED="N"
THEEXISTINGCLUSTERBRAHMA="NA"
THEEXISTINGCLUSTERINDRA="NA"
if [[ ! -d "$TheClusterFolderForThisRUN/CERTS" ]]; then
	THENATUREOFTHISRUN="FIRSTRUN"
else
	TheExistingDetFile="$TheClusterFolderForThisRUN/$STACKNAME.normal"
	if [ ! -f $TheExistingDetFile ]; then
		TheExistingDetFile="$TheClusterFolderForThisRUN/Nodes$STACKNAME.vpn"
		THEEXISTINGRUNWASVPNBASED="Y"
	fi
	TMP_RNDM_FL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)	
	$BASE/Scripts/SecretsFile-Decrypter "$TheExistingDetFile├1├1├$BASE/tmp/$TMP_RNDM_FL├$ADMIN_PASSWORD"
	sudo chmod 777 $BASE/tmp/$TMP_RNDM_FL	
	mapfile -t EXISTING_RUN_DETAILS < "$BASE/tmp/$TMP_RNDM_FL"
	echo "Cluster Existing Node Details..."
	COUNTebhER=0
	for E1R1D in "${!EXISTING_RUN_DETAILS[@]}"; do
		ER1D="${EXISTING_RUN_DETAILS[$E1R1D]}"
		echo "($E1R1D) : $ER1D"	
		IFS=',' read -r -a ER_1D <<< $ER1D
		ROLE_VAL1="${ER_1D[7]}"
			
		ER1_1D_VAL1="${ER_1D[0]}"		
		EXISTING_IPS+=("$ER1_1D_VAL1")
					
		if (( $COUNTebhER == 0 )) ; then
			if [[ "$ROLE_VAL1" == "BRAHMA" ]]; then
				THEEXISTINGCLUSTERBRAHMA="$ER1D"
				COUNTebhER=$((COUNTebhER + 1))
			fi
		fi
	done
	COUNTebhER=0 
	for E1R1D in "${!EXISTING_RUN_DETAILS[@]}"; do
		ER1D="${EXISTING_RUN_DETAILS[$E1R1D]}"	
		IFS=',' read -r -a ER_1D <<< $ER1D
		ROLE_VAL1="${ER_1D[7]}"		
		if (( $COUNTebhER == 0 )) ; then
			if [[ "$ROLE_VAL1" == "INDRA" ]]; then
				THEEXISTINGCLUSTERINDRA="$ER1D"
				COUNTebhER=$((COUNTebhER + 1))
			fi
		fi
	done
	COUNTebhER=0	       	
	sudo rm -f $BASE/tmp/$TMP_RNDM_FL
fi
echo "THE STATE OF THIS RUN FOR CLUSTER {$STACKPRETTYNAME} IS {$THENATUREOFTHISRUN}"

echo "THE VALUE OF NativeApps : $NativeApps"
V_A_MC_MAP_BUCKET="NA"
V_A_MC_MAP_CLOUDCOMMANDER="NA"
V_A_MC_MAP_PVTCLD="NA"
V_A_MC_MAP_CHITRAGUPTA1="NA"
V_A_MC_MAP_CHITRAGUPTA2="NA"
V_A_MC_MAP_CHITRAGUPTA3="NA"
V_A_MC_MAP_CHITRAGUPTA4="NA"
V_A_MC_MAP_CHITRAGUPTA5="NA"
V_A_MC_MAP_CHITRAGUPTA6="NA"
V_A_MC_MAP_CHITRAGUPTA7="NA"
V_A_MC_MAP_CHITRAGUPTA8="NA"
V_A_MC_MAP_CHITRAGUPTA9="NA"
V_A_MC_MAP_CHITRAGUPTA10="NA"
V_A_MC_MAP_CHITRAGUPTA11="NA"
V_A_MC_MAP_EFK1="NA"
V_A_MC_MAP_EFK2="NA"
V_A_MC_MAP_EFK3="NA"

if [[ "$ISAUTOMATED" == "Y" ]]; then
	#terminator -e "bash -c 'tail -f $THENOHUPFILE; exec bash'"
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
	if [ "$PREP_ONLY" == "Y" ]; then
        	echo "Swarm File Prep Done."
        	exit 1
	fi
else
	if [[ "$ISAUTOMATED" == "X" ]]; then
		echo "Swarm File Prep Done."
	else
		THE1SFTSTK2_FILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)	
		THE1SFTSTK1FILE="$BASE/tmp/Stack_$THE1SFTSTK2_FILE.csv"
		create_instance_details "$INSTANCE_DETAILS_FILE" "$THE1SFTSTK1FILE" "N"
		INSTANCE_DETAILS_FILE="$THE1SFTSTK1FILE"
	fi					
fi

THEGUACA_SQL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
THEGUACASQL="$BASE/tmp/THEGUACA_SQL_$THEGUACA_SQL.sql" && touch $THEGUACASQL && sudo chmod 777 $THEGUACASQL

if [ "$THENATUREOFTHISRUN" == "RECURRING" ] ; then
	echo "SET @entityid = (select entity_id from guacamole_entity where name = 'admin');" | sudo tee -a $THEGUACASQL > /dev/null
fi

# Function to parse the instance details file
parse_instance_details() {
    echo 'sudo -H -u root bash -c "echo \"\" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTESCRIPT > /dev/null
    echo 'sudo -H -u root bash -c "echo \"#VAMANA => '"$STACKPRETTYNAME"' '"$REQUNQ"' START \" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTESCRIPT > /dev/null 
    
    COUNTxER=0
    COUNTvER=0
    NACGD1="N"
    
    while IFS=',' read -r SCPID INSTID IP HOSTNAME PORT PEM OS U1SER C1TYPE ROLE M1EM C1ORE; do
	IP_EXISTS="N"
	
	if [ "$THENATUREOFTHISRUN" == "RECURRING" ] ; then
		for existing_ip in "${EXISTING_IPS[@]}"; do
			if [[ "$IP" == "$existing_ip" ]]; then
			    IP_EXISTS="Y"
			    break
			fi
		done
	fi
	
	if [[ "$IP_EXISTS" == "Y" ]]; then
		echo "IP $IP Exists In The Cluster..."
	else	    
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
		               
		#echo 'sudo -H -u root bash -c "sed -i -e s~'"$IP"'~#'"$IP"'~g /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTESCRIPT > /dev/null 
		echo 'sudo sed -i -e "/\<'"${IP}"'\>/s/^/#/" /etc/hosts' | sudo tee -a $BASE/tmp/$EXECUTESCRIPT > /dev/null                    
		if [ "$ROLE" == "BRAHMA" ]; then
		    BRAHMA_IPS+=("$IP")
		    HOST_NAMES["$IP"]="$lowercase_text-$hyphenated_ip-v$THEVISIONID""-s$SCPID""-i$INSTID""-c$CLUSTERID-b"
		    HOST_ALT_NAMES["$IP"]="alt-$lowercase_text-$hyphenated_ip-v$THEVISIONID""-s$SCPID""-i$INSTID""-c$CLUSTERID-b"
		    echo 'sudo -H -u root bash -c "echo \"'"$IP"' '"$lowercase_text-$hyphenated_ip-v$THEVISIONID""-s$SCPID""-i$INSTID""-c$CLUSTERID-b"'\" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTESCRIPT > /dev/null            
		elif [ "$ROLE" == "VISHVAKARMA" ]; then
		    VISHVAKARMA_IPS+=("$IP")
		    THELETTER="v"
		    
		    if [ "$THENATUREOFTHISRUN" == "FIRSTRUN" ] ; then
			    if [[ "$ISAUTOMATED" == "Y" ]]; then
			    	if (( $COUNTvER == 0 )) ; then
			    		THELETTER="c"
			    		CHITRAGUPTA="$IP"
			    		CHITRAGUPTA1_DET="$CHITRAGUPTA1_DET""$IP,$PORT,$PEM,$U1SER"
			    	fi
			    	if (( $COUNTvER == 1 )) ; then
			    		THELETTER="c"
			    		CHITRAGUPTA="$CHITRAGUPTA"",""$IP"
			    	fi 
			    else
				IS_CG=$(echo "$CHITRAGUPTA" | grep -qw "$IP" && echo "Y" || echo "N")            
			    	if [[ "$NACGD1" == "N" ]]; then
			    		if [[ "$IS_CG" == "Y" ]]; then
			    			CHITRAGUPTA1_DET="$CHITRAGUPTA1_DET""$IP,$PORT,$PEM,$U1SER"
			    			NACGD1="Y"	
			    		fi 
			    	fi
			    	if [[ "$IS_CG" == "Y" ]]; then
			    		THELETTER="c"
			    	fi        	
			    fi
		    fi
		    
		    HOST_NAMES["$IP"]="$lowercase_text-$hyphenated_ip-v$THEVISIONID""-s$SCPID""-i$INSTID""-c$CLUSTERID-$THELETTER"
		    HOST_ALT_NAMES["$IP"]="alt-$lowercase_text-$hyphenated_ip-v$THEVISIONID""-s$SCPID""-i$INSTID""-c$CLUSTERID-$THELETTER"
		    echo 'sudo -H -u root bash -c "echo \"'"$IP"' '"$lowercase_text-$hyphenated_ip-v$THEVISIONID""-s$SCPID""-i$INSTID""-c$CLUSTERID-$THELETTER"'\" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTESCRIPT > /dev/null 
	    	    	    	    	    	    	   	               
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
	fi	              
    done < "$INSTANCE_DETAILS_FILE"
    
    echo 'sudo -H -u root bash -c "echo \"#VAMANA => '"$STACKPRETTYNAME"' '"$REQUNQ"' END \" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTESCRIPT > /dev/null 
    echo 'sudo -H -u root bash -c "echo \"\" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTESCRIPT > /dev/null

    if [ "$THENATUREOFTHISRUN" == "RECURRING" ] ; then
    	echo 'sudo -H -u root bash -c "echo \"\" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTESCRIPT > /dev/null
    	echo 'sudo -H -u root bash -c "echo \"#VAMANA => '"$STACKPRETTYNAME"' '"$REQUNQ"' FOR EXISTING START \" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTESCRIPT > /dev/null     
	for E1R2D in "${!EXISTING_RUN_DETAILS[@]}"; do
		ER1D="${EXISTING_RUN_DETAILS[$E1R2D]}"
		IFS=',' read -r -a ER_1D <<< $ER1D
		ER_1D_VAL1="${ER_1D[0]}"
		ER_1D_VAL2="${ER_1D[4]}"
		ER_1D_VAL3="${ER_1D[8]}"
		
		#EXISTING_IPS+=("$ER_1D_VAL1")
		
		EDVip="${ER_1D[0]}"
		EDVPORTS="${ER_1D[1]}"
		EDVPEM_FILES="${ER_1D[2]}"
		EDVLOGIN_USERS="${ER_1D[3]}"
		EDVHOST_NAMES="${ER_1D[4]}"
		EDVHOST_ALT_NAMES="${ER_1D[5]}"
		EDVJIVA_IPS="${ER_1D[6]}"
		EDVROLE_TYPE="${ER_1D[7]}"
		EDVREQUNQ="${ER_1D[8]}"
		EDVOS_TYPES="${ER_1D[9]}"
		EDVAPP_MEM="${ER_1D[10]}"
		EDVAPP_CORE="${ER_1D[11]}"
		EDVCLUSTER_TYPE="${ER_1D[12]}"
		
		PEM_FILES["$EDVip"]="$EDVPEM_FILES"
		PORTS["$EDVip"]="$EDVPORTS"
		OS_TYPES["$EDVip"]="$EDVOS_TYPES"
		LOGIN_USERS["$EDVip"]="$EDVLOGIN_USERS"
		APP_MEM["$EDVip"]="$EDVAPP_MEM"
		APP_CORE["$EDVip"]="$EDVAPP_CORE" 
		CLUSTER_TYPE["$EDVip"]="$EDVCLUSTER_TYPE"
		ROLE_TYPE["$EDVip"]="$EDVROLE_TYPE"
		HOST_NAMES["$EDVip"]="$EDVHOST_NAMES"
		HOST_ALT_NAMES["$EDVip"]="$EDVHOST_ALT_NAMES"        
        																
		echo 'sudo sed -i -e "/\<'"${ER_1D_VAL1}"'\>/s/^/#/" /etc/hosts' | sudo tee -a $BASE/tmp/$EXECUTESCRIPT > /dev/null 
		echo 'sudo -H -u root bash -c "echo \"'"$ER_1D_VAL1"' '"$ER_1D_VAL2"' #'"$ER_1D_VAL3"'\" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTESCRIPT > /dev/null                   					
	done
	echo 'sudo -H -u root bash -c "echo \"#VAMANA => '"$STACKPRETTYNAME"' '"$REQUNQ"' FOR EXISTING END \" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTESCRIPT > /dev/null 
	echo 'sudo -H -u root bash -c "echo \"\" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTESCRIPT > /dev/null	    
    fi
    
    for ip in "${!CLUSTER_TYPE[@]}"; do
        if [[ "${CLUSTER_TYPE[$ip]}" == "ONPREM" ]]; then
            NATIVE="2"
            break
        fi
    done 

    if [ "$NATIVE" -lt 2 ]; then
	totaloverall=0
	totale2e=0
	
	for ip in "${!CLUSTER_TYPE[@]}"; do
		totaloverall=$((totaloverall + 1))
		if [[ "${CLUSTER_TYPE[$ip]}" == "E2E" ]]; then
		    totale2e=$((totale2e + 1))
		fi
	done
	
	if [ "$totaloverall" -eq "$totale2e" ]; then
		THECLUSTERISONLYE2E="Y"
	else
		THECLUSTERISMULTICLOUD="Y"
	fi		
    fi
    
    if [[ "$ISAUTOMATED" == "N" ]]; then
    	sudo rm -f $INSTANCE_DETAILS_FILE 
    fi 
    if [[ "$ISAUTOMATED" == "Y" ]]; then
    	sudo rm -f $INSTANCE_DETAILS_FILE 
    fi  
    
    THE_PVT_CLD=$(echo "$CHITRAGUPTA" | cut -d',' -f1)
    echo "The THE_PVT_CLD IP is: $THE_PVT_CLD" 
    
    THEINDRA1="${INDRA_IPS[0]}"
    THEINDRA2="NA" 
    if [ ${#INDRA_IPS[@]} -eq 2 ]; then
    	THEINDRA2="${INDRA_IPS[1]}"
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

    sudo rm -f $TheClusterFolderForThisRUN/$IPHF-docker.pem
    sudo rm -f $TheClusterFolderForThisRUN/$IPHF-docker-server-cert.pem
    sudo rm -f $TheClusterFolderForThisRUN/$IPHF-docker-server-key.pem
    sudo rm -f $TheClusterFolderForThisRUN/$IPHF-docker-VARAHA.pem
    sudo rm -f $TheClusterFolderForThisRUN/$IPHF-share-VARAHA.pem
    sudo rm -f $TheClusterFolderForThisRUN/$IPHF-share.pem
    
    if [ "$THENATUREOFTHISRUN" == "FIRSTRUN" ] ; then                
    # Download certificates from the first manager to the local machine
    run_remote $SRC_IP "
        sudo chmod 644 $CERTS_DIR/docker/$IPHF.pem
        sudo chmod 644 $CERTS_DIR/docker/$IPHF-server-cert.pem
        sudo chmod 644 $CERTS_DIR/docker/$IPHF-server-key.pem
        sudo chmod 644 $CERTS_DIR/docker/$IPHF-VARAHA.pem 
        sudo chmod 644 $CERTS_DIR/common/$IPHF-share-VARAHA.pem 
        sudo chmod 644 $CERTS_DIR/common/$IPHF-share.pem                      
    "
        
    scp -i ${PEM_FILES[$SRC_IP]} -P ${PORTS[$SRC_IP]} -o StrictHostKeyChecking=no $THESRCUSER@$SRC_IP:$CERTS_DIR/docker/$IPHF.pem $TheClusterFolderForThisRUN/$IPHF-docker.pem
    scp -i ${PEM_FILES[$SRC_IP]} -P ${PORTS[$SRC_IP]} -o StrictHostKeyChecking=no $THESRCUSER@$SRC_IP:$CERTS_DIR/docker/$IPHF-server-cert.pem $TheClusterFolderForThisRUN/$IPHF-docker-server-cert.pem
    scp -i ${PEM_FILES[$SRC_IP]} -P ${PORTS[$SRC_IP]} -o StrictHostKeyChecking=no $THESRCUSER@$SRC_IP:$CERTS_DIR/docker/$IPHF-server-key.pem $TheClusterFolderForThisRUN/$IPHF-docker-server-key.pem
    scp -i ${PEM_FILES[$SRC_IP]} -P ${PORTS[$SRC_IP]} -o StrictHostKeyChecking=no $THESRCUSER@$SRC_IP:$CERTS_DIR/docker/$IPHF-VARAHA.pem $TheClusterFolderForThisRUN/$IPHF-docker-VARAHA.pem
    scp -i ${PEM_FILES[$SRC_IP]} -P ${PORTS[$SRC_IP]} -o StrictHostKeyChecking=no $THESRCUSER@$SRC_IP:$CERTS_DIR/common/$IPHF-share-VARAHA.pem $TheClusterFolderForThisRUN/$IPHF-share-VARAHA.pem
    scp -i ${PEM_FILES[$SRC_IP]} -P ${PORTS[$SRC_IP]} -o StrictHostKeyChecking=no $THESRCUSER@$SRC_IP:$CERTS_DIR/common/$IPHF-share.pem $TheClusterFolderForThisRUN/$IPHF-share.pem        
    
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
    fi
    
    if [ "$THENATUREOFTHISRUN" == "RECURRING" ] ; then    
    # Download certificates from the first manager to the local machine
    run_remote $SRC_IP "
        sudo chmod 644 $CERTS_DIR/docker/$STACKNAME.pem
        sudo chmod 644 $CERTS_DIR/docker/$STACKNAME-server-cert.pem
        sudo chmod 644 $CERTS_DIR/docker/$STACKNAME-server-key.pem
        sudo chmod 644 $CERTS_DIR/docker/$STACKNAME-VARAHA.pem 
        sudo chmod 644 $CERTS_DIR/docker/$STACKNAME-share-VARAHA.pem 
        sudo chmod 644 $CERTS_DIR/common/$IPHF-share.pem                      
    "
        
    scp -i ${PEM_FILES[$SRC_IP]} -P ${PORTS[$SRC_IP]} -o StrictHostKeyChecking=no $THESRCUSER@$SRC_IP:$CERTS_DIR/docker/$STACKNAME.pem $TheClusterFolderForThisRUN/$IPHF-docker.pem
    scp -i ${PEM_FILES[$SRC_IP]} -P ${PORTS[$SRC_IP]} -o StrictHostKeyChecking=no $THESRCUSER@$SRC_IP:$CERTS_DIR/docker/$STACKNAME-server-cert.pem $TheClusterFolderForThisRUN/$IPHF-docker-server-cert.pem
    scp -i ${PEM_FILES[$SRC_IP]} -P ${PORTS[$SRC_IP]} -o StrictHostKeyChecking=no $THESRCUSER@$SRC_IP:$CERTS_DIR/docker/$STACKNAME-server-key.pem $TheClusterFolderForThisRUN/$IPHF-docker-server-key.pem
    scp -i ${PEM_FILES[$SRC_IP]} -P ${PORTS[$SRC_IP]} -o StrictHostKeyChecking=no $THESRCUSER@$SRC_IP:$CERTS_DIR/docker/$STACKNAME-VARAHA.pem $TheClusterFolderForThisRUN/$IPHF-docker-VARAHA.pem
    scp -i ${PEM_FILES[$SRC_IP]} -P ${PORTS[$SRC_IP]} -o StrictHostKeyChecking=no $THESRCUSER@$SRC_IP:$CERTS_DIR/docker/$STACKNAME-share-VARAHA.pem $TheClusterFolderForThisRUN/$IPHF-share-VARAHA.pem
    scp -i ${PEM_FILES[$SRC_IP]} -P ${PORTS[$SRC_IP]} -o StrictHostKeyChecking=no $THESRCUSER@$SRC_IP:$CERTS_DIR/common/$IPHF-share.pem $TheClusterFolderForThisRUN/$IPHF-share.pem        
    
    run_remote $SRC_IP "
        sudo chown root:root $CERTS_DIR/docker/$STACKNAME.pem
        sudo chown root:root $CERTS_DIR/docker/$STACKNAME-server-cert.pem
        sudo chown root:root $CERTS_DIR/docker/$STACKNAME-server-key.pem  
        sudo chown root:root $CERTS_DIR/docker/$STACKNAME-VARAHA.pem 
        sudo chown root:root $CERTS_DIR/docker/$STACKNAME-share-VARAHA.pem    
        sudo chown root:root $CERTS_DIR/common/$IPHF-share.pem              
        sudo chmod 644 $CERTS_DIR/docker/$STACKNAME.pem
        sudo chmod 644 $CERTS_DIR/docker/$STACKNAME-server-cert.pem
        sudo chmod 644 $CERTS_DIR/docker/$STACKNAME-VARAHA.pem
        sudo chmod 644 $CERTS_DIR/docker/$STACKNAME-share-VARAHA.pem
        sudo chmod 644 $CERTS_DIR/common/$IPHF-share.pem                
        sudo chmod 600 $CERTS_DIR/docker/$STACKNAME-server-key.pem
    " 
    fi 
            
    # Upload certificates to each of the other manager nodes
    sudo chmod 777 $TheClusterFolderForThisRUN/$IPHF-docker.pem
    sudo chmod 777 $TheClusterFolderForThisRUN/$IPHF-docker-server-cert.pem
    sudo chmod 777 $TheClusterFolderForThisRUN/$IPHF-docker-server-key.pem
    sudo chmod 777 $TheClusterFolderForThisRUN/$IPHF-docker-VARAHA.pem
    sudo chmod 777 $TheClusterFolderForThisRUN/$IPHF-share-VARAHA.pem 
    sudo chmod 777 $TheClusterFolderForThisRUN/$IPHF-share.pem           
    for IP in "${BRAHMA_IPS[@]:1}" "${VISHVAKARMA_IPS[@]}" "${INDRA_IPS[@]}"; do
        local THEREQUSER=${LOGIN_USERS[$IP]}
        
        scp -i "${PEM_FILES[$IP]}" -P "${PORTS[$IP]}" -o StrictHostKeyChecking=no $TheClusterFolderForThisRUN/$IPHF-docker.pem $THEREQUSER@$IP:/home/$THEREQUSER/$IPHF.pem
        scp -i "${PEM_FILES[$IP]}" -P "${PORTS[$IP]}" -o StrictHostKeyChecking=no $TheClusterFolderForThisRUN/$IPHF-docker-server-cert.pem $THEREQUSER@$IP:/home/$THEREQUSER/$IPHF-server-cert.pem
        scp -i "${PEM_FILES[$IP]}" -P "${PORTS[$IP]}" -o StrictHostKeyChecking=no $TheClusterFolderForThisRUN/$IPHF-docker-server-key.pem $THEREQUSER@$IP:/home/$THEREQUSER/$IPHF-server-key.pem
        scp -i "${PEM_FILES[$IP]}" -P "${PORTS[$IP]}" -o StrictHostKeyChecking=no $TheClusterFolderForThisRUN/$IPHF-docker-VARAHA.pem $THEREQUSER@$IP:/home/$THEREQUSER/$IPHF-VARAHA.pem
        scp -i "${PEM_FILES[$IP]}" -P "${PORTS[$IP]}" -o StrictHostKeyChecking=no $TheClusterFolderForThisRUN/$IPHF-share-VARAHA.pem $THEREQUSER@$IP:/home/$THEREQUSER/$IPHF-share-VARAHA.pem
                        
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
    
    if [ "$THENATUREOFTHISRUN" == "FIRSTRUN" ] ; then
	    MGR=$(echo "${BRAHMA_IPS[0]}" | sed 's/\./-/g')
	    run_remote ${BRAHMA_IPS[0]} "
		    sudo mv $CERTS_DIR/docker/$MGR.pem $CERTS_DIR/docker/$STACKNAME.pem
		    sudo mv $CERTS_DIR/docker/$MGR-server-key.pem $CERTS_DIR/docker/$STACKNAME-server-key.pem
		    sudo mv $CERTS_DIR/docker/$MGR-server-cert.pem $CERTS_DIR/docker/$STACKNAME-server-cert.pem
		    sudo mv $CERTS_DIR/docker/$MGR-VARAHA.pem $CERTS_DIR/docker/$STACKNAME-VARAHA.pem
		    sudo mv $CERTS_DIR/common/$MGR-share-VARAHA.pem $CERTS_DIR/docker/$STACKNAME-share-VARAHA.pem            
	    "      
    fi
    
    # Clean up local files
    sudo rm -f $TheClusterFolderForThisRUN/$IPHF-docker.pem
    sudo rm -f $TheClusterFolderForThisRUN/$IPHF-docker-server-cert.pem
    sudo rm -f $TheClusterFolderForThisRUN/$IPHF-docker-server-key.pem
    sudo rm -f $TheClusterFolderForThisRUN/$IPHF-docker-VARAHA.pem
    if [ "$THENATUREOFTHISRUN" == "FIRSTRUN" ] ; then
	    sudo mv $TheClusterFolderForThisRUN/$IPHF-share-VARAHA.pem $TheClusterFolderForThisRUN/$STACKPRETTYNAME-share-VARAHA.pem 
	    sudo mv $TheClusterFolderForThisRUN/$IPHF-share.pem $TheClusterFolderForThisRUN/$STACKPRETTYNAME-share.pem 
    fi 
    if [ "$THENATUREOFTHISRUN" == "RECURRING" ] ; then
	    sudo rm -f $TheClusterFolderForThisRUN/$IPHF-share-VARAHA.pem
	    sudo rm -f $TheClusterFolderForThisRUN/$IPHF-share.pem
    fi      
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
    sed -i -e s~"ATPRT"~"$AutoPorts"~g $BASE/tmp/$DOCKERTEMPLATE    
    sed -i -e s~"ATPR1R"~"$THEIPRRANGE"~g $BASE/tmp/$DOCKERTEMPLATE
    sed -i -e s~"ATPR2R"~"$THEEPRRANGE"~g $BASE/tmp/$DOCKERTEMPLATE
    sed -i -e s~"ATPR3R"~"$THEAPRRANGE"~g $BASE/tmp/$DOCKERTEMPLATE
    sed -i -e s~"ATPR4R"~"$THE2IPRRANGE"~g $BASE/tmp/$DOCKERTEMPLATE
    sed -i -e s~"TCIMC"~"$THECLUSTERISMULTICLOUD"~g $BASE/tmp/$DOCKERTEMPLATE
    sed -i -e s~"THEIP1TO"~"$THEIPTO"~g $BASE/tmp/$DOCKERTEMPLATE
    sed -i -e s~"THE1INDRA1"~"$THEINDRA1"~g $BASE/tmp/$DOCKERTEMPLATE
    sed -i -e s~"THE2INDRA2"~"$THEINDRA2"~g $BASE/tmp/$DOCKERTEMPLATE

    THEINDRAIPFORSTUFF="${INDRA_IPS[0]}"
    if [ "$THENATUREOFTHISRUN" == "RECURRING" ] ; then
	IFS=',' read -r -a TEC2B <<< $THEEXISTINGCLUSTERINDRA
	THEINDRAIPFORSTUFF="${TEC2B[0]}"	
    fi
                                
    BUCKETCLIENT="${CLUSTER_APPS_MAPPING["BUCKETCLIENT"]}.${CLUSTERAPPSMAPPING["BUCKETCLIENT"]}"
    scp -i "$THE1REQPEM" -o StrictHostKeyChecking=no -P $P1ORT "$BASE/Resources/$BUCKETCLIENT" "$THE1REQUSER@$IP:/home/$THE1REQUSER/mc"
    MIOTEMPLATE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
    sudo cp $BASE/Resources/MountSBBTemplate $BASE/tmp/$MIOTEMPLATE
    sed -i -e s~"MNIO1"~"$STACK_PRETTY_NAME"~g $BASE/tmp/$MIOTEMPLATE
    sed -i -e s~"MNIO2"~"/shiva/bdd/bucket/$STACKNAME"~g $BASE/tmp/$MIOTEMPLATE 
    sed -i -e s~"MNIO3"~"$DFS_DATA_DIR/MINIO/.$STACK_PRETTY_NAME"~g $BASE/tmp/$MIOTEMPLATE 
    sed -i -e s~"MNIO4"~"https://${HOST_NAMES[$THEINDRAIPFORSTUFF]}:$MINPortIO3"~g $BASE/tmp/$MIOTEMPLATE 
    sed -i -e s~"MNIO5"~"$STACK_PRETTY_NAME"~g $BASE/tmp/$MIOTEMPLATE 
    sed -i -e s~"MNIO6"~"$CERTS_DIR/cluster/ca/${HOST_NAMES[$THEINDRAIPFORSTUFF]}.pem"~g $BASE/tmp/$MIOTEMPLATE
    scp -i "$THE1REQPEM" -o StrictHostKeyChecking=no -P $P1ORT "$BASE/tmp/$MIOTEMPLATE" "$THE1REQUSER@$IP:/home/$THE1REQUSER/MountSBB.sh"
    sudo rm -f $BASE/tmp/$MIOTEMPLATE

    KRBBTEMPLATE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
    sudo cp $BASE/Resources/SetUpKerberosLDAP $BASE/tmp/$KRBBTEMPLATE
    
    sed -i -e s~"THEVAL1"~"ldaps://${HOST_NAMES[$THEINDRAIPFORSTUFF]}:$ChitraGuptaPortLDP5"~g $BASE/tmp/$KRBBTEMPLATE
    sed -i -e s~"THEVAL2"~"${HOST_NAMES[$THEINDRAIPFORSTUFF]}:$ChitraGuptaPortKERB3"~g $BASE/tmp/$KRBBTEMPLATE
    sed -i -e s~"THEVAL3"~"${HOST_NAMES[$THEINDRAIPFORSTUFF]}:$ChitraGuptaPortKERB4"~g $BASE/tmp/$KRBBTEMPLATE
    sed -i -e s~"THEVAL4"~"$STACK_PRETTY_NAME.VAMANA"~g $BASE/tmp/$KRBBTEMPLATE
    sed -i -e s~"THEVAL5"~"$STACKPRETTYNAME.vamana"~g $BASE/tmp/$KRBBTEMPLATE
    sed -i -e s~"THEVAL6"~"$ADMIN_PASSWORD"~g $BASE/tmp/$KRBBTEMPLATE
    sed -i -e s~"THEVAL7"~"dc=$STACKPRETTYNAME,dc=vamana"~g $BASE/tmp/$KRBBTEMPLATE
                               
    scp -i "$THE1REQPEM" -o StrictHostKeyChecking=no -P $P1ORT "$BASE/tmp/$KRBBTEMPLATE" "$THE1REQUSER@$IP:/home/$THE1REQUSER/SetUpKerberos.sh"
    sudo rm -f $BASE/tmp/$KRBBTEMPLATE
    
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

    #IS2_CG="N"		
    #if [[ "$CHITRAGUPTA" == *"$IP"* ]]; then
    #    IS2_CG="Y"
    #fi
    IS2_CG=$(echo "$CHITRAGUPTA" | grep -qw "$IP" && echo "Y" || echo "N")
    if [[ "$IS2_CG" == "Y" ]]; then
    #if [[ "$IP" == "$CHITRAGUPTA" ]]; then
    	echo "IP $IP : CHITRAGUPTA => $CHITRAGUPTA"

    thenameofthepvtcld="${HOST_NAMES[$IP]}"
    if [ "$NATIVE" -lt 2 ]; then
    	thenameofthepvtcld="$IP"
    fi
    	   	
	    if [[ "$CGDTD" == "N" ]]; then
            echo "V_A_MC_MAP_BUCKET $V_A_MC_MAP_BUCKET: V_A_MC_MAP_CLOUDCOMMANDER $V_A_MC_MAP_CLOUDCOMMANDER: V_A_MC_MAP_PVTCLD $V_A_MC_MAP_PVTCLD: V_A_MC_MAP_CHITRAGUPTA1 $V_A_MC_MAP_CHITRAGUPTA1: V_A_MC_MAP_CHITRAGUPTA2 $V_A_MC_MAP_CHITRAGUPTA2: V_A_MC_MAP_CHITRAGUPTA3 $V_A_MC_MAP_CHITRAGUPTA3: V_A_MC_MAP_CHITRAGUPTA4 $V_A_MC_MAP_CHITRAGUPTA4: V_A_MC_MAP_CHITRAGUPTA5 $V_A_MC_MAP_CHITRAGUPTA5: V_A_MC_MAP_CHITRAGUPTA6 $V_A_MC_MAP_CHITRAGUPTA6: V_A_MC_MAP_CHITRAGUPTA7 $V_A_MC_MAP_CHITRAGUPTA7: V_A_MC_MAP_CHITRAGUPTA8 $V_A_MC_MAP_CHITRAGUPTA8: V_A_MC_MAP_CHITRAGUPTA9 $V_A_MC_MAP_CHITRAGUPTA9: V_A_MC_MAP_CHITRAGUPTA10 $V_A_MC_MAP_CHITRAGUPTA10: V_A_MC_MAP_CHITRAGUPTA11 $V_A_MC_MAP_CHITRAGUPTA11: V_A_MC_MAP_EFK1 $V_A_MC_MAP_EFK1: V_A_MC_MAP_EFK2 $V_A_MC_MAP_EFK2: V_A_MC_MAP_EFK3 $V_A_MC_MAP_EFK3"

            CHITRAGUPTA_DET="$CHITRAGUPTA1_DET""■$ChitraGuptaPort1,$ChitraGuptaPort2,$ChitraGuptaPort3,$ChitraGuptaPort4,$ChitraGuptaPort5,$ChitraGuptaPort6,$ChitraGuptaPort7,$ChitraGuptaPortZ1■guacamole_$STACK_PRETTY_NAME,guacamole_$STACK_PRETTY_NAME,$ADMIN_PASSWORD,admin_$STACK_PRETTY_NAME,$WEBSSH_PASSWORD,${CLUSTER_APPS_MAPPING["CHITRAGUPTA1"]}:${CLUSTERAPPSMAPPING["CHITRAGUPTA1"]},${CLUSTER_APPS_MAPPING["CHITRAGUPTA2"]}:${CLUSTERAPPSMAPPING["CHITRAGUPTA2"]},$V_A_MC_MAP_CHITRAGUPTA1,$V_A_MC_MAP_CHITRAGUPTA2■${CLUSTER_APPS_MAPPING["CHITRAGUPTA3"]}:${CLUSTERAPPSMAPPING["CHITRAGUPTA3"]},$V_A_MC_MAP_CHITRAGUPTA3,$REVERSED_PASSWORD■${CLUSTER_APPS_MAPPING["CHITRAGUPTA4"]}:${CLUSTERAPPSMAPPING["CHITRAGUPTA4"]},$V_A_MC_MAP_CHITRAGUPTA4,$REVERSED_PASSWORD■$ADMIN_PASSWORD,$ChitraGuptaPort8,$ChitraGuptaPortU1,$ChitraGuptaPortV1,$ChitraGuptaPortW1,$ChitraGuptaPortY1,${CLUSTER_APPS_MAPPING["CHITRAGUPTA5"]}:${CLUSTERAPPSMAPPING["CHITRAGUPTA5"]},$V_A_MC_MAP_CHITRAGUPTA5,${CLUSTER_APPS_MAPPING["CHITRAGUPTA6"]}:${CLUSTERAPPSMAPPING["CHITRAGUPTA6"]},$V_A_MC_MAP_CHITRAGUPTA6,${CLUSTER_APPS_MAPPING["CHITRAGUPTA7"]}:${CLUSTERAPPSMAPPING["CHITRAGUPTA7"]},$V_A_MC_MAP_CHITRAGUPTA7,${CLUSTER_APPS_MAPPING["CHITRAGUPTA8"]}:${CLUSTERAPPSMAPPING["CHITRAGUPTA8"]},$V_A_MC_MAP_CHITRAGUPTA8■$ADMIN_PASSWORD,$ChitraGuptaPortLDP1,$ChitraGuptaPortLDP2,$ChitraGuptaPortLDP3,$ChitraGuptaPortLDP4,$ChitraGuptaPortLDP5,$STACKPRETTYNAME,${CLUSTER_APPS_MAPPING["CHITRAGUPTA9"]}:${CLUSTERAPPSMAPPING["CHITRAGUPTA9"]},$V_A_MC_MAP_CHITRAGUPTA9,${CLUSTER_APPS_MAPPING["CHITRAGUPTA10"]}:${CLUSTERAPPSMAPPING["CHITRAGUPTA10"]},$V_A_MC_MAP_CHITRAGUPTA10■$ADMIN_PASSWORD,$ChitraGuptaPortKERB1,$ChitraGuptaPortKERB2,$ChitraGuptaPortKERB3,$ChitraGuptaPortKERB4,$STACKPRETTYNAME,${CLUSTER_APPS_MAPPING["CHITRAGUPTA11"]}:${CLUSTERAPPSMAPPING["CHITRAGUPTA11"]},$V_A_MC_MAP_CHITRAGUPTA11■$ADMIN_PASSWORD,$PVTCLDPortIO1,$PVTCLDPortIO2,$STACKPRETTYNAME,${CLUSTER_APPS_MAPPING["PVTCLD"]}:${CLUSTERAPPSMAPPING["PVTCLD"]},$V_A_MC_MAP_PVTCLD,$DFS_CLUSTER_DIR/NextcloudShared,$DFS_DATA_DIR/NEXTCLOUD/CONTENT,$STACK_PRETTY_NAME,$DFS_DATA_DIR/CHITRAGUPTA$STACKNAME/pvtcld/EnablePvtCldShare.sh,$DFS_DATA_DIR/Misc$STACKNAME/custom-apache-config.conf,${INDRA_IPS[0]},$thenameofthepvtcld,$DFS_DATA_DIR/Misc$STACKNAME/config.php,$DFS_DATA_DIR/CHITRAGUPTA$STACKNAME/pvtcld/EnablePvtCldShare2.sh"
  		    CGDTD="Y"
  	    fi
  	
        CGSQLTEMPLATE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
        sudo cp $BASE/Resources/ChitraGupta.sql $BASE/tmp/$CGSQLTEMPLATE
        echo "Acamehere1"
        sed -i -e s~"GUACAMOLEADMIN"~"admin"~g $BASE/tmp/$CGSQLTEMPLATE
        echo "Bcamehere2"
        sed -i -e s~"GUACAMOLEPWD"~"$WEBSSH_PASSWORD"~g $BASE/tmp/$CGSQLTEMPLATE
        echo "Ccamehere3"
        cat $THEGUACASQL >> $BASE/tmp/$CGSQLTEMPLATE

        PVT_CLDTEMPLATE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
        sudo cp $BASE/Resources/EnablePvtCldShareTemplate $BASE/tmp/$PVT_CLDTEMPLATE
        sed -i -e s~"PVTCLD1"~"$ADMIN_PASSWORD"~g $BASE/tmp/$PVT_CLDTEMPLATE
        sed -i -e s~"PVTCLD2"~"$STACKPRETTYNAME"~g $BASE/tmp/$PVT_CLDTEMPLATE

        P2VT2_CLDTEMPLATE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
        sudo cp $BASE/Resources/EnablePvtCldShareTemplateII $BASE/tmp/$P2VT2_CLDTEMPLATE
        sed -i -e s~"PVTCLD1"~"$ADMIN_PASSWORD"~g $BASE/tmp/$P2VT2_CLDTEMPLATE
        sed -i -e s~"PVTCLD2"~"$STACKPRETTYNAME"~g $BASE/tmp/$P2VT2_CLDTEMPLATE

        P3VT3_CLDTEMPLATE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
        sudo cp $BASE/Resources/EnablePvtCldShareTemplateIII $BASE/tmp/$P3VT3_CLDTEMPLATE
        sed -i -e s~"THEFLDRPATH"~"$DFS_DATA_DIR/NEXTCLOUD/CONTENT/admin"~g $BASE/tmp/$P3VT3_CLDTEMPLATE

        PVT1_CLDTEMPLATE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
        sudo cp $BASE/Resources/PvtCldConfigTemplate $BASE/tmp/$PVT1_CLDTEMPLATE
	if [ "$NATIVE" -lt 2 ]; then
		sed -i -e s~"INDRA"~"${INDRA_IPS[0]}"~g $BASE/tmp/$PVT1_CLDTEMPLATE
		sed -i -e s~"CHITRAGUPTA"~"$THE_PVT_CLD"~g $BASE/tmp/$PVT1_CLDTEMPLATE	 
	else       
		sed -i -e s~"INDRA"~"${HOST_NAMES[${INDRA_IPS[0]}]}"~g $BASE/tmp/$PVT1_CLDTEMPLATE
		sed -i -e s~"CHITRAGUPTA"~"${HOST_NAMES[$THE_PVT_CLD]}"~g $BASE/tmp/$PVT1_CLDTEMPLATE        
	fi
        sed -i -e s~"THE_PORT"~"$PVTCLDPortIO2"~g $BASE/tmp/$PVT1_CLDTEMPLATE
        	
        scp -i "$THE1REQPEM" -o StrictHostKeyChecking=no -P $P1ORT "$BASE/tmp/$PVT1_CLDTEMPLATE" "$THE1REQUSER@$IP:/home/$THE1REQUSER/config.php"
        scp -i "$THE1REQPEM" -o StrictHostKeyChecking=no -P $P1ORT "$BASE/tmp/$PVT_CLDTEMPLATE" "$THE1REQUSER@$IP:/home/$THE1REQUSER/EnablePvtCldShare.sh"
        scp -i "$THE1REQPEM" -o StrictHostKeyChecking=no -P $P1ORT "$BASE/tmp/$P2VT2_CLDTEMPLATE" "$THE1REQUSER@$IP:/home/$THE1REQUSER/EnablePvtCldShare2.sh"
        scp -i "$THE1REQPEM" -o StrictHostKeyChecking=no -P $P1ORT "$BASE/tmp/$P3VT3_CLDTEMPLATE" "$THE1REQUSER@$IP:/home/$THE1REQUSER/EnablePvtCldShare3.sh"
                		   	
        scp -i "$THE1REQPEM" -o StrictHostKeyChecking=no -P $P1ORT "$BASE/tmp/$CGSQLTEMPLATE" "$THE1REQUSER@$IP:/home/$THE1REQUSER/initdb-redux.sql"
        scp -i "$THE1REQPEM" -o StrictHostKeyChecking=no -P $P1ORT "$BASE/Resources/boodark.tar.gz" "$THE1REQUSER@$IP:/home/$THE1REQUSER/boodark.tar.gz"
        scp -i "$THE1REQPEM" -o StrictHostKeyChecking=no -P $P1ORT "$BASE/Resources/1860_rev37.json" "$THE1REQUSER@$IP:/home/$THE1REQUSER/1860_rev37.json" 
        scp -i "$THE1REQPEM" -o StrictHostKeyChecking=no -P $P1ORT "$BASE/Resources/container-metrics.json" "$THE1REQUSER@$IP:/home/$THE1REQUSER/container-metrics.json"
        scp -i "$THE1REQPEM" -o StrictHostKeyChecking=no -P $P1ORT "$BASE/Resources/node-metrics.json" "$THE1REQUSER@$IP:/home/$THE1REQUSER/node-metrics.json"  	   	
        sudo rm -f $BASE/tmp/$CGSQLTEMPLATE
        sudo rm -f $BASE/tmp/$PVT_CLDTEMPLATE 
        sudo rm -f $BASE/tmp/$PVT1_CLDTEMPLATE  
        sudo rm -f $BASE/tmp/$P2VT2_CLDTEMPLATE	
        sudo rm -f $BASE/tmp/$P3VT3_CLDTEMPLATE        
        #sudo rm -f $THEGUACASQL
        
        echo "Dcamehere4"
    	sed -i -e s~"GGEPO"~"$CHITRAGUPTA_DET"~g $BASE/tmp/$DOCKERTEMPLATE
    	echo "Ecamehere5"
    	echo "$CHITRAGUPTA_DET"
    	#exit 
    else
    	sed -i -e s~"GGEPO"~"NA"~g $BASE/tmp/$DOCKERTEMPLATE
    fi
        
    sudo chmod 777 $BASE/tmp/$DOCKERTEMPLATE

    THE_RNDM_VAL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 20 | head -n 1)
    
    PVT_GLUSTTEMPLATE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
    sudo cp $BASE/Resources/PreGlusterRunTemplate $BASE/tmp/$PVT_GLUSTTEMPLATE
    sed -i -e s~"THECUR_STACK"~"$STACKNAME"~g $BASE/tmp/$PVT_GLUSTTEMPLATE

    P2VT2_GLUSTTEMPLATE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
    sudo cp $BASE/Resources/PreGlusterRunTemplateII $BASE/tmp/$P2VT2_GLUSTTEMPLATE
    sed -i -e s~"THECUR_STACK"~"$STACKNAME"~g $BASE/tmp/$P2VT2_GLUSTTEMPLATE
    sed -i -e s~"THE_DIR"~"$DFS_DATA_DIR/Misc$STACKNAME"~g $BASE/tmp/$P2VT2_GLUSTTEMPLATE
    sed -i -e s~"THE_RNDM_VAL"~"$THE_RNDM_VAL"~g $BASE/tmp/$P2VT2_GLUSTTEMPLATE
    
    PVT_DOCKTEMPLATE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
    sudo cp $BASE/Resources/PreDockerRunTemplate $BASE/tmp/$PVT_DOCKTEMPLATE
    sed -i -e s~"THECUR_STACK"~"$STACKNAME"~g $BASE/tmp/$PVT_DOCKTEMPLATE
    sed -i -e s~"DFS1_DATA1_DIR"~"$DFS_DATA_DIR"~g $BASE/tmp/$PVT_DOCKTEMPLATE

    P2VT2_DOCKTEMPLATE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
    sudo cp $BASE/Resources/PreDockerRunTemplateII $BASE/tmp/$P2VT2_DOCKTEMPLATE
    sed -i -e s~"THECUR_STACK"~"$STACKNAME"~g $BASE/tmp/$P2VT2_DOCKTEMPLATE
    sed -i -e s~"THE_DIR"~"$DFS_DATA_DIR/Misc$STACKNAME"~g $BASE/tmp/$P2VT2_DOCKTEMPLATE
    sed -i -e s~"THE_RNDM_VAL"~"$THE_RNDM_VAL"~g $BASE/tmp/$P2VT2_DOCKTEMPLATE
    
    scp -i "$THE1REQPEM" -o StrictHostKeyChecking=no -P $P1ORT "$BASE/tmp/$PVT_DOCKTEMPLATE" "$THE1REQUSER@$IP:/home/$THE1REQUSER/PreDockerRunActual.sh"
    scp -i "$THE1REQPEM" -o StrictHostKeyChecking=no -P $P1ORT "$BASE/tmp/$P2VT2_DOCKTEMPLATE" "$THE1REQUSER@$IP:/home/$THE1REQUSER/PreDockerRun.sh"

    scp -i "$THE1REQPEM" -o StrictHostKeyChecking=no -P $P1ORT "$BASE/tmp/$PVT_GLUSTTEMPLATE" "$THE1REQUSER@$IP:/home/$THE1REQUSER/PreGlusterRunActual.sh"
    scp -i "$THE1REQPEM" -o StrictHostKeyChecking=no -P $P1ORT "$BASE/tmp/$P2VT2_GLUSTTEMPLATE" "$THE1REQUSER@$IP:/home/$THE1REQUSER/PreGlusterRun.sh"

    sudo rm -f $BASE/tmp/$PVT_GLUSTTEMPLATE
    sudo rm -f $BASE/tmp/$P2VT2_GLUSTTEMPLATE
    sudo rm -f $BASE/tmp/$PVT_DOCKTEMPLATE
    sudo rm -f $BASE/tmp/$P2VT2_DOCKTEMPLATE
            
    EFKTEMPLATE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
    sudo cp $BASE/Resources/DockerEFK.yml $BASE/tmp/$EFKTEMPLATE

    IFS=':' read -r -a _EFK1 <<< "$V_A_MC_MAP_EFK1"
    _EFK1_M="${_EFK1[0]}"
    _EFK1_C="${_EFK1[1]}"    
    IFS=':' read -r -a _EFK2 <<< "$V_A_MC_MAP_EFK2"
    _EFK2_M="${_EFK2[0]}"
    _EFK2_C="${_EFK2[1]}"
    IFS=':' read -r -a _EFK3 <<< "$V_A_MC_MAP_EFK3"
    _EFK3_M="${_EFK3[0]}"
    _EFK3_C="${_EFK3[1]}"
             
    sed -i -e s~"EFKV1"~"${CLUSTER_APPS_MAPPING["EFK1"]}"~g $BASE/tmp/$EFKTEMPLATE
    sed -i -e s~"EFKV2"~"${CLUSTERAPPSMAPPING["EFK1"]}"~g $BASE/tmp/$EFKTEMPLATE
    sed -i -e s~"EFKV3"~"$DFS_DATA_DIR/EFKDATA"~g $BASE/tmp/$EFKTEMPLATE
    sed -i -e s~"EFKV4"~"$EFKPort1"~g $BASE/tmp/$EFKTEMPLATE
    sed -i -e s~"EFKV5"~"$_EFK1_C"~g $BASE/tmp/$EFKTEMPLATE
    sed -i -e s~"EFKV6"~"$_EFK1_M"~g $BASE/tmp/$EFKTEMPLATE
    sed -i -e s~"EFKV7"~"$DFS_DATA_DIR/EFK/DockerEFK.sh"~g $BASE/tmp/$EFKTEMPLATE    
    sed -i -e s~"EFKKV1"~"${CLUSTER_APPS_MAPPING["EFK2"]}"~g $BASE/tmp/$EFKTEMPLATE
    sed -i -e s~"EFKKV2"~"${CLUSTERAPPSMAPPING["EFK2"]}"~g $BASE/tmp/$EFKTEMPLATE
    sed -i -e s~"EFKKV3"~"$EFKPort2"~g $BASE/tmp/$EFKTEMPLATE
    sed -i -e s~"EFKKV4"~"$_EFK2_C"~g $BASE/tmp/$EFKTEMPLATE
    sed -i -e s~"EFKKV5"~"$_EFK2_M"~g $BASE/tmp/$EFKTEMPLATE
    sed -i -e s~"EFKFV1"~"${CLUSTER_APPS_MAPPING["EFK3"]}"~g $BASE/tmp/$EFKTEMPLATE
    sed -i -e s~"EFKFV2"~"${CLUSTERAPPSMAPPING["EFK3"]}"~g $BASE/tmp/$EFKTEMPLATE
    sed -i -e s~"EFKFV3"~"/shiva"~g $BASE/tmp/$EFKTEMPLATE
    sed -i -e s~"EFKFV4"~"$DFS_DATA_DIR/EFKFBC"~g $BASE/tmp/$EFKTEMPLATE
    sed -i -e s~"EFKFV5"~"$DFS_DATA_DIR/EFKFBY/filebeat.yml"~g $BASE/tmp/$EFKTEMPLATE
    sed -i -e s~"EFKFV6"~"$_EFK3_C"~g $BASE/tmp/$EFKTEMPLATE
    sed -i -e s~"EFKFV7"~"$_EFK3_M"~g $BASE/tmp/$EFKTEMPLATE
    sed -i -e s~"EFKPWD"~"$ADMIN_PASSWORD"~g $BASE/tmp/$EFKTEMPLATE
    sed -i -e s~"STACKNAME"~"$STACKNAME"~g $BASE/tmp/$EFKTEMPLATE
 
    scp -i "$THE1REQPEM" -o StrictHostKeyChecking=no -P $P1ORT "$BASE/tmp/$EFKTEMPLATE" "$THE1REQUSER@$IP:/home/$THE1REQUSER/DockerEFK.yml"
    sudo rm -f $BASE/tmp/$EFKTEMPLATE

    EFK2TEMPLATE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
    sudo cp $BASE/Resources/DockerEFK.sh $BASE/tmp/$EFK2TEMPLATE
    sed -i -e s~"THEPWD"~"$ADMIN_PASSWORD"~g $BASE/tmp/$EFK2TEMPLATE
    scp -i "$THE1REQPEM" -o StrictHostKeyChecking=no -P $P1ORT "$BASE/tmp/$EFK2TEMPLATE" "$THE1REQUSER@$IP:/home/$THE1REQUSER/DockerEFK.sh"
    sudo rm -f $BASE/tmp/$EFK2TEMPLATE

    EFK3TEMPLATE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
    sudo cp $BASE/Resources/DockerEFK2.sh $BASE/tmp/$EFK3TEMPLATE
    sed -i -e s~"THEFILELOC"~"$DFS_DATA_DIR/EFKFBC"~g $BASE/tmp/$EFK3TEMPLATE
    scp -i "$THE1REQPEM" -o StrictHostKeyChecking=no -P $P1ORT "$BASE/tmp/$EFK3TEMPLATE" "$THE1REQUSER@$IP:/home/$THE1REQUSER/DockerEFK2.sh"
    sudo rm -f $BASE/tmp/$EFK3TEMPLATE
                                                        
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
if [[ "$THECLUSTERISMULTICLOUD" == "Y" ]]; then
    if [[ "$ELIGIBLEFORKRISHNA" == "N" ]]; then
    	run_remote ${BRAHMA_IPS[0]} "PRISUB=\$(head -n 1 /opt/PRISUB) && docker network create --driver overlay --attachable --opt encrypted --subnet \$PRISUB $STACKNAME-encrypted-overlay"
    fi
    if [[ "$ELIGIBLEFORKRISHNA" == "Y" ]]; then
    	run_remote ${BRAHMA_IPS[0]} "
        docker network create \
          --driver overlay \
          --attachable \
          --opt encrypted \
          $STACKNAME-encrypted-overlay
    "    
    fi
else
    run_remote ${BRAHMA_IPS[0]} "
        docker network create \
          --driver overlay \
          --attachable \
          --opt encrypted \
          $STACKNAME-encrypted-overlay
    "
fi
}

# Function to create a GlusterFS volume cluster with retry logic
create_glusterfs_volume_cluster() {
    peer_probe_cmds=""
    volume_create_cmd=""
    retry_count=0
    max_retries=10
    success=false
    S1TA1CKN1AME="$1"
    DFS1_CLUSTER1_DIR="$2"
    GLUSTER_VPATH="$3"
    
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
	echo "create_glusterfs_$S1TA1CKN1AME_volume_cluster : $peer_probe_cmds"
	echo "create_glusterfs_$S1TA1CKN1AME_volume_cluster : $volume_create_cmd"        
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
	    
	    GD1F_DATA="$glusterfs_addresses■$THEFINALVOLUMENAME■$DFS1_CLUSTER1_DIR■/var/log/glusterfs/$THEFINALVOLUMENAME-mount.log"
	    GD1F_FILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	    GD1F1_FILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	    echo $GD1F_DATA > $BASE/tmp/$GD1F1_FILE
	    $BASE/Scripts/SecretsFile-Encrypter "$BASE/tmp/$GD1F1_FILE├$GLUSTER_VPATH├$ADMIN_PASSWORD├$GD1F_FILE"
	    sudo chmod 777 $GLUSTER_VPATH
	    sudo rm -f $BASE/tmp/$GD1F1_FILE

	    ALL2_IPS=("${BRAHMA_IPS[@]}" "${VISHVAKARMA_IPS[@]}" "${INDRA_IPS[@]}")
	    for IP in "${ALL2_IPS[@]}"; do
		run_remote $IP "sudo rm -f /opt/GV$S1TA1CKN1AME && sudo touch /opt/GV$S1TA1CKN1AME && echo \"$glusterfs_addresses■$THEFINALVOLUMENAME■$DFS1_CLUSTER1_DIR■/var/log/glusterfs/$THEFINALVOLUMENAME-mount.log\" | sudo tee -a /opt/GV$S1TA1CKN1AME > /dev/null && sudo chmod 777 /opt/GV$S1TA1CKN1AME && hostname && sudo mount -t glusterfs $glusterfs_addresses:/$THEFINALVOLUMENAME $DFS1_CLUSTER1_DIR -o log-level=DEBUG,log-file=/var/log/glusterfs/$THEFINALVOLUMENAME-mount.log"
	    done    
    fi
}

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
		echo "create_glusterfsvolume_portainer : $peer_probe_cmds"
		echo "create_glusterfsvolume_portainer : $volume_create_cmd" 
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
		sudo mv $THENOHUPFILE $THENAMEOFTHELOGFOLDER/MainRUN-FATAL_ERROR-Portainer-$RND1M_.out
		TheFinalMessageFile="$THENAMEOFTHELOGFOLDER/VAMANA-FAILURE"
		sudo touch $TheFinalMessageFile
		sudo chmod 777 $TheFinalMessageFile		
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
		    run_remote $IP "sudo rm -f /opt/PHAGDet && sudo touch /opt/PHAGDet && echo \"$glusterfs_addresses■Portainer$THEFINALVOLUME1NAME■$DFS_DATA_DIR/PortainerMnt$STACKNAME■/var/log/glusterfs/Portainer$STACKNAME-mount.log\" | sudo tee -a /opt/PHAGDet > /dev/null && sudo chmod 777 /opt/PHAGDet && hostname && sudo mount -t glusterfs $glusterfs_addresses:/Portainer$THEFINALVOLUME1NAME $DFS_DATA_DIR/PortainerMnt$STACKNAME -o log-level=DEBUG,log-file=/var/log/glusterfs/Portainer$STACKNAME-mount.log"
		done
	fi
}

# Function to create swarm labels
create_swarm_labels() {
	if [ "$THENATUREOFTHISRUN" == "FIRSTRUN" ] ; then
		for IP in "${BRAHMA_IPS[@]}"; do
			NODE_ID=$(run_remote $IP "docker info -f '{{.Swarm.NodeID}}'")
			if [ -n "$NODE_ID" ]; then
			    run_remote $IP "docker node update --label-add $STACKNAME""BRAHMAreplica=true $NODE_ID"
			else
			    echo "Node $IP is not part of a Swarm"
			fi
		done
		
		INDRHA="N"
		for IP in "${INDRA_IPS[@]}"; do
			NODE_ID=$(run_remote $IP "docker info -f '{{.Swarm.NodeID}}'")
			if [ -n "$NODE_ID" ]; then
			    if [ "$INDRHA" == "N" ]; then
			    	run_remote ${BRAHMA_IPS[0]} "docker node update --label-add $STACKNAME""INDRA_ACTIVEreplica=true $NODE_ID"
			    	INDRHA="Y"
			    else
			    	run_remote ${BRAHMA_IPS[0]} "docker node update --label-add $STACKNAME""INDRA_PASSIVEreplica=true $NODE_ID"
			    fi
			else
			    echo "Node $IP is not part of a Swarm"
			fi
		done
	fi
	
	THEBRAHMAIPFOR1SSL="${BRAHMA_IPS[0]}"

	if [ "$THENATUREOFTHISRUN" == "RECURRING" ] ; then
		IFS=',' read -r -a TEC1B <<< $THEEXISTINGCLUSTERBRAHMA
		THEBRAHMAIPFOR1SSL="${TEC1B[0]}"	
	fi	
	
	for IP in "${VISHVAKARMA_IPS[@]}"; do
		NODE_ID=$(run_remote $IP "docker info -f '{{.Swarm.NodeID}}'")
		if [ -n "$NODE_ID" ]; then		
		    #IS1_CG="N"		
		    #if [[ "$CHITRAGUPTA" == *"$IP"* ]]; then
		    #    IS1_CG="Y"
		    #fi
		    IS1_CG=$(echo "$CHITRAGUPTA" | grep -qw "$IP" && echo "Y" || echo "N")
		    if [[ "$IS1_CG" == "Y" ]]; then		    				
		    #if [[ "$IP" == "$CHITRAGUPTA" ]]; then
			    run_remote $THEBRAHMAIPFOR1SSL "docker node update --label-add $STACKNAME""CHITRAGUPTAreplica=true $NODE_ID"
		    fi
		    if [[ "$IP" == "$THE_PVT_CLD" ]]; then
			    run_remote $THEBRAHMAIPFOR1SSL "docker node update --label-add $STACKNAME""THE_PVT_CLDreplica=true $NODE_ID"
		    fi            
		    run_remote $THEBRAHMAIPFOR1SSL "docker node update --label-add $STACKNAME""VISHVAKARMAreplica=true $NODE_ID"		
		else
		    echo "Node $IP is not part of a Swarm"
		fi
	done			
}

# Function to create cluster level cdn & proxy
create_cluster_cdn_proxy() {
    CDNPRX="$1"
    
    THEINDRIP=""
    if [ "$CDNPRX" == "ACTIVE" ]; then
    	THEINDRIP="${INDRA_IPS[0]}"
    fi
    if [ "$CDNPRX" == "PASSIVE" ]; then
    	THEINDRIP="${INDRA_IPS[1]}"
    fi
        
    DOCKERTEMPLATE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
    sudo cp $BASE/Scripts/VARAHA.sh $BASE/tmp/$DOCKERTEMPLATE

    #MGRIPS=$(IFS=','; echo "${BRAHMA_IPS[*]}")
    THECFGPATH=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
    THEDCYPATH=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)    
    IWP="$THEINDRIP"
    THE1RAM=${APP_MEM[$IWP]}
    R2AM=$( [[ $THE1RAM == *,* ]] && echo "${THE1RAM#*,}" || echo "$THE1RAM" )
    THE1CORE=${APP_CORE[$IWP]}
    C2ORE=$( [[ $THE1CORE == *,* ]] && echo "${THE1CORE#*,}" || echo "$THE1CORE" ) 

    THEREQINDRA="$THEINDRIP"
    SYNCWITHIFCONFIG="N"
    if [ "$NATIVE" -lt 2 ]; then
    	THEREQINDRA="${JIVA_IPS[$THEINDRIP]}"
    	SYNCWITHIFCONFIG="Y"
    fi
   
    sudo chmod 777 $BASE/tmp/$DOCKERTEMPLATE
    
    MIN_IO_DET="$REVERSED_PASSWORD,$MINPortIO1,$MINPortIO2,$MINPortIO3,$MINPortIO4,$DFS_DATA_DIR/MINIO/EntryPoint.sh,$DFS_DATA_DIR/MINIODATA,${CLUSTER_APPS_MAPPING["BUCKET"]}:${CLUSTERAPPSMAPPING["BUCKET"]},$V_A_MC_MAP_BUCKET,$FLBRPortIO2"
     
    max_attempts=5
    attempt=0
    while true; do
    	attempt=$((attempt + 1))
        scp -i "${PEM_FILES[${BRAHMA_IPS[0]}]}" -o StrictHostKeyChecking=no -P ${PORTS[${BRAHMA_IPS[0]}]} "$BASE/tmp/$DOCKERTEMPLATE" "${LOGIN_USERS[${BRAHMA_IPS[0]}]}@${BRAHMA_IPS[0]}:/home/${LOGIN_USERS[${BRAHMA_IPS[0]}]}"
        status=$?
        if [ $status -eq 0 ]; then
            ssh -i "${PEM_FILES[${BRAHMA_IPS[0]}]}" -o StrictHostKeyChecking=no -p ${PORTS[${BRAHMA_IPS[0]}]} ${LOGIN_USERS[${BRAHMA_IPS[0]}]}@${BRAHMA_IPS[0]} "sudo rm -f /home/${LOGIN_USERS[${BRAHMA_IPS[0]}]}/VARAHA.sh && sudo mv /home/${LOGIN_USERS[${BRAHMA_IPS[0]}]}/$DOCKERTEMPLATE /home/${LOGIN_USERS[${BRAHMA_IPS[0]}]}/VARAHA.sh && sudo chmod 777 /home/${LOGIN_USERS[${BRAHMA_IPS[0]}]}/VARAHA.sh && /home/${LOGIN_USERS[${BRAHMA_IPS[0]}]}/VARAHA.sh \"CORE\" \"$MGR1IPS\" \"$STACKNAME\" \"$STACKPRETTYNAME\" \"$DFS_DATA2_DIR/Static$STACKNAME\" \"$VarahaPort1\" \"$VarahaPort2\" \"$DFS_DATA_DIR/Tmp$STACKNAME/$THECFGPATH.cfg\" \"$VarahaPort3\" \"$VarahaPort4\" \"$ADMIN_PASSWORD\" \"$PortainerSPort\" \"$DFS_DATA_DIR/Tmp$STACKNAME/$THEDCYPATH.yml\" \"$C2ORE\" \"$R2AM\" \"$CERTS_DIR\" \"$DFS_DATA_DIR/Errors$STACKNAME\" \"$DFS_DATA_DIR/Misc$STACKNAME/RunHAProxy\" \"$THEREQINDRA\" \"${CLUSTERAPPSMAPPING["INDRA"]}\" \"${CLUSTER_APPS_MAPPING["INDRA"]}\" \"$SYNCWITHIFCONFIG\" \"$WEBSSHPort1\" \"$WEBSSH_PASSWORD\" \"$DFS_DATA_DIR/Misc$STACKNAME/webssh\" \"$THEWEBSSHIDLELIMIT\" \"${CLUSTERAPPSMAPPING["WEBSSH"]}\" \"${CLUSTER_APPS_MAPPING["WEBSSH"]}\" \"$CHITRAGUPTA_DET\" \"$MIN_IO_DET\" \"${HOST_NAMES[$THEINDRIP]}\" \"$EFKPort3\" \"$EFKPort4\" \"$CDNPRX\" \"$ALT_INDR_HA_PRT\" \"$THECLUSTERISMULTICLOUD\" \"$CHITRAGUPTA\" \"$THEIPTO\" && sudo rm -f /home/${LOGIN_USERS[${BRAHMA_IPS[0]}]}/VARAHA.sh"
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

final_nodes_list() {
	declare -a FNL_IPS
	ALL9_IPS=("${BRAHMA_IPS[@]}" "${VISHVAKARMA_IPS[@]}" "${INDRA_IPS[@]}")
	ALL92_IPS=("${BRAHMA_IPS[@]}" "${INDRA_IPS[@]}" "${VISHVAKARMA_IPS[0]}")
	
	for ip in "${ALL9_IPS[@]}"; do
		#FNL_IPS+=("$ip,${PORTS[$ip]},${PEM_FILES[$ip]},${LOGIN_USERS[$ip]},${HOST_NAMES[$ip]},${HOST_ALT_NAMES[$ip]},${JIVA_IPS[$ip]},${ROLE_TYPE[$ip]},$REQUNQ")
		FNL_IPS+=("$ip,${PORTS[$ip]},${PEM_FILES[$ip]},${LOGIN_USERS[$ip]},${HOST_NAMES[$ip]},${HOST_ALT_NAMES[$ip]},${JIVA_IPS[$ip]},${ROLE_TYPE[$ip]},$REQUNQ,${OS_TYPES[$ip]},${APP_MEM[$ip]},${APP_CORE[$ip]},${CLUSTER_TYPE[$ip]}")	
	done
	
	DOCKER9TEMPLATE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	if [ "$THENATUREOFTHISRUN" == "RECURRING" ] ; then
		for E1R2D in "${!EXISTING_RUN_DETAILS[@]}"; do
			ER1D="${EXISTING_RUN_DETAILS[$E1R2D]}"
			echo "$ER1D" >> "$BASE/tmp/$DOCKER9TEMPLATE"                   					
		done	    
	fi	
	for item in "${FNL_IPS[@]}"; do
	    echo "$item" >> "$BASE/tmp/$DOCKER9TEMPLATE"
	done	

	if [ "$THENATUREOFTHISRUN" == "FIRSTRUN" ] ; then
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
	fi
	
	FNNPATH="$TheClusterFolderForThisRUN/$STACKNAME.normal"
	if [[ "$ELIGIBLEFORKRISHNA" == "Y" ]]; then
		FNNPATH="$TheClusterFolderForThisRUN/Nodes$STACKNAME.vpn"		
	fi

	cat $BASE/tmp/$DOCKER9TEMPLATE
	
	if [ "$THENATUREOFTHISRUN" == "RECURRING" ] ; then
		sudo rm -f $FNNPATH
	fi
	
	FNN_FILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	$BASE/Scripts/SecretsFile-Encrypter "$BASE/tmp/$DOCKER9TEMPLATE├$FNNPATH├$ADMIN_PASSWORD├$FNN_FILE"
	sudo chmod 777 $FNNPATH
	sudo rm -f $BASE/tmp/$FNN_FILE
	sudo rm -f $BASE/tmp/$DOCKER9TEMPLATE
}

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

create_cert_for_all() {
    sudo mkdir -p $TheClusterFolderForThisRUN/CERTS
    sudo chmod -R 777 $TheClusterFolderForThisRUN/CERTS
    sudo mkdir -p $TheClusterFolderForThisRUN/CERTS/CA
    sudo chmod -R 777 $TheClusterFolderForThisRUN/CERTS/CA
    sudo mkdir -p $TheClusterFolderForThisRUN/CERTS/FULL
    sudo chmod -R 777 $TheClusterFolderForThisRUN/CERTS/FULL
            
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

        scp -i "$pem_file" -P "$port" -o StrictHostKeyChecking=no "$user@$ip:$CERTS_DIR/self/$IPHF.pem" "$TheClusterFolderForThisRUN/CERTS/CA/$THEIPNAME.pem"
        scp -i "$pem_file" -P "$port" -o StrictHostKeyChecking=no "$user@$ip:$CERTS_DIR/self/$IPHF-VARAHA.pem" "$TheClusterFolderForThisRUN/CERTS/FULL/$THEIPNAME.pem"
    done 
    
    sudo chmod -R 777 $TheClusterFolderForThisRUN/CERTS/*

    pushd $TheClusterFolderForThisRUN
    tar -czf "CERTS.tar.gz" "CERTS"
    sudo chmod 777 CERTS.tar.gz
    popd
    
    ALL_CERT2_IPS=("${BRAHMA_IPS[@]}" "${VISHVAKARMA_IPS[@]}" "${INDRA_IPS[@]}")
    if [ "$THENATUREOFTHISRUN" == "RECURRING" ] ; then
    	ALL_CERT2_IPS=("${VISHVAKARMA_IPS[@]}" "${EXISTING_IPS[@]}")
    fi    
    	
    for ip in "${ALL_CERT2_IPS[@]}"; do
    	if ping -c 5 "$ip" > /dev/null; then
        	scp -i "${PEM_FILES[$ip]}" -o StrictHostKeyChecking=no -P ${PORTS[$ip]} "$TheClusterFolderForThisRUN/CERTS.tar.gz" "${LOGIN_USERS[$ip]}@$ip:/home/${LOGIN_USERS[$ip]}"
        	ssh -i "${PEM_FILES[$ip]}" -o StrictHostKeyChecking=no -p ${PORTS[$ip]} ${LOGIN_USERS[$ip]}@$ip "sudo rm -rf CERTS && tar -xzf \"CERTS.tar.gz\" && sudo mv CERTS/CA/* $CERTS_DIR/cluster/ca && sudo mv CERTS/FULL/* $CERTS_DIR/cluster/full && sudo rm -rf CERTS && sudo rm -f CERTS.tar.gz"
        else
        	echo "IP $ip Not Pinging For CERTS Copy..."
        fi
    done
    
    sudo rm -f $TheClusterFolderForThisRUN/CERTS.tar.gz       
}

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
		scp -i "$pem_file" -P "$port" -o StrictHostKeyChecking=no $user@$ip:$FILE_PATH_1 $THENAMEOFTHELOGFOLDER/$hyphenated_ip-DSU-ERROR.out
	    	FILE_COPIED=true
	fi
    	
    	if [ "$FILE_COPIED" = false ]; then
		ssh -o StrictHostKeyChecking=no -i "$pem_file" -p "$port" "$user@$ip" "[ -f $FILE_PATH_2 ]"
		if [ $? -eq 0 ]; then
			echo "File found at $FILE_PATH_2 for $ip"
			scp -i "$pem_file" -P "$port" -o StrictHostKeyChecking=no $user@$ip:$FILE_PATH_2 $THENAMEOFTHELOGFOLDER/$hyphenated_ip-DSU.out
		    	FILE_COPIED=true
		fi    	
    	fi
}

THEFINALVOLUMENAME="$STACKNAME"
THEFINALVOLUME1NAME="$STACKNAME"

# Set Native Apps Details
set_NativeApps_details

# Parse instance details
parse_instance_details

# Set All Ports
SetAllPorts

THEBRAHMAIPFORSSL="${BRAHMA_IPS[0]}"

if [ "$THENATUREOFTHISRUN" == "RECURRING" ] ; then
	IFS=',' read -r -a TECB <<< $THEEXISTINGCLUSTERBRAHMA
	THEBRAHMAIPFORSSL="${TECB[0]}"	
fi

if [ "$THENATUREOFTHISRUN" == "FIRSTRUN" ] ; then
	# Generate SSL certificates on the first manager node
	generate_ssl_certificates $THEBRAHMAIPFORSSL
fi

# Copy SSL certificates to the other manager nodes
copy_ssl_certificates $THEBRAHMAIPFORSSL

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
if [ "$THENATUREOFTHISRUN" == "RECURRING" ] ; then
	ELIGIBLEFORKRISHNA="$THEEXISTINGRUNWASVPNBASED"
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
if [ "$THENATUREOFTHISRUN" == "FIRSTRUN" ] ; then
	for IP in "${BRAHMA_IPS[@]}"; do
	    install_docker "B" $IP
	done
fi
for IP in "${VISHVAKARMA_IPS[@]}"; do
    install_docker "V" $IP
done
if [ "$THENATUREOFTHISRUN" == "FIRSTRUN" ] ; then
	for IP in "${INDRA_IPS[@]}"; do
	    install_docker "I" $IP
	done
fi
sudo chmod 777 $BASE/tmp/$EXECUTESCRIPT
$BASE/tmp/$EXECUTESCRIPT
if [ "$THENATUREOFTHISRUN" == "RECURRING" ] ; then
	ALL_23IPS=("${EXISTING_IPS[@]}")
	for ip in "${ALL_23IPS[@]}"; do
		if ping -c 5 "$ip" > /dev/null; then
			scp -i "${PEM_FILES[$ip]}" -o StrictHostKeyChecking=no -P ${PORTS[$ip]} "$BASE/tmp/$EXECUTESCRIPT" "${LOGIN_USERS[$ip]}@$ip:/home/${LOGIN_USERS[$ip]}"
			ssh -i "${PEM_FILES[$ip]}" -o StrictHostKeyChecking=no -p ${PORTS[$ip]} ${LOGIN_USERS[$ip]}@$ip "sudo chmod 777 /home/${LOGIN_USERS[$ip]}/$EXECUTESCRIPT && /home/${LOGIN_USERS[$ip]}/$EXECUTESCRIPT && sudo rm -f /home/${LOGIN_USERS[$ip]}/$EXECUTESCRIPT"
		else
			echo "IP $ip Not Pinging For Hosts File Update..."
		fi
	done
			
	IFS=',' read -r -a TEC5B <<< $THEEXISTINGCLUSTERBRAHMA
	THEBRAHMADETFORSQL0="${TEC5B[0]}"
	THEBRAHMADETFORSQL1="${TEC5B[1]}"
	THEBRAHMADETFORSQL2="${TEC5B[2]}"
	THEBRAHMADETFORSQL3="${TEC5B[3]}"
				
	THERESULTIP=$(ssh -i $THEBRAHMADETFORSQL2 -p $THEBRAHMADETFORSQL1 -o StrictHostKeyChecking=no $THEBRAHMADETFORSQL3@$THEBRAHMADETFORSQL0 "docker service ps $STACKNAME""_CHITRAGUPTA_mysql | grep 'Running' | head -n 1")
	THERESULTIP=$(echo $THERESULTIP | awk '{print $4}')
	
	echo "Original Output For MySQL : $THERESULTIP"
	for E1R2D in "${!EXISTING_RUN_DETAILS[@]}"; do
		ER1D="${EXISTING_RUN_DETAILS[$E1R2D]}"
		IFS=',' read -r -a ER_1D <<< $ER1D
		ER_1D1_VAL1="${ER_1D[4]}"
		ER_1D1_VAL2="${ER_1D[0]}"
		if [ "$THERESULTIP" == "$ER_1D1_VAL1" ] ; then
			THERESULTIP="$ER_1D1_VAL2"
			break
		fi                   					
	done
	echo "Actual Output For MySQL : $THERESULTIP"
	
	THEBRAHMADETFORSQL1="${PORTS[$THERESULTIP]}"
	THEBRAHMADETFORSQL2="${PEM_FILES[$THERESULTIP]}"	
	THEBRAHMADETFORSQL3="${LOGIN_USERS[$THERESULTIP]}"
	
	CONTAINER_ID=$(ssh -i $THEBRAHMADETFORSQL2 -p $THEBRAHMADETFORSQL1 -o StrictHostKeyChecking=no $THEBRAHMADETFORSQL3@$THERESULTIP "docker ps --filter 'name=$STACKNAME""_CHITRAGUPTA_mysql' --format '{{.ID}}'")
	
	echo "MySQL Container On IP $THERESULTIP : $CONTAINER_ID"
	
	if ping -c 5 "$THERESULTIP" > /dev/null; then
		scp -i $THEBRAHMADETFORSQL2 -P $THEBRAHMADETFORSQL1 -o StrictHostKeyChecking=no $THEGUACASQL $THEBRAHMADETFORSQL3@$THERESULTIP:/tmp/$STACKPRETTYNAME-$REQUNQ-$THEGUACA_SQL.sql
		ssh -i $THEBRAHMADETFORSQL2 -p $THEBRAHMADETFORSQL1 -o StrictHostKeyChecking=no $THEBRAHMADETFORSQL3@$THERESULTIP "docker cp /tmp/$STACKPRETTYNAME-$REQUNQ-$THEGUACA_SQL.sql $CONTAINER_ID:/tmp/$STACKPRETTYNAME-$REQUNQ-$THEGUACA_SQL.sql"
		ssh -i $THEBRAHMADETFORSQL2 -p $THEBRAHMADETFORSQL1 -o StrictHostKeyChecking=no $THEBRAHMADETFORSQL3@$THERESULTIP "docker exec -i $CONTAINER_ID mysql -uroot -p$REVERSED_PASSWORD guacamole_$STACK_PRETTY_NAME < /tmp/$STACKPRETTYNAME-$REQUNQ-$THEGUACA_SQL.sql"
	else
		echo "IP $THERESULTIP Not Pinging For Guacamole MYSQL [$THEGUACASQL : /tmp/$STACKPRETTYNAME-$REQUNQ-$THEGUACA_SQL.sql] Update..."
		echo "---------------"
		cat $THEGUACASQL
		echo "---------------"
	fi						
fi
sudo rm -f $BASE/tmp/$EXECUTESCRIPT
sudo rm -f $THEGUACASQL

create_cert_for_all

ALL1_IPS=("${BRAHMA_IPS[@]}" "${VISHVAKARMA_IPS[@]}" "${INDRA_IPS[@]}")
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
    if (( $COUNTER == 120 )) ; then
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
	sudo mv $THENOHUPFILE $THENAMEOFTHELOGFOLDER/MainRUN-FATAL_ERROR-install_docker-$RND1M_.out
	TheFinalMessageFile="$THENAMEOFTHELOGFOLDER/VAMANA-FAILURE"
	sudo touch $TheFinalMessageFile
	sudo chmod 777 $TheFinalMessageFile	
	exit
fi

if [ "$THENATUREOFTHISRUN" == "RECURRING" ] ; then
	GLUSTERVPATH_1=""
	GLUSTERVPATH_2=""
	GLUSTERVPATH_3=""
	ALL12_IPS=("${VISHVAKARMA_IPS[@]}")
			
	TMP_RNDM_GD1F1FL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)	
	$BASE/Scripts/SecretsFile-Decrypter "$GLUSTERVPATH1├1├1├$BASE/tmp/$TMP_RNDM_GD1F1FL├$ADMIN_PASSWORD"
	sudo chmod 777 $BASE/tmp/$TMP_RNDM_GD1F1FL
	GLUSTERVPATH_1=$(head -n 1 $BASE/tmp/$TMP_RNDM_GD1F1FL)
	sudo rm -f $BASE/tmp/$TMP_RNDM_GD1F1FL
	TMP_RNDM_GD1F1FL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)	
	$BASE/Scripts/SecretsFile-Decrypter "$GLUSTERVPATH2├1├1├$BASE/tmp/$TMP_RNDM_GD1F1FL├$ADMIN_PASSWORD"
	sudo chmod 777 $BASE/tmp/$TMP_RNDM_GD1F1FL
	GLUSTERVPATH_2=$(head -n 1 $BASE/tmp/$TMP_RNDM_GD1F1FL)
	sudo rm -f $BASE/tmp/$TMP_RNDM_GD1F1FL
	TMP_RNDM_GD1F1FL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)	
	$BASE/Scripts/SecretsFile-Decrypter "$GLUSTERVPATH3├1├1├$BASE/tmp/$TMP_RNDM_GD1F1FL├$ADMIN_PASSWORD"
	sudo chmod 777 $BASE/tmp/$TMP_RNDM_GD1F1FL
	GLUSTERVPATH_3=$(head -n 1 $BASE/tmp/$TMP_RNDM_GD1F1FL)
	sudo rm -f $BASE/tmp/$TMP_RNDM_GD1F1FL

	IFS='■' read -r -a GLUSTERVPATH_V_1 <<< $GLUSTERVPATH_1
	GLUSTERVPATH_V_V_1="${GLUSTERVPATH_V_1[0]}"
	GLUSTERVPATH_V_V_2="${GLUSTERVPATH_V_1[1]}"
	GLUSTERVPATH_V_V_3="${GLUSTERVPATH_V_1[2]}"		
	for IP in "${ALL12_IPS[@]}"; do
	run_remote $IP "sudo rm -f /opt/GV$STACKNAME && sudo touch /opt/GV$STACKNAME && echo \"$GLUSTERVPATH_1\" | sudo tee -a /opt/GV$STACKNAME > /dev/null && sudo chmod 777 /opt/GV$STACKNAME && hostname && sudo mount -t glusterfs $GLUSTERVPATH_V_V_1:/$GLUSTERVPATH_V_V_2 $GLUSTERVPATH_V_V_3 -o log-level=DEBUG,log-file=/var/log/glusterfs/$GLUSTERVPATH_V_V_2-mount.log"
	done 

	IFS='■' read -r -a GLUSTERVPATH_V_1 <<< $GLUSTERVPATH_2
	GLUSTERVPATH_V_V_1="${GLUSTERVPATH_V_1[0]}"
	GLUSTERVPATH_V_V_2="${GLUSTERVPATH_V_1[1]}"
	GLUSTERVPATH_V_V_3="${GLUSTERVPATH_V_1[2]}"		
	for IP in "${ALL12_IPS[@]}"; do
	run_remote $IP "sudo rm -f /opt/GVminiogdata && sudo touch /opt/GVminiogdata && echo \"$GLUSTERVPATH_2\" | sudo tee -a /opt/GVminiogdata > /dev/null && sudo chmod 777 /opt/GVminiogdata && hostname && sudo mount -t glusterfs $GLUSTERVPATH_V_V_1:/$GLUSTERVPATH_V_V_2 $GLUSTERVPATH_V_V_3 -o log-level=DEBUG,log-file=/var/log/glusterfs/$GLUSTERVPATH_V_V_2-mount.log"
	done
	
	IFS='■' read -r -a GLUSTERVPATH_V_1 <<< $GLUSTERVPATH_3
	GLUSTERVPATH_V_V_1="${GLUSTERVPATH_V_1[0]}"
	GLUSTERVPATH_V_V_2="${GLUSTERVPATH_V_1[1]}"
	GLUSTERVPATH_V_V_3="${GLUSTERVPATH_V_1[2]}"		
	for IP in "${ALL12_IPS[@]}"; do
	run_remote $IP "sudo rm -f /opt/GVnextgcloud && sudo touch /opt/GVnextgcloud && echo \"$GLUSTERVPATH_3\" | sudo tee -a /opt/GVnextgcloud > /dev/null && sudo chmod 777 /opt/GVnextgcloud && hostname && sudo mount -t glusterfs $GLUSTERVPATH_V_V_1:/$GLUSTERVPATH_V_V_2 $GLUSTERVPATH_V_V_3 -o log-level=DEBUG,log-file=/var/log/glusterfs/$GLUSTERVPATH_V_V_2-mount.log"
	done					
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

if [ "$NATIVE" -lt 2 ]; then
	EXECUTE2SCRIPT=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1) && touch $BASE/tmp/$EXECUTE2SCRIPT && sudo chmod 777 $BASE/tmp/$EXECUTE2SCRIPT
	EXECUTE3SCRIPT='#!/bin/bash'"
	"
	echo "$EXECUTE3SCRIPT" | sudo tee -a $BASE/tmp/$EXECUTE2SCRIPT > /dev/null
	echo 'sudo -H -u root bash -c "echo \"\" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTE2SCRIPT > /dev/null
	echo 'sudo -H -u root bash -c "echo \"#VAMANA ALT => '"$STACKPRETTYNAME"' '"$REQUNQ"' START \" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTE2SCRIPT > /dev/null
	for ip in "${BRAHMA_IPS[@]}" "${VISHVAKARMA_IPS[@]}" "${INDRA_IPS[@]}"; do
	    internal_ip=$(fetch_internal_ip $ip)
	    JIVA_IPS["$ip"]="$internal_ip"
	    #echo 'sudo -H -u root bash -c "sed -i -e s~'"$internal_ip"'~#'"$internal_ip"'~g /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTE2SCRIPT > /dev/null 
	    echo 'sudo sed -i -e "/\<'"${internal_ip}"'\>/s/^/#/" /etc/hosts' | sudo tee -a $BASE/tmp/$EXECUTE2SCRIPT > /dev/null  
	    echo 'sudo -H -u root bash -c "echo \"'"$internal_ip"' '"${HOST_ALT_NAMES[$ip]}"'\" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTE2SCRIPT > /dev/null	    
	done
	for ip in "${!JIVA_IPS[@]}"; do
	    echo "$ip : ${JIVA_IPS[$ip]}"
	done
	echo 'sudo -H -u root bash -c "echo \"#VAMANA ALT => '"$STACKPRETTYNAME"' '"$REQUNQ"' END \" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTE2SCRIPT > /dev/null 
	echo 'sudo -H -u root bash -c "echo \"\" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTE2SCRIPT > /dev/null

	if [ "$THENATUREOFTHISRUN" == "RECURRING" ] ; then
		echo 'sudo -H -u root bash -c "echo \"\" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTE2SCRIPT > /dev/null
		echo 'sudo -H -u root bash -c "echo \"#VAMANA ALT => '"$STACKPRETTYNAME"' '"$REQUNQ"' FOR EXISTING START \" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTE2SCRIPT > /dev/null     
		for E1R2D in "${!EXISTING_RUN_DETAILS[@]}"; do
			ER1D="${EXISTING_RUN_DETAILS[$E1R2D]}"
			IFS=',' read -r -a ER_1D <<< $ER1D
			ER_1D_VAL1="${ER_1D[6]}"
			ER_1D_VAL2="${ER_1D[5]}"
			ER_1D_VAL3="${ER_1D[8]}"
			
			echo 'sudo sed -i -e "/\<'"${ER_1D_VAL1}"'\>/s/^/#/" /etc/hosts' | sudo tee -a $BASE/tmp/$EXECUTE2SCRIPT > /dev/null 
			echo 'sudo -H -u root bash -c "echo \"'"$ER_1D_VAL1"' '"$ER_1D_VAL2"' #'"$ER_1D_VAL3"'\" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTE2SCRIPT > /dev/null                   					
		done
		echo 'sudo -H -u root bash -c "echo \"#VAMANA ALT => '"$STACKPRETTYNAME"' '"$REQUNQ"' FOR EXISTING END \" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTE2SCRIPT > /dev/null 
		echo 'sudo -H -u root bash -c "echo \"\" >> /etc/hosts"' | sudo tee -a $BASE/tmp/$EXECUTE2SCRIPT > /dev/null	    
	fi

	ALL_IPS=("${BRAHMA_IPS[@]}" "${VISHVAKARMA_IPS[@]}" "${INDRA_IPS[@]}")
	if [ "$THENATUREOFTHISRUN" == "RECURRING" ] ; then
		ALL_IPS=("${VISHVAKARMA_IPS[@]}" "${EXISTING_IPS[@]}")
	fi
	for ip in "${ALL_IPS[@]}"; do
		scp -i "${PEM_FILES[$ip]}" -o StrictHostKeyChecking=no -P ${PORTS[$ip]} "$BASE/tmp/$EXECUTE2SCRIPT" "${LOGIN_USERS[$ip]}@$ip:/home/${LOGIN_USERS[$ip]}"
		ssh -i "${PEM_FILES[$ip]}" -o StrictHostKeyChecking=no -p ${PORTS[$ip]} ${LOGIN_USERS[$ip]}@$ip "sudo chmod 777 /home/${LOGIN_USERS[$ip]}/$EXECUTE2SCRIPT && /home/${LOGIN_USERS[$ip]}/$EXECUTE2SCRIPT && sudo rm -f /home/${LOGIN_USERS[$ip]}/$EXECUTE2SCRIPT"
	done

	sudo rm -f $BASE/tmp/$EXECUTE2SCRIPT	  
fi

if [ "$THENATUREOFTHISRUN" == "FIRSTRUN" ] ; then
	MGR1IPS=$(IFS=','; echo "${BRAHMA_IPS[*]}")
	THESWARMFIRSTMANAGER="${BRAHMA_IPS[0]}"
	if [[ "$THECLUSTERISMULTICLOUD" == "Y" ]]; then
	    if [[ "$ELIGIBLEFORKRISHNA" == "N" ]]; then
	    	THESWARMFIRSTMANAGER=$(fetch_internal_ip ${BRAHMA_IPS[0]})
	    	#MGR1IPS=""
		#for ip in "${BRAHMA_IPS[@]}"; do
		#    result=$(fetch_internal_ip "$ip")
		#    if [ -z "$MGR1IPS" ]; then
		#	MGR1IPS="$result"
		#    else
		#	MGR1IPS="$MGR1IPS,$result"
		#    fi
		#done    	
	    fi
	    if [[ "$ELIGIBLEFORKRISHNA" == "Y" ]]; then
	    	THESWARMFIRSTMANAGER=$(fetch_internal_ip ${BRAHMA_IPS[0]})
	    fi
	fi

	# Initialize Docker Swarm with custom ports and autolock on the first manager node
	run_remote ${BRAHMA_IPS[0]} "docker swarm init --advertise-addr $THESWARMFIRSTMANAGER --autolock"

	sudo rm -f $UNLOCKFILEPATH
	sudo rm -f $MJTFILEPATH
	sudo rm -f $WJTFILEPATH
	sudo rm -f $RODFILEPATH
	
	SWARM_UNLOCK_KEY=$(run_remote ${BRAHMA_IPS[0]} "docker swarm unlock-key -q")
	ULFP_FILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	ULFP1_FILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	echo $SWARM_UNLOCK_KEY > $BASE/tmp/$ULFP1_FILE
	$BASE/Scripts/SecretsFile-Encrypter "$BASE/tmp/$ULFP1_FILE├$UNLOCKFILEPATH├$ADMIN_PASSWORD├$ULFP_FILE"
	sudo chmod 777 $UNLOCKFILEPATH
	sudo rm -f $BASE/tmp/$ULFP1_FILE

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
	
	RODFP_FILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	RODFP1_FILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	echo "$MGR1IPS■$THESWARMFIRSTMANAGER" > $BASE/tmp/$RODFP1_FILE
	$BASE/Scripts/SecretsFile-Encrypter "$BASE/tmp/$RODFP1_FILE├$RODFILEPATH├$ADMIN_PASSWORD├$RODFP_FILE"
	sudo chmod 777 $RODFILEPATH
	sudo rm -f $BASE/tmp/$RODFP1_FILE	
fi

if [ "$THENATUREOFTHISRUN" == "RECURRING" ] ; then
	TMP_RNDM_1FL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)	
	$BASE/Scripts/SecretsFile-Decrypter "$UNLOCKFILEPATH├1├1├$BASE/tmp/$TMP_RNDM_1FL├$ADMIN_PASSWORD"
	sudo chmod 777 $BASE/tmp/$TMP_RNDM_1FL
	SWARM_UNLOCK_KEY=$(head -n 1 $BASE/tmp/$TMP_RNDM_1FL)
	sudo rm -f $BASE/tmp/$TMP_RNDM_1FL
	
	TMP_RNDM_1FL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)	
	$BASE/Scripts/SecretsFile-Decrypter "$WJTFILEPATH├1├1├$BASE/tmp/$TMP_RNDM_1FL├$ADMIN_PASSWORD"
	sudo chmod 777 $BASE/tmp/$TMP_RNDM_1FL
	VISHVAKARMA_JOIN_TOKEN=$(head -n 1 $BASE/tmp/$TMP_RNDM_1FL)
	sudo rm -f $BASE/tmp/$TMP_RNDM_1FL
	
	TMP_RNDM_1FL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)	
	$BASE/Scripts/SecretsFile-Decrypter "$RODFILEPATH├1├1├$BASE/tmp/$TMP_RNDM_1FL├$ADMIN_PASSWORD"
	sudo chmod 777 $BASE/tmp/$TMP_RNDM_1FL
	ROD_1_1=$(head -n 1 $BASE/tmp/$TMP_RNDM_1FL)
	sudo rm -f $BASE/tmp/$TMP_RNDM_1FL
	IFS='■' read -r -a ROD1_1_1 <<< $ROD_1_1
	MGR1IPS="${ROD1_1_1[0]}"
	THESWARMFIRSTMANAGER="${ROD1_1_1[1]}"			
fi

echo "$DFS_DATA_DIR/Misc$STACKNAME/DockerRestartJoinTemplate$STACKNAME '$MGR1IPS' '$STACKNAME' '$DFS_DATA_DIR/Misc$STACKNAME'"

if [ "$THENATUREOFTHISRUN" == "FIRSTRUN" ] ; then
	# Join remaining manager nodes to the Swarm
	for IP in "${BRAHMA_IPS[@]:1}"; do
	    THEIPOFTHISMGR="$IP"
	    if [[ "$THECLUSTERISMULTICLOUD" == "Y" ]]; then
		if [[ "$ELIGIBLEFORKRISHNA" == "N" ]]; then
	    	    THEIPOFTHISMGR=$(fetch_internal_ip $IP)
		fi
		if [[ "$ELIGIBLEFORKRISHNA" == "Y" ]]; then
	    	    THEIPOFTHISMGR=$(fetch_internal_ip $IP)
		fi        
	    fi    
	    run_remote $IP "sudo rm -f /var/lib/.dsuk$STACKNAME && echo '$SWARM_UNLOCK_KEY' | sudo tee /var/lib/.dsuk$STACKNAME > /dev/null && sudo rm -f /var/lib/.dsjt$STACKNAME && echo '$BRAHMA_JOIN_TOKEN' | sudo tee /var/lib/.dsjt$STACKNAME > /dev/null && docker swarm join --token $BRAHMA_JOIN_TOKEN --advertise-addr $THEIPOFTHISMGR $THESWARMFIRSTMANAGER:2377 && $DFS_DATA_DIR/Misc$STACKNAME/DockerRestartJoinTemplate$STACKNAME '$MGR1IPS' '$STACKNAME' '$DFS_DATA_DIR/Misc$STACKNAME' && $DFS_DATA_DIR/Misc$STACKNAME/DockerCleanUpTemplate$STACKNAME '$STACKNAME' '$DFS_DATA_DIR/Misc$STACKNAME'"    
	done

	for IP in "${BRAHMA_IPS[0]}"; do
	    run_remote $IP "sudo rm -f /var/lib/.dsuk$STACKNAME && echo '$SWARM_UNLOCK_KEY' | sudo tee /var/lib/.dsuk$STACKNAME > /dev/null && sudo rm -f /var/lib/.dsjt$STACKNAME && echo '$BRAHMA_JOIN_TOKEN' | sudo tee /var/lib/.dsjt$STACKNAME > /dev/null && $DFS_DATA_DIR/Misc$STACKNAME/DockerRestartJoinTemplate$STACKNAME '$MGR1IPS' '$STACKNAME' '$DFS_DATA_DIR/Misc$STACKNAME' && $DFS_DATA_DIR/Misc$STACKNAME/DockerCleanUpTemplate$STACKNAME '$STACKNAME' '$DFS_DATA_DIR/Misc$STACKNAME'"    
	done
fi

# Join worker nodes to the Swarm
for IP in "${VISHVAKARMA_IPS[@]}"; do
    THEIPOFTHISMGR="$IP"
    if [[ "$THECLUSTERISMULTICLOUD" == "Y" ]]; then
        if [[ "$ELIGIBLEFORKRISHNA" == "N" ]]; then
    	    THEIPOFTHISMGR=$(fetch_internal_ip $IP)
        fi
        if [[ "$ELIGIBLEFORKRISHNA" == "Y" ]]; then
    	    THEIPOFTHISMGR=$(fetch_internal_ip $IP)
        fi
    fi
    run_remote $IP "sudo rm -f /var/lib/.dsuk$STACKNAME && echo '$SWARM_UNLOCK_KEY' | sudo tee /var/lib/.dsuk$STACKNAME > /dev/null && sudo rm -f /var/lib/.dsjt$STACKNAME && echo '$VISHVAKARMA_JOIN_TOKEN' | sudo tee /var/lib/.dsjt$STACKNAME > /dev/null && docker swarm join --token $VISHVAKARMA_JOIN_TOKEN --advertise-addr $THEIPOFTHISMGR $THESWARMFIRSTMANAGER:2377 && $DFS_DATA_DIR/Misc$STACKNAME/DockerRestartJoinTemplate$STACKNAME '$MGR1IPS' '$STACKNAME' '$DFS_DATA_DIR/Misc$STACKNAME' && $DFS_DATA_DIR/Misc$STACKNAME/DockerCleanUpTemplate$STACKNAME '$STACKNAME' '$DFS_DATA_DIR/Misc$STACKNAME'"
done

if [ "$THENATUREOFTHISRUN" == "FIRSTRUN" ] ; then
	# Join router nodes to the Swarm
	for IP in "${INDRA_IPS[@]}"; do
	    THEIPOFTHISMGR="$IP"
	    if [[ "$THECLUSTERISMULTICLOUD" == "Y" ]]; then
		if [[ "$ELIGIBLEFORKRISHNA" == "N" ]]; then
	    	    THEIPOFTHISMGR=$(fetch_internal_ip $IP)
		fi
		if [[ "$ELIGIBLEFORKRISHNA" == "Y" ]]; then
	    	    THEIPOFTHISMGR=$(fetch_internal_ip $IP)
		fi
	    fi
	    run_remote $IP "sudo rm -f /var/lib/.dsuk$STACKNAME && echo '$SWARM_UNLOCK_KEY' | sudo tee /var/lib/.dsuk$STACKNAME > /dev/null && sudo rm -f /var/lib/.dsjt$STACKNAME && echo '$VISHVAKARMA_JOIN_TOKEN' | sudo tee /var/lib/.dsjt$STACKNAME > /dev/null && docker swarm join --token $VISHVAKARMA_JOIN_TOKEN --advertise-addr $THEIPOFTHISMGR $THESWARMFIRSTMANAGER:2377 && $DFS_DATA_DIR/Misc$STACKNAME/DockerRestartJoinTemplate$STACKNAME '$MGR1IPS' '$STACKNAME' '$DFS_DATA_DIR/Misc$STACKNAME' && $DFS_DATA_DIR/Misc$STACKNAME/DockerCleanUpTemplate$STACKNAME '$STACKNAME' '$DFS_DATA_DIR/Misc$STACKNAME'"
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

	create_glusterfs_volume_cluster "$STACKNAME" "$DFS_CLUSTER_DIR" "$GLUSTERVPATH1"
	create_glusterfs_volume_cluster "miniogdata" "$DFS_DATA_DIR/MINIODATA" "$GLUSTERVPATH2"
	create_glusterfs_volume_cluster "nextgcloud" "$DFS_DATA_DIR/NEXTCLOUD" "$GLUSTERVPATH3"

	if [ ${#BRAHMA_IPS[@]} -lt 2 ]; then
		echo "No need for Portainer HA"
		ALL32_IPS=("${BRAHMA_IPS[@]}" "${VISHVAKARMA_IPS[@]}" "${INDRA_IPS[@]}")
		for IP in "${ALL32_IPS[@]}"; do
			run_remote $IP "sudo rm -f /opt/PHANA && sudo touch /opt/PHANA && sudo chmod 777 /opt/PHANA"
		done 	
	else
		create_glusterfs_volume_portainer
	fi
fi
    
create_swarm_labels

final_nodes_list

if [ "$THENATUREOFTHISRUN" == "FIRSTRUN" ] ; then
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
sed -i -e s~"E1F1K"~"$DFS_DATA_DIR/EFK/DockerEFK.yml"~g $BASE/tmp/$DOCKERCGTEMPLATE

echo "" && echo "Install Guacamole & MySql..."
echo "$ChitraGuptaPort1,$ChitraGuptaPort2,$ChitraGuptaPort3,$ChitraGuptaPort4,$ChitraGuptaPort5,$ChitraGuptaPort6,$ChitraGuptaPort7"
echo "" && echo "Install Prometheus, Grafana, Node Exporter & cAdvisor..."
echo "$ChitraGuptaPort8,$ChitraGuptaPortU1,$ChitraGuptaPortV1,$ChitraGuptaPortW1,$ChitraGuptaPortY1"
nohup $BASE/tmp/$DOCKERCGTEMPLATE > $THENAMEOFTHELOGFOLDER/CHITRAGUPTA-$RND1M_.out 2>&1 &

create_cluster_cdn_proxy "ACTIVE"
if [ ${#INDRA_IPS[@]} -eq 2 ]; then
    create_cluster_cdn_proxy "PASSIVE"
fi

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
IFS=':' read -r -a _MK1T7 <<< "$V_A_MC_MAP_BUCKET"
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
IFS=':' read -r -a _MK11T7 <<< "$V_A_MC_MAP_CLOUDCOMMANDER"
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

ALLL_IPS=("${BRAHMA_IPS[@]}" "${VISHVAKARMA_IPS[@]}" "${INDRA_IPS[@]}")
for ip in "${ALLL_IPS[@]}"; do
    ssh -i "${PEM_FILES[$ip]}" -o StrictHostKeyChecking=no -p ${PORTS[$ip]} ${LOGIN_USERS[$ip]}@$ip "sudo rm -f /tmp/MountSBB-RUN.out && nohup $DFS_DATA_DIR/MINIO/MountSBB.sh > /tmp/MountSBB-RUN.out 2>&1 &" < /dev/null > /dev/null 2>&1 &
    if [[ "$THE_PVT_CLD" == "$ip" ]]; then
        ssh -i "${PEM_FILES[$ip]}" -o StrictHostKeyChecking=no -p ${PORTS[$ip]} ${LOGIN_USERS[$ip]}@$ip "sudo rm -f /tmp/PvtCldShare-RUN.out && nohup sudo $DFS_DATA_DIR/CHITRAGUPTA$STACKNAME/pvtcld/EnablePvtCldShare3.sh > /tmp/PvtCldShare-RUN.out 2>&1 &" < /dev/null > /dev/null 2>&1 &
    fi
done

echo "FULL Ports List ${PORTSLIST[@]}"

echo "Portainer Proxy : https://${HOST_NAMES[${INDRA_IPS[0]}]}:$VarahaPort3"
echo "Portainer Admin : https://${HOST_NAMES[${INDRA_IPS[0]}]}:$VarahaPort4"
echo "Static Global : https://${HOST_NAMES[${INDRA_IPS[0]}]}:$VarahaPort2"

thenamefornc="${HOST_NAMES[${INDRA_IPS[0]}]}"
if [ "$NATIVE" -lt 2 ]; then
	thenamefornc="${INDRA_IPS[0]}"
fi

if [[ "$ISAUTOMATED" == "Y" ]]; then
	google-chrome "https://${HOST_NAMES[${INDRA_IPS[0]}]}:$VarahaPort3" "https://${HOST_NAMES[${INDRA_IPS[0]}]}:$VarahaPort4" "https://${HOST_NAMES[${INDRA_IPS[0]}]}:$VarahaPort2" "https://${HOST_NAMES[${INDRA_IPS[0]}]}:$ChitraGuptaPort5/guacamole/" "https://${HOST_NAMES[${INDRA_IPS[0]}]}:$ChitraGuptaPort6" "https://${HOST_NAMES[${INDRA_IPS[0]}]}:$ChitraGuptaPortY1" "https://${HOST_NAMES[${INDRA_IPS[0]}]}:$ChitraGuptaPortZ1" "https://${HOST_NAMES[${INDRA_IPS[0]}]}:$ChitraGuptaPortLDP4" "https://${HOST_NAMES[${INDRA_IPS[0]}]}:$MINPortIO4" "https://${HOST_NAMES[${INDRA_IPS[0]}]}:$FLBRPortIO2" "https://$thenamefornc:$PVTCLDPortIO2" "https://${HOST_NAMES[${INDRA_IPS[0]}]}:$EFKPort4" &
	
	if [ ${#INDRA_IPS[@]} -eq 2 ]; then
		/opt/firefox/firefox  "https://${HOST_NAMES[${INDRA_IPS[1]}]}:$AltIndrhaprt1" "https://${HOST_NAMES[${INDRA_IPS[1]}]}:$AltIndrhaprt2" "https://${HOST_NAMES[${INDRA_IPS[1]}]}:$AltIndrhaprt3" "https://${HOST_NAMES[${INDRA_IPS[1]}]}:$AltIndrhaprt8/guacamole/" "https://${HOST_NAMES[${INDRA_IPS[1]}]}:$AltIndrhaprt9" "https://${HOST_NAMES[${INDRA_IPS[1]}]}:$AltIndrhaprt11" "https://${HOST_NAMES[${INDRA_IPS[1]}]}:$AltIndrhaprt12" "https://${HOST_NAMES[${INDRA_IPS[1]}]}:$AltIndrhaprt13" "https://${HOST_NAMES[${INDRA_IPS[1]}]}:$AltIndrhaprt6" "https://${HOST_NAMES[${INDRA_IPS[1]}]}:$AltIndrhaprt7" "https://${HOST_NAMES[${INDRA_IPS[1]}]}:$AltIndrhaprt19" &
	fi
fi

THEHAINDRHOST="INDRA_HA"
thenamefor2nc="INDRA_HA"
if [ ${#INDRA_IPS[@]} -eq 2 ]; then
    THEHAINDRHOST="${HOST_NAMES[${INDRA_IPS[1]}]}"
    thenamefor2nc="${HOST_NAMES[${INDRA_IPS[1]}]}"
fi

FNN2PATH="$TheClusterFolderForThisRUN/$STACKNAME.json"
echo "[
  {
    \"Portainer\": \"https://${HOST_NAMES[${INDRA_IPS[0]}]}:$VarahaPort3 | https://$THEHAINDRHOST:$AltIndrhaprt1\"
  },
  {
    \"MinIO Console\": \"https://${HOST_NAMES[${INDRA_IPS[0]}]}:$MINPortIO4 | https://$THEHAINDRHOST:$AltIndrhaprt6\"
  },
  {
    \"MinIO\": \"https://${HOST_NAMES[${INDRA_IPS[0]}]}:$MINPortIO3 | https://$THEHAINDRHOST:$AltIndrhaprt5\"
  },
  {
    \"Cloud Commander\": \"https://${HOST_NAMES[${INDRA_IPS[0]}]}:$FLBRPortIO2 | https://$THEHAINDRHOST:$AltIndrhaprt7\"
  },
  {
    \"Nextcloud\": \"https://$thenamefornc:$PVTCLDPortIO2 | https://$thenamefor2nc:$AltIndrhaprt17\"
  },
  {
    \"Prometheus\": \"https://${HOST_NAMES[${INDRA_IPS[0]}]}:$ChitraGuptaPortZ1 | https://$THEHAINDRHOST:$AltIndrhaprt12\"
  },
  {
    \"Grafana\": \"https://${HOST_NAMES[${INDRA_IPS[0]}]}:$ChitraGuptaPortY1 | https://$THEHAINDRHOST:$AltIndrhaprt11\"
  },
  {
    \"Guacamole\": \"https://${HOST_NAMES[${INDRA_IPS[0]}]}:$ChitraGuptaPort5/guacamole/ | https://$THEHAINDRHOST:$AltIndrhaprt8/guacamole/\"
  },
  {
    \"phpMyAdmin\": \"https://${HOST_NAMES[${INDRA_IPS[0]}]}:$ChitraGuptaPort6 | https://$THEHAINDRHOST:$AltIndrhaprt9\"
  },
  {
    \"phpLDAPadmin\": \"https://${HOST_NAMES[${INDRA_IPS[0]}]}:$ChitraGuptaPortLDP4 | https://$THEHAINDRHOST:$AltIndrhaprt13\"
  },
  {
    \"Static Hosting\": \"https://${HOST_NAMES[${INDRA_IPS[0]}]}:$VarahaPort2 | https://$THEHAINDRHOST:$AltIndrhaprt3\"
  },
  {
    \"HAProxy Admin\": \"https://${HOST_NAMES[${INDRA_IPS[0]}]}:$VarahaPort4 | https://$THEHAINDRHOST:$AltIndrhaprt2\"
  },
  {
    \"Elastic Search\": \"https://${HOST_NAMES[${INDRA_IPS[0]}]}:$EFKPort3 | https://$THEHAINDRHOST:$AltIndrhaprt18\"
  },
  {
    \"Kibana\": \"https://${HOST_NAMES[${INDRA_IPS[0]}]}:$EFKPort4 | https://$THEHAINDRHOST:$AltIndrhaprt19\"
  },
  {
    \"MySQL\": \"${HOST_NAMES[${INDRA_IPS[0]}]}:$ChitraGuptaPort7 | $THEHAINDRHOST:$AltIndrhaprt10\"
  },
  {
    \"OpenLDAP\": \"ldaps://${HOST_NAMES[${INDRA_IPS[0]}]}:$ChitraGuptaPortLDP5 | ldaps://$THEHAINDRHOST:$AltIndrhaprt14\"
  },
  {
    \"Kerberos KDC\": \"${HOST_NAMES[${INDRA_IPS[0]}]}:$ChitraGuptaPortKERB3 | $THEHAINDRHOST:$AltIndrhaprt15\"
  },
  {
    \"Kerberos Admin\": \"${HOST_NAMES[${INDRA_IPS[0]}]}:$ChitraGuptaPortKERB4 | $THEHAINDRHOST:$AltIndrhaprt16\"
  }
]" >> "$FNN2PATH"

PORTAINER_URL="https://${BRAHMA_IPS[0]}:$PortainerSPort/api"
PORTAINER_URL="https://${HOST_NAMES[${INDRA_IPS[0]}]}:$VarahaPort3/api"
USERNAME="admin"
MAX_RETRIES=100
SLEEP_INTERVAL=5
THENEW1ENV="$STACKPRETTYNAME"

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

sudo touch $TheFinalMessageFile
sudo chmod 777 $TheFinalMessageFile

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
    #sudo mv $THENOHUPFILE $BASE/Output/Logs/$REQUNQ-VAMANA-$STACKPRETTYNAME.out
    exit 1
fi
rename_environment
else
	ALLL_IPS=("${VISHVAKARMA_IPS[@]}")
	for ip in "${ALLL_IPS[@]}"; do
	    ssh -i "${PEM_FILES[$ip]}" -o StrictHostKeyChecking=no -p ${PORTS[$ip]} ${LOGIN_USERS[$ip]}@$ip "sudo rm -f /tmp/MountSBB-RUN.out && nohup $DFS_DATA_DIR/MINIO/MountSBB.sh > /tmp/MountSBB-RUN.out 2>&1 &" < /dev/null > /dev/null 2>&1 &
	done

	sudo touch $TheFinalMessageFile
	sudo chmod 777 $TheFinalMessageFile
fi
#sudo mv $THENOHUPFILE $BASE/Output/Logs/$REQUNQ-VAMANA-$STACKPRETTYNAME.out
#fi

sudo rm -rf /home/$CURRENTUSER/.ssh/known_hosts
sudo rm -rf /root/.ssh/known_hosts
sudo rm -rf /root/.bash_history
sudo rm -rf /home/$CURRENTUSER/.bash_history

#https://github.com/portainer/portainer/issues/523
#https://github.com/portainer/portainer/issues/1205
#https://www.portainer.io/blog/monitoring-a-swarm-cluster-with-prometheus-and-grafana
#https://portainer-notes.readthedocs.io/en/latest/deployment.html

