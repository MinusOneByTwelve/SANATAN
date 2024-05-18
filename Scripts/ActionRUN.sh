#!/bin/bash

set -e

CURRENTUSER=$(whoami)
sudo rm -rf /home/$CURRENTUSER/.ssh/known_hosts
sudo rm -rf /root/.ssh/known_hosts

RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
YELLOW='\e[33m'
BLUE='\033[0;34m'
LBLUE='\033[1;34m'
DGRAY='\033[1;35m'
PURPLE='\033[0;35m'
RGRAY='\033[1;30m'
PINK='\e[1;92m'
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

FILESTOBEDELETED=()
SCOPEFOLDERS=()

Vision_DELETE() {
	#IFS="º" read -ra INPUT <<< "$1"
	#_INPUT1="${INPUT[0]}"
	#_INPUT2="${INPUT[1]}"
	IFS="º" read -ra INPUT <<< "$1"
	_INPUT2="${INPUT[1]}"
	TEMP1="${INPUT[0]}"
	IFS="┼" read -ra TEMP2 <<< "$TEMP1"
	_INPUT1="${TEMP2[1]}"
	#IFS="├" read -ra INPUT_1 <<< "$_INPUT1"
	IFS="├" read -ra INPUT_1 <<< "$_INPUT1"
	INPUT_1_="${INPUT_1[1]}"	
	IFS="¶" read -ra INPUT_2 <<< "$_INPUT2"	

	#RANDOMVAL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 6 | head -n 1)
	#sudo touch $BASE/tmp/$RANDOMVAL
	#sudo chmod 777 $BASE/tmp/$RANDOMVAL
	
	#FILESTOBEDELETED+=("$BASE/tmp/$RANDOMVAL")
	
	OVERALLCOUNTER=0
	SUCCESSCOUNTER=0
	
	for _INPUT_2 in "${INPUT_2[@]}"; do
		OVERALLCOUNTER=$((OVERALLCOUNTER + 1))
		#echo $_INPUT_2
		IFS="■" read -ra var1 <<< "$_INPUT_2"
		var2="${var1[0]}"
		var3="${var1[1]}"
		#echo 1$var2
		#echo 2$var3		
		IFS="┼" read -ra var4 <<< "$var3"
		var5="${var4[0]}"
		var6="${var4[1]}"
		#echo 3$var5
		#echo 4$var6
		#exit		
		IFS="¤" read -ra var7 <<< "$var5"
		var8="${var7[0]}"
		var9="${var7[1]}"
		SCOPEFOLDERS+=("$var9")		
		var10="${var7[2]}"		
		#echo 5$var8
		#echo 6$var9
		#echo 7$var10				
		IFS="¬" read -ra var11 <<< "$var10"
		var12="${var11[0]}"
		var13="${var11[1]}"
		#echo 8$var12
		#echo 9$var13		
		tf_file=$(find "$var9" -maxdepth 1 -type f -name "*.tf" | head -n 1)
		tf_filename=$(basename "$tf_file")
		
		RANDOM2VAL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 6 | head -n 1)
		RANDOM3VAL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 6 | head -n 1)
				
		sudo mv $var9/terraform.tfstate $var9/$RANDOM2VAL 		
		sudo mv $var9/$tf_filename $var9/$RANDOM3VAL
		
		$BASE/Scripts/SecretsFile-Decrypter "$var9/$RANDOM2VAL├1├1├$var9/terraform.tfstate├$var13"
		$BASE/Scripts/SecretsFile-Decrypter "$var9/$RANDOM3VAL├1├1├$var9/$tf_filename├$var13"
		
		if [ "$var6" == "gcp" ] ; then
			$BASE/Scripts/SecretsFile-Decrypter "$BASE/Output/Pem/.GCP-ServiceAccount-$var2├1├1├$BASE/tmp/.GCP-ServiceAccount-$var2├$var13"
		fi
		
		sudo chmod 777 $var9/terraform.tfstate
		sudo chmod 777 $var9/$tf_filename
		if [ "$var6" == "gcp" ] ; then
			sudo chmod 777 $BASE/tmp/.GCP-ServiceAccount-$var2
		fi
		
		(
			set -Ee
			function _catch {
				echo "ERROR"
				cd $CURDIR
				sudo mv $var9/terraform.tfstate $var9/terraform.tfstate2
				sudo mv $var9/$tf_filename $var9/$tf_filename2
				sudo mv $var9/$RANDOM2VAL $var9/terraform.tfstate
				sudo mv $var9/$RANDOM3VAL $var9/$tf_filename
				sudo rm -rf $var9/terraform.tfstate2
				sudo rm -rf $var9/$tf_filename2
				if [ "$var6" == "gcp" ] ; then	
					sudo rm -rf $BASE/tmp/.GCP-ServiceAccount-$var2	
				fi		
				exit 0
			}
			function _finally {
				ABC="XYZ"
			}
			trap _catch ERR
			trap _finally EXIT
			CURDIR=$(pwd)
			cd $var9
			terraform destroy --auto-approve
			if [ $? -eq 0 ]; then
				cd $CURDIR
				SUCCESSCOUNTER=$((SUCCESSCOUNTER + 1))
				sudo rm -rf $var9
				sudo rm -rf $BASE/Output/Pem/$var2.pem
				if [ "$var6" == "gcp" ] ; then	
					sudo rm -rf $BASE/Output/Pem/.GCP-ServiceAccount-$var2	
					sudo rm -rf $BASE/Output/Pem/$var2.pem.pub
					sudo rm -rf $BASE/tmp/.GCP-ServiceAccount-$var2
				fi				
			else
				cd $CURDIR
				sudo mv $var9/terraform.tfstate $var9/terraform.tfstate2
				sudo mv $var9/$tf_filename $var9/$tf_filename2
				sudo mv $var9/$RANDOM2VAL $var9/terraform.tfstate
				sudo mv $var9/$RANDOM3VAL $var9/$tf_filename
				sudo rm -rf $var9/terraform.tfstate2
				sudo rm -rf $var9/$tf_filename2	
				if [ "$var6" == "gcp" ] ; then	
					sudo rm -rf $BASE/tmp/.GCP-ServiceAccount-$var2	
				fi													
			fi			
			cd $CURDIR					
		)		
		
		sudo rm -rf $var9/$RANDOM2VAL
		sudo rm -rf $var9/$RANDOM3VAL
				
		FILESTOBEDELETED+=("$var9/$RANDOM2VAL")
		FILESTOBEDELETED+=("$var9/$RANDOM3VAL")										
	done
	
	if [ "$OVERALLCOUNTER" -eq "$SUCCESSCOUNTER" ]; then
		sudo rm -rf $BASE/Output/$INPUT_1_		
	fi
	ALLCLEAN="YES"
	#echo $INPUT_1_
	for folder in "${SCOPEFOLDERS[@]}"; do
		#echo $folder
		if [ -d "$folder" ]; then
			ALLCLEAN="NO"
			break
		fi
	done
	if [ "$ALLCLEAN" == "YES" ] ; then
		sudo rm -rf $BASE/Output/$INPUT_1_
	fi	
}

AWS_IDENTITY_DELETE() {
	AID1=$1
	AID2=$2
	AID3=$3
	
	#echo "AID1 : $AID1    AID2 : $AID2      AID3 : $AID3"
	IFS='|' read -ra items <<< "$AID1"
	for scopeidy in "${items[@]}"; do
		search_result=$(grep -n "^$scopeidy" $AID2)
		
		IFS=',' read -ra scid <<< "$scopeidy"
		sc1id="${scid[0]}"
		sc2id="${scid[1]}"
		sc3id="s""$sc1id""i""$sc2id"
		
		if [ -n "$search_result" ]; then
			line_number=$(echo "$search_result" | awk -F ':' 'NR==1 {print $1}')
			content=$(echo "$search_result" | awk -F ':' 'NR==1 {print $2}')
			IFS=',' read -ra contents <<< "$content"
			filtered_content=$(IFS=',' && printf "%s," "${contents[@]:0:${#contents[@]}-1}")
			filtered_content=${filtered_content%,}	
			IFS=',' read -r -a USERLISTVALS <<< $content
			thecurrentdeleteflag="${USERLISTVALS[27]}"
			TheVMPemFile="${USERLISTVALS[25]}"
			TheVMPemFile=$(NARASIMHA "decrypt" "$TheVMPemFile" "$AID3")				
			thenewdeleteflag=""
			#echo "scopeidy : $scopeidy  THEFOLDERINQ : $THEFOLDERINQ  Secret1Key : $Secret1Key  TheVMPemFile : $TheVMPemFile"
			if [ "$thecurrentdeleteflag" == "Y" ] ; then
				thenewdeleteflag="Y"
				#echo "came here1: $thenewdeleteflag"
			else
				Secret1Key="${USERLISTVALS[5]}"
				Secret1Key=$(NARASIMHA "decrypt" "$Secret1Key" "$AID3")	
				THEFOLDERINQ=$(find $BASE/Output/Terraform -type d -name "*$sc3id*" | head -n 1)
				
				if [ -f "$THEFOLDERINQ/ISDELETED" ]; then
				    	thenewdeleteflag="Y"
				    	#echo "came here2: $thenewdeleteflag"
				else				    
					tf_file=$(find "$THEFOLDERINQ" -maxdepth 1 -type f -name "*.tf" | head -n 1)
					tf_filename=$(basename "$tf_file")
					#echo "scopeidy : $scopeidy  THEFOLDERINQ : $THEFOLDERINQ  Secret1Key : $Secret1Key  tf_filename : $tf_filename"					
					RANDOM2VAL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 6 | head -n 1)
					RANDOM3VAL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 6 | head -n 1)
							
					sudo mv $THEFOLDERINQ/terraform.tfstate $THEFOLDERINQ/$RANDOM2VAL 		
					sudo mv $THEFOLDERINQ/$tf_filename $THEFOLDERINQ/$RANDOM3VAL
					
					$BASE/Scripts/SecretsFile-Decrypter "$THEFOLDERINQ/$RANDOM2VAL├1├1├$THEFOLDERINQ/terraform.tfstate├$Secret1Key"
					$BASE/Scripts/SecretsFile-Decrypter "$THEFOLDERINQ/$RANDOM3VAL├1├1├$THEFOLDERINQ/$tf_filename├$Secret1Key"
					
					sudo chmod 777 $THEFOLDERINQ/terraform.tfstate
					sudo chmod 777 $THEFOLDERINQ/$tf_filename
					
					(
					set -Ee
					function _catch {
						echo "ERROR"
						cd $CURDIR
						sudo mv $THEFOLDERINQ/terraform.tfstate $THEFOLDERINQ/terraform.tfstate2
						sudo mv $THEFOLDERINQ/$tf_filename $THEFOLDERINQ/$tf_filename-2
						sudo mv $THEFOLDERINQ/$RANDOM2VAL $THEFOLDERINQ/terraform.tfstate
						sudo mv $THEFOLDERINQ/$RANDOM3VAL $THEFOLDERINQ/$tf_filename
						sudo rm -rf $THEFOLDERINQ/terraform.tfstate2
						sudo rm -rf $THEFOLDERINQ/$tf_filename-2
						thenewdeleteflag="A"		
						exit 0
					}
					function _finally {
						ABC="XYZ"
					}
					trap _catch ERR
					trap _finally EXIT
					CURDIR=$(pwd)
					cd $THEFOLDERINQ
					terraform destroy --auto-approve
					if [ $? -eq 0 ]; then
						cd $CURDIR
						sudo rm -rf $THEFOLDERINQ/.terraform
						sudo touch $THEFOLDERINQ/ISDELETED
						sudo chmod 777 $THEFOLDERINQ/ISDELETED
						sudo rm -f $TheVMPemFile	
						sudo mv $THEFOLDERINQ/terraform.tfstate $THEFOLDERINQ/terraform.tfstate2
						sudo mv $THEFOLDERINQ/$tf_filename $THEFOLDERINQ/$tf_filename-2
						sudo mv $THEFOLDERINQ/$RANDOM2VAL $THEFOLDERINQ/terraform.tfstate
						sudo mv $THEFOLDERINQ/$RANDOM3VAL $THEFOLDERINQ/$tf_filename
						sudo rm -rf $THEFOLDERINQ/terraform.tfstate2
						sudo rm -rf $THEFOLDERINQ/$tf_filename-2
						thenewdeleteflag="Y"									
					else
						cd $CURDIR
						sudo mv $THEFOLDERINQ/terraform.tfstate $THEFOLDERINQ/terraform.tfstate2
						sudo mv $THEFOLDERINQ/$tf_filename $THEFOLDERINQ/$tf_filename-2
						sudo mv $THEFOLDERINQ/$RANDOM2VAL $THEFOLDERINQ/terraform.tfstate
						sudo mv $THEFOLDERINQ/$RANDOM3VAL $THEFOLDERINQ/$tf_filename
						sudo rm -rf $THEFOLDERINQ/terraform.tfstate2
						sudo rm -rf $THEFOLDERINQ/$tf_filename-2
						thenewdeleteflag="A"													
					fi			
					cd $CURDIR					
					)
					
					sudo rm -rf $THEFOLDERINQ/$RANDOM2VAL
					sudo rm -rf $THEFOLDERINQ/$RANDOM3VAL
							
					FILESTOBEDELETED+=("$THEFOLDERINQ/$RANDOM2VAL")
					FILESTOBEDELETED+=("$THEFOLDERINQ/$RANDOM3VAL")
				fi							
			fi
			#echo "came here3: $thenewdeleteflag"
			thenewcontent="$filtered_content,$thenewdeleteflag"
			#echo "thenewcontent : $thenewcontent"
			sed -i "$line_number""s#.*#$thenewcontent#" "$AID2"		
		else
		    echo "Not Found"
		fi
	done	
}

THECHOICE=$1
THEVALUES=$2
#echo $THECHOICE
#echo $THEVALUES
#exit
if [ "$THECHOICE" == "Vision_DELETE" ] ; then
	Vision_DELETE "$THEVALUES"
fi

if [ "$THECHOICE" == "AWS_IDENTITY_DELETE" ] ; then
	THE3VALUES=$3
	THE4VALUES=$4
	AWS_IDENTITY_DELETE "$THEVALUES" "$THE3VALUES" "$THE4VALUES"
fi

for FILE in "${FILESTOBEDELETED[@]}"; do
	#echo $FILE
	sudo rm -rf "$FILE"
done

