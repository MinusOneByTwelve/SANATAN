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
	
	sudo $BASE/Scripts/KRISHNA.sh "$THEREALVAL■MAYADHI"
fi

if [ "$TASKIDENTIFIER" == "MATSYA" ] ; then
	THESTACKFILE="$2"
	THEVISIONKEY="$3"
	declare -A PICRFLOCATIONMAPPING
	declare -A PICRFSCRIPTMAPPING
	declare -A PICRFSCRIPTCOPY
	declare -A PICRFCRONCOPY
	declare -A PICRFCRONFILE
	declare -A PICRFCRONRESFILE
	THEMACHINEFROMWHEREITALLSTARTED="NA"

	ALLINCLUSIVEFINALCODETORUN=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	echo '#!/bin/bash' | sudo tee -a $BASE/tmp/$ALLINCLUSIVEFINALCODETORUN > /dev/null
	sudo chmod 777 	$BASE/tmp/$ALLINCLUSIVEFINALCODETORUN
	echo '' | sudo tee -a $BASE/tmp/$ALLINCLUSIVEFINALCODETORUN > /dev/null	
	echo 'declare -A PICRFCRONRESFILEOUTPUT' | sudo tee -a $BASE/tmp/$ALLINCLUSIVEFINALCODETORUN > /dev/null
	echo 'declare -A PICRFCRONRESFILEAUTHOUTPUT' | sudo tee -a $BASE/tmp/$ALLINCLUSIVEFINALCODETORUN > /dev/null
	echo 'declare -A PICRFCRONRESFILELOCOUTPUT' | sudo tee -a $BASE/tmp/$ALLINCLUSIVEFINALCODETORUN > /dev/null
	echo 'declare -A PICRF1234' | sudo tee -a $BASE/tmp/$ALLINCLUSIVEFINALCODETORUN > /dev/null
	echo 'declare -A PICRF5678' | sudo tee -a $BASE/tmp/$ALLINCLUSIVEFINALCODETORUN > /dev/null	
	echo 'THEFILETOLOOKUP="'"$THESTACKFILE"'"' | sudo tee -a $BASE/tmp/$ALLINCLUSIVEFINALCODETORUN > /dev/null			
	#echo 'PICRFCRFO="ERROR"' | sudo tee -a $BASE/tmp/$ALLINCLUSIVEFINALCODETORUN > /dev/null
	echo '' | sudo tee -a $BASE/tmp/$ALLINCLUSIVEFINALCODETORUN > /dev/null
		
	ALLINCLUSIVE2FINALCODETORUN=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	echo '' | sudo tee -a $BASE/tmp/$ALLINCLUSIVE2FINALCODETORUN > /dev/null
	#echo 'sleep 20' | sudo tee -a $BASE/tmp/$ALLINCLUSIVE2FINALCODETORUN > /dev/null	
	sudo chmod 777 	$BASE/tmp/$ALLINCLUSIVE2FINALCODETORUN
	echo '' | sudo tee -a $BASE/tmp/$ALLINCLUSIVE2FINALCODETORUN > /dev/null	
	
	ALLINCLUSIVE3FINALCODETORUN=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
				
	header=$(head -n 1 $THESTACKFILE)
	csv_data=$(tail -n +2 $THESTACKFILE)
	json_data=$(echo "$csv_data" | awk -v header="$header" 'BEGIN { FS=","; OFS=","; split(header, keys, ","); print "[" } { print "{"; for (i=1; i<=NF; i++) { printf "\"%s\":\"%s\"", keys[i], $i; if (i < NF) printf ","; } print "},"; } END { print "{}]"; }' | sed '$s/,$//')
	filtered_json=$(echo "$json_data" | jq 'map(select(.IP != null and .IP != ""))')
	filtered_json2=$(echo "$filtered_json" | jq 'map(select(.IP == "TBD"))')
	
	# Input JSON data
	filtered_json_2=$(echo "$filtered_json" | jq 'map(select(.IP != "TBD"))')
	output__file=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)	
	output_file="$BASE/tmp/$output__file"
	header=$(echo "$filtered_json_2" | jq -r '.[0] | keys_unsorted | join(",")')
	echo "$header" > "$output_file"
	echo "$filtered_json_2" | jq -c '.[]' | while IFS= read -r obj; do
	    record=$(echo "$obj" | jq -r 'map(.) | @csv')
	    echo "$record" >> "$output_file"
	done	
	sudo chmod 777 $output_file
	echo 'THEFILE2TOLOOKUP="'"$output_file"'"' | sudo tee -a $BASE/tmp/$ALLINCLUSIVEFINALCODETORUN > /dev/null
	
	grouped_json=$(echo "$filtered_json2" | jq 'group_by(.Parent) | map({"Parent":.[0].Parent, "Count": length})')
	curdttm=$(date +"%d%m%y%H%M%S")
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
		scopeid="$scopeid-$curdttm"
		THEPARENTAUTHDETAILS="$pusername,$pport,$ppassword,$ppem"
		
		if (( COUNTER == 0 )) ; then
			sudo mkdir $BASE/tmp/"Scope$scopeid-WIP"
			sudo chmod -R 777 $BASE/tmp/"Scope$scopeid-WIP"
			sudo touch $BASE/tmp/"Scope$scopeid-WIP_"
			sudo chmod 777 $BASE/tmp/"Scope$scopeid-WIP_"

			sudo mkdir $BASE/tmp/"Scope$scopeid-SSH"
			sudo chmod -R 777 $BASE/tmp/"Scope$scopeid-SSH"
			
			echo '-----------------------'
			echo 'NEW SSH KEYS'
			echo '-----------------------'
			sudo -H -u root bash -c "cd $BASE/tmp/Scope$scopeid-SSH && echo -e  'y\n'|ssh-keygen -b 2048 -t rsa -P '' -f id_rsa && cat id_rsa.pub >> authorized_keys && cp id_rsa op-Scope$scopeid.pem && puttygen op-Scope$scopeid.pem -o op-Scope$scopeid.ppk && cd ~"
			sudo rm -rf $BASE/Output/Pem/op-Scope$scopeid.pem
			#sudo rm -rf $BASE/op-Scope$scopeid.ppk
			sudo mv $BASE/tmp/"Scope$scopeid-SSH"/op-Scope$scopeid.pem $BASE/Output/Pem
			#sudo mv $BASE/tmp/"Scope$scopeid-SSH"/op-Scope$scopeid.ppk $BASE
			sudo chmod u=rwx,g=rx,o=rx $BASE/Output/Pem/op-Scope$scopeid.pem
			#sudo chmod u=rwx,g=rx,o=rx $BASE/op-Scope$scopeid.ppk
			#sudo rm -rf $BASE/VagVBox/Scope$scopeid/Keys/authorized_keys
			#sudo rm -rf $BASE/VagVBox/Scope$scopeid/Keys/id_rsa
			sudo mv $BASE/tmp/"Scope$scopeid-SSH"/id_rsa.pub $BASE/Output/Pem/op-Scope$scopeid.pub	
			sudo chown -R root:root $BASE/Output/Pem/op-Scope$scopeid.pub
			sudo chmod -R u=rx,g=rx,o=rx $BASE/Output/Pem/op-Scope$scopeid.pub	
			sudo rm -rf $BASE/tmp/"Scope$scopeid-SSH"
			echo '-----------------------'				
		fi
		 
		__PICRFLOCATIONMAPPING=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
		_PICRFLOCATIONMAPPING="$BASE/Output/$__PICRFLOCATIONMAPPING"

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
				
		THECODETORUNFORONPREMISEDEPLOY=$(echo '#!/bin/bash'"

ROOTPWD=\$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
MATSYAPWD=\$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
VAGRANTPWD=\$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
UBUPWD=\$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
RANDOMSSHPORT=\$(shuf -i 45000-46000 -n 1)
FINALOUTPUTREQ=\"YES\"
FINALPROCESSOUTPUT=\"$_PICRFLOCATIONMAPPING\"
CLUSTER=\"Scope$scopeid\"
IPSTART=1
TOTALNOOFIPSREQ=\$(($count + 1))
BASE=\"$BASE\"
source $BASE/Resources/StackVersioningAndMisc
sudo mkdir -p $BASE
sudo mkdir -p $BASE/MN
sudo mkdir -p $BASE/mounts
sudo mkdir -p $BASE/Repo
sudo mkdir -p $BASE/tmp
sudo mkdir -p $BASE/VagVBox
sudo mkdir -p $BASE/Scripts
sudo mkdir -p $BASE/Secrets
sudo mkdir -p $BASE/Resources
sudo mkdir -p $BASE/Output
sudo mkdir -p $BASE/Output/Terraform
if [[ ! -d \"$BASE/Output/Pem\" ]]; then
	sudo mkdir -p $BASE/Output/Pem
	sudo chmod -R 777 $BASE/Output/Pem
fi
if [ -f /home/$pusername/Downloads/op-Scope$scopeid.pem ]; then
   sudo mv /home/$pusername/Downloads/op-Scope$scopeid.pem $BASE/Output/Pem/op-Scope$scopeid.pem
   sudo chmod u=rwx,g=rx,o=rx $BASE/Output/Pem/op-Scope$scopeid.pem
   sudo mv /home/$pusername/Downloads/op-Scope$scopeid.pub $BASE/Output/Pem/op-Scope$scopeid.pub
   sudo chmod u=rwx,g=rx,o=rx $BASE/Output/Pem/op-Scope$scopeid.pub
   sudo chown -R root:root $BASE/Output/Pem/op-Scope$scopeid.pub
   sudo chmod -R u=rx,g=rx,o=rx $BASE/Output/Pem/op-Scope$scopeid.pub      
fi
GETMEUNIQUEOUTPUTFILEIPS=\$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
GETMEUNIQUEIPS \"\$TOTALNOOFIPSREQ\" \"$nic\" \"$BASE/tmp/\$GETMEUNIQUEOUTPUTFILEIPS\"
GETMEUNIQUEOUTPUTIPS=\$(head -n 1 \"$BASE/tmp/\$GETMEUNIQUEOUTPUTFILEIPS\")
sudo rm -rf $BASE/tmp/\$GETMEUNIQUEOUTPUTFILEIPS
sudo mkdir -p $BASE/Output/Scope$scopeid-CDR
sudo chmod -R 777 $BASE/Output/Scope$scopeid-CDR
echo \"=========== READY TO RUN ===========\"
nohup $BASE/Scripts/Vagrant-VirtualBox.sh \"$BASE├\$CLUSTER├c├0├\$TOTALNOOFIPSREQ├$THESETUPMODE├c├2048,1,50|$only3from_filtered_json2_otherinfo├c├$nic├$gateway├$netmask├\$IPSTART├c├$BASE/Output/Scope$scopeid-CDR,$the4thfrom_filtered_json2_otherinfo├n├\$ROOTPWD├\$MATSYAPWD├\$VAGRANTPWD├├\$RANDOMSSHPORT├\$FINALOUTPUTREQ├\$FINALPROCESSOUTPUT├\$GETMEUNIQUEOUTPUTIPS├IDCDR,$__filtered_json2_identity├NO├ISSAMEASHOST├$THEPARENTAUTHDETAILS\" > $BASE/tmp/Scope$scopeid-JOBLOG3.out 2>&1 &
")
		CONSIDERTHISMACHINE="YES"
		if [ -z "$only3from_filtered_json2_otherinfo" ] || [ -z "$the4thfrom_filtered_json2_otherinfo" ]; then
		    CONSIDERTHISMACHINE="NO"
		fi
		
		if [ "$CONSIDERTHISMACHINE" == "YES" ] ; then
			ISTHISSAMEMACHINE="NO"
			ip_addresses=$(ip addr show | grep -Po 'inet \K[\d.]+')
			if echo "$ip_addresses" | grep -qw "$parent"; then
			    	ISTHISSAMEMACHINE="YES"
			    	THEMACHINEFROMWHEREITALLSTARTED="$parent"
			    	THECODETORUNFORONPREMISEDEPLOY=$(echo "$THECODETORUNFORONPREMISEDEPLOY" | sed "s|ISSAMEASHOST|YES|")
			else
				THECODETORUNFORONPREMISEDEPLOY=$(echo "$THECODETORUNFORONPREMISEDEPLOY" | sed "s|ISSAMEASHOST|NO|")			
			fi
											
			__PICRFSCRIPTMAPPING=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
			_PICRFSCRIPTMAPPING="$BASE/tmp/$__PICRFSCRIPTMAPPING"
			echo "$THECODETORUNFORONPREMISEDEPLOY" | sudo tee $BASE/tmp/$__PICRFSCRIPTMAPPING > /dev/null		
			sudo chmod 777 $BASE/tmp/$__PICRFSCRIPTMAPPING
							
			__PICRFSCRIPTLOGGING=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
			THECODETORUNFORONPREMISECRON=$(echo '#!/bin/bash'"

SCRIPT_PATH=\"THEACTUALSCRIPTFILEPATH\"
sudo chmod 777 THEACTUALSCRIPTFILEPATH
nohup THEACTUALSCRIPTFILEPATH > $BASE/tmp/Scope$scopeid-JOBLOG2.out 2>&1 &
#echo \"THEACTUALSCRIPTFILEPATH\" > THEACTUALSCRIPTFILECRONRESPATH
#SCHEDULE_TIME=\$(date -d \"+10 seconds\" +\"%H:%M %b %d %Y\")
#OUTPUT=\$(echo \"\$SCRIPT_PATH\" | at \"\$SCHEDULE_TIME\" 2>&1)
#if [ \$? -eq 0 ]; then
#    JOB_ID=\$(echo \"\$OUTPUT\" | awk '{print \$2}')
#    echo \"Script scheduled for execution at \$SCHEDULE_TIME with job ID \$JOB_ID\"
#    echo \"\$JOB_ID\" > THEACTUALSCRIPTFILECRONRESPATH
#else
#    echo \"Error: Unable to schedule the script for execution.\"
#    echo \"Reason: \$OUTPUT\"
#    echo \"ERROR\" > THEACTUALSCRIPTFILECRONRESPATH
#fi
")
			
			__PICRFSCRIPTCROND=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
			_PICRFSCRIPTCROND="$BASE/tmp/$__PICRFSCRIPTCROND"			

			__PICRFSCRIPTCRONRESD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
						
			if [ "$ISTHISSAMEMACHINE" == "NO" ] ; then
				ISREMOTEMACHINEPINGING="NO"
				ping -c 3 $parent > /dev/null
				if [ $? -eq 0 ]; then
					ISREMOTEMACHINEPINGING="YES"
				fi
				
				if [ "$ISREMOTEMACHINEPINGING" == "YES" ] ; then
					$BASE/Scripts/Vagrant-VirtualBox-Prerequisites-Sync.sh $parent■$pusername■$pport■$ppassword■$ppem■$BASE
					
					PICRFSCRIPTMAPPING[$parent]="/home/$pusername/Downloads/$__PICRFSCRIPTMAPPING"
					PICRFLOCATIONMAPPING[$parent]="$_PICRFLOCATIONMAPPING"
					
					MAINFILECOPYRESULT="NO"
					if [ "$ppem" == "NA" ] ; then
						sshpass -p "$ppassword" ssh -p "$pport" -o StrictHostKeyChecking=no "$pusername@$parent" "sudo apt-get -y install ant curl git ipcalc ipset iptables jq mc nano nmap openssl parallel pv socat ssh sshpass ufw wget lsof putty pv rsync putty-tools cron at"
						
						sshpass -p "$ppassword" scp -o StrictHostKeyChecking=no -P $pport "$BASE/tmp/$__PICRFSCRIPTMAPPING" "$pusername@$parent:/home/$pusername/Downloads"
						sshpass -p "$ppassword" scp -o StrictHostKeyChecking=no -P $pport "$BASE/Output/Pem/op-Scope$scopeid.pem" "$pusername@$parent:/home/$pusername/Downloads"
						sshpass -p "$ppassword" scp -o StrictHostKeyChecking=no -P $pport "$BASE/Output/Pem/op-Scope$scopeid.pub" "$pusername@$parent:/home/$pusername/Downloads"

						if [ $? -eq 0 ]; then
						    PICRFSCRIPTCOPY[$parent]="YES"
						    sudo rm -rf $BASE/tmp/$__PICRFSCRIPTMAPPING
						    MAINFILECOPYRESULT="YES"
						else
						    PICRFSCRIPTCOPY[$parent]="NO"
						fi					
					else
						ssh -p "$pport" -o StrictHostKeyChecking=no -i "$ppem" "$pusername@$parent" "sudo apt-get -y install ant curl git ipcalc ipset iptables jq mc nano nmap openssl parallel pv socat ssh sshpass ufw wget lsof putty pv rsync putty-tools cron at"
						
						scp -i "$ppem" -o StrictHostKeyChecking=no -P $pport "$BASE/tmp/$__PICRFSCRIPTMAPPING" "$pusername@$parent:/home/$pusername/Downloads"
						scp -i "$ppem" -o StrictHostKeyChecking=no -P $pport "$BASE/Output/Pem/op-Scope$scopeid.pem" "$pusername@$parent:/home/$pusername/Downloads"
						scp -i "$ppem" -o StrictHostKeyChecking=no -P $pport "$BASE/Output/Pem/op-Scope$scopeid.pub" "$pusername@$parent:/home/$pusername/Downloads"
						
						if [ $? -eq 0 ]; then
							PICRFSCRIPTCOPY[$parent]="YES"
							sudo rm -rf $BASE/tmp/$__PICRFSCRIPTMAPPING
							MAINFILECOPYRESULT="YES"
						else
							PICRFSCRIPTCOPY[$parent]="NO"
						fi					
					fi
					
					if [ "$MAINFILECOPYRESULT" == "YES" ] ; then
						THECODETORUNFORONPREMISECRON=$(echo "$THECODETORUNFORONPREMISECRON" | sed "s|THEACTUALSCRIPTFILEPATH|/home/$pusername/Downloads/$__PICRFSCRIPTMAPPING|")
						THECODETORUNFORONPREMISECRON=$(echo "$THECODETORUNFORONPREMISECRON" | sed "s|THEACTUALSCRIPTFILECRONRESPATH|/home/$pusername/Downloads/$__PICRFSCRIPTCRONRESD|")
						echo "$THECODETORUNFORONPREMISECRON" | sudo tee $BASE/tmp/$__PICRFSCRIPTCROND > /dev/null
											
						if [ "$ppem" == "NA" ] ; then
							sshpass -p "$ppassword" scp -o StrictHostKeyChecking=no -P $pport "$BASE/tmp/$__PICRFSCRIPTCROND" "$pusername@$parent:/home/$pusername/Downloads"
							if [ $? -eq 0 ]; then
							    	PICRFCRONCOPY[$parent]="YES"
							    	sudo rm -rf $BASE/tmp/$__PICRFSCRIPTCROND		
								PICRFCRONFILE[$parent]="/home/$pusername/Downloads/$__PICRFSCRIPTCROND"
								PICRFCRONCOPY[$parent]="YES"
								PICRFCRONRESFILE[$parent]="/home/$pusername/Downloads/$__PICRFSCRIPTCRONRESD"		
								echo "sshpass -p \"$ppassword\" ssh -p \"$pport\" -o StrictHostKeyChecking=no \"$pusername@$parent\" \"sudo chmod 777 /home/$pusername/Downloads/$__PICRFSCRIPTMAPPING && sudo chmod 777 /home/$pusername/Downloads/$__PICRFSCRIPTCROND && sudo mkdir -p $BASE/tmp && sudo chmod -R 777 $BASE/tmp && nohup /home/$pusername/Downloads/$__PICRFSCRIPTCROND > $BASE/tmp/Scope$scopeid-JOBLOG1.out 2>&1 &\"" | sudo tee -a $BASE/tmp/$ALLINCLUSIVEFINALCODETORUN > /dev/null
								#echo "PICRFCRFO=\$(sshpass -p \"$ppassword\" ssh -p \"$pport\" -o StrictHostKeyChecking=no \"$pusername@$parent\" \"sed -n 2p /home/$pusername/Downloads/$__PICRFSCRIPTCRONRESD\")" | sudo tee -a $BASE/tmp/$ALLINCLUSIVE2FINALCODETORUN > /dev/null	
								echo "PICRFCRONRESFILEOUTPUT[\"$parent\"]=\"$BASE/tmp/Scope$scopeid-JOBLOG3.out\"" | sudo tee -a $BASE/tmp/$ALLINCLUSIVE2FINALCODETORUN > /dev/null
								echo "PICRFCRONRESFILEAUTHOUTPUT[\"$parent\"]=\"UP■$pusername■$pport■$ppassword\"" | sudo tee -a $BASE/tmp/$ALLINCLUSIVE2FINALCODETORUN > /dev/null
								echo "PICRFCRONRESFILELOCOUTPUT[\"$parent\"]=\"$_PICRFLOCATIONMAPPING\"" | sudo tee -a $BASE/tmp/$ALLINCLUSIVE2FINALCODETORUN > /dev/null
								echo "PICRF1234[\"$parent\"]=\"/home/$pusername/Downloads/$__PICRFSCRIPTMAPPING\"" | sudo tee -a $BASE/tmp/$ALLINCLUSIVE2FINALCODETORUN > /dev/null
								echo "PICRF5678[\"$parent\"]=\"/home/$pusername/Downloads/$__PICRFSCRIPTCROND\"" | sudo tee -a $BASE/tmp/$ALLINCLUSIVE2FINALCODETORUN > /dev/null
								IP_ADDRESS_HYPHEN_PARENT=${parent//./-} && echo "$IP_ADDRESS_HYPHEN_PARENT" | sudo tee -a $BASE/tmp/"Scope$scopeid-WIP_" > /dev/null				    
							else
							    	PICRFCRONCOPY[$parent]="NO"
							fi					
						else
							scp -i "$ppem" -o StrictHostKeyChecking=no -P $pport "$BASE/tmp/$__PICRFSCRIPTCROND" "$pusername@$parent:/home/$pusername/Downloads"
							if [ $? -eq 0 ]; then
								PICRFCRONCOPY[$parent]="YES"
								sudo rm -rf $BASE/tmp/$__PICRFSCRIPTCROND
								PICRFCRONFILE[$parent]="/home/$pusername/Downloads/$__PICRFSCRIPTCROND"
								PICRFCRONCOPY[$parent]="YES"
								PICRFCRONRESFILE[$parent]="/home/$pusername/Downloads/$__PICRFSCRIPTCRONRESD"
								echo "ssh -p \"$pport\" -o StrictHostKeyChecking=no -i \"$ppem\" \"$pusername@$parent\" \"sudo chmod 777 /home/$pusername/Downloads/$__PICRFSCRIPTMAPPING && sudo chmod 777 /home/$pusername/Downloads/$__PICRFSCRIPTCROND && sudo mkdir -p $BASE/tmp && sudo chmod -R 777 $BASE/tmp && nohup /home/$pusername/Downloads/$__PICRFSCRIPTCROND > $BASE/tmp/Scope$scopeid-JOBLOG1.out 2>&1 &\"" | sudo tee -a $BASE/tmp/$ALLINCLUSIVEFINALCODETORUN > /dev/null
								#echo "PICRFCRFO=\$(ssh -p \"$pport\" -o StrictHostKeyChecking=no -i \"$ppem\" \"$pusername@$parent\" \"sed -n 2p /home/$pusername/Downloads/$__PICRFSCRIPTCRONRESD\")" | sudo tee -a $BASE/tmp/$ALLINCLUSIVE2FINALCODETORUN > /dev/null	
								echo "PICRFCRONRESFILEOUTPUT[\"$parent\"]=\"$BASE/tmp/Scope$scopeid-JOBLOG3.out\"" | sudo tee -a $BASE/tmp/$ALLINCLUSIVE2FINALCODETORUN > /dev/null
								echo "PICRFCRONRESFILEAUTHOUTPUT[\"$parent\"]=\"PEM■$pusername■$pport■$ppem\"" | sudo tee -a $BASE/tmp/$ALLINCLUSIVE2FINALCODETORUN > /dev/null
								echo "PICRFCRONRESFILELOCOUTPUT[\"$parent\"]=\"$_PICRFLOCATIONMAPPING\"" | sudo tee -a $BASE/tmp/$ALLINCLUSIVE2FINALCODETORUN > /dev/null
								echo "PICRF1234[\"$parent\"]=\"/home/$pusername/Downloads/$__PICRFSCRIPTMAPPING\"" | sudo tee -a $BASE/tmp/$ALLINCLUSIVE2FINALCODETORUN > /dev/null
								echo "PICRF5678[\"$parent\"]=\"/home/$pusername/Downloads/$__PICRFSCRIPTCROND\"" | sudo tee -a $BASE/tmp/$ALLINCLUSIVE2FINALCODETORUN > /dev/null
								IP_ADDRESS_HYPHEN_PARENT=${parent//./-} && echo "$IP_ADDRESS_HYPHEN_PARENT" | sudo tee -a $BASE/tmp/"Scope$scopeid-WIP_" > /dev/null
							else
								PICRFCRONCOPY[$parent]="NO"
							fi					
						fi					
					fi
				fi
			else
				PICRFSCRIPTCOPY[$parent]="YES"
				PICRFSCRIPTMAPPING[$parent]="$_PICRFSCRIPTMAPPING"
				PICRFLOCATIONMAPPING[$parent]="$_PICRFLOCATIONMAPPING"
				THECODETORUNFORONPREMISECRON=$(echo "$THECODETORUNFORONPREMISECRON" | sed "s|THEACTUALSCRIPTFILEPATH|$_PICRFSCRIPTMAPPING|")
				THECODETORUNFORONPREMISECRON=$(echo "$THECODETORUNFORONPREMISECRON" | sed "s|THEACTUALSCRIPTFILECRONRESPATH|$BASE/tmp/$__PICRFSCRIPTCRONRESD|")
				echo "$THECODETORUNFORONPREMISECRON" | sudo tee $BASE/tmp/$__PICRFSCRIPTCROND > /dev/null		
				sudo chmod 777 $BASE/tmp/$__PICRFSCRIPTCROND
				PICRFCRONFILE[$parent]="$BASE/tmp/$__PICRFSCRIPTCROND"
				PICRFCRONCOPY[$parent]="YES"
				PICRFCRONRESFILE[$parent]="$BASE/tmp/$__PICRFSCRIPTCRONRESD"
				echo "sudo chmod 777 $_PICRFSCRIPTMAPPING && sudo chmod 777 $BASE/tmp/$__PICRFSCRIPTCROND && sudo mkdir -p $BASE/tmp && sudo chmod -R 777 $BASE/tmp && nohup $BASE/tmp/$__PICRFSCRIPTCROND > $BASE/tmp/Scope$scopeid-JOBLOG1.out 2>&1 &" | sudo tee -a $BASE/tmp/$ALLINCLUSIVEFINALCODETORUN > /dev/null
				#echo "PICRFCRFO=\$(sed -n 2p $BASE/tmp/$__PICRFSCRIPTCRONRESD)" | sudo tee -a $BASE/tmp/$ALLINCLUSIVE2FINALCODETORUN > /dev/null
				echo "PICRFCRONRESFILEOUTPUT[\"$parent\"]=\"$BASE/tmp/Scope$scopeid-JOBLOG3.out\"" | sudo tee -a $BASE/tmp/$ALLINCLUSIVE2FINALCODETORUN > /dev/null
				if [ "$ppem" == "NA" ] ; then
					echo "PICRFCRONRESFILEAUTHOUTPUT[\"$parent\"]=\"UP■$pusername■$pport■$ppassword\"" | sudo tee -a $BASE/tmp/$ALLINCLUSIVE2FINALCODETORUN > /dev/null
				else	
					echo "PICRFCRONRESFILEAUTHOUTPUT[\"$parent\"]=\"PEM■$pusername■$pport■$ppem\"" | sudo tee -a $BASE/tmp/$ALLINCLUSIVE2FINALCODETORUN > /dev/null	
				fi
				echo "PICRFCRONRESFILELOCOUTPUT[\"$parent\"]=\"$_PICRFLOCATIONMAPPING\"" | sudo tee -a $BASE/tmp/$ALLINCLUSIVE2FINALCODETORUN > /dev/null
				echo "PICRF1234[\"$parent\"]=\"$_PICRFSCRIPTMAPPING\"" | sudo tee -a $BASE/tmp/$ALLINCLUSIVE2FINALCODETORUN > /dev/null	
				echo "PICRF5678[\"$parent\"]=\"$BASE/tmp/$__PICRFSCRIPTCROND\"" | sudo tee -a $BASE/tmp/$ALLINCLUSIVE2FINALCODETORUN > /dev/null
				IP_ADDRESS_HYPHEN_PARENT=${parent//./-} && echo "$IP_ADDRESS_HYPHEN_PARENT" | sudo tee -a $BASE/tmp/"Scope$scopeid-WIP_" > /dev/null																	
			fi
		fi
		
		#PICRFSTATUSCRONCOPY="NO"
		#PICRFSTATUSSCRIPTCOPY="NO"
		#if [ -v "PICRFCRONCOPY[$parent]" ]; then
		#	PICRFSTATUSCRONCOPY="${PICRFCRONCOPY[$parent]}"
		#fi
		#if [ -v "PICRFSCRIPTCOPY[$parent]" ]; then
		#	PICRFSTATUSSCRIPTCOPY="${PICRFSCRIPTCOPY[$parent]}"
		#fi
		#if [ "$PICRFSTATUSCRONCOPY" == "YES" ] && [ "$PICRFSTATUSSCRIPTCOPY" == "YES" ]; then
		#	
		#fi
				
		COUNTER=$((COUNTER + 1))		
	done
	COUNTER=0
	
	cat $BASE/tmp/$ALLINCLUSIVEFINALCODETORUN $BASE/tmp/$ALLINCLUSIVE2FINALCODETORUN > $BASE/tmp/$ALLINCLUSIVE3FINALCODETORUN
	sudo chmod 777 $BASE/tmp/$ALLINCLUSIVE3FINALCODETORUN
	sudo rm -rf $BASE/tmp/$ALLINCLUSIVEFINALCODETORUN
	sudo rm -rf $BASE/tmp/$ALLINCLUSIVE2FINALCODETORUN
	echo "" | sudo tee -a $BASE/tmp/$ALLINCLUSIVE3FINALCODETORUN > /dev/null
	echo '
CURRENTUSER=$(whoami)
sudo rm -rf /home/$CURRENTUSER/.ssh/known_hosts
sudo rm -rf /root/.ssh/known_hosts

THEMACHINEFROMWHEREITALLSTARTED="'"$THEMACHINEFROMWHEREITALLSTARTED"'"
	
# Continuously check for file existence and execute local script
while true; do
    # Loop through each server and file path
    for server in "${!PICRFCRONRESFILEOUTPUT[@]}"; do
        file="${PICRFCRONRESFILEOUTPUT[$server]}"
        auth_info="${PICRFCRONRESFILEAUTHOUTPUT[$server]}"
	therealfile="${PICRFCRONRESFILELOCOUTPUT[$server]}"
        thefilewhichran="${PICRF1234[$server]}"
	thefilewhichrun="${PICRF5678[$server]}"	
        # Extract authentication details
        IFS='"■"' read -r auth_type user port password_pem <<< "$auth_info"

        # Execute SSH command with appropriate authentication method
        if [ "$auth_type" == "UP" ]; then
            # Password authentication
            #echo "sshpass -p \"$password_pem\" ssh -p \"$port\" -o StrictHostKeyChecking=no \"$user@$server\""
            #if sshpass -p "$password_pem" ssh -o "StrictHostKeyChecking=no" -o "BatchMode yes" "$user@$server" "[ -f '"\$file"' ]"; then
            if sshpass -p "$password_pem" ssh -p "$port" -o StrictHostKeyChecking=no "$user@$server" "[ -f '"\$file"' ]"; then
                echo "File $file exists on server $server"
                unset PICRFCRONRESFILEOUTPUT["$server"]  # Remove the item from the list
                #nohup '"$BASE"'/Scripts/Vagrant-VirtualBox-Instance-Sync.sh "A" "$THEFILETOLOOKUP" "$server" "$auth_info" "$therealfile" "'"Scope$scopeid"'" > '"$BASE"'/tmp/JOBLOG4.out &
                nohup '"$BASE"'/Scripts/Vagrant-VirtualBox-Instance-Sync.sh "A" "$THEFILETOLOOKUP" "$server" "$auth_info" "$therealfile" "'"Scope$scopeid"'" "$thefilewhichran" "$thefilewhichrun" "$THEMACHINEFROMWHEREITALLSTARTED" "'"$BASE/tmp/Scope$scopeid-WIP"'" "$THEFILE2TOLOOKUP" 2>&1 &
            else
                echo "File $file does not exist on server $server"
            fi
        elif [ "$auth_type" == "PEM" ]; then
            # .pem key authentication
            #if ssh -i "$password_pem" -o "StrictHostKeyChecking=no" -o "BatchMode yes" "$user@$server" "[ -f '"\$file"' ]"; then
            if ssh -p "$port" -o StrictHostKeyChecking=no -i "$password_pem" "$user@$server" "[ -f '"\$file"' ]"; then
                echo "File $file exists on server $server"
                unset PICRFCRONRESFILEOUTPUT["$server"]  # Remove the item from the list
                #nohup '"$BASE"'/Scripts/Vagrant-VirtualBox-Instance-Sync.sh "A" "$THEFILETOLOOKUP" "$server" "$auth_info" "$therealfile" "'"Scope$scopeid"'" > '"$BASE"'/tmp/JOBLOG4.out &
                nohup '"$BASE"'/Scripts/Vagrant-VirtualBox-Instance-Sync.sh "A" "$THEFILETOLOOKUP" "$server" "$auth_info" "$therealfile" "'"Scope$scopeid"'" "$thefilewhichran" "$thefilewhichrun" "$THEMACHINEFROMWHEREITALLSTARTED" "'"$BASE/tmp/Scope$scopeid-WIP"'" "$THEFILE2TOLOOKUP" 2>&1 &
            else
                echo "File $file does not exist on server $server"
            fi
        fi
    done

    # Check if all tasks are completed
    if [ ${#PICRFCRONRESFILEOUTPUT[@]} -eq 0 ]; then
        echo "All tasks completed. Exiting..."
        #sudo rm -rf /tmp/JOBLOG4.out
        nohup '"$BASE"'/Scripts/Vagrant-VirtualBox-Instance-Sync.sh "B" "'"$BASE"'/tmp/Scope'"$scopeid"'-WIP_" "'"$BASE"'/tmp/Scope'"$scopeid"'-WIP" "'"$THEVISIONKEY"'" "$THEFILETOLOOKUP" "$THEFILE2TOLOOKUP" 2>&1 &
        break
    fi

    # Sleep for 1 minute before checking again
    sleep 10
done

sudo rm -rf '"$BASE/tmp/$ALLINCLUSIVE3FINALCODETORUN"'
' | sudo tee -a $BASE/tmp/$ALLINCLUSIVE3FINALCODETORUN > /dev/null
	
	#echo "File To Run : $BASE/tmp/$ALLINCLUSIVE3FINALCODETORUN"
		
	#echo "PICRFCRONCOPY"		
	#for key in "${!PICRFCRONCOPY[@]}"; do
	#    echo "Key: $key, Value: ${PICRFCRONCOPY[$key]}"
	#done
	#echo "PICRFCRONFILE"
	#for key in "${!PICRFCRONFILE[@]}"; do
	#    echo "Key: $key, Value: ${PICRFCRONFILE[$key]}"
	#done
	#echo "PICRFCRONRESFILE"
	#for key in "${!PICRFCRONRESFILE[@]}"; do
	#    echo "Key: $key, Value: ${PICRFCRONRESFILE[$key]}"
	#done
	#echo "PICRFSCRIPTCOPY"
	#for key in "${!PICRFSCRIPTCOPY[@]}"; do
	#    echo "Key: $key, Value: ${PICRFSCRIPTCOPY[$key]}"
	#done
	#echo "PICRFSCRIPTMAPPING"
	#for key in "${!PICRFSCRIPTMAPPING[@]}"; do
	#    echo "Key: $key, Value: ${PICRFSCRIPTMAPPING[$key]}"
	#done
	#echo "PICRFLOCATIONMAPPING"
	#for key in "${!PICRFLOCATIONMAPPING[@]}"; do
	#    echo "Key: $key, Value: ${PICRFLOCATIONMAPPING[$key]}"
	#done
	
	$BASE/tmp/$ALLINCLUSIVE3FINALCODETORUN				
fi
		
