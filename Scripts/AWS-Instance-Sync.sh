#!/bin/bash

CURRENTUSER=$(whoami)
sudo rm -rf /home/$CURRENTUSER/.ssh/known_hosts
sudo rm -rf /root/.ssh/known_hosts

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

THEMODEOFEXECUTION="$1"

if [ "$THEMODEOFEXECUTION" == "A" ]; then
	WIP_FOLDER="$3"
	WIP_LIST="$2"
	visionkey=$4
	therealfile=$5	
	thereal2file=$6
	thenohupfile=$7
	source $BASE/Resources/StackVersioningAndMisc

	file_exists() {
	    [[ -f "$1" ]]
	}

	declare -a processed_files

	while true; do
	    mapfile -t files < "$WIP_LIST"

	    for file in "${files[@]}"; do
		if file_exists "$file"; then
		    if [[ ! " ${processed_files[@]} " =~ " $file " ]]; then
		        echo "Processing file: $file"
		        
		        while IFS= read -r line; do
				echo "$line" >> "$thereal2file"		        				    	
			done < "$file"
								        
		        processed_files+=("$file")
		    else
		        echo "file already done $file"
		    fi
		else
		    echo "file not found $file"
		fi
	    done

	    if [[ "${#processed_files[@]}" -eq "${#files[@]}" ]]; then
		sudo rm -f "$WIP_LIST"
		sudo rm -rf "$WIP_FOLDER"
		sudo rm -f $BASE/tmp/$thenohupfile-JOBLOG2.out
		
		echo "All files processed. Exiting."
		notify-send -t 5000 "Progress" "All files processed. Exiting.AWS-Instance-Sync A Function"
				
		break
	    fi

	    sleep 15
	done
fi

