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

#if [[ ! -d "$BASE/Resources/Terraform" ]]; then
#	sudo mkdir -p $BASE/Resources/Terraform
#	sudo chmod -R 777 $BASE/Resources/Terraform
#fi

THEMODEOFEXECUTION="$1"

if [ "$THEMODEOFEXECUTION" == "A" ]; then
	WIP_FOLDER="$3"
	WIP_LIST="$2"
	visionkey=$4
	therealfile=$5	
	thereal2file=$6
	thenohupfile=$7
	ALLWORK1FOLDER1SYNC=$8
	RND1CLD1XM=$9
	THEREQCLD="${10}"
	THEREQVISID="${11}"
			
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
		        	IFS=',' read -ra fields <<< "$line"
		        	tv0="${fields[0]}"
		        	tv1="${fields[1]}"
		        	tv2="${fields[2]}"
		        	tv3="${fields[3]}"		        	
		        	tv4="${fields[4]}"
		        	tv5="${fields[5]}"		        	
		        	tv6="${fields[6]}"
		        	tv7="${fields[7]}"		        	
		        	tv8="${fields[8]}"
		        	tv9="${fields[9]}"		        	
		        	tv10="${fields[10]}"
		        	tv11="${fields[11]}"		        	
		        	tv12="${fields[12]}"
		        	tv13="${fields[13]}"		        	
		        	tv14="${fields[14]}"
		        	tv15="${fields[15]}"
		        	tv16="${fields[16]}"
		        	tv17="${fields[17]}"		        	
		        	tv18="${fields[18]}"
		        	tv19="${fields[19]}"		        	
		        	tv20="${fields[20]}"
		        	tv21="${fields[21]}"		        	
		        	tv22="${fields[22]}"
		        	tv23="${fields[23]}"		        	
		        	tv24="${fields[24]}"
		        	tv25="${fields[25]}"		        	
		        	tv26="${fields[26]}"
		        	tv27="${fields[27]}" 			        			      		        	
		        	tv28="$tv0,$tv1"
				#tv29=$(grep -n "^$tv28" $thereal2file)
				tv29=$(grep -n "^$tv28" $therealfile)
				if [ "$tv26" == "Y" ]; then
					tv30=$(NARASIMHA "decrypt" "$tv22" "$visionkey")
					tv31=$(NARASIMHA "decrypt" "$tv23" "$visionkey")
					tv32=$(NARASIMHA "decrypt" "$tv25" "$visionkey")
				else
					tv30="$tv22"
					tv31="$tv23"
					tv32="$tv25"				
				fi
				#notify-send -t 5000 "Progress" "ssh -p \"$tv31\" -o StrictHostKeyChecking=no -i \"$tv32\" \"$tv30@$tv6\""
				#ssh -p "$tv31" -o StrictHostKeyChecking=no -i "$tv32" "$tv30@$tv6" "sudo touch /opt/WHOAMI && sudo chmod 777 /opt/WHOAMI && echo \"$tv6\" | sudo tee -a /opt/WHOAMI > /dev/null"
				attempt_counter=0
				max_attempts=10

				#while true; do
				INTERCEPTED="NO"
				while [[ $attempt_counter -lt $max_attempts ]]; do
				    ((attempt_counter++))
				    
				    if ssh -p "$tv31" -o StrictHostKeyChecking=no -i "$tv32" "$tv30@$tv6" \
					"sudo touch /opt/WHOAMI && sudo chmod 777 /opt/WHOAMI && echo \"$tv6\" | sudo tee -a /opt/WHOAMI > /dev/null && [ -f /opt/WHOAMI ]"
				    then
					echo "File /opt/WHOAMI successfully created and verified on remote host."
					INTERCEPTED="YES"
					#notify-send -t 5000 "Progress" "ssh -p \"$tv31\" -o StrictHostKeyChecking=no -i \"$tv32\" \"$tv30@$tv6\" File /opt/WHOAMI successfully created and verified on remote host."
					break
				    else
					echo "Failed to verify file creation, retrying..."
					#notify-send -t 5000 "Progress" "ssh -p \"$tv31\" -o StrictHostKeyChecking=no -i \"$tv32\" \"$tv30@$tv6\" Failed to verify file creation, retrying..."
					sleep 10
				    fi
				done				
				if [[ $attempt_counter -eq $max_attempts ]]; then
				    #notify-send -t 5000 "Progress" "ssh -p \"$tv31\" -o StrictHostKeyChecking=no -i \"$tv32\" \"$tv30@$tv6\" Reached maximum attempt limit without success."
				    echo "Reached maximum attempt limit without success."
				fi
												
				sshinfo=$(ssh -p $tv31 -o StrictHostKeyChecking=no -i "$tv32" "$tv30@$tv6" \
	    'total_ram=$(free -h | awk '"'"'{if (NR==2) print $2}'"'"' | sed "s/Gi//"); \
	    free_ram=$(free -h | awk '"'"'{if (NR==2) print $4}'"'"' | sed "s/Gi//"); \
	    cpu_cores=$(nproc); \
	    echo "$total_ram├$free_ram├$cpu_cores"'
				)
							
				if [ "$INTERCEPTED" == "YES" ]; then
					if [ "$THEREQCLD" == "GCP" ]; then
						if [ "$tv17" == "UBU" ]; then
							tv36="s$tv0""i$tv1""gcsrb"
							IFS='├' read -ra _tv3 <<< "$tv3"
							tv37="${_tv3[3]}"
							trr_md5="${THEREQVISID}├${tv37}"
							tv39=$(echo -n "$trr_md5" | md5sum | awk '{print $1}')						
							tv38=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
							
							nohup $BASE/Scripts/Cloud-Instance-Exec.sh "GCP_UBU├$thenohupfile" "A" "$tv32" "$tv30" "$tv6" "$tv31" "$tv38" "$tv36" "gcp$tv39" > $BASE/tmp/$thenohupfile-$tv38-CIE.out 2>&1 & 
						fi
					fi

					if [ "$THEREQCLD" == "GCP" ]; then
						if [ "$tv17" == "ALMA" ]; then
							tv36="s$tv0""i$tv1""gcsrb"
							IFS='├' read -ra _tv3 <<< "$tv3"
							tv37="${_tv3[3]}"
							trr_md5="${THEREQVISID}├${tv37}"
							tv39=$(echo -n "$trr_md5" | md5sum | awk '{print $1}')						
							tv38=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
							
							nohup $BASE/Scripts/Cloud-Instance-Exec.sh "GCP_ALMA" "A" "$tv32" "$tv30" "$tv6" "$tv31" "$tv38" "$tv36" "gcp$tv39" > $BASE/tmp/$tv38-CIE.out 2>&1 & 
						fi
					fi

					if [ "$THEREQCLD" == "GCP" ]; then
						if [ "$tv17" == "ROCKY" ]; then
							tv36="s$tv0""i$tv1""gcsrb"
							IFS='├' read -ra _tv3 <<< "$tv3"
							tv37="${_tv3[3]}"
							trr_md5="${THEREQVISID}├${tv37}"
							tv39=$(echo -n "$trr_md5" | md5sum | awk '{print $1}')						
							tv38=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
							
							nohup $BASE/Scripts/Cloud-Instance-Exec.sh "GCP_ROCKY" "A" "$tv32" "$tv30" "$tv6" "$tv31" "$tv38" "$tv36" "gcp$tv39" > $BASE/tmp/$tv38-CIE.out 2>&1 & 
						fi
					fi
																			
					if [ "$THEREQCLD" == "AZURE" ]; then
						if [ "$tv17" == "UBU" ]; then
							tv36="s$tv0""i$tv1""bsa"
							IFS='├' read -ra _tv3 <<< "$tv3"
							tv37="${_tv3[0]}"
							trr_md5="${THEREQVISID}├${tv37}"
							tv_3_9=$(echo -n "$trr_md5" | md5sum | awk '{print $1}')
							tv39="${tv_3_9:0:22}""sa"						
							tv38=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
							
							RANDOMAFSMT=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
							sudo cp $BASE/Resources/AzureFileShareMountTemplate $BASE/tmp/$RANDOMAFSMT
							sed -i -e s~"THESTORAGEACCOUNTNAME"~"$tv39"~g $BASE/tmp/$RANDOMAFSMT
							sed -i -e s~"THESTORAGELOCATION"~"/shiva/global/storage"~g $BASE/tmp/$RANDOMAFSMT
							sudo chmod 777 $BASE/tmp/$RANDOMAFSMT
							scp -i "$tv32" -o StrictHostKeyChecking=no -P $tv31 "$BASE/tmp/$RANDOMAFSMT" "$tv30@$tv6:/home/$tv30/EDN"
							sudo rm -f $BASE/tmp/$RANDOMAFSMT
							
							nohup $BASE/Scripts/Cloud-Instance-Exec.sh "AZURE_UBU├$thenohupfile" "A" "$tv32" "$tv30" "$tv6" "$tv31" "$tv38" "$tv36" "$tv39" > $BASE/tmp/$thenohupfile-$tv38-CIE.out 2>&1 & 
						fi
					fi
					
					if [ "$THEREQCLD" == "AZURE" ]; then
						if [ "$tv17" == "ALMA" ]; then
							tv36="s$tv0""i$tv1""bsa"
							IFS='├' read -ra _tv3 <<< "$tv3"
							tv37="${_tv3[0]}"
							trr_md5="${THEREQVISID}├${tv37}"
							tv_3_9=$(echo -n "$trr_md5" | md5sum | awk '{print $1}')
							tv39="${tv_3_9:0:22}""sa"						
							tv38=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
							
							nohup $BASE/Scripts/Cloud-Instance-Exec.sh "AZURE_ALMA" "A" "$tv32" "$tv30" "$tv6" "$tv31" "$tv38" "$tv36" "$tv39" > $BASE/tmp/$tv38-CIE.out 2>&1 & 
						fi
					fi					
									
					if [ "$THEREQCLD" == "AWS" ]; then
						if [ "$tv17" == "UBU" ]; then
							tv36="s$tv0""i$tv1""s3rb"
							IFS='├' read -ra _tv3 <<< "$tv3"
							tv37="${_tv3[2]}"
							trr_md5="${THEREQVISID}├${tv37}"
							tv39=$(echo -n "$trr_md5" | md5sum | awk '{print $1}')						
							tv38=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
							
							nohup $BASE/Scripts/Cloud-Instance-Exec.sh "AWS_UBU├$thenohupfile" "A" "$tv32" "$tv30" "$tv6" "$tv31" "$tv38" "$tv36" "$tv37" "aws$tv39" > $BASE/tmp/$thenohupfile-$tv38-CIE.out 2>&1 & 
						fi
					fi
					
					if [ "$THEREQCLD" == "AWS" ]; then
						if [ "$tv17" == "AZL" ]; then
							tv36="s$tv0""i$tv1""s3rb"
							IFS='├' read -ra _tv3 <<< "$tv3"
							tv37="${_tv3[2]}"
							trr_md5="${THEREQVISID}├${tv37}"
							tv39=$(echo -n "$trr_md5" | md5sum | awk '{print $1}')						
							tv38=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
							
							nohup $BASE/Scripts/Cloud-Instance-Exec.sh "AWS_AZL" "A" "$tv32" "$tv30" "$tv6" "$tv31" "$tv38" "$tv36" "$tv37" "aws$tv39" > $BASE/tmp/$tv38-CIE.out 2>&1 & 
						fi
					fi
					
					if [ "$THEREQCLD" == "AWS" ]; then
						if [ "$tv17" == "ALMA" ]; then
							tv36="s$tv0""i$tv1""s3rb"
							IFS='├' read -ra _tv3 <<< "$tv3"
							tv37="${_tv3[2]}"
							trr_md5="${THEREQVISID}├${tv37}"
							tv39=$(echo -n "$trr_md5" | md5sum | awk '{print $1}')						
							tv38=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
							
							nohup $BASE/Scripts/Cloud-Instance-Exec.sh "AWS_ALMA" "A" "$tv32" "$tv30" "$tv6" "$tv31" "$tv38" "$tv36" "$tv37" "aws$tv39" > $BASE/tmp/$tv38-CIE.out 2>&1 & 
						fi
					fi										
				fi
				
				IFS='├' read -ra _gi <<< "$sshinfo"
				tv33="${_gi[0]}"				
				tv34="${_gi[1]}"
				tv35="${_gi[2]}"
				
				THENEWTVLINE="$tv0,$tv1,$tv2,$tv3,$tv4,$tv5,$tv6,$tv7,$tv8,$tv9,$tv10,$tv11,$tv12,$tv13,$tv14,$tv15,$tv16,$tv17,$tv18,$tv33,$tv34,$tv35,$tv22,$tv23,$tv24,$tv25,$tv26,$tv27"
								
				if [ -n "$tv29" ]; then
					line_number=$(echo "$tv29" | awk -F ':' 'NR==1 {print $1}')
					content=$(echo "$tv29" | awk -F ':' 'NR==1 {print $2}')
					
					while true; do
					    (
						flock -x -w 10 200 || exit 1
						#sed -i "$line_number""s#.*#$line#" "$thereal2file"
						sed -i "$line_number""s#.*#$THENEWTVLINE#" "$therealfile"
						echo "File updated successfully!"
						exit 0
					    #) 200<>"$thereal2file"
					    ) 200<>"$therealfile"
					    if [[ $? -eq 0 ]]; then
						break
					    else
						sleep 1
					    fi
					done					
				fi		        				    	
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
		sudo touch $ALLWORK1FOLDER1SYNC/$RND1CLD1XM
		sudo chmod 777 $ALLWORK1FOLDER1SYNC/$RND1CLD1XM		
		echo '#!/bin/bash' | sudo tee -a $ALLWORK1FOLDER1SYNC/$RND1CLD1XM > /dev/null
		echo '' | sudo tee -a $ALLWORK1FOLDER1SYNC/$RND1CLD1XM > /dev/null
		echo "sudo rm -f \"$WIP_LIST\"" | sudo tee -a $ALLWORK1FOLDER1SYNC/$RND1CLD1XM > /dev/null
		echo "sudo rm -rf \"$WIP_FOLDER\"" | sudo tee -a $ALLWORK1FOLDER1SYNC/$RND1CLD1XM > /dev/null						
		#sudo rm -f $BASE/tmp/$thenohupfile-JOBLOG2.out
		sudo mv $BASE/tmp/$thenohupfile-JOBLOG2.out $BASE/Output/Logs/$thenohupfile-JOBLOG2.out
		
		echo "All files processed. Exiting."
		notify-send -t 5000 "Progress" "All files processed. Exiting.Cloud-Instance-Sync A Function [$THEREQCLD]"
				
		break
	    fi

	    sleep 15
	done
fi

if [ "$THEMODEOFEXECUTION" == "B" ]; then
	THEMAINJOBFOLDER="$2"
	WIP_FOLDER="$3"
	WIPX_LIST="$4"
	THE1STACK1FILE="$5"
	THE1VISION1KEY="$6"
	SOFTSTACK="$7"
	VAMANA="$8"
	UNQRUNID="$9"
	RNDMJX1="${10}"
	TheFileToMonitor="${11}"
	TheFinalLogFolder="${12}"
			
	source $BASE/Resources/StackVersioningAndMisc

	file2_exists() {
	    [[ -f "$1" ]]
	}

	declare -a processed_files

	while true; do
	    mapfile -t files < "$WIPX_LIST"

	    for file in "${files[@]}"; do
		if file2_exists "$file"; then
		    if [[ ! " ${processed_files[@]} " =~ " $file " ]]; then
		        echo "Processing file: $file"
		        
		        sudo chmod 777 $file
		        $file
		        		        								        
		        processed_files+=("$file")
		    else
		        echo "file already done $file"
		    fi
		else
		    echo "file not found $file"
		fi
	    done

	    if [[ "${#processed_files[@]}" -eq "${#files[@]}" ]]; then	
		THEFILEFORNEWVAL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
		sudo touch $BASE/tmp/$THEFILEFORNEWVAL
		sudo chmod 777 $BASE/tmp/$THEFILEFORNEWVAL 	
		CSVFILE_ENC_DYC "$THE1STACK1FILE" "6,12,13,14,15,23,24,25,26" "27" "Y" "encrypt" "$THE1VISION1KEY" "1" "27" "$BASE/tmp/$THEFILEFORNEWVAL"
		sudo rm -f $THE1STACK1FILE
		sudo mv $BASE/tmp/$THEFILEFORNEWVAL $THE1STACK1FILE
		
		if [ "$SOFTSTACK" == "NA" ]; then
			echo "SOFTSTACK : $SOFTSTACK"
		else
			PART_1=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
			#sudo touch $BASE/tmp/$PART_1
			#sudo chmod 777 $BASE/tmp/$PART_1		
			cut -d ',' -f 1-28 $THE1STACK1FILE > $BASE/tmp/$PART_1.csv

			PART_2=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
			#sudo touch $BASE/tmp/$PART_2
			#sudo chmod 777 $BASE/tmp/$PART_2
			awk -F ',' '{ for (i = 3; i <= NF; i++) printf "%s%s", $i, (i<NF ? "," : "\n") }' $SOFTSTACK > $BASE/tmp/$PART_2.csv

			PART_3=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
			#sudo touch $BASE/tmp/$PART_3
			#sudo chmod 777 $BASE/tmp/$PART_3
			paste -d ',' $BASE/tmp/$PART_1.csv $BASE/tmp/$PART_2.csv > $BASE/tmp/$PART_3.csv
			
			sudo rm -f $THE1STACK1FILE
			sudo mv $BASE/tmp/$PART_3.csv $THE1STACK1FILE		

			sudo rm $BASE/tmp/$PART_1.csv $BASE/tmp/$PART_2.csv
		fi
		
		TheFinalMessageFile="$BASE/Output/Logs/$UNQRUNID-MATSYA-SUCCESS"
		
		if [ "$TheFileToMonitor" == "NA" ] ; then
			echo "No End Level Monitoring Required For $UNQRUNID..."
		else
			max_time=3600
			interval=10
			start_time=$(date +%s)
			while true; do
			    if [ -e "$TheFileToMonitor" ]; then
				echo "$TheFileToMonitor Now Available..."
				sudo rm -f $TheFileToMonitor
				break
			    fi
			    current_time=$(date +%s)
			    elapsed_time=$((current_time - start_time))
			    if [ $elapsed_time -ge $max_time ]; then
				echo "Error: Maximum Time Limit Reached... $TheFileToMonitor Not Found..."
				TheFinalMessageFile="$BASE/Output/Logs/$UNQRUNID-MATSYA-FAILURE"
				VAMANA="NA"
				break
			    fi
			    sleep $interval
			done		
		fi
		
		sudo rm -rf $THEMAINJOBFOLDER						
							
		echo "All files processed. Exiting."
		notify-send -t 5000 "Progress" "All files processed. Exiting.Cloud-Instance-Sync B Function"
		
		if [ "$VAMANA" == "NA" ]; then
			echo "VAMANA : $VAMANA"
		else
			echo "Processing VAMANA..."
			notify-send -t 5000 "Progress" "Processing VAMANA..."
			IFS='├' read -r -a THE_ARGS <<< $VAMANA
			echo "VAMANA : $VAMANA"
			INSTANCE_DETAILS_FILE="${THE_ARGS[0]}"
			VISION_KEY="${THE_ARGS[1]}"
			THEVISIONID="${THE_ARGS[2]}"			
			ADMIN_PASSWORD="${THE_ARGS[3]}"	
			WEBSSH_PASSWORD="${THE_ARGS[4]}"
			PREP_ONLY="${THE_ARGS[5]}"
			AutoPorts="${THE_ARGS[6]}"			
			echo '{
  "ScopeFile": "'"$INSTANCE_DETAILS_FILE"'",
  "VisionKey": "'"$VISION_KEY"'",
  "Identity": "'"$UNQRUNID"'",  
  "VisionId": "'"$THEVISIONID"'",
  "FromMatsya": "Y",
  "WebSSHKey": "'"$WEBSSH_PASSWORD"'",       
  "AdminKey": "'"$ADMIN_PASSWORD"'",       
  "PrepOnly": "'"$PREP_ONLY"'",       
  "ChitraGupta": "NA",       
  "AutoPorts": "'"$AutoPorts"'"      
}'			

			#sleep 60
			#notify-send -t 5000 "Progress" "Starting VAMANA..."
			
			nohup /opt/Matsya/Scripts/MAYADHI.sh 'VAMANA' '{
  "ScopeFile": "'"$INSTANCE_DETAILS_FILE"'",
  "VisionKey": "'"$VISION_KEY"'",
  "Identity": "'"$UNQRUNID"'",  
  "VisionId": "'"$THEVISIONID"'",
  "FromMatsya": "Y",
  "WebSSHKey": "'"$WEBSSH_PASSWORD"'",       
  "AdminKey": "'"$ADMIN_PASSWORD"'",       
  "PrepOnly": "'"$PREP_ONLY"'",       
  "ChitraGupta": "NA",       
  "AutoPorts": "'"$AutoPorts"'"      
}' > $BASE/Output/Logs/$UNQRUNID-Cloud-Instance-Sync-B-VAMANA-Initiate.out 2>&1 &							
		fi
		
		sudo touch $TheFinalMessageFile
		sudo chmod 777 $TheFinalMessageFile
		
		sudo mv $BASE/tmp/$RNDMJX1-Cloud-Instance-Sync-B.out $BASE/Output/Logs/$UNQRUNID-$RNDMJX1-Cloud-Instance-Sync-B.out
		#sudo rm -f $BASE/tmp/$RNDMJX1-Cloud-Instance-Sync-B.out
		
		sudo mv $BASE/Output/Logs/$UNQRUNID-* $TheFinalLogFolder
		rename 's/'"$UNQRUNID"'-//' $TheFinalLogFolder/$UNQRUNID-*
				
		break
	    fi

	    sleep 20
	done
fi

