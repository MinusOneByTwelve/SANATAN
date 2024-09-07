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

DEBUG="NO"
THEMODEOFEXECUTION="$1"

if [ "$DEBUG" == "YES" ] ; then
	THEDEBUGFILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	echo "" | sudo tee $BASE/tmp/VVBIS-THEMODEOFEXECUTION_$THEMODEOFEXECUTION-$THEDEBUGFILE > /dev/null	
fi

LogNotification() {
	local Header="$1"
	local Message="$2"
	if [ "$DEBUG" == "YES" ] ; then
		echo "$Message" | sudo tee -a $BASE/tmp/VVBIS-THEMODEOFEXECUTION_$THEMODEOFEXECUTION-$THEDEBUGFILE > /dev/null
	fi	
}

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
			echo "File $THENEWFILE exists on THESERVER UP $THESERVER"
			LogNotification "$CLUSTERNAME Progress" "File $THENEWFILE exists on THESERVER UP $THESERVER"
			break
		    else
			echo "File $THENEWFILE does not exist on THESERVER $THESERVER"
		    fi
		elif [ "$auth_type" == "PEM" ]; then
		    if ssh -p "$port" -o StrictHostKeyChecking=no -i "$password_pem" "$user@$THESERVER" "[ -f '$THENEWFILE' ]"; then
			echo "File $THENEWFILE exists on THESERVER PEM $THESERVER"
			LogNotification "$CLUSTERNAME Progress" "File $THENEWFILE exists on THESERVER PEM $THESERVER"
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
			    	LogNotification "$CLUSTERNAME Progress" "RESULT $THENEWFILE EXISTS UP ... $THESERVER"
			    	#sudo rm -f $BASE/tmp/$THENEWLOCALFILE
				sshpass -p "$password_pem" scp -o StrictHostKeyChecking=no -P $port "$user@$THESERVER:$THENEWFILE" "$BASE/tmp/$THENEWLOCALFILE"
				sshpass -p "$password_pem" ssh -p "$port" -o StrictHostKeyChecking=no "$user@$THESERVER" "sudo rm -rf $THENEWFILE"	
			    else
				echo "RESULT $THENEWFILE does not exist on THESERVER $THESERVER"
				LogNotification "$CLUSTERNAME Progress" "RESULT $THENEWFILE does not exist on THESERVER $THESERVER"
				break
			    fi
			elif [ "$auth_type" == "PEM" ]; then
			    if ssh -p "$port" -o StrictHostKeyChecking=no -i "$password_pem" "$user@$THESERVER" "[ -f '$THENEWFILE' ]"; then
			    	LogNotification "$CLUSTERNAME Progress" "RESULT $THENEWFILE EXISTS PEM ... $THESERVER"
			    	#sudo rm -f $BASE/tmp/$THENEWLOCALFILE
				scp -i "$password_pem" -o StrictHostKeyChecking=no -P $port "$user@$THESERVER:$THENEWFILE" "$BASE/tmp/$THENEWLOCALFILE"
				ssh -p "$port" -o StrictHostKeyChecking=no -i "$password_pem" "$user@$THESERVER" "sudo rm -rf $THENEWFILE"
			    else
				echo "RESULT $THENEWFILE does not exist on THESERVER $THESERVER"
				LogNotification "$CLUSTERNAME Progress" "RESULT $THENEWFILE does not exist on THESERVER $THESERVER"
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
	THESTACKREALFILE=$7
	ALLWORKFOLDER1SYNC=$8
	RNDOPRMXM=$9
	UNQRQ1="${10}"
	THEVISIONFOLDER="${11}"
		
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
		        LogNotification "$CLUSTERNAME Progress" "Processing file: $WIP_FOLDER/$file"
		        
		        while IFS= read -r line; do
				IFS=',' read -ra fields <<< "$line"
				if [[ -z "${fields[0]}" || -z "${fields[1]}" || -z "${fields[2]}" || -z "${fields[3]}" ]]; then
				    echo "Data is invalid"
				else
				    echo "Data is OK"
				    LogNotification "$CLUSTERNAME Progress" "Data is OK : $line"
				    echo "$line" >> "$thereal2file"
				    #echo "$WIP_FOLDER/$file : '$line'" | sudo tee -a /home/prathamos/Downloads/log > /dev/null
				    #echo "" | sudo tee -a /home/prathamos/Downloads/log > /dev/null
				fi		        				    	
			done < "$WIP_FOLDER/$file"
								        
		        processed_files+=("$file")
		    else
		        echo "file already done $WIP_FOLDER/$file"
		        LogNotification "$CLUSTERNAME Progress" "file already done $WIP_FOLDER/$file"
		    fi
		else
		    echo "file not found $WIP_FOLDER/$file"
		    LogNotification "$CLUSTERNAME Progress" "file not found $WIP_FOLDER/$file"
		fi
	    done

	    # Check if all files in the list have been processed
	    if [[ "${#processed_files[@]}" -eq "${#files[@]}" ]]; then
		# Remove the list file and exit
		rm -f "$WIP_LIST"
		echo "All files processed. Exiting."
		LogNotification "$CLUSTERNAME Progress" "All files processed. Exiting.Vagrant-VirtualBox-Instance-Sync B Function"
		sudo rm -f $therealfile
		sudo mv $thereal2file $therealfile
		sudo chmod 777 $therealfile
		
		pattern=$(echo "$WIP_FOLDER" | awk -F'/' '{print $NF}' | sed 's/-WIP//')
		sudo rm -f $BASE/Output/Pem/op-$pattern.pub
				
		nohup $BASE/Scripts/Vagrant-VirtualBox-Instance-Sync.sh "D" "$WIP_LIST" "$WIP_FOLDER" "$thereal2file" "$THESTACKREALFILE" "$ALLWORKFOLDER1SYNC" "$RNDOPRMXM" "$therealfile" "$UNQRQ1" "$THEVISIONFOLDER" "$visionkey" 2>&1 &
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
	#LogNotification "$CLUSTERNAME Progress" "Vagrant-VirtualBox-Instance-Sync C Function.GOT FILE $thenew1file and  $theoldfile and VisionKey = $thevisionkey"	
	cat $thenew1file >> $theoldfile
	#sudo rm -f $thenew1file
fi

if [ "$THEMODEOFEXECUTION" == "D" ]; then
	thefiletodelete=$2
	thefoldertocheck=$3
	thefile2todelete=$4
	THE1STACKREALFILE=$5
	AL1LWORKFOLDER1SYNC=$6
	RND1OPRMXM=$7
	THEREPLACEMENT=$8
	UNQ1RQ1=$9
	THEVISION1FOLDER="${10}"
	V1ISION1KEY="${11}"
			
	LogNotification "$CLUSTERNAME Progress" "came to Vagrant-VirtualBox-Instance-Sync D Function :::: $THE1STACKREALFILE :::: $AL1LWORKFOLDER1SYNC :::: $RND1OPRMXM :::: $THEREPLACEMENT"
	#echo "came to Vagrant-VirtualBox-Instance-Sync D Function :::: $THE1STACKREALFILE :::: $AL1LWORKFOLDER1SYNC :::: $RND1OPRMXM :::: $THEREPLACEMENT :::: $thefile2todelete :::: $thefoldertocheck :::: $thefiletodelete" | sudo tee -a /home/prathamos/Downloads/log > /dev/null
        while IFS= read -r line; do
        	IFS=',' read -ra fields <<< "$line"
        	tv0="${fields[0]}"
        	tv1="${fields[1]}"     			      		        	
        	tv28="$tv0,$tv1"
        	
        	if [ "$tv28" != "," ]; then
			tv29=$(grep -n "^$tv28" $THE1STACKREALFILE)
									
			if [ -n "$tv29" ]; then
				line_number=$(echo "$tv29" | awk -F ':' 'NR==1 {print $1}')
				content=$(echo "$tv29" | awk -F ':' 'NR==1 {print $2}')
				LogNotification "$CLUSTERNAME Progress" "line_number : $line_number   ::::::::::  content : $content"
				#echo "line_number : $line_number   ::::::::::  content : $content   ::::::::::  line : $line" | sudo tee -a /home/prathamos/Downloads/log > /dev/null
				while true; do
				    (
					flock -x -w 10 200 || exit 1
					sed -i "$line_number""s#.*#$line#" "$THE1STACKREALFILE"
					echo "File updated successfully!"
					exit 0
				    ) 200<>"$THE1STACKREALFILE"
				    if [[ $? -eq 0 ]]; then
					break
				    else
					sleep 1
				    fi
				done					
			fi
		fi		        				    	
	done < "$THEREPLACEMENT"	
	
	CURSTAMP=$(date +"%d%m%Y%H%M%S")
	THETASKFOLDER="$THEVISION1FOLDER/$UNQ1RQ1-$CURSTAMP-MATSYA"
	sudo mkdir $THETASKFOLDER
	#sudo cp $thefiletodelete $THETASKFOLDER
	#sudo cp $thefile2todelete $THETASKFOLDER
	sudo cp $THE1STACKREALFILE $THETASKFOLDER/INSTANCES_BASE.csv
	#sudo cp $THEREPLACEMENT $THETASKFOLDER
	
	FILE="$THETASKFOLDER/EXECUTE"
	FIL2E="$THETASKFOLDER/INSTANCES"	
	if [ -f "$FILE" ]; then
	    echo "$FILE Exists..."
	    cat $FILE
	else
	    echo "$FILE does not exist. Creating it..."	    
	    WINLEA='#!/bin/bash'"

THEUSERCHOICE=\"\$1\"
VISIONKEY=\"\$2\"

echo \$THEUSERCHOICE
echo ''

"
	    echo "$WINLEA" | sudo tee $FILE > /dev/null
	    touch $FIL2E
	    sudo chmod 777 $FILE
	    sudo chmod 777 $FIL2E
	    
	    FIL3E="$THEVISION1FOLDER/$UNQ1RQ1-Logs-Real"
	    touch $FIL3E
	    sudo chmod 777 $FIL3E
	    	    	    
	    echo "$FILE created."
	    cat $FILE
	    echo "
$FILE \"\$THEUSERCHOICE\" \"\$VISIONKEY\"
" | sudo tee -a $THEVISION1FOLDER/WingardiumLeviosaAccio.sh > /dev/null
	fi	
					
	sudo chmod -R 777 $THETASKFOLDER
	sudo chmod -R 777 $THEVISION1FOLDER
	
	RNDMJ1=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	nohup $BASE/Scripts/Vagrant-VirtualBox-Instance-Sync.sh "E" "$THEVISION1FOLDER/$UNQ1RQ1-Logs" "$THEVISION1FOLDER" "$UNQ1RQ1" "$BASE/tmp/$UNQ1RQ1-$RNDMJ1-VVISE.out" "$FIL2E" "$V1ISION1KEY" "$THE1STACKREALFILE" > $BASE/tmp/$UNQ1RQ1-$RNDMJ1-VVISE.out 2>&1 &	

	RNDMJ1=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	nohup $BASE/Scripts/Vagrant-VirtualBox-Instance-Sync.sh "Z" "$THEVISION1FOLDER/$UNQ1RQ1-Logs" "$THEVISION1FOLDER/$UNQ1RQ1-Logs-Real" "$BASE/tmp/$UNQ1RQ1-$RNDMJ1-VVISZ.out" "$THETASKFOLDER/INSTANCES_BASE.csv" "$BASE/Output/Logs" > $BASE/tmp/$UNQ1RQ1-$RNDMJ1-VVISZ.out 2>&1 &
	
	DELETESTUFFSCRIPT=$(echo '#!/bin/bash'"
		
sudo rm -f \"$thefiletodelete\"
sudo rm -rf \"$thefoldertocheck\"
sudo rm -rf \"$thefile2todelete\"
")
	echo "$DELETESTUFFSCRIPT" | sudo tee $AL1LWORKFOLDER1SYNC/$RND1OPRMXM > /dev/null
	sudo chmod 777 $AL1LWORKFOLDER1SYNC/$RND1OPRMXM	
	sudo rm -rf /home/$CURRENTUSER/nohup.out	
fi

get_line_count() {
    local file="$1"
    if [[ -f "$file" ]]; then
	wc -l < "$file" | tr -d ' '
    else
	echo "0"
    fi
}
	
if [ "$THEMODEOFEXECUTION" == "E" ]; then
	input_file="$2"
	input_folder="$3"
	input_unique="$4"
	input_log_unique="$5"
	F1IL2E="$6"
    	T1V1_KEY="$7"	
    	THEORIGINALINSTFILE="$8"
    	    	
	local_directory="$BASE/Output/Logs"
	local_2_directory="$input_folder"
	
	while IFS= read -r linesreal; do
	
	    IFS=',' read -ra fiel1ds <<< "$linesreal"
	    FuncVal1="${fiel1ds[0]}"
	    FuncVal2="${fiel1ds[1]}"	    
	    FuncVal3="${fiel1ds[2]}"
	    FuncVal4="${fiel1ds[3]}"
	    FuncVal5="${fiel1ds[4]}"
	    FuncVal6="${fiel1ds[5]}"
	    FuncVal7="${fiel1ds[6]}"
	    FuncVal8="${fiel1ds[7]}"
	    FuncVal9="${fiel1ds[8]}"
	    FuncVal10="${fiel1ds[9]}"
	    	    
	    R1NDMJ1=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	    hyphenated_ip="${FuncVal1//./-}"	    	    	    	    	    
	    nohup $BASE/Scripts/Vagrant-VirtualBox-Instance-Sync.sh "F" "$input_folder" "$BASE/tmp/$input_unique-$R1NDMJ1-$hyphenated_ip-VVISF.out" "$FuncVal1" "$FuncVal2" "$FuncVal3" "$FuncVal4" "$FuncVal5" "$FuncVal6" "$FuncVal7" "$FuncVal8" "$FuncVal9" "$FuncVal10" "$F1IL2E" "$T1V1_KEY" "$input_unique" "$THEORIGINALINSTFILE" > $BASE/tmp/$input_unique-$R1NDMJ1-$hyphenated_ip-VVISF.out 2>&1 &
	    echo "Processing For $FuncVal1..."
	    
	done < "$input_file"
	
	echo "All files processed successfully!"
	
	sudo mv $input_log_unique $local_directory
	sudo mv $BASE/tmp/$input_unique-MAYADHI.out $local_directory
fi

if [ "$THEMODEOFEXECUTION" == "F" ]; then
    inputX_folder="$2"
    FunctionLogFile="$3"

    ip="$4"
    user="$5"	    
    port="$6"
    password="$7"
    pem="$8"
    joblog_file="$9"
    ip_out_file="${10}"
    enc_pem="${11}"
    dec_pem="${12}"
    the1scope1id="${13}"
    F1I1L2E="${14}"
    T1V1KEY="${15}"
    input1_1unique="${16}"
    THEORIGINAL1INSTFILE="${17}"
            
    local_directory="$BASE/Output/Logs"
    local_2_directory="$inputX_folder"
	
    joblog_filename=$(basename "$joblog_file")
    ip_out_filename=$(basename "$ip_out_file")

    if [[ -f "$local_2_directory/$joblog_filename" ]]; then
	echo "$joblog_filename already exists, skipping download."
	sudo mv $local_2_directory/$joblog_filename $local_directory
    else
	echo "Downloading $joblog_filename..."
	if [[ "$pem" == "NA" ]]; then
	    echo "Using password-based authentication."
	    SSHPASS=$password sshpass -e scp -o StrictHostKeyChecking=no -P $port "$user@$ip:$joblog_file" "$local_2_directory/"
	    SSHPASS=$password sshpass -e ssh -o StrictHostKeyChecking=no -p $port "$user@$ip" "sudo rm -f $joblog_file"
	else
	    echo "Using PEM file-based authentication."
	    scp -i "$pem" -o StrictHostKeyChecking=no -P $port "$user@$ip:$joblog_file" "$local_2_directory/"
	    ssh -i "$pem" -o StrictHostKeyChecking=no -p $port "$user@$ip" "sudo rm -f $joblog_file"
	fi
        sudo mv $local_2_directory/$joblog_filename $local_directory
    fi

    if [[ -f "$local_2_directory/$ip_out_filename" ]]; then
	echo "$ip_out_filename already exists, skipping download."
    else
	echo "Downloading $ip_out_filename..."
	if [[ "$pem" == "NA" ]]; then
	    SSHPASS=$password sshpass -e scp -o StrictHostKeyChecking=no -P $port "$user@$ip:$ip_out_file" "$local_2_directory/"
	    SSHPASS=$password sshpass -e ssh -o StrictHostKeyChecking=no -p $port "$user@$ip" "sudo rm -f $ip_out_file"
	else
	    scp -i "$pem" -o StrictHostKeyChecking=no -P $port "$user@$ip:$ip_out_file" "$local_2_directory/"
	    ssh -i "$pem" -o StrictHostKeyChecking=no -p $port "$user@$ip" "sudo rm -f $ip_out_file"
	fi
    fi
    
    if [[ -f "$local_2_directory/$ip_out_filename" ]]; then
    	THEDATAVAL=$(head -n 1 $local_2_directory/$ip_out_filename)
    	IFS='■' read -ra THEDATA_VAL <<< "$THEDATAVAL"
    	THEDATA_VAL_PORT="${THEDATA_VAL[0]}"
    	THEDATA_VAL_IPS="${THEDATA_VAL[1]}"
    	THEDATA_VAL_IDEN="${THEDATA_VAL[2]}"    	
	IFS=',' read -r -a THE_DATA_VAL_IPS <<< "$THEDATA_VAL_IPS"
	IFS=',' read -r -a THE_DATA_VAL_IDEN <<< "$THEDATA_VAL_IDEN"	
	INSTANCESBASE="$F1I1L2E""_BASE.csv"
	INSTANCESFAIL="$F1I1L2E""_FAIL"
		
	for ((i=1; i<${#THE_DATA_VAL_IPS[@]}; i++)); do
		THECURRENTIP="${THE_DATA_VAL_IPS[$i]}"
		THECURRENT_IDEN="${THE_DATA_VAL_IDEN[$i]}"
		THECURRENTIDEN="${THECURRENT_IDEN#ID}"
		
		echo "Processing For THECURRENTIP $THECURRENTIP... THECURRENTIDEN $THECURRENTIDEN... SCOPE $the1scope1id..."
		
		MATCH=$(awk -F',' -v ip="$THECURRENTIP" '$7 == ip' "$INSTANCESBASE")
		if [[ -n "$MATCH" ]]; then
			echo "$MATCH" >> "$F1I1L2E"
			echo "Found and appended: $THECURRENTIP => $MATCH"
		else
			if ping -c 5 "$THECURRENTIP" > /dev/null; then
			    echo "IP $THECURRENTIP Pinging..."
			    if [[ -f "$dec_pem" ]]; then
				ls -l $dec_pem
				sudo chown $CURRENTUSER:$CURRENTUSER $dec_pem
				sudo chmod 600 $dec_pem
				ls -l $dec_pem
				TIMEOUT_DURATION=10							    
			    	#CHECKIFWORKING=$(ssh -p "$THEDATA_VAL_PORT" -o StrictHostKeyChecking=no -i "$dec_pem" "vagrant@$THECURRENTIP" "echo 'WORKING'")
				CHECKIFWORKING=$(timeout $TIMEOUT_DURATION ssh -p "$THEDATA_VAL_PORT" -o StrictHostKeyChecking=no -i "$dec_pem" "vagrant@$THECURRENTIP" "echo 'WORKING'" 2>/dev/null)
				#CHECKIFWORKING=$(timeout 10 SSHPASS="130513" sshpass -e ssh -o StrictHostKeyChecking=no -p 22 "prathamos@$192.168.0.100" "echo 'WORKING'" 2>/dev/null)
				#CHECKIFWORKING=$(sshpass -p "130513" ssh -o ConnectTimeout=15 -p 22 -o "StrictHostKeyChecking=no" prathamos@192.168.0.100 "echo 'WORKING'" 2>/dev/null)				
				if [ $? -eq 124 ]; then
					echo "IP $THECURRENTIP Not Available 1..."
					if [[ -f "$INSTANCESFAIL" ]]; then
						sudo chmod 777 $INSTANCESFAIL
						echo "$ip:$THECURRENTIP" >> "$INSTANCESFAIL"
					else
						sudo touch $INSTANCESFAIL
						sudo chmod 777 $INSTANCESFAIL
						echo "$ip:$THECURRENTIP" >> "$INSTANCESFAIL"
					fi					
				else
					if [ "$CHECKIFWORKING" == "WORKING" ]; then
						MATC1H=$(awk -F',' -v ScopeId="$the1scope1id" -v Identity="$THECURRENTIDEN" '$1 == ScopeId && $2 == Identity' "$INSTANCESBASE")
						if [[ -n "$MATC1H" ]]; then
							echo "IP $THECURRENTIP Available 0..."
							hyphenated1_ip="${THECURRENTIP//./-}"
							source $BASE/Resources/StackVersioningAndMisc
							IFS=',' read -ra splitrealrow <<< "$MATC1H"
							thecolumn_1="${splitrealrow[0]}"
							thecolumn_2="${splitrealrow[1]}"
							thecolumn_3="${splitrealrow[2]}"
							thecolumn_4="${splitrealrow[3]}"
							thecolumn_5="${splitrealrow[4]}"
							thecolumn_6="${splitrealrow[5]}"
							thecolumn_7="$THECURRENTIP"
							thecolumn_8="${splitrealrow[7]}"
							thecolumn_9="${splitrealrow[8]}"
							thecolumn_10="${splitrealrow[9]}"
							thecolumn_11="${splitrealrow[10]}"							
							thecolumn_12="$user"							
							thecolumn_13="$port"
							thecolumn_14="$password"
							thecolumn_15="$pem"
							thecolumn_16="${splitrealrow[15]}"
							thecolumn_17="$hyphenated1_ip"							
							thecolumn_18="${splitrealrow[17]}"
							thecolumn_19="${splitrealrow[18]}"
							thecolumn_20="1"
							thecolumn_21="1"
							thecolumn_22="1"							
							thecolumn_23="vagrant"
							thecolumn_24="$THEDATA_VAL_PORT"							
							thecolumn_25=""							
							thecolumn_26="$dec_pem"							
							thecolumn_27="N"
							thecolumn_28="N"
							
							thenewdecrow="$thecolumn_1,$thecolumn_2,$thecolumn_3,$thecolumn_4,$thecolumn_5,$thecolumn_6,$thecolumn_7,$thecolumn_8,$thecolumn_9,$thecolumn_10,$thecolumn_11,$thecolumn_12,$thecolumn_13,$thecolumn_14,$thecolumn_15,$thecolumn_16,$thecolumn_17,$thecolumn_18,$thecolumn_19,$thecolumn_20,$thecolumn_21,$thecolumn_22,$thecolumn_23,$thecolumn_24,$thecolumn_25,$thecolumn_26,$thecolumn_27,$thecolumn_28"
							THEFILEFORNEW1VAL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
							THEFILEFORNEW2VAL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
							echo "$thenewdecrow" | sudo tee $BASE/tmp/$THEFILEFORNEW2VAL > /dev/null
							sudo chmod 777 $BASE/tmp/$THEFILEFORNEW2VAL
							sudo touch $BASE/tmp/$THEFILEFORNEW1VAL
							sudo chmod 777 $BASE/tmp/$THEFILEFORNEW1VAL 	
							CSVFILE_ENC_DYC "$BASE/tmp/$THEFILEFORNEW2VAL" "6,12,13,14,15,23,24,25,26" "27" "Y" "encrypt" "$T1V1KEY" "0" "27" "$BASE/tmp/$THEFILEFORNEW1VAL"
							sudo rm -f $BASE/tmp/$THEFILEFORNEW2VAL
							sudo mv $BASE/tmp/$THEFILEFORNEW1VAL $BASE/tmp/$THEFILEFORNEW2VAL
							THEDATAXVAL=$(head -n 1 $BASE/tmp/$THEFILEFORNEW2VAL)
							sudo rm -f $BASE/tmp/$THEFILEFORNEW2VAL
							echo "$THEDATAXVAL" >> "$F1I1L2E"
														
							thelinenoinorgfile=$(awk -F, '$1 == "" && $2 == "" { next } NR > 1 && $1 == "'"$the1scope1id"'" && $2 == "'"$THECURRENTIDEN"'" { print NR }' $THEORIGINAL1INSTFILE)
							sed -i "$thelinenoinorgfile""s#.*#$THEDATAXVAL#" "$THEORIGINAL1INSTFILE"
						else
							echo "IP $THECURRENTIP Not Available 2..."
							if [[ -f "$INSTANCESFAIL" ]]; then
								sudo chmod 777 $INSTANCESFAIL
								echo "$ip:$THECURRENTIP" >> "$INSTANCESFAIL"
							else
								sudo touch $INSTANCESFAIL
								sudo chmod 777 $INSTANCESFAIL
								echo "$ip:$THECURRENTIP" >> "$INSTANCESFAIL"
							fi						
						fi						
					else
						echo "IP $THECURRENTIP Not Available 3..."
						if [[ -f "$INSTANCESFAIL" ]]; then
							sudo chmod 777 $INSTANCESFAIL
							echo "$ip:$THECURRENTIP" >> "$INSTANCESFAIL"
						else
							sudo touch $INSTANCESFAIL
							sudo chmod 777 $INSTANCESFAIL
							echo "$ip:$THECURRENTIP" >> "$INSTANCESFAIL"
						fi						
					fi
				fi
			    else
				echo "IP $THECURRENTIP Not Available 4..."
				if [[ -f "$INSTANCESFAIL" ]]; then
					sudo chmod 777 $INSTANCESFAIL
					echo "$ip:$THECURRENTIP" >> "$INSTANCESFAIL"
				else
					sudo touch $INSTANCESFAIL
					sudo chmod 777 $INSTANCESFAIL
					echo "$ip:$THECURRENTIP" >> "$INSTANCESFAIL"
				fi			    	
			    fi
			else
			    echo "IP $THECURRENTIP Not Available 5..."
			    if [[ -f "$INSTANCESFAIL" ]]; then
			    	sudo chmod 777 $INSTANCESFAIL
			    	echo "$ip:$THECURRENTIP" >> "$INSTANCESFAIL"
			    else
			    	sudo touch $INSTANCESFAIL
			    	sudo chmod 777 $INSTANCESFAIL
			    	echo "$ip:$THECURRENTIP" >> "$INSTANCESFAIL"
			    fi
			fi									
		fi		
	done 
	
	sudo rm -f $local_2_directory/$ip_out_filename
	theiurealfile="$local_2_directory/$input1_1unique-Logs-Real"
	echo "$THEDATAVAL" >> "$theiurealfile"   	
    fi    
    
    sudo mv $FunctionLogFile $local_directory	
fi

if [ "$THEMODEOFEXECUTION" == "Z" ]; then
	TMOE_Z_2="$2"
	TMOE_Z_3="$3"
	TMOE_Z_4="$4"
	TMOE_Z_5="$5"
	TMOE_Z_6="$6"
	
	FILE1="$TMOE_Z_2"
	FILE2="$TMOE_Z_3"

	while true; do
	    lines_file1=$(get_line_count "$FILE1")
	    lines_file2=$(get_line_count "$FILE2")
	    
	    if [[ "$lines_file1" -eq "$lines_file2" ]]; then
		echo "All Done For FILE1 $FILE1 :  FILE2 $FILE2"
		sudo rm -f $TMOE_Z_2
		sudo rm -f $TMOE_Z_3
		sudo rm -f $TMOE_Z_5
		sudo mv $TMOE_Z_4 $TMOE_Z_6
		exit 0
	    else
	    	echo "Current Status Of FILE1 $FILE1 :  FILE2 $FILE2"
	    	cat $FILE1
	    	echo "-----"
	    	cat $FILE2
	    	echo "====="
	    fi
	    
	    sleep 10
	done							
fi

