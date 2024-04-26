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
#if [[ ! -d "$BASE/Output/Terraform/Default" ]]; then
#    sudo mkdir -p $BASE/Output/Terraform/Default
#    sudo cp $BASE/Resources/sample_aws.tf $BASE/Output/Terraform/Default
#    sudo cp $BASE/Resources/sample_azure.tf $BASE/Output/Terraform/Default
#    sudo cp $BASE/Resources/sample_gcp.tf $BASE/Output/Terraform/Default
#    sudo chmod -R 777 $BASE/Output/Terraform/Default
#    pushd $BASE/Output/Terraform/Default
#    terraform init
#    popd    
#fi

source $BASE/Resources/StackVersioningAndMisc

echo -e "${ORANGE}==============================================================================${NC}"
echo -e "${BLUE}${BOLD}\x1b[4mM${NORM}${NC}ultifaceted deploy${BLUE}${BOLD}\x1b[4mA${NORM}${NC}gnostic ${BLUE}${BOLD}\x1b[4mT${NORM}${NC}imesaving ${BLUE}${BOLD}\x1b[4mS${NORM}${NC}calable anal${BLUE}${BOLD}\x1b[4mY${NORM}${NC}tics ${BLUE}${BOLD}\x1b[4mA${NORM}${NC}malgamated ${BOLD}\x1b[30;44mPLATFORM\x1b[m${NORM}"
echo -e "${GREEN}==============================================================================${NC}"
echo ''
echo -e "\x1b[3m\x1b[4mCLOUD MULTINODE\x1b[m"
echo ''

declare -A name_map
THEPARALLELFUNC_LIST=()
FILESTOBEDELETED=()

deploy_instances() {
    local num_instances=$1
    local cloud_provider=$2
    local terraform_file=$3
    local VAR1=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 6 | head -n 1)
    local guid="$4""_""$VAR1"
    local parallel=$5
    local flnmofcldp=$6
    local flnmofcldpres=$7
    local thevar1=$8
    local thevar2=$9
    local thevar3="${10}"    
    createnewtf="NA"
        
	if [ "$terraform_file" == "NA" ] ; then
		createnewtf="YES"
		
		if [ "$cloud_provider" == "aws" ] ; then
			RANDOMINSTANCENAME=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
			sudo cp $BASE/Resources/TerraformTemplateAWS.tf $BASE/tmp/$RANDOMINSTANCENAME.tf
			sudo chmod 777 $BASE/tmp/$RANDOMINSTANCENAME.tf 
			
			terraform_file="$BASE/tmp/$RANDOMINSTANCENAME.tf"
			
			FILESTOBEDELETED+=("$terraform_file")
			
			RANDOMSCOPEVAL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
			echo '      {
        "Name": "'"$guid"'",
        "Type": "'"$cloud_provider"'",        
        "Action": [
          "DELETE",
          "IDENTITYADD",
          "RUNSCRIPT",      
          "LOADFILE"
        ],
        "Identity": [        ' | sudo tee $BASE/tmp/$RANDOMSCOPEVAL > /dev/null
			sudo chmod 777 $BASE/tmp/$RANDOMSCOPEVAL
						
			FILESTOBEDELETED+=("$BASE/tmp/$RANDOMSCOPEVAL")
			echo "$BASE/tmp/$RANDOMSCOPEVAL" | sudo tee -a $thevar3 > /dev/null
									
			IFS='¬' read -r -a CHOICEVALS <<< $thevar1
			THEREQUIREDAMI="${CHOICEVALS[0]}"
			THEREQUIREDTYPE="${CHOICEVALS[1]}"
			THEREQUIREDUSER="${CHOICEVALS[2]}"
			
			THEREQUIREDPEMKEY="$guid"
			THEREQUIREDLOCPEMKEY="$BASE/Output/Pem"
			THEREQUIREDINSTNUM="$num_instances"
			THEREQUIREDINSTANCE="$guid"
			
			IFS='¬' read -r -a CHOICEVALS2 <<< $thevar2
			SECRETSTHEFILE="${CHOICEVALS2[0]}"
			SECRETTHEKEY="${CHOICEVALS2[1]}"
			ITER=${SECRETTHEKEY:7:6}
			RANDOMSECFILENAME=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
			sudo cp $SECRETSTHEFILE $BASE/tmp/$RANDOMSECFILENAME
			sudo chown $CURRENTUSER:$CURRENTUSER $BASE/tmp/$RANDOMSECFILENAME
			sudo chmod u=r,g=,o= $BASE/tmp/$RANDOMSECFILENAME
			REALSECRETSFILENAME=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
			openssl enc -a -d -aes-256-cbc -pbkdf2 -iter $ITER -k $SECRETTHEKEY -in $BASE/tmp/$RANDOMSECFILENAME -out $BASE/tmp/$REALSECRETSFILENAME
			sudo chown $CURRENTUSER:$CURRENTUSER $BASE/tmp/$REALSECRETSFILENAME
			sudo chmod u=r,g=,o= $BASE/tmp/$REALSECRETSFILENAME
			THEACTUALSECRETS=$(<$BASE/tmp/$REALSECRETSFILENAME)		
			sudo rm -rf $BASE/tmp/$REALSECRETSFILENAME				
			sudo rm -rf $BASE/tmp/$RANDOMSECFILENAME
			
			FILESTOBEDELETED+=("$BASE/tmp/$REALSECRETSFILENAME")
			FILESTOBEDELETED+=("$BASE/tmp/$RANDOMSECFILENAME")
			#FILESTOBEDELETED+=("$THEREQUIREDLOCPEMKEY/$THEREQUIREDPEMKEY.pem")
			
			THEREQUIREDREGION=$(echo $THEACTUALSECRETS | jq -c ".MN.Cluster.Secrets[0].THEREQUIREDREGION?")
			THEREQUIREDREGION="${THEREQUIREDREGION//$DoubleQuotes/$NoQuotes}"
			THEREQUIREDACCESSKEY=$(echo $THEACTUALSECRETS | jq -c ".MN.Cluster.Secrets[0].THEREQUIREDACCESSKEY?")
			THEREQUIREDACCESSKEY="${THEREQUIREDACCESSKEY//$DoubleQuotes/$NoQuotes}"
			THEREQUIREDSECRETKEY=$(echo $THEACTUALSECRETS | jq -c ".MN.Cluster.Secrets[0].THEREQUIREDSECRETKEY?")
			THEREQUIREDSECRETKEY="${THEREQUIREDSECRETKEY//$DoubleQuotes/$NoQuotes}"
			THEREQUIREDSUBNET=$(echo $THEACTUALSECRETS | jq -c ".MN.Cluster.Secrets[0].THEREQUIREDSUBNET?")
			THEREQUIREDSUBNET="${THEREQUIREDSUBNET//$DoubleQuotes/$NoQuotes}"
			THEREQUIREDSECGRP=$(echo $THEACTUALSECRETS | jq -c ".MN.Cluster.Secrets[0].THEREQUIREDSECGRP?")
			THEREQUIREDSECGRP="${THEREQUIREDSECGRP//$DoubleQuotes/$NoQuotes}"
			
			sed -i -e s~"THEREQUIREDAMI"~"$THEREQUIREDAMI"~g $terraform_file
			sed -i -e s~"THEREQUIREDTYPE"~"$THEREQUIREDTYPE"~g $terraform_file
			sed -i -e s~"THEREQUIREDPEMKEY"~"$THEREQUIREDPEMKEY"~g $terraform_file
			sed -i -e s~"THEREQUIREDLOCPEMKEY"~"$THEREQUIREDLOCPEMKEY"~g $terraform_file
			sed -i -e s~"THEREQUIREDINSTNUM"~"$THEREQUIREDINSTNUM"~g $terraform_file
			sed -i -e s~"THEREQUIREDINSTANCE"~"$THEREQUIREDINSTANCE"~g $terraform_file
			sed -i -e s~"THEREQUIREDREGION"~"$THEREQUIREDREGION"~g $terraform_file
			sed -i -e s~"THEREQUIREDACCESSKEY"~"$THEREQUIREDACCESSKEY"~g $terraform_file
			sed -i -e s~"THEREQUIREDSECRETKEY"~"$THEREQUIREDSECRETKEY"~g $terraform_file
			sed -i -e s~"THEREQUIREDSUBNET"~"$THEREQUIREDSUBNET"~g $terraform_file
			sed -i -e s~"THEREQUIREDSECGRP"~"$THEREQUIREDSECGRP"~g $terraform_file												
		fi
	fi
            
    echo "function function$guid(){" | sudo tee -a $flnmofcldp > /dev/null

    echo "    sudo rm -rf $BASE/Output/Terraform/$guid && sudo mkdir $BASE/Output/Terraform/$guid && CURRENTUSER=\$(whoami) && sudo chown -R $CURRENTUSER:$CURRENTUSER $BASE/Output/Terraform/$guid && sudo chmod -R 700 $BASE/Output/Terraform/$guid" | sudo tee -a $flnmofcldp > /dev/null
    #echo "    sudo ln -s $BASE/Output/Terraform/Default/.terraform $BASE/Output/Terraform/$guid/.terraform && sudo ln -s $BASE/Output/Terraform/Default/.terraform.lock.hcl $BASE/Output/Terraform/$guid/.terraform.lock.hcl" | sudo tee -a $flnmofcldp > /dev/null    
    if [ "$createnewtf" == "NA" ] ; then
        echo "    sudo cp $terraform_file $BASE/Output/Terraform/$guid" | sudo tee -a $flnmofcldp > /dev/null
    else    
    	echo "    sudo mv $terraform_file $BASE/Output/Terraform/$guid" | sudo tee -a $flnmofcldp > /dev/null
    fi
    echo "    cd $BASE/Output/Terraform/$guid" | sudo tee -a $flnmofcldp > /dev/null
    echo "    terraform init" | sudo tee -a $flnmofcldp > /dev/null
    echo "    terraform plan" | sudo tee -a $flnmofcldp > /dev/null
    echo "    if [ \$? -eq 0 ]; then" | sudo tee -a $flnmofcldp > /dev/null            
   
    echo "        echo \"Terraform plan succeeded for $terraform_file. Applying changes...\"" | sudo tee -a $flnmofcldp > /dev/null    
    if [ ! -z "$parallel" ]; then
        echo "        terraform apply --auto-approve -parallelism=$parallel" | sudo tee -a $flnmofcldp > /dev/null
    else
        echo "        terraform apply --auto-approve" | sudo tee -a $flnmofcldp > /dev/null
    fi
    
    cp_guid="$cloud_provider""_""$guid"
    FILESTOBEDELETED+=("$BASE/tmp/$cp_guid.matsya")
            
    echo "        CURRENTUSER=\$(whoami) && sudo rm -rf $BASE/tmp/$cp_guid.matsya && sudo touch $BASE/tmp/$cp_guid.matsya && sudo chmod 777 $BASE/tmp/$cp_guid.matsya" | sudo tee -a $flnmofcldp > /dev/null
    
    if [ "$cloud_provider" == "aws" ] ; then
	echo "        public_ips_json_$guid=\$(terraform output -json)
        names_$guid=(\$(echo \"\$public_ips_json_$guid\" | jq -r '.instance_names.value[]'))
        ips_$guid=(\$(echo \"\$public_ips_json_$guid\" | jq -r '.public_ips.value[]'))
        totcnt_$guid=\${#names_$guid[@]}
        for i in \"\${"'!'"names_$guid[@]}\"; do
            echo \"\${ips_$guid[\$i]}¬\${names_$guid[\$i]}¬$THEREQUIREDUSER¬$THEREQUIREDLOCPEMKEY/$THEREQUIREDPEMKEY.pem\" >> \"$BASE/tmp/$cp_guid.matsya\"
            #echo \"CURRENTUSER=\$(whoami) && sudo rm -rf /home/\$CURRENTUSER/.ssh/known_hosts && sudo rm -rf /root/.ssh/known_hosts && ssh -o StrictHostKeyChecking=no -i $THEREQUIREDLOCPEMKEY/$THEREQUIREDPEMKEY.pem $THEREQUIREDUSER@\${ips_$guid[\$i]}\"
            echo '          {
            \"Attribute\": \"'\"\${ips_$guid[\$i]}\"'¬$THEREQUIREDUSER¬$THEREQUIREDLOCPEMKEY/$THEREQUIREDPEMKEY.pem\",
            \"Action\": [\"DELETE\",\"RUNSCRIPT\",\"LOADFILE\"],
            \"IP\": \"'\"\${ips_$guid[\$i]}\"'\",
            \"Type\": \"'\"$cloud_provider\"'\",            
            \"Name\": \"'\"\${names_$guid[\$i]}\"'\",                        
            \"Info\": \"'\"\${ips_$guid[\$i]}\"'¤$BASE/Output/Terraform/$guid¤$guid¤$thevar2¤'\"\${names_$guid[\$i]}\"'\"
          },' | sudo tee -a $BASE/tmp/$RANDOMSCOPEVAL > /dev/null    
        done" | sudo tee -a $flnmofcldp > /dev/null
	echo "        echo '        {}],\"Info\": \"'\"\$totcnt_$guid\"'¤$BASE/Output/Terraform/$guid¤$thevar2\"},' | sudo tee -a $BASE/tmp/$RANDOMSCOPEVAL > /dev/null" | sudo tee -a $flnmofcldp > /dev/null	
    fi
    
    echo "        CURRENTUSER=\$(whoami) && sudo chown -R \$CURRENTUSER:\$CURRENTUSER $BASE/tmp/$cp_guid.matsya && sudo chmod -R 700 $BASE/tmp/$cp_guid.matsya" | sudo tee -a $flnmofcldp > /dev/null     
    if [ "$cloud_provider" == "aws" ] ; then
	    if [ "$createnewtf" == "YES" ] ; then
    		echo "        CURRENTUSER=\$(whoami) && sudo chown \$CURRENTUSER:\$CURRENTUSER $THEREQUIREDLOCPEMKEY/$THEREQUIREDPEMKEY.pem && sudo chmod 400 $THEREQUIREDLOCPEMKEY/$THEREQUIREDPEMKEY.pem" | sudo tee -a $flnmofcldp > /dev/null 	    	
	    fi
    fi 

    echo "        echo \"Instances deployed successfully for $cloud_provider-$4.File Name is $BASE/tmp/$cp_guid.matsya\"" | sudo tee -a $flnmofcldp > /dev/null
    
    echo "    else" | sudo tee -a $flnmofcldp > /dev/null
    echo "        CURRENTUSER=\$(whoami) && sudo rm -rf $BASE/tmp/$cp_guid.matsya && sudo touch $BASE/tmp/$cp_guid.matsya && sudo chmod 777 $BASE/tmp/$cp_guid.matsya && echo \"ERROR\" >> \"$BASE/tmp/$cp_guid.matsya\" && sudo chown -R \$CURRENTUSER:\$CURRENTUSER $BASE/tmp/$cp_guid.matsya && sudo chmod -R 700 $BASE/tmp/$cp_guid.matsya" | sudo tee -a $flnmofcldp > /dev/null
    if [ "$cloud_provider" == "aws" ] ; then
	    if [ "$createnewtf" == "YES" ] ; then
    		echo "        sudo rm -rf $THEREQUIREDLOCPEMKEY/$THEREQUIREDPEMKEY.pem" | sudo tee -a $flnmofcldp > /dev/null 	    	
	    fi
    fi        
    echo "        echo \"Terraform plan failed for $terraform_file. Aborting...File Name is $BASE/tmp/$cp_guid.matsya\"" | sudo tee -a $flnmofcldp > /dev/null
    echo "    fi" | sudo tee -a $flnmofcldp > /dev/null

    if [ "$cloud_provider" == "aws" ] ; then
	    if [ "$createnewtf" == "YES" ] ; then
		echo "    if [ -f \"$BASE/Output/Terraform/$guid/$RANDOMINSTANCENAME.tf\" ]; then" | sudo tee -a $flnmofcldp > /dev/null
		echo "        CURRENTUSER=\$(whoami)" | sudo tee -a $flnmofcldp > /dev/null
		echo "        VAR6$guid=\$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)" | sudo tee -a $flnmofcldp > /dev/null
		echo "        sudo cp $BASE/Output/Terraform/$guid/$RANDOMINSTANCENAME.tf $BASE/Secrets/\$VAR6$guid" | sudo tee -a $flnmofcldp > /dev/null
		echo "        sudo chown \$CURRENTUSER:\$CURRENTUSER $BASE/Secrets/\$VAR6$guid" | sudo tee -a $flnmofcldp > /dev/null
		echo "        sudo chmod u=r,g=,o= $BASE/Secrets/\$VAR6$guid" | sudo tee -a $flnmofcldp > /dev/null
		echo "        openssl enc -a -aes-256-cbc -pbkdf2 -iter $ITER -in $BASE/Secrets/\$VAR6$guid -out $BASE/Secrets/\".\$VAR6$guid\" -k $SECRETTHEKEY" | sudo tee -a $flnmofcldp > /dev/null
		echo "        sudo chown \$CURRENTUSER:\$CURRENTUSER $BASE/Secrets/\".\$VAR6$guid\"" | sudo tee -a $flnmofcldp > /dev/null
		echo "        sudo chmod u=r,g=,o= $BASE/Secrets/\".\$VAR6$guid\"" | sudo tee -a $flnmofcldp > /dev/null
		echo "        sudo rm -rf $BASE/Secrets/\$VAR6$guid" | sudo tee -a $flnmofcldp > /dev/null
		echo "        sudo rm -rf /root/.bash_history" | sudo tee -a $flnmofcldp > /dev/null
		echo "        sudo rm -rf /home/\$CURRENTUSER/.bash_history" | sudo tee -a $flnmofcldp > /dev/null
		echo "        sudo rm -rf $BASE/Output/Terraform/$guid/$RANDOMINSTANCENAME.tf" | sudo tee -a $flnmofcldp > /dev/null
		echo "        sudo mv $BASE/Secrets/\".\$VAR6$guid\" $BASE/Output/Terraform/$guid/$RANDOMINSTANCENAME.tf" | sudo tee -a $flnmofcldp > /dev/null
		echo "        sudo chmod u=rwx,g=rwx,o=rwx $BASE/Output/Terraform/$guid/$RANDOMINSTANCENAME.tf" | sudo tee -a $flnmofcldp > /dev/null
		echo "    fi" | sudo tee -a $flnmofcldp > /dev/null
		
		echo "    if [ -f \"$BASE/Output/Terraform/$guid/terraform.tfstate\" ]; then" | sudo tee -a $flnmofcldp > /dev/null
		echo "        CURRENTUSER=\$(whoami)" | sudo tee -a $flnmofcldp > /dev/null
		echo "        VAR7$guid=\$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)" | sudo tee -a $flnmofcldp > /dev/null
		echo "        sudo cp $BASE/Output/Terraform/$guid/terraform.tfstate $BASE/Secrets/\$VAR7$guid" | sudo tee -a $flnmofcldp > /dev/null
		echo "        sudo chown \$CURRENTUSER:\$CURRENTUSER $BASE/Secrets/\$VAR7$guid" | sudo tee -a $flnmofcldp > /dev/null
		echo "        sudo chmod u=r,g=,o= $BASE/Secrets/\$VAR7$guid" | sudo tee -a $flnmofcldp > /dev/null
		echo "        openssl enc -a -aes-256-cbc -pbkdf2 -iter $ITER -in $BASE/Secrets/\$VAR7$guid -out $BASE/Secrets/\".\$VAR7$guid\" -k $SECRETTHEKEY" | sudo tee -a $flnmofcldp > /dev/null
		echo "        sudo chown \$CURRENTUSER:\$CURRENTUSER $BASE/Secrets/\".\$VAR7$guid\"" | sudo tee -a $flnmofcldp > /dev/null
		echo "        sudo chmod u=r,g=,o= $BASE/Secrets/\".\$VAR7$guid\"" | sudo tee -a $flnmofcldp > /dev/null
		echo "        sudo rm -rf $BASE/Secrets/\$VAR7$guid" | sudo tee -a $flnmofcldp > /dev/null
		echo "        sudo rm -rf /root/.bash_history" | sudo tee -a $flnmofcldp > /dev/null
		echo "        sudo rm -rf /home/\$CURRENTUSER/.bash_history" | sudo tee -a $flnmofcldp > /dev/null
		echo "        sudo rm -rf $BASE/Output/Terraform/$guid/terraform.tfstate" | sudo tee -a $flnmofcldp > /dev/null
		echo "        sudo mv $BASE/Secrets/\".\$VAR7$guid\" $BASE/Output/Terraform/$guid/terraform.tfstate" | sudo tee -a $flnmofcldp > /dev/null
		echo "        sudo chmod u=rwx,g=rwx,o=rwx $BASE/Output/Terraform/$guid/terraform.tfstate" | sudo tee -a $flnmofcldp > /dev/null
		echo "    fi" | sudo tee -a $flnmofcldp > /dev/null			    	
	    fi
    fi 
        
    echo "}" | sudo tee -a $flnmofcldp > /dev/null
    echo "$BASE/tmp/$cp_guid.matsya" | sudo tee -a $flnmofcldpres > /dev/null  
    THEPARALLELFUNC_LIST+=("function$guid")  
}

validate_parameters() {
    local num_instances=$1
    local parallel=$2
    local cloud_provider=$3
    local terraform_file=$4
    local guid=$5

    if [ -z "$guid" ]; then
        echo "Error: GUID parameter is mandatory."
        return 1
    fi

    if [[ ! "$guid" =~ ^[a-zA-Z0-9]+$ ]]; then
        echo "Error: GUID parameter can only contain alphabets, numbers."
        return 1
    fi

    if [ ${#guid} -lt 6 ]; then
        echo "Error: GUID parameter must be at least 6 characters long."
        return 1
    fi
    
    if [ ! -z "$parallel" ]; then
        if [[ ! "$parallel" =~ ^[0-9]+$ ]]; then
            echo "Error: Parallelism parameter must be a number."
            return 1
        elif [ "$parallel" -gt "$num_instances" ]; then
            echo "Warning: Parallelism parameter cannot be greater than the number of instances. Setting parallelism to number of instances."
            parallel=$num_instances
        fi
    fi

    if [[ "$num_instances" -le 0 ]]; then
        echo "Error: Number of instances must be greater than zero."
        return 1
    fi

    if [ ! -z "$parallel" ] && [[ "$parallel" -le 0 ]]; then
        echo "Error: Parallelism parameter must be greater than zero."
        return 1
    fi

    if [ "$cloud_provider" != "gcp" ] && [ "$cloud_provider" != "aws" ] && [ "$cloud_provider" != "azure" ]; then
        echo "Error: Cloud provider must be either GCP, AWS, or Azure."
        return 1
    fi

    if [ "$terraform_file" != "NA" ]; then
	    if [ ! -f "$terraform_file" ]; then
		echo "Error: Terraform file '$terraform_file' does not exist."
		return 1
	    fi

	    if [[ ! "$terraform_file" =~ \.tf$ ]]; then
		echo "Error: Terraform file must have a .tf extension."
		return 1
	    fi
    fi
}

if [ $# -eq 0 ]; then
    echo "Usage: $BASE/Scripts/GlobalCloudNewTerminal.sh '<num_instances>¤<cloud_provider>¤<terraform_file>¤<guid>¤[parallel]├...'VisionName NO 4"
    echo ''
    exit 1
fi

THEVISIONCREATIONTIME=$(date +"%Y_%m_%d_%H_%M_%S_%3N")
THEVISIONNAME="VISION_$2_$THEVISIONCREATIONTIME.json"

echo '{
  "Vision": {
    "Name": "'"$THEVISIONNAME"'",
    "Action": [
      "DELETE",
      "SCOPEADD",
      "RUNSCRIPT",      
      "LOADFILE"      
    ],
    "Info": "'"$BASE/Output/$THEVISIONNAME"'",
    "Scope": [' | sudo tee $BASE/tmp/$THEVISIONNAME > /dev/null
sudo chmod 777 $BASE/tmp/$THEVISIONNAME

FILESTOBEDELETED+=("$BASE/tmp/$THEVISIONNAME")

DIFF=$((600000-500000+1))
R=$(($(($RANDOM%$DIFF))+500000))
THEVISIONKEY=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
RKEY1=${THEVISIONKEY:0:7}
RKEY2=${THEVISIONKEY:7:8}
THEVISIONKEY="$RKEY1$R$RKEY2"
AUTOMATEDRUN=$3
GLOBALPARALLEL=$4
GLOBALNAPARALLEL="NO"
if [ ! -z "$GLOBALPARALLEL" ]; then
	if [[ ! "$GLOBALPARALLEL" =~ ^[0-9]+$ ]]; then
    		echo "Error: Parallelism parameter must be a number."
    		echo ''
    		exit 1
	fi
fi
if [ ! -z "$GLOBALPARALLEL" ] && [[ "$GLOBALPARALLEL" -le 0 ]]; then
	echo "Error: Parallelism parameter must be greater than zero."
	echo ''
	exit 1
fi
if [ ! -z "$GLOBALPARALLEL" ]; then
	GLOBALNAPARALLEL="YES"
fi  
        
IFS="├" read -ra blocks <<< "$1"

RANDOMVAL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 6 | head -n 1)
ALLDIFFCLDLIST="GlobalCloudExecute_$RANDOMVAL"
ALLDIFFCLDFLSTLIST='#!/bin/bash'"
"
echo "$ALLDIFFCLDFLSTLIST" | sudo tee $BASE/tmp/$ALLDIFFCLDLIST > /dev/null
sudo chmod 777 $BASE/tmp/$ALLDIFFCLDLIST

ALLDIFFCLDCOLLECTLIST="GlobalCloudExecute_$RANDOMVAL.result"
sudo touch $BASE/tmp/$ALLDIFFCLDCOLLECTLIST
sudo chmod 777 $BASE/tmp/$ALLDIFFCLDCOLLECTLIST

ALLDIFFCLDCOLLECTSCOPESLIST="GlobalCloudExecute_$RANDOMVAL.scopes"
sudo touch $BASE/tmp/$ALLDIFFCLDCOLLECTSCOPESLIST
sudo chmod 777 $BASE/tmp/$ALLDIFFCLDCOLLECTSCOPESLIST

if [ "$GLOBALNAPARALLEL" == "YES" ] ; then
	arrlen=${#blocks[@]}
	if [ "$arrlen" -lt "$GLOBALPARALLEL" ]; then
	    GLOBALPARALLEL="$arrlen"
	fi
	
	if [ "$GLOBALPARALLEL" -eq 1 ]; then
	    GLOBALNAPARALLEL="NO"
	fi	
fi

for block in "${blocks[@]}"; do
    IFS="¤" read -ra params <<< "$block"

    while ! validate_parameters "${params[0]}" "${params[4]}" "${params[1]}" "${params[2]}" "${params[3]}"; do
        read -p "Enter correct parameters for block '$block': " corrected_params
        IFS="¤" read -ra corrected_input <<< "$corrected_params"

        validate_parameters "${corrected_input[0]}" "${corrected_input[4]}" "${corrected_input[1]}" "${corrected_input[2]}" "${corrected_input[3]}"
        if [ $? -eq 0 ]; then
            params=("${corrected_input[@]}")
        fi
    done

    deploy_instances "${params[0]}" "${params[1]}" "${params[2]}" "${params[3]}" "${params[4]}" "$BASE/tmp/$ALLDIFFCLDLIST" "$BASE/tmp/$ALLDIFFCLDCOLLECTLIST" "${params[5]}" "${params[6]}" "$BASE/tmp/$ALLDIFFCLDCOLLECTSCOPESLIST"
done

THEORIGINALFOLDERLOC=$(pwd)

if [ "$GLOBALNAPARALLEL" == "NO" ] ; then
	printf "\n" >> "$BASE/tmp/$ALLDIFFCLDLIST"
	
	for item in "${THEPARALLELFUNC_LIST[@]}"; do
    		echo "$item" >> "$BASE/tmp/$ALLDIFFCLDLIST"
    		printf "\n" >> "$BASE/tmp/$ALLDIFFCLDLIST"
	done
fi

if [ "$GLOBALNAPARALLEL" == "YES" ] ; then
	
	lines=$(( (${#THEPARALLELFUNC_LIST[@]} + GLOBALPARALLEL - 1) / GLOBALPARALLEL ))

	for ((i = 0; i < lines; i++)); do
	    printf "\n" >> "$BASE/tmp/$ALLDIFFCLDLIST"
	    start=$((i * GLOBALPARALLEL))
	    end=$((start + GLOBALPARALLEL - 1))
	    if (( end >= ${#THEPARALLELFUNC_LIST[@]} )); then
		end=$((${#THEPARALLELFUNC_LIST[@]} - 1))
	    fi

	    if ((start == end)); then
		echo "${THEPARALLELFUNC_LIST[start]}" >> "$BASE/tmp/$ALLDIFFCLDLIST"
	    else
		printf "export -f " >> "$BASE/tmp/$ALLDIFFCLDLIST"
		for ((j = start; j <= end; j++)); do
		    printf "%s" "${THEPARALLELFUNC_LIST[j]}" >> "$BASE/tmp/$ALLDIFFCLDLIST"
		    if ((j < end)); then
		        printf " && export -f " >> "$BASE/tmp/$ALLDIFFCLDLIST"
		    fi
		done
		printf "\n" >> "$BASE/tmp/$ALLDIFFCLDLIST"
		
		result=$((end - start))
		result=$((result + 1))
		printf "parallel -j $result ::: " >> "$BASE/tmp/$ALLDIFFCLDLIST"
		for ((j = start; j <= end; j++)); do
		    printf "%s" "${THEPARALLELFUNC_LIST[j]}" >> "$BASE/tmp/$ALLDIFFCLDLIST"
		    if ((j < end)); then
		        printf " " >> "$BASE/tmp/$ALLDIFFCLDLIST"
		    fi
		done
		printf "\n" >> "$BASE/tmp/$ALLDIFFCLDLIST"		
	    fi
	done
	printf "\n" >> "$BASE/tmp/$ALLDIFFCLDLIST"
fi

echo "cd $THEORIGINALFOLDERLOC" | sudo tee -a $BASE/tmp/$ALLDIFFCLDLIST > /dev/null 
printf "\n" >> "$BASE/tmp/$ALLDIFFCLDLIST"

if [ "$AUTOMATEDRUN" == "YES" ] ; then
	$BASE/tmp/$ALLDIFFCLDLIST
else
	read -p "
Script File Ready !!
$STACKLINELENGTHY
1) Executable Bash Script => $BASE/tmp/$ALLDIFFCLDLIST 
2) Final Vision File      => $BASE/Output/$THEVISIONNAME
3) Vision Key             => $THEVISIONKEY
$STACKLINELENGTHY
Execute(1) / Abort(0)
					> " -e -i "0" THECLOUDRUNCHOICE
	if (( $THECLOUDRUNCHOICE == 1 )) ; then
		$BASE/tmp/$ALLDIFFCLDLIST
	fi
	
	if (( $THECLOUDRUNCHOICE == 0 )) ; then
		sudo rm -rf $BASE/tmp/$THEVISIONNAME
		FILESTOBEDELETED+=("$BASE/Output/$THEVISIONNAME")
	fi	
fi

input_file="$BASE/tmp/$ALLDIFFCLDCOLLECTSCOPESLIST"
output_file="$BASE/tmp/$THEVISIONNAME"

if [ ! -f "$input_file" ]; then
    echo "Error: Input file '$input_file' not found."
    exit 1
fi

while IFS= read -r line; do
    if [ -f "$line" ]; then
        cat "$line" >> "$output_file"
    else
        echo "Warning: File '$line' mentioned in '$input_file' does not exist."
    fi
done < "$input_file"

echo '    {}]
  }
}' | sudo tee -a $BASE/tmp/$THEVISIONNAME > /dev/null

ITTHEVISIONKEYER=${THEVISIONKEY:7:6}
VISIONSAFEGUARD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
sudo cp $BASE/tmp/$THEVISIONNAME $BASE/Secrets/$VISIONSAFEGUARD
sudo chown $CURRENTUSER:$CURRENTUSER $BASE/Secrets/$VISIONSAFEGUARD
sudo chmod u=r,g=,o= $BASE/Secrets/$VISIONSAFEGUARD
openssl enc -a -aes-256-cbc -pbkdf2 -iter $ITTHEVISIONKEYER -in $BASE/Secrets/$VISIONSAFEGUARD -out $BASE/Secrets/".$VISIONSAFEGUARD" -k $THEVISIONKEY
sudo chown $CURRENTUSER:$CURRENTUSER $BASE/Secrets/".$VISIONSAFEGUARD"
sudo chmod u=r,g=,o= $BASE/Secrets/".$VISIONSAFEGUARD"
sudo rm -rf $BASE/Secrets/$VISIONSAFEGUARD
sudo rm -rf /root/.bash_history
sudo rm -rf /home/$CURRENTUSER/.bash_history
sudo mv $BASE/Secrets/".$VISIONSAFEGUARD" $BASE/Output/$THEVISIONNAME
sudo chmod 777 $BASE/Output/$THEVISIONNAME

FILESTOBEDELETED+=("$BASE/tmp/$ALLDIFFCLDLIST")
FILESTOBEDELETED+=("$BASE/tmp/$ALLDIFFCLDCOLLECTLIST")
FILESTOBEDELETED+=("$BASE/tmp/$ALLDIFFCLDCOLLECTSCOPESLIST")

for FILE in "${FILESTOBEDELETED[@]}"; do
    #echo "$FILES"
    sudo rm -rf "$FILE"
done
		
