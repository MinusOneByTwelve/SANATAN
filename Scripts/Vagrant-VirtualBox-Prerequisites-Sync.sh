#!/bin/bash

CURRENTUSER=$(whoami)
sudo rm -rf /home/$CURRENTUSER/.ssh/known_hosts
sudo rm -rf /root/.ssh/known_hosts

USERINTERACTION="YES"
USERVALS=""
MANUALRUN="NO"

# Define the remote host
REMOTE_HOST=""

# Define the remote user
REMOTE_USER=""

# Define the SSH port
SSH_PORT=""

# Define the remote password
REMOTE_PASSWD=""

REMOTE_PEM=""

BASE="ubu"

if [ $# -eq 0 ]; then
	USERVALS=""
else
	USERVALS=$1
	USERINTERACTION="NO"
	IFS='■' read -r -a USERLISTVALS <<< $USERVALS
	REMOTE_HOST="${USERLISTVALS[0]}"
	REMOTE_USER="${USERLISTVALS[1]}"	
	SSH_PORT="${USERLISTVALS[2]}"
	REMOTE_PASSWD="${USERLISTVALS[3]}"
	REMOTE_PEM="${USERLISTVALS[4]}"	
	BASE="${USERLISTVALS[5]}"					
fi

# Define the remote folders
REMOTE_FOLDERS=(
    "$BASE/Resources"
    "$BASE/Scripts"
    "$BASE/Stack"
)

if [ "$REMOTE_PEM" == "NA" ] ; then
	sshpass -p "$REMOTE_PASSWD" ssh -p "$SSH_PORT" -o StrictHostKeyChecking=no "$REMOTE_USER@$REMOTE_HOST" "[ -d \"$BASE\" ]" >/dev/null 2>&1
else
	ssh -p "$SSH_PORT" -o StrictHostKeyChecking=no -i "$REMOTE_PEM" "$REMOTE_USER@$REMOTE_HOST" "[ -d \"$BASE\" ]" >/dev/null 2>&1
fi

if [ $? -ne 0 ]; then
	echo "Creating $BASE ..."
	if [ "$REMOTE_PEM" == "NA" ] ; then
		sshpass -p "$REMOTE_PASSWD" ssh -p "$SSH_PORT" -o StrictHostKeyChecking=no "$REMOTE_USER@$REMOTE_HOST" "sudo mkdir -p \"$BASE\" && sudo chmod -R 777 \"$BASE\""
	else
		ssh -p "$SSH_PORT" -o StrictHostKeyChecking=no -i "$REMOTE_PEM" "$REMOTE_USER@$REMOTE_HOST" "sudo mkdir -p \"$BASE\" && sudo chmod -R 777 \"$BASE\""
	fi
fi

# Loop through each folder
for folder in "${REMOTE_FOLDERS[@]}"; do
    # Check if the folder exists on ubu2
    if [ "$REMOTE_PEM" == "NA" ] ; then
    	sshpass -p "$REMOTE_PASSWD" ssh -p "$SSH_PORT" -o StrictHostKeyChecking=no "$REMOTE_USER@$REMOTE_HOST" "[ -d '$folder' ]" >/dev/null 2>&1
    else
	ssh -p "$SSH_PORT" -o StrictHostKeyChecking=no -i "$REMOTE_PEM" "$REMOTE_USER@$REMOTE_HOST" "[ -d '$folder' ]" >/dev/null 2>&1
    fi    	
    if [ $? -ne 0 ]; then
        # If the folder doesn't exist, create it on ubu2
        echo "Creating $folder ..."
        if [ "$REMOTE_PEM" == "NA" ] ; then
        	sshpass -p "$REMOTE_PASSWD" ssh -p "$SSH_PORT" -o StrictHostKeyChecking=no "$REMOTE_USER@$REMOTE_HOST" "sudo mkdir -p \"$folder\" && sudo chmod -R 777 \"$folder\""
        else
        	ssh -p "$SSH_PORT" -o StrictHostKeyChecking=no -i "$REMOTE_PEM" "$REMOTE_USER@$REMOTE_HOST" "sudo mkdir -p \"$folder\" && sudo chmod -R 777 \"$folder\""
        fi
    fi

    # Sync the contents of the folder from ubu1 to ubu2
    if [ "$REMOTE_PEM" == "NA" ] ; then
    	rsync -avz --delete -e "sshpass -p "$REMOTE_PASSWD" ssh -p $SSH_PORT -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" "$folder/" "$REMOTE_USER@$REMOTE_HOST:$folder/"
    else
    	rsync -avz --delete -e "ssh -p $SSH_PORT -i "$REMOTE_PEM" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" "$folder/" "$REMOTE_USER@$REMOTE_HOST:$folder/"
    fi
    
    # Check MD5 sums and delete if necessary
    if [ "$REMOTE_PEM" == "NA" ] ; then
	    sshpass -p "$REMOTE_PASSWD" ssh -p "$SSH_PORT" -o StrictHostKeyChecking=no "$REMOTE_USER@$REMOTE_HOST" "sudo find '$folder' -type f -exec md5sum {} \;" | while read md5sum file; do
		local_md5sum=$(md5sum "$file" | awk '{print $1}')
		if [ "$md5sum" != "$local_md5sum" ]; then
		    sshpass -p "$REMOTE_PASSWD" ssh -p "$SSH_PORT" -o StrictHostKeyChecking=no "$REMOTE_USER@$REMOTE_HOST" "sudo rm '$file'"
		    rsync -avz -e "sshpass -p "$REMOTE_PASSWD" ssh -p $SSH_PORT -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" "$file" "$REMOTE_USER@$REMOTE_HOST:$file"
		fi
	    done
    else
	    ssh -p "$SSH_PORT" -o StrictHostKeyChecking=no -i "$REMOTE_PEM" "$REMOTE_USER@$REMOTE_HOST" "sudo find '$folder' -type f -exec md5sum {} \;" | while read md5sum file; do
		local_md5sum=$(md5sum "$file" | awk '{print $1}')
		if [ "$md5sum" != "$local_md5sum" ]; then
		    ssh -p "$SSH_PORT" -o StrictHostKeyChecking=no -i "$REMOTE_PEM" "$REMOTE_USER@$REMOTE_HOST" "sudo rm '$file'"
		    rsync -avz -e "ssh -p $SSH_PORT -i "$REMOTE_PEM" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" "$file" "$REMOTE_USER@$REMOTE_HOST:$file"
		fi
	    done    
    fi
done

