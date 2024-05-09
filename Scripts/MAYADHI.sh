#!/bin/bash

set -e

clear

CURRENTUSER=$(whoami)
sudo rm -rf /home/$CURRENTUSER/.ssh/known_hosts
sudo rm -rf /root/.ssh/known_hosts

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

USERINTERACTION="YES"
USERVALS=""
MANUALRUN="NO"

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

source $BASE/Resources/StackVersioningAndMisc
SSKEYGENSH="$BASE/Scripts/KeyGeneratorSSH.sh"

echo -e "${ORANGE}=================================================================${NC}"
echo -e "${BLUE}${BOLD}\x1b[4mM${NORM}${NC}iddleware ${BLUE}${BOLD}\x1b[4mA${NORM}${NC}ssisting ${BLUE}${BOLD}\x1b[4mY${NORM}${NC}onder ${BLUE}${BOLD}\x1b[4mA${NORM}${NC}pplications ${BLUE}${BOLD}\x1b[4mD${NORM}${NC}ata ${BLUE}${BOLD}\x1b[4mH${NORM}${NC}ardware ${BLUE}${BOLD}\x1b[4mI${NORM}${NC}nterfaces"
echo -e "${GREEN}=================================================================${NC}"
echo ''
echo -e "\x1b[3mM   M  AAAAA  Y   Y  AAAAA  DDDD   H   H  III  \x1b[m"
echo -e "\x1b[3mMM MM  A   A    Y    A   A  D   D  H   H   I   \x1b[m"
echo -e "\x1b[3mM M M  AAAAA    Y    AAAAA  D   D  HHHHH   I   \x1b[m"
echo -e "\x1b[3mM   M  A   A    Y    A   A  D   D  H   H   I   \x1b[m"
echo -e "\x1b[3mM   M  A   A    Y    A   A  DDDD   H   H  III  \x1b[m"
echo ''
echo -e "\x1b[3m\x1b[4mLayer Interlocutor\x1b[m"
echo ''

if [ $# -eq 0 ]; then
    echo "Usage: $BASE/Scripts/MAYADHI.sh Parameters.."
    echo ''
    exit 1
fi

TASKIDENTIFIER=$1

if [ "$TASKIDENTIFIER" == "KRISHNA" ] ; then
	THEJSON=$2

	nic=$(jq -r '.NIC' <<< "$THEJSON")
	filename=$(jq -r '.FileName' <<< "$THEJSON")
	auth=""
	while IFS= read -r line; do
	    auth+="┼$line"
	done < <(jq -r '.Auth[] | "\(.Type)├\(.User)¤\(.Port)├\(.Value)"' <<< "$THEJSON")
	auth=${auth#┼}
	THEREALVAL="$nic■$auth■$filename"
	
	sudo /opt/Matsya/Scripts/KRISHNA.sh "$THEREALVAL■MAYADHI"
fi

if [ "$TASKIDENTIFIER" == "MATSYA" ] ; then
	THESTACKFILE="$2"
	THEVISIONKEY="$3"
	declare -A PARENTIDENTITYCREATIONREMOTEFILELOCATIONMAPPING
	#find . -type d -name 'op-Scope46-*-ID997'
	#/opt/essentials/newport.sh
	header=$(head -n 1 $THESTACKFILE)
	csv_data=$(tail -n +2 $THESTACKFILE)
	json_data=$(echo "$csv_data" | awk -v header="$header" 'BEGIN { FS=","; OFS=","; split(header, keys, ","); print "[" } { print "{"; for (i=1; i<=NF; i++) { printf "\"%s\":\"%s\"", keys[i], $i; if (i < NF) printf ","; } print "},"; } END { print "{}]"; }' | sed '$s/,$//')
	filtered_json=$(echo "$json_data" | jq 'map(select(.IP != null and .IP != ""))')
	filtered_json2=$(echo "$filtered_json" | jq 'map(select(.IP == "TBD"))')
	grouped_json=$(echo "$filtered_json2" | jq 'group_by(.Parent) | map({"Parent":.[0].Parent, "Count": length})')
	COUNTER=0
	for row in $(echo "$grouped_json" | jq -r '.[] | @base64'); do
		parent=$(echo "$row" | base64 -d | jq -r '.Parent')
		count=$(echo "$row" | base64 -d | jq -r '.Count')
		first_line=$(echo "$filtered_json2" | jq --arg parent "$parent" 'map(select(.Parent == $parent)) | .[0]')
		nic=$(jq -r '.NIC' <<< "$first_line")
		gateway=$(jq -r '.Gateway' <<< "$first_line")
		netmask=$(jq -r '.Netmask' <<< "$first_line")
		pusername=$(jq -r '.PUserName' <<< "$first_line")
		pport=$(jq -r '.PPort' <<< "$first_line")
		ppassword=$(jq -r '.PPassword' <<< "$first_line")
		ppem=$(jq -r '.PPEM' <<< "$first_line")	   
		scopeid=$(jq -r '.ScopeId' <<< "$first_line") 
		 
		__PARENTIDENTITYCREATIONREMOTEFILELOCATIONMAPPING=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
		_PARENTIDENTITYCREATIONREMOTEFILELOCATIONMAPPING="$BASE/Output/$__PARENTIDENTITYCREATIONREMOTEFILELOCATIONMAPPING"
		PARENTIDENTITYCREATIONREMOTEFILELOCATIONMAPPING[$parent]="$_PARENTIDENTITYCREATIONREMOTEFILELOCATIONMAPPING"

		_filtered_json2=$(echo "$filtered_json2" | jq -c --arg parent "$parent" '.[] | select(.Parent == $parent and .IP == "TBD")')
		
		_filtered_json2_identity=$(echo "$_filtered_json2" | jq -sr '[.[].Identity] | join(",")')
		IFS=',' read -ra ip_array <<< "$_filtered_json2_identity"
		for ((i = 0; i < ${#ip_array[@]}; i++)); do
		    ip_array[i]="ID${ip_array[i]}"
		done
		__filtered_json2_identity=$(IFS=','; echo "${ip_array[*]}")
	
		_filtered_json2_otherinfo=$(echo "$_filtered_json2" | jq -sr '[.[].OtherInfo] | join("■")')
		IFS='■' read -ra _filtered_json2_otherinfo1 <<< "$_filtered_json2_otherinfo"
		only3from_filtered_json2_otherinfo=""
		the4thfrom_filtered_json2_otherinfo=""
		for item in "${_filtered_json2_otherinfo1[@]}"; do
		    IFS='├' read -ra _filtered_json2_otherinfo2 <<< "$item"
		    only3from_filtered_json2_otherinfo+="$(IFS=','; echo "${_filtered_json2_otherinfo2[*]:0:3}")|"
		    the4thfrom_filtered_json2_otherinfo+="${_filtered_json2_otherinfo2[3]},"
		done
		only3from_filtered_json2_otherinfo=${only3from_filtered_json2_otherinfo%|}
		the4thfrom_filtered_json2_otherinfo=${the4thfrom_filtered_json2_otherinfo%,}
		
		THESETUPMODE="l"
		#if [ $count -gt 3 ]; then
		#	THESETUPMODE="p"
		#fi
				
		MainSSHCode=""
		THECODETORUNFORONPREMISEDEPLOY="ROOTPWD=\$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
MATSYAPWD=\$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
VAGRANTPWD=\$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
UBUPWD=\$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
RANDOMSSHPORT=\$(shuf -i 45000-46000 -n 1)
FINALOUTPUTREQ=\"YES\"
FINALPROCESSOUTPUT=\"$_PARENTIDENTITYCREATIONREMOTEFILELOCATIONMAPPING\"
CLUSTER=\"Scope$scopeid\"
IPSTART=1
TOTALNOOFIPSREQ=\$(($count + 1))
BASE=\"$BASE\"
source $BASE/Resources/StackVersioningAndMisc
GETMEUNIQUEOUTPUTFILEIPS=\$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
GETMEUNIQUEIPS \"\$TOTALNOOFIPSREQ\" \"$nic\" \"$BASE/tmp/\$GETMEUNIQUEOUTPUTFILEIPS\"
GETMEUNIQUEOUTPUTIPS=\$(head -n 1 \"$BASE/tmp/\$GETMEUNIQUEOUTPUTFILEIPS\")
sudo rm -rf $BASE/tmp/\$GETMEUNIQUEOUTPUTFILEIPS
sudo mkdir -p $BASE/Output/Scope$scopeid-CDR
sudo chmod -R 777 $BASE/Output/Scope$scopeid-CDR
$BASE/Scripts/Vagrant-VirtualBox.sh \"$BASE├\$CLUSTER├c├0├\$TOTALNOOFIPSREQ├$THESETUPMODE├c├2048,1,50|$only3from_filtered_json2_otherinfo├c├$nic├$gateway├$netmask├\$IPSTART├c├$BASE/Output/$scopeid-CDR,$the4thfrom_filtered_json2_otherinfo├y├\$ROOTPWD├\$MATSYAPWD├\$VAGRANTPWD├├\$RANDOMSSHPORT├\$FINALOUTPUTREQ├\$FINALPROCESSOUTPUT├\$GETMEUNIQUEOUTPUTIPS├IDCDR,$__filtered_json2_identity\""

		if [ "$ppem" == "NA" ] ; then
			MainSSHCode="sshpass -p \"$ppassword\" ssh -p $pport -o StrictHostKeyChecking=no \"$pusername@$parent\""
		else
			MainSSHCode="ssh -p $pport -o StrictHostKeyChecking=no -i \"$ppem\" \"$pusername@$parent\""
		fi
		
		#echo "Parent: $parent, Count: $count, NIC: $nic, Gateway: $gateway, Netmask: $netmask, PUserName: $pusername, PPort: $pport, PPassword: $ppassword, PPEM: $ppem, IDENTITY: $_filtered_json2_identity"
		#echo ""		
		#echo $MainSSHCode
		echo $THECODETORUNFORONPREMISEDEPLOY
		
		COUNTER=$((COUNTER + 1))		
	done
	COUNTER=0		
fi
	
	
	
	
	
	
	
	
	
	
	
	
	
		
