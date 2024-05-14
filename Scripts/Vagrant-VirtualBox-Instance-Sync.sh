#!/bin/bash

CURRENTUSER=$(whoami)
sudo rm -rf /home/$CURRENTUSER/.ssh/known_hosts
sudo rm -rf /root/.ssh/known_hosts

BASE="/opt/Matsya"
sudo mkdir -p $BASE
sudo mkdir -p $BASE/tmp
sudo chmod -R 777 $BASE/tmp
sudo mkdir -p $BASE/Scripts
sudo mkdir -p $BASE/Secrets
sudo mkdir -p $BASE/Resources
sudo mkdir -p $BASE/Output
sudo mkdir -p $BASE/Output/Terraform

if [[ ! -d "$BASE/Output/Pem" ]]; then
	sudo mkdir -p $BASE/Output/Pem
	sudo chmod -R 777 $BASE/Output/Pem
fi

THEMODEOFEXECUTION="$1"

if [ "$THEMODEOFEXECUTION" == "A" ]; then
	THEORIGINALFILE=$2
	THESERVER=$3
	AUTHDETAILS=$4
	THENEWFILE=$5
	CLUSTERNAME=$6
	THEFILEWHICHRANEVERYTHING=$7
	THEFILEWHICHRANCRON=$8
	THEMACHINEFROMWHEREITALLSTARTED=$9
	ACKFOLDER="${10}"
	THEREALFILE2_2="${11}"
	THEVISION1KEY="${12}"
	
	source $BASE/Resources/StackVersioningAndMisc
	
	IP_ADDRESS_HYPHEN10=${THESERVER//./-}
	THENEWPEM="$BASE/Output/Pem/op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN10.pem"
	IFS='"■"' read -r auth_type user port password_pem <<< "$AUTHDETAILS"
	THENEWLOCALFILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	THENEWLOCALPEM=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	#THENEWLOCALPEM="${THENEWPEM##*/}"

	while true; do
		if [ "$auth_type" == "UP" ]; then
		    if sshpass -p "$password_pem" ssh -p "$port" -o StrictHostKeyChecking=no "$user@$THESERVER" "[ -f '$THENEWFILE' ]"; then
			echo "File $THENEWFILE exists on THESERVER $THESERVER"
			#notify-send -t 5000 "$CLUSTERNAME Progress" "File $THENEWFILE exists on THESERVER $THESERVER"
			break
		    else
			echo "File $THENEWFILE does not exist on THESERVER $THESERVER"
		    fi
		elif [ "$auth_type" == "PEM" ]; then
		    if ssh -p "$port" -o StrictHostKeyChecking=no -i "$password_pem" "$user@$THESERVER" "[ -f '$THENEWFILE' ]"; then
			echo "File $THENEWFILE exists on THESERVER $THESERVER"
			#notify-send -t 5000 "$CLUSTERNAME Progress" "File $THENEWFILE exists on THESERVER $THESERVER"
			break
		    else
			echo "File $THENEWFILE does not exist on THESERVER $THESERVER"
		    fi
		fi
		
		sleep 20
	done

	if [ "$THEMACHINEFROMWHEREITALLSTARTED" == "$THESERVER" ]; then
		sudo mv $THENEWFILE $BASE/tmp/$THENEWLOCALFILE
		#sudo touch $ACKFOLDER/$IP_ADDRESS_HYPHEN10
		#sudo chmod 777 $ACKFOLDER/$IP_ADDRESS_HYPHEN10
		sudo mv $BASE/tmp/$THENEWLOCALFILE $ACKFOLDER/$IP_ADDRESS_HYPHEN10
		sudo chmod 777 $ACKFOLDER/$IP_ADDRESS_HYPHEN10
		
		THEFILEFORNEWVAL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
		sudo touch $BASE/tmp/$THEFILEFORNEWVAL
		sudo chmod 777 $BASE/tmp/$THEFILEFORNEWVAL 	
		CSVFILE_ENC_DYC "$ACKFOLDER/$IP_ADDRESS_HYPHEN10" "6,12,13,14,15,23,24,25,26" "27" "Y" "encrypt" "$THEVISION1KEY" "0" "27" "$BASE/tmp/$THEFILEFORNEWVAL"
		#echo "'$ACKFOLDER/$IP_ADDRESS_HYPHEN10:6,12,13,14,15,23,24,25,26:27:Y:encrypt:$THEVISION1KEY:0:27:$BASE/tmp/$THEFILEFORNEWVAL'" | sudo tee -a /home/prathamos/Downloads/log > /dev/null
		sudo rm -f $ACKFOLDER/$IP_ADDRESS_HYPHEN10
		sudo mv $BASE/tmp/$THEFILEFORNEWVAL $ACKFOLDER/$IP_ADDRESS_HYPHEN10		
		#echo '#!/bin/bash' | sudo tee -a $ACKFOLDER/$IP_ADDRESS_HYPHEN10 > /dev/null
		#echo "ls $THENEWPEM" | sudo tee -a $ACKFOLDER/$IP_ADDRESS_HYPHEN10 > /dev/null
		#$ACKFOLDER/$IP_ADDRESS_HYPHEN10
		sudo rm -f $THEFILEWHICHRANEVERYTHING
		sudo rm -f $THEFILEWHICHRANCRON	
	else
		while true; do
			if [ "$auth_type" == "UP" ]; then
			    if sshpass -p "$password_pem" ssh -p "$port" -o StrictHostKeyChecking=no "$user@$THESERVER" "[ -f '$THENEWFILE' ]"; then
			    	#notify-send -t 5000 "$CLUSTERNAME Progress" "RESULT $THENEWFILE EXISTS ... $THESERVER"
			    	#sudo rm -f $BASE/tmp/$THENEWLOCALFILE
				sshpass -p "$password_pem" scp -o StrictHostKeyChecking=no -P $port "$user@$THESERVER:$THENEWFILE" "$BASE/tmp/$THENEWLOCALFILE"
				sshpass -p "$password_pem" ssh -p "$port" -o StrictHostKeyChecking=no "$user@$THESERVER" "sudo rm -rf $THENEWFILE"	
			    else
				echo "RESULT $THENEWFILE does not exist on THESERVER $THESERVER"
				#notify-send -t 5000 "$CLUSTERNAME Progress" "RESULT $THENEWFILE does not exist on THESERVER $THESERVER"
				break
			    fi
			elif [ "$auth_type" == "PEM" ]; then
			    if ssh -p "$port" -o StrictHostKeyChecking=no -i "$password_pem" "$user@$THESERVER" "[ -f '$THENEWFILE' ]"; then
			    	#notify-send -t 5000 "$CLUSTERNAME Progress" "RESULT $THENEWFILE EXISTS ... $THESERVER"
			    	#sudo rm -f $BASE/tmp/$THENEWLOCALFILE
				scp -i "$password_pem" -o StrictHostKeyChecking=no -P $port "$user@$THESERVER:$THENEWFILE" "$BASE/tmp/$THENEWLOCALFILE"
				ssh -p "$port" -o StrictHostKeyChecking=no -i "$password_pem" "$user@$THESERVER" "sudo rm -rf $THENEWFILE"
			    else
				echo "RESULT $THENEWFILE does not exist on THESERVER $THESERVER"
				#notify-send -t 5000 "$CLUSTERNAME Progress" "RESULT $THENEWFILE does not exist on THESERVER $THESERVER"
				break
			    fi
			fi
			
			sleep 30
		done	
	
		if [ "$auth_type" == "UP" ]; then
			sshpass -p "$password_pem" ssh -p "$port" -o StrictHostKeyChecking=no "$user@$THESERVER" "sudo rm -rf $THEFILEWHICHRANEVERYTHING && sudo rm -rf $THEFILEWHICHRANCRON"
			#sudo touch $ACKFOLDER/$IP_ADDRESS_HYPHEN10
			#sudo chmod 777 $ACKFOLDER/$IP_ADDRESS_HYPHEN10
			#echo '#!/bin/bash' | sudo tee -a $ACKFOLDER/$IP_ADDRESS_HYPHEN10 > /dev/null
			#echo "sshpass -p \"$password_pem\" scp -o StrictHostKeyChecking=no -P $port \"$user@$THESERVER:$THENEWPEM\" \"$BASE/tmp/$THENEWLOCALPEM\"" | sudo tee -a $ACKFOLDER/$IP_ADDRESS_HYPHEN10 > /dev/null
			#$ACKFOLDER/$IP_ADDRESS_HYPHEN10
			sudo mv $BASE/tmp/$THENEWLOCALFILE $ACKFOLDER/$IP_ADDRESS_HYPHEN10
			sudo chmod 777 $ACKFOLDER/$IP_ADDRESS_HYPHEN10
			
			THEFILEFORNEWVAL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
			sudo touch $BASE/tmp/$THEFILEFORNEWVAL
			sudo chmod 777 $BASE/tmp/$THEFILEFORNEWVAL 	
			CSVFILE_ENC_DYC "$ACKFOLDER/$IP_ADDRESS_HYPHEN10" "6,12,13,14,15,23,24,25,26" "27" "Y" "encrypt" "$THEVISION1KEY" "0" "27" "$BASE/tmp/$THEFILEFORNEWVAL"
			sudo rm -f $ACKFOLDER/$IP_ADDRESS_HYPHEN10
			sudo mv $BASE/tmp/$THEFILEFORNEWVAL $ACKFOLDER/$IP_ADDRESS_HYPHEN10
			#echo "'$ACKFOLDER/$IP_ADDRESS_HYPHEN10:6,12,13,14,15,23,24,25,26:27:Y:encrypt:$THEVISION1KEY:0:27:$BASE/tmp/$THEFILEFORNEWVAL'" | sudo tee -a /home/prathamos/Downloads/log > /dev/null									
		elif [ "$auth_type" == "PEM" ]; then
			ssh -p "$port" -o StrictHostKeyChecking=no -i "$password_pem" "$user@$THESERVER" "sudo rm -rf $THEFILEWHICHRANEVERYTHING && sudo rm -rf $THEFILEWHICHRANCRON"
			#sudo touch $ACKFOLDER/$IP_ADDRESS_HYPHEN10
			#sudo chmod 777 $ACKFOLDER/$IP_ADDRESS_HYPHEN10	
			#echo '#!/bin/bash' | sudo tee -a $ACKFOLDER/$IP_ADDRESS_HYPHEN10 > /dev/null
			#echo "scp -i \"$password_pem\" -o StrictHostKeyChecking=no -P $port \"$user@$THESERVER:$THENEWPEM\" \"$BASE/tmp/$THENEWLOCALPEM\"" | sudo tee -a $ACKFOLDER/$IP_ADDRESS_HYPHEN10 > /dev/null
			#$ACKFOLDER/$IP_ADDRESS_HYPHEN10
			sudo mv $BASE/tmp/$THENEWLOCALFILE $ACKFOLDER/$IP_ADDRESS_HYPHEN10
			sudo chmod 777 $ACKFOLDER/$IP_ADDRESS_HYPHEN10
			
			THEFILEFORNEWVAL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
			sudo touch $BASE/tmp/$THEFILEFORNEWVAL
			sudo chmod 777 $BASE/tmp/$THEFILEFORNEWVAL 	
			CSVFILE_ENC_DYC "$ACKFOLDER/$IP_ADDRESS_HYPHEN10" "6,12,13,14,15,23,24,25,26" "27" "Y" "encrypt" "$THEVISION1KEY" "0" "27" "$BASE/tmp/$THEFILEFORNEWVAL"
			sudo rm -f $ACKFOLDER/$IP_ADDRESS_HYPHEN10
			sudo mv $BASE/tmp/$THEFILEFORNEWVAL $ACKFOLDER/$IP_ADDRESS_HYPHEN10								
		fi
	fi
fi

if [ "$THEMODEOFEXECUTION" == "B" ]; then
	WIP_FOLDER="$3"
	WIP_LIST="$2"
	visionkey=$4
	therealfile=$5	
	thereal2file=$6
	source $BASE/Resources/StackVersioningAndMisc
	# Function to check if file exists
	file_exists() {
	    [[ -f "$1" ]]
	}

	# Initialize an empty array to store processed files
	declare -a processed_files

	# Continuously monitor the folder for new files
	while true; do
	    # Read the file names into an array
	    mapfile -t files < "$WIP_LIST"

	    # Process each file in the list
	    for file in "${files[@]}"; do
		if file_exists "$WIP_FOLDER/$file"; then
		    # Check if the file has already been processed
		    if [[ ! " ${processed_files[@]} " =~ " $file " ]]; then
		        echo "Processing file: $WIP_FOLDER/$file"
		        #notify-send -t 5000 "$CLUSTERNAME Progress" "Processing file: $WIP_FOLDER/$file"
		        
		        while IFS= read -r line; do
				IFS=',' read -ra fields <<< "$line"
				if [[ -z "${fields[0]}" || -z "${fields[1]}" || -z "${fields[2]}" || -z "${fields[3]}" ]]; then
				    echo "Data is invalid"
				else
				    echo "Data is OK"
				    #notify-send -t 5000 "$CLUSTERNAME Progress" "Data is OK : $line"
				    echo "$line" >> "$thereal2file"
				    #echo "$WIP_FOLDER/$file : '$line'" | sudo tee -a /home/prathamos/Downloads/log > /dev/null
				    #echo "" | sudo tee -a /home/prathamos/Downloads/log > /dev/null
				fi		        				    	
			done < "$WIP_FOLDER/$file"
								        
		        processed_files+=("$file")
		    else
		        echo "file already done $WIP_FOLDER/$file"
		        #notify-send -t 5000 "$CLUSTERNAME Progress" "file already done $WIP_FOLDER/$file"
		    fi
		else
		    echo "file not found $WIP_FOLDER/$file"
		    #notify-send -t 5000 "$CLUSTERNAME Progress" "file not found $WIP_FOLDER/$file"
		fi
	    done

	    # Check if all files in the list have been processed
	    if [[ "${#processed_files[@]}" -eq "${#files[@]}" ]]; then
		# Remove the list file and exit
		rm -f "$WIP_LIST"
		echo "All files processed. Exiting."
		notify-send -t 5000 "$CLUSTERNAME Progress" "All files processed. Exiting.Vagrant-VirtualBox-Instance-Sync B Function"
		sudo rm -f $therealfile
		sudo mv $thereal2file $therealfile
		sudo chmod 777 $therealfile
		
		pattern=$(echo "$WIP_FOLDER" | awk -F'/' '{print $NF}' | sed 's/-WIP//')
		sudo rm -f $BASE/Output/Pem/op-$pattern.pub
				
		nohup $BASE/Scripts/Vagrant-VirtualBox-Instance-Sync.sh "D" "$WIP_LIST" "$WIP_FOLDER" "$thereal2file" 2>&1 &
		break
	    fi

	    # Wait for a short duration before polling again
	    sleep 30
	done
fi

if [ "$THEMODEOFEXECUTION" == "C" ]; then
	source $BASE/Resources/StackVersioningAndMisc

	thenew1file=$2
	theoldfile=$3
	thevisionkey=$4	
	#notify-send -t 5000 "$CLUSTERNAME Progress" "Vagrant-VirtualBox-Instance-Sync C Function.GOT FILE $thenew1file and  $theoldfile and VisionKey = $thevisionkey"	
	cat $thenew1file >> $theoldfile
	#sudo rm -f $thenew1file
fi

if [ "$THEMODEOFEXECUTION" == "D" ]; then
	thefiletodelete=$2
	thefoldertocheck=$3
	thefile2todelete=$4
	#notify-send -t 5000 "$CLUSTERNAME Progress" "Vagrant-VirtualBox-Instance-Sync D Function.GOT $thefiletodelete and  $thefoldertocheck and  $thefile2todelete"	
	sudo rm -f $thefiletodelete
	sudo rm -rf $thefoldertocheck
	sudo rm -f $thefile2todelete		
fi

