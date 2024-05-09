#!/bin/bash

set -e

clear

CURRENTUSER=$(whoami)
CURRENTREALUSER="$SUDO_USER"

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
MAYADHICALL="NO"

declare -a Networks=()
declare -a Authentication=()
declare -a Potentials=()

NetworkScanResult=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 6 | head -n 1)

if [ $# -eq 0 ]; then
	USERVALS=""
else
	USERVALS=$1
	USERINTERACTION="NO"
	IFS='■' read -r -a USERLISTVALS <<< $USERVALS
	_select_interfaces="${USERLISTVALS[0]}"
	_collect_authentication="${USERLISTVALS[1]}"
	NetworkScanResult="${USERLISTVALS[2]}"
	sudo rm -rf "$BASE/tmp/$NetworkScanResult.csv"
	IFS='┼' read -r -a Networks <<< "$_select_interfaces"
	IFS='┼' read -r -a Authentication <<< "$_collect_authentication"
	USERINPUTCOUNT=${#USERLISTVALS[@]}
	if (( $USERINPUTCOUNT > 3 )) ; then
		MAYADHICALL="YES"
	fi				
fi

sudo touch "$BASE/tmp/$NetworkScanResult.csv"
sudo chmod 777 "$BASE/tmp/$NetworkScanResult.csv"

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

echo -e "${ORANGE}=================================================================${NC}"
echo -e "${BLUE}${BOLD}\x1b[4mK${NORM}${NC}eystone ${BLUE}${BOLD}\x1b[4mR${NORM}${NC}emote ${BLUE}${BOLD}\x1b[4mI${NORM}${NC}ntelligent ${BLUE}${BOLD}\x1b[4mS${NORM}${NC}canning ${BLUE}${BOLD}\x1b[4mH${NORM}${NC}olistic ${BLUE}${BOLD}\x1b[4mN${NORM}${NC}etwork ${BLUE}${BOLD}\x1b[4mA${NORM}${NC}ssimilator\x1b[m${NORM}"
echo -e "${GREEN}=================================================================${NC}"
echo ''
echo -e "\x1b[3mK    K  RRRR    III   SSS   H   H  N   N  AAAAA\x1b[m"
echo -e "\x1b[3mK   K   R   R    I   S      H   H  NN  N  A   A\x1b[m"
echo -e "\x1b[3mKKK     RRRR     I    SSS   HHHHH  N N N  AAAAA\x1b[m"
echo -e "\x1b[3mK  K    R  R     I       S  H   H  N  NN  A   A\x1b[m"
echo -e "\x1b[3mK   K   R   R   III  SSSS   H   H  N   N  A   A\x1b[m"
echo ''
echo -e "\x1b[3m\x1b[4mNetwork Scanner\x1b[m"
echo ''
echo "$STACKLINELENGTHY"

select_interfaces() {
    interfaces=$(ifconfig | grep -oE '^[^[:space:]]+')
    for interface in $interfaces; do
        interface=$(echo "$interface" | sed 's/://g')
        read -p "Do you want to use interface $interface? (y/n): " choice
        if [ "$choice" = "y" ]; then
            Networks+=("$interface")
        fi
        read -p "Want to choose any more interfaces? (y/n): " more
        if [ "$more" != "y" ]; then
            break
        fi
    done
    echo "Selected interfaces: ${Networks[@]}"
}

collect_authentication() {
    while true; do
        read -p "Enter username-password combination or username-PEM combination (format: UserName├Password or UserName├PEMPath): " auth
        IFS='├' read -ra parts <<< "$auth"
        username="${parts[0]}"
        password="${parts[1]//├/}"
        if [[ "${parts[1]}" == *".pem" ]]; then
            Authentication+=("PEM├$username├$password")
        else
            Authentication+=("UP├$username├$password")
        fi
        read -p "Want to choose any more authentication combinations? (y/n): " more
        if [ "$more" != "y" ]; then
            break
        fi
    done
    echo "Selected authentication combinations: ${Authentication[@]}"
}

scan_network() {
    for interface in "${Networks[@]}"; do
        gateway=$(route -n | awk '$1 == "0.0.0.0" {print $2}' | head -n1)
        network=$(echo "$gateway" | awk -F. '{print $1"."$2"."$3"."}')
        net1mask=$(ifconfig "$interface" | awk '/inet / {print $4}')
        echo "Scanning network on interface $interface with gateway $gateway..."
        live_hosts=$(sudo nmap -sP -n "$network"0/24 | grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b')
        for host in $live_hosts; do
            if [ "$host" == "$gateway" ]; then
                echo "Skipping router IP address: $host"
                continue
            fi
            Potentials+=("$host■$interface■$gateway■$net1mask")
        done
    done
    echo "Potential live hosts: ${Potentials[@]}"
}

attempt_ssh() {
    echo "Attempting SSH connections..."
    echo "ScopeId,Identity,InstanceType,OtherInfo,Secrets,SecretsKey,IP,Parent,NIC,Gateway,Netmask,PUserName,PPort,PPassword,PPEM,ISVM,HostName,OS,VVBoxStatus,TotalRAM,FreeRAM,CPUCores,UserName,Port,Password,PEM" >> $BASE/tmp/$NetworkScanResult.csv
    for _hostparts in "${Potentials[@]}"; do
        IFS='■' read -ra hostparts <<< "$_hostparts"
        host="${hostparts[0]}"
        themappednic="${hostparts[1]}"
        gate1way="${hostparts[2]}"
        net2mask="${hostparts[3]}"        
        for auth in "${Authentication[@]}"; do
            IFS='├' read -ra parts <<< "$auth"
            if [ "${parts[0]}" == "UP" ]; then
                IFS='¤' read -ra _userparts <<< "${parts[1]}"
                username="${_userparts[0]}"
                thereqport="${_userparts[1]}"
                password="${parts[2]}"
                echo "Trying SSH with username: $username, password: $password, to host: $host..."
                if output=$(sshpass -p "$password" ssh -p $thereqport -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$username@$host" exit 2>&1); then
                    ssh_and_get_info=$(ssh_and_get_info "$themappednic" "$host" "$username¤$thereqport" "$password" "" "") && IFS='├' read -ra _gi <<< "$ssh_and_get_info" && _gi1="${_gi[1]}" && _gi2="${_gi[0]}" && _gi3="${_gi[2]}" && _gi4="${_gi[3]}" && _gi5="${_gi[4]}" && _gi6="${_gi[5]}" && _gi7="${_gi[6]}" && _gi10="${_gi[8]}" && _gi11="${_gi[9]}" && _gi12="${_gi[10]}" && _gi8="${_gi[7]}" && _gi9="" && { [[ -z "${_gi8}" ]] && _gi9="$host" || _gi9="${_gi8}"; }         
                    echo ",,,,,,$host,$_gi9,$_gi10,$_gi11,$_gi12,,,,,$_gi7,$_gi1,$_gi2,$_gi3,$_gi4,$_gi5,$_gi6,$username,$thereqport,$password,NA" >> $BASE/tmp/$NetworkScanResult.csv 
                    break          
                elif [[ "$output" == *"Permission denied"* ]]; then
                    if [[ "$username" == "root" ]]; then
                        echo "$host,,,$username,$password,,,FAILURE,Permission denied"
                    else
                        echo "Trying SSH with username: root, password: $password, to host: $host..."
                        if sshpass -p "$password" ssh -p $thereqport -o StrictHostKeyChecking=no -o ConnectTimeout=5 "root@$host" exit 2>&1 >/dev/null; then
                            ssh_and_get_info=$(ssh_and_get_info "$themappednic" "$host" "root¤$thereqport" "$password" "" "") && IFS='├' read -ra _gi <<< "$ssh_and_get_info" && _gi1="${_gi[1]}" && _gi2="${_gi[0]}" && _gi3="${_gi[2]}" && _gi4="${_gi[3]}" && _gi5="${_gi[4]}" && _gi6="${_gi[5]}" && _gi7="${_gi[6]}" && _gi10="${_gi[8]}" && _gi11="${_gi[9]}" && _gi12="${_gi[10]}" && _gi8="${_gi[7]}" && _gi9="" && { [[ -z "${_gi8}" ]] && _gi9="$host" || _gi9="${_gi8}"; }         
                            echo ",,,,,,$host,$_gi9,$_gi10,$_gi11,$_gi12,,,,,$_gi7,$_gi1,$_gi2,$_gi3,$_gi4,$_gi5,$_gi6,$username,$thereqport,$password,NA" >> $BASE/tmp/$NetworkScanResult.csv 
                            break                           
                        else
                                #echo "came here1 : sshpass -p \"$password\" ssh $username@$host -p $thereqport"
				if output=$(sshpass -p "$password" ssh $username@$host -p $thereqport -o ConnectTimeout=5 exit 2>&1); then
					ssh_and_get_info=$(ssh_and_get_info "$themappednic" "$host" "$username¤$thereqport" "$password" "" "sudo") && IFS='├' read -ra _gi <<< "$ssh_and_get_info" && _gi1="${_gi[1]}" && _gi2="${_gi[0]}" && _gi3="${_gi[2]}" && _gi4="${_gi[3]}" && _gi5="${_gi[4]}" && _gi6="${_gi[5]}" && _gi7="${_gi[6]}" && _gi10="${_gi[8]}" && _gi11="${_gi[9]}" && _gi12="${_gi[10]}" && _gi8="${_gi[7]}" && _gi9="" && { [[ -z "${_gi8}" ]] && _gi9="$host" || _gi9="${_gi8}"; }         
					echo ",,,,,,$host,$_gi9,$_gi10,$_gi11,$_gi12,,,,,$_gi7,$_gi1,$_gi2,$_gi3,$_gi4,$_gi5,$_gi6,$username,$thereqport,$password,NA" >> $BASE/tmp/$NetworkScanResult.csv 
					#echo "worked1"
					break
				elif output=$(sudo sshpass -p "$password" ssh $username@$host -p $thereqport -o ConnectTimeout=5 exit 2>&1); then
					ssh_and_get_info=$(ssh_and_get_info "$themappednic" "$host" "$username¤$thereqport" "$password" "" "sudo") && IFS='├' read -ra _gi <<< "$ssh_and_get_info" && _gi1="${_gi[1]}" && _gi2="${_gi[0]}" && _gi3="${_gi[2]}" && _gi4="${_gi[3]}" && _gi5="${_gi[4]}" && _gi6="${_gi[5]}" && _gi7="${_gi[6]}" && _gi10="${_gi[8]}" && _gi11="${_gi[9]}" && _gi12="${_gi[10]}" && _gi8="${_gi[7]}" && _gi9="" && { [[ -z "${_gi8}" ]] && _gi9="$host" || _gi9="${_gi8}"; }         
					echo ",,,,,,$host,$_gi9,$_gi10,$_gi11,$_gi12,,,,,$_gi7,$_gi1,$_gi2,$_gi3,$_gi4,$_gi5,$_gi6,$username,$thereqport,$password,NA" >> $BASE/tmp/$NetworkScanResult.csv 
					#echo "worked2"
					break
				elif output=$(sudo sshpass -p "$password" ssh $username@$host -p $thereqport -o ConnectTimeout=5 -o StrictHostKeyChecking=no exit 2>&1); then
					ssh_and_get_info=$(ssh_and_get_info "$themappednic" "$host" "$username¤$thereqport" "$password" "" "sudo") && IFS='├' read -ra _gi <<< "$ssh_and_get_info" && _gi1="${_gi[1]}" && _gi2="${_gi[0]}" && _gi3="${_gi[2]}" && _gi4="${_gi[3]}" && _gi5="${_gi[4]}" && _gi6="${_gi[5]}" && _gi7="${_gi[6]}" && _gi10="${_gi[8]}" && _gi11="${_gi[9]}" && _gi12="${_gi[10]}" && _gi8="${_gi[7]}" && _gi9="" && { [[ -z "${_gi8}" ]] && _gi9="$host" || _gi9="${_gi8}"; }         
					echo ",,,,,,$host,$_gi9,$_gi10,$_gi11,$_gi12,,,,,$_gi7,$_gi1,$_gi2,$_gi3,$_gi4,$_gi5,$_gi6,$username,$thereqport,$password,NA" >> $BASE/tmp/$NetworkScanResult.csv 
					#echo "worked3"
					break
				elif output=$(sshpass -p "$password" ssh $username@$host -p $thereqport -o ConnectTimeout=5 -o StrictHostKeyChecking=no exit 2>&1); then
					ssh_and_get_info=$(ssh_and_get_info "$themappednic" "$host" "$username¤$thereqport" "$password" "" "sudo") && IFS='├' read -ra _gi <<< "$ssh_and_get_info" && _gi1="${_gi[1]}" && _gi2="${_gi[0]}" && _gi3="${_gi[2]}" && _gi4="${_gi[3]}" && _gi5="${_gi[4]}" && _gi6="${_gi[5]}" && _gi7="${_gi[6]}" && _gi10="${_gi[8]}" && _gi11="${_gi[9]}" && _gi12="${_gi[10]}" && _gi8="${_gi[7]}" && _gi9="" && { [[ -z "${_gi8}" ]] && _gi9="$host" || _gi9="${_gi8}"; }         
					echo ",,,,,,$host,$_gi9,$_gi10,$_gi11,$_gi12,,,,,$_gi7,$_gi1,$_gi2,$_gi3,$_gi4,$_gi5,$_gi6,$username,$thereqport,$password,NA" >> $BASE/tmp/$NetworkScanResult.csv 
					#echo "worked4"
					break															
				else                        
					echo "$host,,,$username,$password,,,NOSSH,Permission denied"
				fi
                        fi
                    fi
                #elif output=$(sudo sshpass -p "$password" ssh -p $thereqport -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$username@$host" exit 2>&1); then
                elif output=$(sudo sshpass -p "$password" ssh $username@$host -p $thereqport -o ConnectTimeout=5 -o StrictHostKeyChecking=no exit 2>&1); then
                    ssh_and_get_info=$(ssh_and_get_info "$themappednic" "$host" "$username¤$thereqport" "$password" "" "sudo") && IFS='├' read -ra _gi <<< "$ssh_and_get_info" && _gi1="${_gi[1]}" && _gi2="${_gi[0]}" && _gi3="${_gi[2]}" && _gi4="${_gi[3]}" && _gi5="${_gi[4]}" && _gi6="${_gi[5]}" && _gi7="${_gi[6]}" && _gi10="${_gi[8]}" && _gi11="${_gi[9]}" && _gi12="${_gi[10]}" && _gi8="${_gi[7]}" && _gi9="" && { [[ -z "${_gi8}" ]] && _gi9="$host" || _gi9="${_gi8}"; }         
                    echo ",,,,,,$host,$_gi9,$_gi10,$_gi11,$_gi12,,,,,$_gi7,$_gi1,$_gi2,$_gi3,$_gi4,$_gi5,$_gi6,$username,$thereqport,$password,NA" >> $BASE/tmp/$NetworkScanResult.csv 
                    break                    
                else
                    echo "$host,,,$username,$password,,,NOSSH2,$output"
                fi
            elif [ "${parts[0]}" == "PEM" ]; then
                IFS='¤' read -ra _userparts <<< "${parts[1]}"
                username="${_userparts[0]}"
                thereqport="${_userparts[1]}"            
                pem_path="${parts[2]}"
                echo "Trying SSH with username: $username, PEM path: $pem_path, to host: $host..."
                #echo "ssh -p $thereqport -o StrictHostKeyChecking=no -i \"$pem_path\" -o ConnectTimeout=5 \"$username@$host\""
                if output=$(ssh -p $thereqport -o StrictHostKeyChecking=no -i "$pem_path" -o ConnectTimeout=5 "$username@$host" exit 2>&1); then
                    #echo "camehere9"
                    ssh_and_get_info=$(ssh_and_get_info "$themappednic" "$host" "$username¤$thereqport" "" "$pem_path" "") && IFS='├' read -ra _gi <<< "$ssh_and_get_info" && _gi1="${_gi[1]}" && _gi2="${_gi[0]}" && _gi3="${_gi[2]}" && _gi4="${_gi[3]}" && _gi5="${_gi[4]}" && _gi6="${_gi[5]}" && _gi7="${_gi[6]}" && _gi10="${_gi[8]}" && _gi11="${_gi[9]}" && _gi12="${_gi[10]}" && _gi8="${_gi[7]}" && _gi9="" && { [[ -z "${_gi8}" ]] && _gi9="$host" || _gi9="${_gi8}"; }         
                    echo ",,,,,,$host,$_gi9,$_gi10,$_gi11,$_gi12,,,,,$_gi7,$_gi1,$_gi2,$_gi3,$_gi4,$_gi5,$_gi6,$username,$thereqport,,$pem_path" >> $BASE/tmp/$NetworkScanResult.csv
                    break                    
                elif [[ "$output" == *"Permission denied"* ]]; then
                    if [[ "$username" == "root" ]]; then
                        echo "$host,,,$username,,,$pem_path,FAILURE,Permission denied"
                    else
                        echo "Trying SSH with username: root, PEM path: $pem_path, to host: $host..."
                        if ssh -p $thereqport -o StrictHostKeyChecking=no -i "$pem_path" -o ConnectTimeout=5 "root@$host" exit 2>&1 >/dev/null; then
                            ssh_and_get_info=$(ssh_and_get_info "$themappednic" "$host" "root¤$thereqport" "" "$pem_path" "") && IFS='├' read -ra _gi <<< "$ssh_and_get_info" && _gi1="${_gi[1]}" && _gi2="${_gi[0]}" && _gi3="${_gi[2]}" && _gi4="${_gi[3]}" && _gi5="${_gi[4]}" && _gi6="${_gi[5]}" && _gi7="${_gi[6]}" && _gi10="${_gi[8]}" && _gi11="${_gi[9]}" && _gi12="${_gi[10]}" && _gi8="${_gi[7]}" && _gi9="" && { [[ -z "${_gi8}" ]] && _gi9="$host" || _gi9="${_gi8}"; }         
                            echo ",,,,,,$host,$_gi9,$_gi10,$_gi11,$_gi12,,,,,$_gi7,$_gi1,$_gi2,$_gi3,$_gi4,$_gi5,$_gi6,$username,$thereqport,,$pem_path" >> $BASE/tmp/$NetworkScanResult.csv 
                            break                           
                        else
                            echo "$host,,,$username,,,$pem_path,NOSSH3,Permission denied"
                        fi
                    fi
                else
                    echo "$host,,,$username,,,$pem_path,NOSSH4,$output"
                fi
            fi
        done
    done
}

ssh_and_get_info() {
    local themapped1nic="$1"
    local host="$2"
    IFS='¤' read -ra _userparts <<< "$3"
    local username="${_userparts[0]}"
    local thereqport="${_userparts[1]}"    
    local password="$4"
    local pem="$5"
    local issudo="$6"
    
    local os_type_and_hostname
    if [ -n "$pem" ]; then
        os_type_and_hostname=$(ssh -p $thereqport -o StrictHostKeyChecking=no -i "$pem" "$username@$host" \
	    'os_type=$(if command -v apt-get &> /dev/null; then echo "Ubuntu"; elif command -v yum &> /dev/null; then echo "RedHat"; else echo "WinMac"; fi); \
	    hostname=$(hostname); \
	    if command -v vagrant &> /dev/null && command -v virtualbox &> /dev/null; then vagrant_virtualbox_installed="Yes"; else vagrant_virtualbox_installed="No"; fi; \
	    total_ram=$(free -h | awk '"'"'{if (NR==2) print $2}'"'"' | sed "s/Gi//"); \
	    free_ram=$(free -h | awk '"'"'{if (NR==2) print $4}'"'"' | sed "s/Gi//"); \
	    cpu_cores=$(nproc); \
	    isvm_exists="No"; \
	    if [ -e "/opt/ISVM" ]; then isvm_exists="Yes"; fi; \
	    THEMACHPARENT=""; \
	    if [ -e "/opt/MYPARENT" ]; then THEMACHPARENT=$(head -n 1 "/opt/MYPARENT"); fi; \
	    nic=$(ip addr | grep -B 2 "'"$host"'" | awk '"'"'/^[0-9]/ {print $2; exit}'"'"'); \
	    nic=${nic%:}; \
	    gateway=$(ip route show dev "$nic" | grep -oP "^default via \K\S+"); \
	    netmask=$(ifconfig "$nic" | awk '"'"'/inet / {print $4}'"'"'); \
	    echo "$os_type├$hostname├$vagrant_virtualbox_installed├$total_ram├$free_ram├$cpu_cores├$isvm_exists├$THEMACHPARENT├$nic├$gateway├$netmask"'
	)		    
    else
        if [ "$issudo" == "sudo" ] ; then
            os_type_and_hostname=$(sshpass -p "$password" ssh $username@$host -p $thereqport \
	    'os_type=$(if command -v apt-get &> /dev/null; then echo "Ubuntu"; elif command -v yum &> /dev/null; then echo "RedHat"; else echo "WinMac"; fi); \
	    hostname=$(hostname); \
	    if command -v vagrant &> /dev/null && command -v virtualbox &> /dev/null; then vagrant_virtualbox_installed="Yes"; else vagrant_virtualbox_installed="No"; fi; \
	    total_ram=$(free -h | awk '"'"'{if (NR==2) print $2}'"'"' | sed "s/Gi//"); \
	    free_ram=$(free -h | awk '"'"'{if (NR==2) print $7}'"'"' | sed "s/Gi//"); \
	    cpu_cores=$(nproc); \
	    isvm_exists="No"; \
	    if [ -e "/opt/ISVM" ]; then isvm_exists="Yes"; fi; \
	    THEMACHPARENT=""; \
	    if [ -e "/opt/MYPARENT" ]; then THEMACHPARENT=$(head -n 1 "/opt/MYPARENT"); fi; \
	    nic=$(ip addr | grep -B 2 "'"$host"'" | awk '"'"'/^[0-9]/ {print $2; exit}'"'"'); \
	    nic=${nic%:}; \
	    gateway=$(ip route show dev "$nic" | grep -oP "^default via \K\S+"); \
	    netmask=$(ifconfig "$nic" | awk '"'"'/inet / {print $4}'"'"'); \
	    echo "$os_type├$hostname├$vagrant_virtualbox_installed├$total_ram├$free_ram├$cpu_cores├$isvm_exists├$THEMACHPARENT├$nic├$gateway├$netmask"'
	    )
	else
            os_type_and_hostname=$(sshpass -p "$password" ssh -p $thereqport -o StrictHostKeyChecking=no "$username@$host" \
	    'os_type=$(if command -v apt-get &> /dev/null; then echo "Ubuntu"; elif command -v yum &> /dev/null; then echo "RedHat"; else echo "WinMac"; fi); \
	    hostname=$(hostname); \
	    if command -v vagrant &> /dev/null && command -v virtualbox &> /dev/null; then vagrant_virtualbox_installed="Yes"; else vagrant_virtualbox_installed="No"; fi; \
	    total_ram=$(free -h | awk '"'"'{if (NR==2) print $2}'"'"' | sed "s/Gi//"); \
	    free_ram=$(free -h | awk '"'"'{if (NR==2) print $7}'"'"' | sed "s/Gi//"); \
	    cpu_cores=$(nproc); \
	    isvm_exists="No"; \
	    if [ -e "/opt/ISVM" ]; then isvm_exists="Yes"; fi; \
	    THEMACHPARENT=""; \
	    if [ -e "/opt/MYPARENT" ]; then THEMACHPARENT=$(head -n 1 "/opt/MYPARENT"); fi; \
	    nic=$(ip addr | grep -B 2 "'"$host"'" | awk '"'"'/^[0-9]/ {print $2; exit}'"'"'); \
	    nic=${nic%:}; \
	    gateway=$(ip route show dev "$nic" | grep -oP "^default via \K\S+"); \
	    netmask=$(ifconfig "$nic" | awk '"'"'/inet / {print $4}'"'"'); \
	    echo "$os_type├$hostname├$vagrant_virtualbox_installed├$total_ram├$free_ram├$cpu_cores├$isvm_exists├$THEMACHPARENT├$nic├$gateway├$netmask"'
	    )	
	fi

            
    fi

    echo "$os_type_and_hostname"
}

main() {
	echo ""
	if [ "$USERINTERACTION" == "YES" ] || [ "$USERINTERACTION" == "yes" ] ; then
		select_interfaces
		collect_authentication
	fi
	scan_network
	attempt_ssh
	sudo chown -R $CURRENTREALUSER:$CURRENTREALUSER $BASE/tmp/$NetworkScanResult.csv
	chmod -R u=rwx,g=,o= $BASE/tmp/$NetworkScanResult.csv
	if [ "$MAYADHICALL" == "YES" ] ; then
		clear
		echo "DONE"
	else
		echo ""
		$BASE/Scripts/BashTabularPrint.sh "$BASE/tmp/$NetworkScanResult.csv■-1■,"
		echo "" 	
	fi	   
}

if [ "$(id -u)" != "0" ]; then
    echo "This script must be run with sudo."
    echo ''
    exit 1
fi
	
main

