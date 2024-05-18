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

if [[ ! -d "$BASE/Output/Scope" ]]; then
	sudo mkdir -p $BASE/Output/Scope
	sudo chmod -R 777 $BASE/Output/Scope
fi

if [[ ! -d "$BASE/Output/Vision" ]]; then
	sudo mkdir -p $BASE/Output/Vision
	sudo chmod -R 777 $BASE/Output/Vision
fi

if [[ ! -d "$BASE/Resources/Terraform" ]]; then
	sudo mkdir -p $BASE/Resources/Terraform
	sudo chmod -R 777 $BASE/Resources/Terraform
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

if [ "$TASKIDENTIFIER" == "NARASIMHA" ] ; then
	THETASK=$2
	
	if [ "$THETASK" == "NewVisionKey" ] ; then
		NewVisionKey=$(NARASIMHA "newkey")
		echo "$NewVisionKey"
	fi
fi

if [ "$TASKIDENTIFIER" == "PARASHURAMA" ] ; then
	THEJSON=$2

	ScopeFile=$(jq -r '.ScopeFile' <<< "$THEJSON")
	VisionKey=$(jq -r '.VisionKey' <<< "$THEJSON")	
	Node=""
	while IFS= read -r line; do
	    Node+="|$line"
	done < <(jq -r '.Node[] | "\(.ScopeId),\(.IdentityId)"' <<< "$THEJSON")
	ScpIdy=${Node#|}
	
	declare -A DiffInstanceTypes
	processed_combinations=()
	IFS='|' read -ra ScpIdyArray <<< "$ScpIdy"
	for item in "${ScpIdyArray[@]}"; do
	    if [[ " ${processed_combinations[@]} " =~ " $item " ]]; then
		continue
	    fi
	    
	    processed_combinations+=("$item")
	    
	    ScopeId=$(echo "$item" | cut -d ',' -f1)
	    Identity=$(echo "$item" | cut -d ',' -f2)
	    
	    InstanceType=$(grep "^$ScopeId,$Identity" "$ScopeFile" | cut -d ',' -f3)
	    
	    if [ -n "$InstanceType" ]; then
		if [[ -v DiffInstanceTypes["$InstanceType"] ]]; then
		    DiffInstanceTypes["$InstanceType"]+="|$item"
		else
		    DiffInstanceTypes["$InstanceType"]="$item"
		fi
	    fi
	done

	for key in "${!DiffInstanceTypes[@]}"; do
	    	#echo "InstanceType: $key, ScpIdy items: ${DiffInstanceTypes["$key"]}"
		if [ "$key" == "onprem1" ] ; then
			#echo "sudo $BASE/Scripts/Vagrant-VirtualBox.sh \"D\" \"$ScopeFile\" \"$VisionKey\" \"${DiffInstanceTypes["$key"]}\""
			nohup sudo $BASE/Scripts/Vagrant-VirtualBox.sh "D" "$ScopeFile" "$VisionKey" "${DiffInstanceTypes["$key"]}" 2>&1 &
		fi
		
		if [ "$key" == "gcp" ] ; then
			echo "gcp : ${DiffInstanceTypes["$key"]}"
		fi
		
		if [ "$key" == "aws" ] ; then
			#echo "aws : ${DiffInstanceTypes["$key"]}"
			$BASE/Scripts/ActionRUN.sh "AWS_IDENTITY_DELETE" "${DiffInstanceTypes["$key"]}" "$ScopeFile" "$VisionKey"
		fi
		
		if [ "$key" == "azure" ] ; then
			echo "azure : ${DiffInstanceTypes["$key"]}"
		fi
		
		if [ "$key" == "e2e" ] ; then
			echo "e2e : ${DiffInstanceTypes["$key"]}"
		fi			    
	done	
fi

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
	THEJSON=$2

	THESTACKFILE=$(jq -r '.ScopeFile' <<< "$THEJSON")
	THEVISIONKEY=$(jq -r '.VisionKey' <<< "$THEJSON")
	THEVISIONID=$(jq -r '.VisionId' <<< "$THEJSON")
		
	ALLWORKFOLDER=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	sudo mkdir $BASE/tmp/$ALLWORKFOLDER
	sudo chmod -R 777 $BASE/tmp/$ALLWORKFOLDER
	sudo cp $THESTACKFILE $BASE/tmp/$ALLWORKFOLDER
	THESTACK1_FILE=$(basename $THESTACKFILE)
	THESTACK1FILE="$BASE/tmp/$ALLWORKFOLDER/$THESTACK1_FILE"
	sudo chmod 777 $THESTACK1FILE	
	
	# SANITIZE ORIGINAL FILE
	header=$(head -n 1 $THESTACK1FILE)
	csv_data=$(tail -n +2 $THESTACK1FILE)
	json1_data=$(echo "$csv_data" | awk -v header="$header" 'BEGIN { FS=","; OFS=","; split(header, keys, ","); print "[" } { print "{"; for (i=1; i<=NF; i++) { printf "\"%s\":\"%s\"", keys[i], $i; if (i < NF) printf ","; } print "},"; } END { print "{}]"; }' | sed '$s/,$//')
	filter1ed_json=$(echo "$json1_data" | jq 'map(select(.IP != null and .IP != ""))')

	THESANITIZEDREALFILE__file=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)	
	THESANITIZEDREALFILE_file="$BASE/tmp/$ALLWORKFOLDER/$THESANITIZEDREALFILE__file"
	header=$(echo "$filter1ed_json" | jq -r '.[0] | keys_unsorted | join(",")')
	echo "$header" > "$THESANITIZEDREALFILE_file"
	echo "$filter1ed_json" | jq -c '.[]' | while IFS= read -r obj; do
	    record=$(echo "$obj" | jq -r 'map(.) | @csv')
	    echo "$record" >> "$THESANITIZEDREALFILE_file"
	done	
	sudo chmod 777 $THESANITIZEDREALFILE_file
	sed -i 's/""//g' "$THESANITIZEDREALFILE_file"
	sed -i 's/"//g' "$THESANITIZEDREALFILE_file"
	sudo rm -f $THESTACKFILE
	sudo mv $THESANITIZEDREALFILE_file $THESTACKFILE
	# SANITIZE ORIGINAL FILE
		
	# CREATE FILE WHERE IP IS NOT TBD
	filter1ed_json_2=$(echo "$filter1ed_json" | jq 'map(select(.IP != "TBD"))')
	out1put__file=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)	
	out1put_file="$BASE/tmp/$ALLWORKFOLDER/$out1put__file"
	header=$(echo "$filter1ed_json_2" | jq -r '.[0] | keys_unsorted | join(",")')
	echo "$header" > "$out1put_file"
	echo "$filter1ed_json_2" | jq -c '.[]' | while IFS= read -r obj; do
	    record=$(echo "$obj" | jq -r 'map(.) | @csv')
	    echo "$record" >> "$out1put_file"
	done	
	sudo chmod 777 $out1put_file
	sed -i 's/""//g' "$out1put_file"
	sed -i 's/"//g' "$out1put_file"	
	# CREATE FILE WHERE IP IS NOT TBD
	
	# CREATE FILE WHERE IP IS TBD
	filter1ed1_json_2=$(echo "$filter1ed_json" | jq 'map(select(.IP == "TBD"))')
	out1put1__file=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)	
	out1put1_file="$BASE/tmp/$ALLWORKFOLDER/$out1put1__file"
	echo "$header" > "$out1put1_file"
	echo "$filter1ed1_json_2" | jq -c '.[]' | while IFS= read -r obj; do
	    record=$(echo "$obj" | jq -r 'map(.) | @csv')
	    echo "$record" >> "$out1put1_file"
	done	
	sudo chmod 777 $out1put1_file
	sed -i 's/""//g' "$out1put1_file"
	sed -i 's/"//g' "$out1put1_file"	
	# CREATE FILE WHERE IP IS TBD
	
	# INSTANCE TYPE BASED FILE CREATION
	Scp1Idy=""
	Scp1Idy=$(awk -F ',' 'NR > 1 { Scp1Idy = Scp1Idy $1 "," $2 "|" } END { print Scp1Idy }' "$out1put1_file")
	Scp1Idy=${Scp1Idy%|}
	declare -A DiffInstanceTypes
	declare -A DiffFILESInstanceTypes
	processed_combinations=()
	read -r header < "$out1put1_file"
	IFS='|' read -ra Scp1IdyArray <<< "$Scp1Idy"
	for item in "${Scp1IdyArray[@]}"; do
	    if [[ " ${processed_combinations[@]} " =~ " $item " ]]; then
		continue
	    fi
	    processed_combinations+=("$item")
	    ScopeId=$(echo "$item" | cut -d ',' -f1)
	    Identity=$(echo "$item" | cut -d ',' -f2)
	    line=$(grep "^$ScopeId,$Identity" "$out1put1_file")
	    if [ -n "$line" ]; then
		InstanceType=$(echo "$line" | cut -d ',' -f3)
		if [[ -v DiffInstanceTypes["$InstanceType"] ]]; then
		    DiffInstanceTypes["$InstanceType"]+="|$line"
		else
		    DiffInstanceTypes["$InstanceType"]="$line"
		fi
	    fi
	done
	for key in "${!DiffInstanceTypes[@]}"; do
	    out1put1_file_inst=$(basename $out1put1_file)
	    file_name="${key}_${out1put1_file_inst}"
	    out1put1_dir_inst=$(dirname "$out1put1_file")
	    file_name="$out1put1_dir_inst/$file_name.csv"
	    DiffFILESInstanceTypes["$key"]="$file_name"
	    if [ "$key" != "onprem" ] ; then
	    	echo "$header" > "$file_name"
	    fi
	    echo "${DiffInstanceTypes["$key"]}" | tr '|' '\n' >> "$file_name"	    
	    #echo "Created file: $file_name"
	    if [ "$key" == "onprem" ] ; then
	    	temp_file=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	    	cat "$out1put_file" "$file_name" > $BASE/tmp/$ALLWORKFOLDER/$temp_file
	    	sudo chmod 777 $BASE/tmp/$ALLWORKFOLDER/$temp_file
	    	sudo rm -f $file_name
	    	sudo mv "$BASE/tmp/$ALLWORKFOLDER/$temp_file" "$file_name"
	    fi	    
	done
	sudo rm -f $THESTACK1FILE
	sudo rm -f $out1put_file
	sudo rm -f $out1put1_file
	
	THEFILEFORNEWVAL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	sudo touch $BASE/tmp/$THEFILEFORNEWVAL
	sudo chmod 777 $BASE/tmp/$THEFILEFORNEWVAL 	
	CSVFILE_ENC_DYC "$THESTACKFILE" "6,12,13,14,15,23,24,25,26" "27" "Y" "encrypt" "$THEVISIONKEY" "1" "27" "$BASE/tmp/$THEFILEFORNEWVAL"
	sudo rm -f $THESTACKFILE
	sudo mv $BASE/tmp/$THEFILEFORNEWVAL $THESTACKFILE	
	# INSTANCE TYPE BASED FILE CREATION
	
	# INSTANCE TYPE BASED FILE ACTION
	sudo chmod -R 777 $BASE/tmp/$ALLWORKFOLDER

	ALL1WORK=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	sudo mkdir $BASE/tmp/$ALLWORKFOLDER/"$ALL1WORK-WIP"
	sudo chmod -R 777 $BASE/tmp/$ALLWORKFOLDER/"$ALL1WORK-WIP"
	sudo touch $BASE/tmp/$ALLWORKFOLDER/"$ALL1WORK-WIP_"
	sudo chmod 777 $BASE/tmp/$ALLWORKFOLDER/"$ALL1WORK-WIP_"
	ALLWORKFOLDERSYNC="$BASE/tmp/$ALLWORKFOLDER/$ALL1WORK-WIP"
	ALLWORKFILESYNC="$BASE/tmp/$ALLWORKFOLDER/$ALL1WORK-WIP_"
	
	for THEWORK_FILE in "${!DiffFILESInstanceTypes[@]}"; do
		THEWORKFILE="${DiffFILESInstanceTypes["$THEWORK_FILE"]}"
		
		if [ "$THEWORK_FILE" == "onprem" ] ; then
			echo "onprem : $THEWORKFILE"
			#nohup $BASE/Scripts/MAYADHI.sh 'ONPREMVVB' '{"ScopeFile": "'"$THEWORKFILE"'","VisionKey": "'"$THEVISIONKEY"'"}' 2>&1 &
		fi
				
		if [ "$THEWORK_FILE" == "gcp" ] ; then
			echo "gcp : $THEWORKFILE"
		fi
		
		if [ "$THEWORK_FILE" == "aws" ] ; then
			echo "aws : $THEWORKFILE"
			RNDAWSXM=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
			echo "$ALLWORKFOLDERSYNC/$RNDAWSXM" | sudo tee -a $ALLWORKFILESYNC > /dev/null			
			$BASE/Scripts/MAYADHI.sh 'aws' '{"ScopeFile": "'"$THEWORKFILE"'","VisionKey": "'"$THEVISIONKEY"'", "VisionId": "'"$THEVISIONID"'", "RealFile": "'"$THESTACKFILE"'", "AllWorkFolder": "'"$ALLWORKFOLDERSYNC"'", "AllWorkFile": "'"$RNDAWSXM"'"}'
		fi
		
		if [ "$THEWORK_FILE" == "azure" ] ; then
			echo "azure : $THEWORKFILE"
		fi
		
		if [ "$THEWORK_FILE" == "e2e" ] ; then
			echo "e2e : $THEWORKFILE"
		fi		
	done	
	# INSTANCE TYPE BASED FILE ACTION
	
	nohup $BASE/Scripts/Cloud-Instance-Sync.sh "B" "$BASE/tmp/$ALLWORKFOLDER" "$ALLWORKFOLDERSYNC" "$ALLWORKFILESYNC" "$THESTACKFILE" "$THEVISIONKEY" 2>&1 &		
fi

if [ "$TASKIDENTIFIER" == "aws" ] ; then
	THEJSON=$2

	THESTACKAWSFILE=$(jq -r '.ScopeFile' <<< "$THEJSON")
	THEVISIONKEY=$(jq -r '.VisionKey' <<< "$THEJSON")
	THEVISIONID=$(jq -r '.VisionId' <<< "$THEJSON")	
	THESTACKREALFILE=$(jq -r '.RealFile' <<< "$THEJSON")
	ALLWORKFOLDER1SYNC=$(jq -r '.AllWorkFolder' <<< "$THEJSON")	
	RNDAWS1XM=$(jq -r '.AllWorkFile' <<< "$THEJSON")
		
	THESTACKFOLDERAWS=$(dirname "$THESTACKAWSFILE")
	sudo mkdir $THESTACKFOLDERAWS/"$TASKIDENTIFIER-WIP"
	sudo chmod -R 777 $THESTACKFOLDERAWS/"$TASKIDENTIFIER-WIP"
	sudo touch $THESTACKFOLDERAWS/"$TASKIDENTIFIER-WIP_"
	sudo chmod 777 $THESTACKFOLDERAWS/"$TASKIDENTIFIER-WIP_"
	THESTACKFOLDERSYNC="$THESTACKFOLDERAWS/$TASKIDENTIFIER-WIP"
	THESTACKFILESYNC="$THESTACKFOLDERAWS/$TASKIDENTIFIER-WIP_"
	
	if [[ ! -d "$BASE/Output/Vision/V$THEVISIONID" ]]; then
		sudo mkdir -p "$BASE/Output/Vision/V$THEVISIONID"
		sudo chmod -R 777 "$BASE/Output/Vision/V$THEVISIONID"
	fi
	sudo mkdir -p "$BASE/Output/Vision/V$THEVISIONID/$TASKIDENTIFIER"
	sudo chmod -R 777 "$BASE/Output/Vision/V$THEVISIONID/$TASKIDENTIFIER"
		
	THEVISIONFOLDER="$BASE/Output/Vision/V$THEVISIONID/$TASKIDENTIFIER"
	
	header=$(head -n 1 $THESTACKAWSFILE)
	csv_data=$(tail -n +2 $THESTACKAWSFILE)
	json_data=$(echo "$csv_data" | awk -v header="$header" 'BEGIN { FS=","; OFS=","; split(header, keys, ","); print "[" } { print "{"; for (i=1; i<=NF; i++) { printf "\"%s\":\"%s\"", keys[i], $i; if (i < NF) printf ","; } print "},"; } END { print "{}]"; }' | sed '$s/,$//')
	filtered_json=$(echo "$json_data" | jq 'map(select(.IP != null and .IP != ""))')
	filtered_json2=$(echo "$filtered_json" | jq 'map(select(.IP == "TBD"))')	
	newfiltered_json2_json=$(echo "$filtered_json2" | jq 'map((.OtherInfo | split("├")) as $info | .OtherInfo = ($info[0:2] + [.UserName, .OS] + $info[2:5] | join("├")))')

	THESANITIZEDREAL2FILE__file=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)	
	THESANITIZEDREAL2FILE_file="$BASE/tmp/$THESANITIZEDREAL2FILE__file"
	header=$(echo "$filtered_json2" | jq -r '.[0] | keys_unsorted | join(",")')
	echo "$header" > "$THESANITIZEDREAL2FILE_file"
	echo "$filtered_json2" | jq -c '.[]' | while IFS= read -r obj; do
	    record=$(echo "$obj" | jq -r 'map(.) | @csv')
	    echo "$record" >> "$THESANITIZEDREAL2FILE_file"
	done	
	sudo chmod 777 $THESANITIZEDREAL2FILE_file
	sed -i 's/""//g' "$THESANITIZEDREAL2FILE_file"
	sed -i 's/"//g' "$THESANITIZEDREAL2FILE_file"
	sudo rm -f $THESTACKAWSFILE
	sudo mv $THESANITIZEDREAL2FILE_file $THESTACKAWSFILE

	THEFILEFORNEWVAL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	sudo touch $BASE/tmp/$THEFILEFORNEWVAL
	sudo chmod 777 $BASE/tmp/$THEFILEFORNEWVAL 	
	CSVFILE_ENC_DYC "$THESTACKAWSFILE" "6,12,13,14,15,23,24,25,26" "27" "Y" "encrypt" "$THEVISIONKEY" "1" "27" "$BASE/tmp/$THEFILEFORNEWVAL"
	sudo rm -f $THESTACKAWSFILE
	sudo mv $BASE/tmp/$THEFILEFORNEWVAL $THESTACKAWSFILE
	
	declare -A RegionSeg
	while read -r line; do
		region=$(echo "$line" | jq -r '.OtherInfo | split("├")[4]')
		if [[ -z "${RegionSeg[$region]}" ]]; then
			RegionSeg[$region]="[$line"
		else
			RegionSeg[$region]+=", $line"
		fi
	done < <(echo "$newfiltered_json2_json" | jq -c '.[]')
	for key in "${!RegionSeg[@]}"; do
		RegionSeg[$key]+="]"
	done
	declare -A InstanceTFChoice
	for key in "${!RegionSeg[@]}"; do
		Instance1TFChoice=()
		#echo "Region: $key"
		regjson=$(echo "${RegionSeg[$key]}" | jq .)
		#echo "Items:"
		#echo "$regjson"
		while read -r line2; do	
			#echo "$line2"
			#other_info=$(echo $line2 | jq -r '.OtherInfo | split("├") | "\(.[0])├\(.[1])├\(.[4])├\(.[5])"')
			other_info=$(echo $line2 | jq -r '.OtherInfo')
			IFS='├' read -ra other1_info <<< "$other_info"
			the1region="${other1_info[4]}"
			the1zone="${other1_info[5]}"
			#echo "other_info : $other_info     -------    the1region : $the1region"
			secrets_key=$(echo $line2 | jq -r '.SecretsKey')
			secrets_file=$(echo $line2 | jq -r '.Secrets')
			Scope1Id=$(echo $line2 | jq -r '.ScopeId')
			Identity1Id=$(echo $line2 | jq -r '.Identity')			
			#line2reqval="${THEVISIONID}├${other_info}├${secrets_file}├${secrets_key}"
			#thevalhash=$(echo -n "$line2reqval" | md5sum | awk '{print $1}')
			line2reqval="${THEVISIONID}├${the1region}"
			line2req2val="${THEVISIONID}├${the1region}├${the1zone}"
			thevalhash=$(echo -n "$line2reqval" | md5sum | awk '{print $1}')
			theval2hash=$(echo -n "$line2req2val" | md5sum | awk '{print $1}')
			thevalhash="$TASKIDENTIFIER""$thevalhash"
			theval2hash="$TASKIDENTIFIER""$theval2hash"
			if [[ ! -f "$THEVISIONFOLDER/$theval2hash-z.tf" ]]; then
				sudo cp $BASE/Resources/TerraformTemplateSubnetAWS.tf $THEVISIONFOLDER/$theval2hash-z.tf
				InstanceTFChoice["$theval2hash"]="$theval2hash■0■0■$other_info■$secrets_file■$secrets_key■$THEVISIONFOLDER/$theval2hash-z.tf■ZONE■$thevalhash■$theval2hash"
			else
				thecopy1candidate=$(find $BASE/Output/Terraform -type f -name "*$theval2hash-z*" -print -quit)
				if [ -n "$thecopy1candidate" ]; then
					ABC="XYZ"
				else
					InstanceTFChoice["$theval2hash"]="$theval2hash■0■0■$other_info■$secrets_file■$secrets_key■$THEVISIONFOLDER/$theval2hash-z.tf■ZONE■$thevalhash■$theval2hash"
				fi			
			fi			
						
			CHOICEDONE="Z"
			
			if [[ ! -f "$THEVISIONFOLDER/$thevalhash-c.tf" ]]; then
				Aexists="NO"
				for element in "${Instance1TFChoice[@]}"; do
					if [[ "$element" == "A" ]]; then
						Aexists="YES"
						break
					fi
				done
				if [ "$Aexists" == "NO" ] ; then			
					sudo cp $BASE/Resources/TerraformTemplateCoreAWS.tf $THEVISIONFOLDER/$thevalhash-c.tf
					CHOICEDONE="A"
					Instance1TFChoice+=("$CHOICEDONE")
					InstanceTFChoice["$thevalhash"]="$thevalhash■0■0■$other_info■$secrets_file■$secrets_key■$THEVISIONFOLDER/$thevalhash-c.tf■NEW■$thevalhash■$theval2hash"
					CHOICEDONE="Z"
				fi
			else
				thecopycandidate=$(find $BASE/Output/Terraform -type f -name "*$thevalhash-c*" -print -quit)
				if [ -n "$thecopycandidate" ]; then
					if [ "$CHOICEDONE" == "Z" ] ; then				    
						CHOICEDONE="B"
						Instance1TFChoice+=("$CHOICEDONE")
					fi
				else
					if [ "$CHOICEDONE" == "Z" ] ; then
						Aexists="NO"
						for element in "${Instance1TFChoice[@]}"; do
							if [[ "$element" == "A" ]]; then
								Aexists="YES"
								break
							fi
						done
						Cexists="NO"
						for element in "${Instance1TFChoice[@]}"; do
							if [[ "$element" == "C" ]]; then
								Cexists="YES"
								break
							fi
						done						
						if [ "$Aexists" == "NO" ] ; then
							if [ "$Cexists" == "NO" ] ; then		
								CHOICEDONE="C"
								Instance1TFChoice+=("$CHOICEDONE")
								InstanceTFChoice["$thevalhash"]="$thevalhash■0■0■$other_info■$secrets_file■$secrets_key■$THEVISIONFOLDER/$thevalhash-c.tf■NEW■$thevalhash■$theval2hash"
								CHOICEDONE="Z"
							fi
						fi									    
					fi
				fi			
			fi
			#echo "CHOICEDONE1 : $CHOICEDONE"			
			if [[ ! -f "$THEVISIONFOLDER/$thevalhash-r.tf" ]]; then
				sudo cp $BASE/Resources/TerraformTemplateRepeatAWS.tf $THEVISIONFOLDER/$thevalhash-r.tf
				if [ "$CHOICEDONE" == "Z" ] || [ "$CHOICEDONE" == "B" ] ; then				    
					CHOICEDONE="D"
					Instance1TFChoice+=("$CHOICEDONE")
				fi
			else
				thecopy1candidate=$(find $BASE/Output/Terraform -type f -name "*$thevalhash-r*" -print -quit)
				if [ -n "$thecopy1candidate" ]; then
					if [ "$CHOICEDONE" == "Z" ] || [ "$CHOICEDONE" == "B" ] ; then				    
						CHOICEDONE="E"
						Instance1TFChoice+=("$CHOICEDONE")
					fi
				else
					if [ "$CHOICEDONE" == "Z" ] || [ "$CHOICEDONE" == "B" ] ; then				    
						CHOICEDONE="F"
						Instance1TFChoice+=("$CHOICEDONE")
					fi
				fi			
			fi
			#echo "CHOICEDONE2 : $CHOICEDONE"
			if [ "$CHOICEDONE" == "A" ] ; then
				InstanceTFChoice["$Scope1Id-$Identity1Id"]="$THEVISIONID■$Scope1Id■$Identity1Id■$other_info■$secrets_file■$secrets_key■$THEVISIONFOLDER/$thevalhash-c.tf■NEW■$thevalhash■$theval2hash"
			fi
			if [ "$CHOICEDONE" == "B" ] ; then
				InstanceTFChoice["$Scope1Id-$Identity1Id"]="$THEVISIONID■$Scope1Id■$Identity1Id■$other_info■$secrets_file■$secrets_key■$THEVISIONFOLDER/$thevalhash-r.tf■REPEAT■$thevalhash■$theval2hash"
			fi
			if [ "$CHOICEDONE" == "C" ] ; then
				InstanceTFChoice["$Scope1Id-$Identity1Id"]="$THEVISIONID■$Scope1Id■$Identity1Id■$other_info■$secrets_file■$secrets_key■$THEVISIONFOLDER/$thevalhash-c.tf■NEW■$thevalhash■$theval2hash"
			fi
			if [ "$CHOICEDONE" == "D" ] ; then
				InstanceTFChoice["$Scope1Id-$Identity1Id"]="$THEVISIONID■$Scope1Id■$Identity1Id■$other_info■$secrets_file■$secrets_key■$THEVISIONFOLDER/$thevalhash-r.tf■REPEAT■$thevalhash■$theval2hash"
			fi
			if [ "$CHOICEDONE" == "E" ] ; then
				InstanceTFChoice["$Scope1Id-$Identity1Id"]="$THEVISIONID■$Scope1Id■$Identity1Id■$other_info■$secrets_file■$secrets_key■$THEVISIONFOLDER/$thevalhash-r.tf■REPEAT■$thevalhash■$theval2hash"
			fi
			if [ "$CHOICEDONE" == "F" ] ; then
				InstanceTFChoice["$Scope1Id-$Identity1Id"]="$THEVISIONID■$Scope1Id■$Identity1Id■$other_info■$secrets_file■$secrets_key■$THEVISIONFOLDER/$thevalhash-r.tf■REPEAT■$thevalhash■$theval2hash"
			fi															
		done < <(echo "$regjson" | jq -c '.[]')	
		unset Instance1TFChoice		
	done
	
	AIFCTR=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	echo '#!/bin/bash' | sudo tee -a $BASE/tmp/$AIFCTR > /dev/null
	sudo chmod 777 	$BASE/tmp/$AIFCTR
	echo '' | sudo tee -a $BASE/tmp/$AIFCTR > /dev/null	
	
	THEREPEATITEMS=""
	THEZONEITEMS=""
	TERRAVFILETRACKING=()
	THEFIRSTTIME="YES"
	for key in "${!InstanceTFChoice[@]}"; do
		#echo "$key  :::::::: ${InstanceTFChoice[$key]}"	
		THEFULL_VALUE="${InstanceTFChoice[$key]}"
		IFS='■' read -ra THEFULLVALUE <<< "$THEFULL_VALUE"
		THEVAL1="${THEFULLVALUE[0]}"
		THEVAL2="${THEFULLVALUE[1]}"
		THEVAL3="${THEFULLVALUE[2]}"
		THEVAL4="${THEFULLVALUE[3]}"
		THEVAL4=$(echo "$THEVAL4" | sed 's/├/¬/g')
		THEVAL5="${THEFULLVALUE[4]}"
		THEVAL6="${THEFULLVALUE[5]}"
		THEVAL7="${THEFULLVALUE[6]}"												
		THEREQMODE="${THEFULLVALUE[7]}"
		THEVAL1HASH="${THEFULLVALUE[8]}"
		THEVAL3HASH="${THEFULLVALUE[9]}"
		
		RNDXM=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
						
		if [ "$THEREQMODE" == "NEW" ] ; then
			echo "$BASE"'/Scripts/MATSYA.sh "1¤'"$TASKIDENTIFIER"'¤'"$THEVAL7"'¤'"v$THEVAL1""s$THEVAL2""i$THEVAL3"'¤1¤'"$THEVAL4¬$THEVAL3HASH¬$THEVAL1HASH¬$THESTACKFOLDERSYNC¬$RNDXM"'¤'"$THEVAL5"'¬'"$THEVAL6"'" "'"cv$THEVAL1""s$THEVAL2""i$THEVAL3"'" "YES" 5 "'"$THEVISIONKEY"'" "'"$THEVAL1HASH"'"' | sudo tee -a $BASE/tmp/$AIFCTR > /dev/null
			echo '' | sudo tee -a $BASE/tmp/$AIFCTR > /dev/null
			TERRAVFILETRACKING+=("cv$THEVAL1""s$THEVAL2""i$THEVAL3")
		fi
		
		if [ "$THEREQMODE" == "REPEAT" ] ; then
			#if [ "$THEFIRSTTIME" == "YES" ] ; then
				#THEFIRSTTIME="NO"
				#RND2M1=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
				#THEREPEAT1ITEMS='1¤'"$TASKIDENTIFIER"'¤'"$THEVAL7"'¤'"v$THEVAL1""s$THEVAL2""i$THEVAL3"'¤1¤'"$THEVAL4¬$THEVAL3HASH¬$THEVAL1HASH¬$THESTACKFOLDERSYNC¬$RNDXM¬$THEVAL2¬$THEVAL3"'¤'"$THEVAL5"'¬'"$THEVAL6"'├'
				#echo "$BASE/Scripts/MATSYA.sh \"$THEREPEAT1ITEMS\" \"$RND2M1\" \"YES\" 5 \"$THEVISIONKEY\" \"$THEVAL1HASH\"" | sudo tee -a $BASE/tmp/$AIFCTR > /dev/null
				#echo '' | sudo tee -a $BASE/tmp/$AIFCTR > /dev/null				
				#TERRAVFILETRACKING+=("$RND2M1")				
			#else
				THEREPEATITEMS="$THEREPEATITEMS"'1¤'"$TASKIDENTIFIER"'¤'"$THEVAL7"'¤'"v$THEVAL1""s$THEVAL2""i$THEVAL3"'¤1¤'"$THEVAL4¬$THEVAL3HASH¬$THEVAL1HASH¬$THESTACKFOLDERSYNC¬$RNDXM¬$THEVAL2¬$THEVAL3"'¤'"$THEVAL5"'¬'"$THEVAL6"'├'
			#fi
			echo "$THESTACKFOLDERSYNC/$RNDXM" | sudo tee -a $THESTACKFILESYNC > /dev/null
		fi
		
		if [ "$THEREQMODE" == "ZONE" ] ; then
			THEZONEITEMS="$THEZONEITEMS"'1¤'"$TASKIDENTIFIER"'¤'"$THEVAL7"'¤'"v$THEVAL1""s$THEVAL2""i$THEVAL3"'¤1¤'"$THEVAL4¬$THEVAL3HASH¬$THEVAL1HASH¬$THESTACKFOLDERSYNC¬$RNDXM"'¤'"$THEVAL5"'¬'"$THEVAL6"'├'
		fi		
	done

	THEZONEITEMS="${THEZONEITEMS%├}"
	if [ "$THEZONEITEMS" != "" ] ; then
		RND1M1=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
		echo "$BASE/Scripts/MATSYA.sh \"$THEZONEITEMS\" \"$RND1M1\" \"YES\" 5 \"$THEVISIONKEY\" \"$THEVAL1HASH\"" | sudo tee -a $BASE/tmp/$AIFCTR > /dev/null
		echo '' | sudo tee -a $BASE/tmp/$AIFCTR > /dev/null	
		TERRAVFILETRACKING+=("$RND1M1")
	fi
	
	THEREPEATITEMS="${THEREPEATITEMS%├}"
	
	#if [ "$THEREPEAT1ITEMS" != "" ] ; then
	#	RND2M1=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	#	echo "$BASE/Scripts/MATSYA.sh \"$THEREPEAT1ITEMS\" \"$RND2M1\" \"YES\" 5 \"$THEVISIONKEY\" \"$THEVAL1HASH\"" | sudo tee -a $BASE/tmp/$AIFCTR > /dev/null
	#	echo '' | sudo tee -a $BASE/tmp/$AIFCTR > /dev/null	
	#	TERRAVFILETRACKING+=("$RND2M1")	
	#fi
	
	if [ "$THEREPEATITEMS" != "" ] ; then	
		RNDM1=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
		echo "$BASE/Scripts/MATSYA.sh \"$THEREPEATITEMS\" \"$RNDM1\" \"YES\" 5 \"$THEVISIONKEY\" \"$THEVAL1HASH\"" | sudo tee -a $BASE/tmp/$AIFCTR > /dev/null
		echo '' | sudo tee -a $BASE/tmp/$AIFCTR > /dev/null	
		TERRAVFILETRACKING+=("$RNDM1")
	fi
	
	RNDMJ1=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	echo "sudo rm -rf $BASE/tmp/$RNDMJ1-JOBLOG1.out" | sudo tee -a $BASE/tmp/$AIFCTR > /dev/null
	echo "sudo rm -f $BASE/tmp/$AIFCTR" | sudo tee -a $BASE/tmp/$AIFCTR > /dev/null
	
	#for item in "${TERRAVFILETRACKING[@]}"; do
	#	echo "$item"
	#done
	
	#cat $BASE/tmp/$AIFCTR
	#exit
	#$BASE/tmp/$AIFCTR
	nohup $BASE/tmp/$AIFCTR > $BASE/tmp/$RNDMJ1-JOBLOG1.out 2>&1 &
	nohup $BASE/Scripts/Cloud-Instance-Sync.sh "A" "$THESTACKFILESYNC" "$THESTACKFOLDERSYNC" "$THEVISIONKEY" "$THESTACKREALFILE" "$THESTACKAWSFILE" "$RNDMJ1" "$ALLWORKFOLDER1SYNC" "$RNDAWS1XM" > $BASE/tmp/$RNDMJ1-JOBLOG2.out 2>&1 &
fi	

if [ "$TASKIDENTIFIER" == "ONPREMVVB" ] ; then
	THEJSON=$2

	THESTACKFILE=$(jq -r '.ScopeFile' <<< "$THEJSON")
	THEVISIONKEY=$(jq -r '.VisionKey' <<< "$THEJSON")
	#THESTACKFILE="$2"
	#THEVISIONKEY="$3"
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
	
	sed -i 's/""//g' "$output_file"
	sed -i 's/"//g' "$output_file"
	THEFILEFORNEWVAL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	sudo touch $BASE/tmp/$THEFILEFORNEWVAL
	sudo chmod 777 $BASE/tmp/$THEFILEFORNEWVAL 	
	CSVFILE_ENC_DYC "$output_file" "6,12,13,14,15,23,24,25,26" "27" "Y" "encrypt" "$THEVISIONKEY" "1" "27" "$BASE/tmp/$THEFILEFORNEWVAL"
	sudo rm -f $output_file
	sudo mv $BASE/tmp/$THEFILEFORNEWVAL $output_file	
	#exit
	filtered1_json_2=$(echo "$filtered_json" | jq 'map(select(.IP == "TBD"))')
	output1__file=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)	
	output1_file="$BASE/tmp/$output1__file"
	echo "$filtered1_json_2" | jq -c '.[]' | while IFS= read -r obj; do
	    record=$(echo "$obj" | jq -r 'map(.) | @csv')
	    echo "$record" >> "$output1_file"
	done	
	sudo chmod 777 $output1_file

	sed -i 's/""//g' "$output1_file"
	sed -i 's/"//g' "$output1_file"		
	THEFILEFORNEWVAL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	sudo touch $BASE/tmp/$THEFILEFORNEWVAL
	sudo chmod 777 $BASE/tmp/$THEFILEFORNEWVAL 	
	CSVFILE_ENC_DYC "$output1_file" "6,12,13,14,15,23,24,25,26" "27" "Y" "encrypt" "$THEVISIONKEY" "0" "27" "$BASE/tmp/$THEFILEFORNEWVAL"
	sudo rm -f $output1_file
	sudo mv $BASE/tmp/$THEFILEFORNEWVAL $output1_file	
		
	output2__file=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)	

	cat $output_file $output1_file > $BASE/tmp/$output2__file
	sudo chmod 777 $BASE/tmp/$output2__file
	sudo rm -f $output1_file
	
	sudo rm -f $THESTACKFILE
	sudo mv $BASE/tmp/$output2__file $THESTACKFILE
	
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
nohup $BASE/Scripts/Vagrant-VirtualBox.sh \"C\" \"$BASE├\$CLUSTER├c├0├\$TOTALNOOFIPSREQ├$THESETUPMODE├c├2048,1,50|$only3from_filtered_json2_otherinfo├c├$nic├$gateway├$netmask├\$IPSTART├c├$BASE/Output/Scope$scopeid-CDR,$the4thfrom_filtered_json2_otherinfo├n├\$ROOTPWD├\$MATSYAPWD├\$VAGRANTPWD├├\$RANDOMSSHPORT├\$FINALOUTPUTREQ├\$FINALPROCESSOUTPUT├\$GETMEUNIQUEOUTPUTIPS├IDCDR,$__filtered_json2_identity├NO├ISSAMEASHOST├$THEPARENTAUTHDETAILS├$THEVISIONKEY\" > $BASE/tmp/Scope$scopeid-JOBLOG3.out 2>&1 &
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
			#echo "I CAME HERE0"
			__PICRFSCRIPTCROND=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
			_PICRFSCRIPTCROND="$BASE/tmp/$__PICRFSCRIPTCROND"			

			__PICRFSCRIPTCRONRESD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
			#echo "I CAME HERE1"			
			if [ "$ISTHISSAMEMACHINE" == "NO" ] ; then
				#echo "I CAME HERE2 $parent"
				ISREMOTEMACHINEPINGING="NO"
				#echo "I CAME HERE3"
				#ping -c 3 $parent > /dev/null
				#echo "I CAME HERE4"
				#if [ $? -eq 0 ]; then
				#	ISREMOTEMACHINEPINGING="YES"
				#	echo "I CAME HERE5"
				#fi
				if ping -c 3 "$parent" > /dev/null; then
				    ISREMOTEMACHINEPINGING="YES"
				    #echo "I CAME HERE5"
				else
				    ISREMOTEMACHINEPINGING="NO"
				    sudo rm -f $BASE/tmp/$__PICRFSCRIPTMAPPING
				    #echo "I CAME HERE6"
				fi				
				#echo "I CAME HERE7"
				#echo "ISREMOTEMACHINEPINGING : $ISREMOTEMACHINEPINGING  $parent"
				#exit
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
                nohup '"$BASE"'/Scripts/Vagrant-VirtualBox-Instance-Sync.sh "A" "$THEFILETOLOOKUP" "$server" "$auth_info" "$therealfile" "'"Scope$scopeid"'" "$thefilewhichran" "$thefilewhichrun" "$THEMACHINEFROMWHEREITALLSTARTED" "'"$BASE/tmp/Scope$scopeid-WIP"'" "$THEFILE2TOLOOKUP" "'"$THEVISIONKEY"'" 2>&1 &
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
                nohup '"$BASE"'/Scripts/Vagrant-VirtualBox-Instance-Sync.sh "A" "$THEFILETOLOOKUP" "$server" "$auth_info" "$therealfile" "'"Scope$scopeid"'" "$thefilewhichran" "$thefilewhichrun" "$THEMACHINEFROMWHEREITALLSTARTED" "'"$BASE/tmp/Scope$scopeid-WIP"'" "$THEFILE2TOLOOKUP" "'"$THEVISIONKEY"'" 2>&1 &
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
		
