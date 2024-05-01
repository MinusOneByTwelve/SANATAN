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

THECHOICE=$1
THEVALUES=$2
#echo $THECHOICE
#echo $THEVALUES
#exit
if [ "$THECHOICE" == "Vision_DELETE" ] ; then
	Vision_DELETE "$THEVALUES"
fi

for FILE in "${FILESTOBEDELETED[@]}"; do
	#echo $FILE
	sudo rm -rf "$FILE"
done

