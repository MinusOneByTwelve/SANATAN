#!/bin/bash

#/opt/Matsya/Scripts/PrepCSMP.sh "contactrkk4├Intra123├osboxes├NA├osboxes.org├192.168.0.100├/home/prathamos/Downloads/ubu4.pem├22"
#/opt/Matsya/Scripts/PrepCSMP.sh "├├contactrkk3├/home/prathamos/Downloads/ubu3.pem├├192.168.0.100├├22"

BASE="/opt/Matsya"
THEARGS="$1"
IFS='├' read -r -a THE_ARGS <<< $THEARGS

# Variables
NEW_USER="${THE_ARGS[0]}"
NEW_PASSWORD="${THE_ARGS[1]}"
SSH_USER="${THE_ARGS[2]}"
SSH_PEM="${THE_ARGS[3]}"
SSH_PASSWORD="${THE_ARGS[4]}"
IP_ADDRESS="${THE_ARGS[5]}"
PEM_FILE="${THE_ARGS[6]}"
THEPORT="${THE_ARGS[7]}"

CS_MP="sudo touch /opt/CLD && sudo chmod 777 /opt/CLD && echo \"CSMP_UBU\" | sudo tee -a /opt/CLD > /dev/null && sudo touch /opt/LCL && sudo chmod 777 /opt/LCL && echo \"LCL\" | sudo tee -a /opt/LCL > /dev/null && sudo touch /opt/GBL && sudo chmod 777 /opt/GBL && echo \"GBL\" | sudo tee -a /opt/GBL > /dev/null && sudo touch /opt/VPC && sudo chmod 777 /opt/VPC && echo \"CSMP\" | sudo tee -a /opt/VPC > /dev/null && sudo touch /opt/EXEC1ON && sudo chmod 777 /opt/EXEC1ON && sudo mkdir -p /shiva && sudo chmod -R 777 /shiva && sudo mkdir -p /shiva/bdd && sudo chown -R root:root /shiva/bdd && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/bdd && sudo mkdir -p /shiva/bdd/storage && sudo chown -R root:root /shiva/bdd/storage && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/bdd/storage && sudo mkdir -p /shiva/local && sudo chown -R root:root /shiva/local && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/local && sudo mkdir -p /shiva/local/storage && sudo chown -R root:root /shiva/local/storage && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/local/storage && sudo mkdir -p /shiva/local/bucket && sudo chown -R root:root /shiva/local/bucket && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/local/bucket && sudo mkdir -p /shiva/global && sudo chown -R root:root /shiva/global && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/global && sudo mkdir -p /shiva/global/bucket && sudo chown -R root:root /shiva/global/bucket && sudo chmod -R u=rwx,g=rwx,o=rwx /shiva/global/bucket && sudo ln -s /shiva/global/bucket /shiva/global/storage && sudo mv /opt/EXEC1ON /opt/EXEC1DONE"

# Commands to run on the remote server
COMMANDS="
echo '$SSH_PASSWORD' | sudo -S adduser $NEW_USER --gecos '';
echo '$SSH_PASSWORD' | sudo -S bash -c \"echo '$NEW_USER:$NEW_PASSWORD' | chpasswd\";
echo '$SSH_PASSWORD' | sudo -S usermod -aG sudo $NEW_USER;
echo '$SSH_PASSWORD' | sudo -S bash -c 'echo \"$NEW_USER ALL=(ALL) NOPASSWD:ALL\" > /etc/sudoers.d/$NEW_USER';
echo '$SSH_PASSWORD' | sudo -S chmod 440 /etc/sudoers.d/$NEW_USER;
"

if [ "$SSH_PEM" == "NA" ]; then
# Execute commands on the remote server
sshpass -p "$SSH_PASSWORD" ssh -o StrictHostKeyChecking=no $SSH_USER@$IP_ADDRESS "$COMMANDS"

echo "Passwordless sudo user $NEW_USER created successfully and login is enabled."

VARTK=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
TEMP_KEY_FILE="$BASE/tmp/temp_key_$VARTK"
TEMP_KEY_PUB_FILE="$BASE/tmp/temp_key_$VARTK.pub"			
echo -e  'y\n'|ssh-keygen -b 2048 -t rsa -P '' -f $TEMP_KEY_FILE && cp $TEMP_KEY_FILE $PEM_FILE
sudo chmod 400 "$PEM_FILE"
expect -c "
spawn ssh-copy-id -i \"$TEMP_KEY_PUB_FILE\" \"$NEW_USER@$IP_ADDRESS\"
expect {
    \"*?assword:*\" {
        send \"$NEW_PASSWORD\\r\"
        expect eof
    }
}
"
rm "$TEMP_KEY_FILE" "$TEMP_KEY_PUB_FILE"
SSH_PEM="$PEM_FILE"
SSH_USER="$NEW_USER"
else
echo "using existing pem $SSH_PEM & user $SSH_USER..."
fi

ssh -o StrictHostKeyChecking=no $SSH_USER@$IP_ADDRESS -p $THEPORT -i $SSH_PEM "$CS_MP"

