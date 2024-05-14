#!/bin/bash

#set -e

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

echo -e "${ORANGE}==========================================================${NC}"
echo -e "${BLUE}${BOLD}\x1b[4mM${NORM}${NC}odular ${BLUE}${BOLD}\x1b[4mA${NORM}${NC}malgamation ${BLUE}${BOLD}\x1b[4mT${NORM}${NC}ransforming ${BLUE}${BOLD}\x1b[4mS${NORM}${NC}ystems ${BLUE}${BOLD}\x1b[4mY${NORM}${NC}ielding ${BLUE}${BOLD}\x1b[4mA${NORM}${NC}gility"
echo -e "${GREEN}==========================================================${NC}"
echo ''
echo -e "\x1b[3mM   M  AAAAA  TTTTT  SSS   Y   Y  AAAAA\x1b[m"
echo -e "\x1b[3mMM MM  A   A    T   S        Y    A   A\x1b[m"
echo -e "\x1b[3mM M M  AAAAA    T    SSS     Y    AAAAA\x1b[m"
echo -e "\x1b[3mM   M  A   A    T       S    Y    A   A\x1b[m"
echo -e "\x1b[3mM   M  A   A    T   SSSS     Y    A   A\x1b[m"
echo ''
echo -e "\x1b[3m\x1b[4mVAGRANT VIRTUALBOX\x1b[m"
echo ''

USERINTERACTION="YES"
USERVALS=""
CONFIRMFILETOCREATE=""

BASE=""
CLUSTERNAME=""
CONFIRMPROCEED=""
NODESNUMBER=""
DEFAULTCONFIG=""
LANTYPE=""
NIC=""
GATEWAY=""
NETMASK=""
STARTRANDOMIP=""
FILEMOUNTOPTION=""
REALFILEMOUNT=""
ADDTOHOSTSFILE=""
ROOTPWD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
MATSYAPWD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
VAGRANTPWD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
UBUPWD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
RANDOMSSHPORT=$(shuf -i 45000-46000 -n 1)
SLAVESFILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
PSCPFILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
FIREWALLFILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
SPARKEXECUTEFILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
SPARKEXECUTEFILEFINAL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
PEMFILENAME=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
JECDRIVERACCESS=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
OPENRANGEPORTS1="35000"
OPENRANGEPORTS2="65000"
PLIMIT=5
LISTOFALLPORTS=()
OPENTERMINALS="n"
FINALOUTPUTREQ="NO"
FINALPROCESSOUTPUT=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 6 | head -n 1)
LISTOFRANDOMIPS=""
MAYADHICALL="NO"
declare -A KEYVALIPS
declare -A KEYVALIDENTITIES
THENEWIDENTITYNAME=""
SSHKEYCREATE="YES"
ISSAMEASHOST="YES"
THEPARENTAUTHDETAILS="NOTHING"
THEUSERCHOICE="Z"

if [ "$#" -ne 2 ]; then
	USERVALS=""
	
	THEUSERCHOICE=$1
	if [ "$THEUSERCHOICE" == "D" ] ; then
		thedatafile=$2
		visionkey=$3
		scopemanyidy=$4
		USERINTERACTION="NO"
		BASE="/opt/Matsya"	
	fi	
else
	THEUSERCHOICE=$1
	if [ "$THEUSERCHOICE" == "C" ] ; then
		USERVALS=$2
		USERINTERACTION="NO"
		IFS='├' read -r -a USERLISTVALS <<< $USERVALS
		BASE="${USERLISTVALS[0]}"
		CLUSTERNAME="${USERLISTVALS[1]}"
		CONFIRMPROCEED="${USERLISTVALS[2]}"
		STACKDEPLOY="${USERLISTVALS[3]}"
		NODESNUMBER="${USERLISTVALS[4]}"
		THESETUPMODE="${USERLISTVALS[5]}"
		THECONFIGTYPE="${USERLISTVALS[6]}"
		DEFAULTCONFIG="${USERLISTVALS[7]}"
		LANTYPE="${USERLISTVALS[8]}"
		NIC="${USERLISTVALS[9]}"
		THISCURRENTMACHINEIP=$(ip addr show $NIC | grep 'inet ' | awk '{print $2}' | awk -F'/' '{print $1}')
		GATEWAY="${USERLISTVALS[10]}"
		NETMASK="${USERLISTVALS[11]}"
		STARTRANDOMIP="${USERLISTVALS[12]}"
		FILEMOUNTOPTION="${USERLISTVALS[13]}"	
		REALFILEMOUNT="${USERLISTVALS[14]}"	
		ADDTOHOSTSFILE="${USERLISTVALS[15]}"
		USERINPUTCOUNT=${#USERLISTVALS[@]}
		if (( $USERINPUTCOUNT > 16 )) ; then
			ROOTPWD="${USERLISTVALS[16]}"	
			MATSYAPWD="${USERLISTVALS[17]}"	
			VAGRANTPWD="${USERLISTVALS[18]}"
			CONFIRMFILETOCREATE="${USERLISTVALS[19]}"
			RANDOMSSHPORT="${USERLISTVALS[20]}"
		fi
		if (( $USERINPUTCOUNT > 21 )) ; then
			FINALOUTPUTREQ="${USERLISTVALS[21]}"
			FINALPROCESSOUTPUT="${USERLISTVALS[22]}"
			LISTOFRANDOMIPS="${USERLISTVALS[23]}"
			LISTOFRANDOMIDENTITIES="${USERLISTVALS[24]}"
			MAYADHICALL="YES"

			IFS=',' read -ra IPs <<< "$LISTOFRANDOMIPS"		
			for (( i=0; i<${#IPs[@]}; i++ )); do
				key=$((i+1))
				KEYVALIPS[$key]=${IPs[$i]}
			done
			
			IFS=',' read -ra IPs2 <<< "$LISTOFRANDOMIDENTITIES"		
			for (( i=0; i<${#IPs2[@]}; i++ )); do
				key=$((i+1))
				KEYVALIDENTITIES[$key]=${IPs2[$i]}
			done
			
			SSHKEYCREATE="${USERLISTVALS[25]}"
			ISSAMEASHOST="${USERLISTVALS[26]}"
			THEPARENTAUTHDETAILS="${USERLISTVALS[27]}"
			THEREALVISIONKEY="${USERLISTVALS[28]}"				
		fi
	fi					
fi

function GetNewPort {
    local FreshPort=$($BASE/Scripts/GetRandomPort.sh)
    if printf '%s\0' "${LISTOFALLPORTS[@]}" | grep -Fxqz -- $FreshPort; then	
    	GetNewPort
    else
        LISTOFALLPORTS+=("$FreshPort")
    fi
    echo $FreshPort
}

#xyz=$(GetNewPort) && echo $xyz && exit
#echo "USERINTERACTION : $USERINTERACTION  THEUSERCHOICE : $THEUSERCHOICE"
#exit
if [ "$USERINTERACTION" == "YES" ] || [ "$USERINTERACTION" == "yes" ] ; then
	read -p "Enter Base Location (If Missing, Will Be Created) > " -e -i "/opt/Matsya" BASE
fi

sudo mkdir -p $BASE
sudo mkdir -p $BASE/MN
sudo mkdir -p $BASE/mounts
sudo mkdir -p $BASE/Repo
sudo mkdir -p $BASE/tmp
sudo mkdir -p $BASE/VagVBox
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

if [ "$THEUSERCHOICE" == "D" ] ; then
	# RESULTS COULD BE N Y P A H D
	IFS='|' read -ra items <<< "$scopemanyidy"
	for scopeidy in "${items[@]}"; do
		search_result=$(grep -n "^$scopeidy" $thedatafile)

		if [ -n "$search_result" ]; then
			line_number=$(echo "$search_result" | awk -F ':' 'NR==1 {print $1}')
			content=$(echo "$search_result" | awk -F ':' 'NR==1 {print $2}')
			IFS=',' read -ra contents <<< "$content"
			filtered_content=$(IFS=',' && printf "%s," "${contents[@]:0:${#contents[@]}-1}")
			filtered_content=${filtered_content%,}	
			IFS=',' read -r -a USERLISTVALS <<< $content
			thehost="${USERLISTVALS[16]}"
			isvm="${USERLISTVALS[15]}"
			themachineip="${USERLISTVALS[6]}"
			thecurrentdeleteflag="${USERLISTVALS[27]}"	
			thenewdeleteflag=""
			if [ "$thecurrentdeleteflag" == "Y" ] ; then
				thenewdeleteflag="Y"
			else
				if [ "$isvm" == "Yes" ] ; then				
					IFS='-' read -ra parts <<< "$thehost"
					filtered_partsthehost=$(IFS='-' && printf "%s-" "${parts[@]:0:${#parts[@]}-1}")
					filtered_partsthehost=${filtered_partsthehost%-}
					VMParent1="${USERLISTVALS[7]}"
					pingcount=0
					for ((i=1; i<=2; i++)); do
						if ping -c 1 "$VMParent1" >/dev/null; then
						pingcount=$((pingcount + 1))
					fi
					done
					if [ $pingcount -gt 0 ]; then
						P1UserName="${USERLISTVALS[11]}"	
						P1Port="${USERLISTVALS[12]}"	
						P1Password="${USERLISTVALS[13]}"	
						P1PEM="${USERLISTVALS[14]}"
						M1PPEM="${USERLISTVALS[25]}"
						P1UserName=$(NARASIMHA "decrypt" "$P1UserName" "$visionkey")
						P1Port=$(NARASIMHA "decrypt" "$P1Port" "$visionkey")
						P1Password=$(NARASIMHA "decrypt" "$P1Password" "$visionkey")
						P1PEM=$(NARASIMHA "decrypt" "$P1PEM" "$visionkey")
						M1PPEM=$(NARASIMHA "decrypt" "$M1PPEM" "$visionkey")
						M1RPPEM="${M1PPEM##*/}"
						M1RNPPPEM="/home/$P1UserName/Downloads"	
					
						CANCONNECT="NO"
						
						if [ "$P1PEM" == "NA" ] ; then
							if output=$(sshpass -p "$P1Password" ssh -p $P1Port -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$P1UserName@$VMParent1" exit 2>&1); then
								CANCONNECT="YES"
							fi						
						else
							if output=$(ssh -p $P1Port -o StrictHostKeyChecking=no -i "$P1PEM" -o ConnectTimeout=5 "$P1UserName@$VMParent1" exit 2>&1); then
								CANCONNECT="YES"
							fi
						fi
						#echo "PARASHURAMA \"VVBD\" \"$VMParent1\" \"$P1UserName\" \"$P1Port\" \"$P1Password\" \"$P1PEM\" \"$M1PPEM\" \"$M1RPPEM\" \"$M1RNPPPEM\" \"$filtered_partsthehost\" \"$themachineip\" \"$visionkey\""
						#exit
						if [ "$CANCONNECT" == "YES" ] ; then
							thenewdeleteflag=$(PARASHURAMA "VVBD" "$VMParent1" "$P1UserName" "$P1Port" "$P1Password" "$P1PEM" "$M1PPEM" "$M1RPPEM" "$M1RNPPPEM" "$filtered_partsthehost" "$themachineip" "$visionkey" "$BASE" "$CURRENTUSER")
							#echo $thenewdeleteflag
							#exit
						else
							echo "Host Machine Access Denied"
							thenewdeleteflag="D"						
						fi
					else
						echo "Host Machine Down"
						thenewdeleteflag="H"
					fi
				else
					echo "Physical Machine"
					thenewdeleteflag="P"
				fi
			fi
			
			thenewcontent="$filtered_content,$thenewdeleteflag"
			
			sed -i "$line_number""s#.*#$thenewcontent#" "$thedatafile"		
		else
		    echo "Not Found"
		fi
	done

	exit
fi

ISFA="$BASE/Stack/$VBOXGENERICSTACKUBUNTU"

SPARKISFA="$BASE/Repo/Stack/Bundle/vagrant-virtualbox-generic-ubuntu-2204-v1-0-0.box"
SPARKJECISFA="$BASE/Repo/Stack/Bundle/vagrant-virtualbox-generic-ubuntu-2204-v1-0-0.box"
GENERICUBUDOCKER_="docker-generic-ubuntu-2204-v1-0-0.tar.7z"
GENERICUBUDOCKER="$BASE/Repo/Stack/Bundle/$GENERICUBUDOCKER_"
SPARKSTACKBUNDLE="$BASE/Repo/Stack/Bundle/Spark.7z"
ZOOKEEPERJAVA_="zulu8.70.0.23-ca-jdk8.0.372-linux_x64.tar.gz"
ZOOKEEPERSTACK_="apache-zookeeper-3.7.1-bin.tar.gz"
ZOOKEEPERJAVA="$BASE/Repo/Stack/Bundle/$ZOOKEEPERJAVA_"
ZOOKEEPERSTACK="$BASE/Repo/Stack/Bundle/$ZOOKEEPERSTACK_"
ZKSETUPFILE="$BASE/Repo/Stack/Bundle/SetUpZooKeeper.sh"
JAVASETUPFILE="$BASE/Repo/Stack/Bundle/SetUpJava.sh"
JECSETUPFILE="$BASE/Repo/Stack/Bundle/SetUpJEC.sh"
NFSSETUPFILE="$BASE/Repo/Stack/Bundle/CreateNFSMount.sh"
SHELLSETUPFILE="$BASE/Repo/Stack/Bundle/SparkInitiate.sh"
SYNCJOBSETUPFILE="$BASE/Repo/Stack/Bundle/SyncJobLogs.sh"
TERMINALNEWCONFIG="$BASE/Repo/Stack/Bundle/confignew"
TERMINALOLDCONFIG="$BASE/Repo/Stack/Bundle/config"
TERMINALSYSTEMCONFIG="/home/prathamos/.config/terminator/config"
ZKEEPERVAR=""
VBOXCHOICE="AUTO"
if [ -f "$ISFA" ]
then
	VBOXCHOICE="MANUAL"
	echo ''
else
	echo "
==============================================================================

*Vagrant VirtualBox Missing...
--------
*Download From Here => $VBOXGENERICUBUNTU
   * Copy To $BASE/Stack/$VBOXGENERICSTACKUBUNTU  

==============================================================================
"
	exit
	read -p "Enter OPTION 1 OR 2 > " -e -i "2" USERCHOICE
	echo ''
	if [ $USERCHOICE == "1" ] || [ $USERCHOICE == "1" ] ; then
		echo "Exiting For Now...Download & Execute Again."
		echo ''
		exit
	else
		WGET="/usr/bin/wget"
		$WGET -q --tries=20 --timeout=10 http://www.google.com -O /tmp/google.idx &> /dev/null
		if [ ! -s /tmp/google.idx ]
		then
			echo "INTERNET NOT CONNECTED"
			echo ''
			exit
		fi
	fi
fi
UUID=$(uuidgen)
UUIDREAL=${UUID:1:6}
if [ "$USERINTERACTION" == "YES" ] || [ "$USERINTERACTION" == "yes" ] ; then
	read -p "Enter Cluster Name (Preferably Unique...) > " -e -i "$UUIDREAL" CLUSTERNAME
	echo ""
fi	
THEUNIQUETHISRUNGUID="$CLUSTERNAME"
sudo mkdir $BASE/tmp/$THEUNIQUETHISRUNGUID
sudo chmod -R 777 $BASE/tmp/$THEUNIQUETHISRUNGUID
echo "==============================================================================

*To Avoid Conflict Later...Open Another Terminal & Execute

   * sudo vagrant global-status --prune
   * sudo vagrant box list

If '$CLUSTERNAME' Appears On Above Commands,Execute

   * sudo $BASE/op-$CLUSTERNAME-kill.sh      
     
==============================================================================
"
echo -e "Enter Choice => { (${GREEN}${BOLD}\x1b[4mC${NORM}${NC})onfirm (${RED}${BOLD}\x1b[4mA${NORM}${NC})bort (${YELLOW}${BOLD}\x1b[4mP${NORM}${NC})roceed } c/a/p"
if [ "$USERINTERACTION" == "YES" ] || [ "$USERINTERACTION" == "yes" ] ; then
	read -p "> " -e -i "a" CONFIRMPROCEED	
	echo ""
fi	
IP_ADDRESS_LIST=()
if [ $CONFIRMPROCEED == "p" ] || [ $CONFIRMPROCEED == "P" ] ; then
	if [ -f "$BASE/op-$CLUSTERNAME-kill.sh" ]
	then
		sudo $BASE/op-$CLUSTERNAME-kill.sh
	fi	
	CONFIRMPROCEED="C"
fi	
if [ $CONFIRMPROCEED == "c" ] || [ $CONFIRMPROCEED == "C" ] ; then
	echo "=============================================================================="
	echo ''
	if [ "$USERINTERACTION" == "YES" ] || [ "$USERINTERACTION" == "yes" ] ; then
		read -p "Stack Deploy [ 0=NA / 1=SPARK / 2=KAFKA ] > " -e -i "0" STACKDEPLOY
		echo ''	
		if [ "$STACKDEPLOY" == "1" ] || [ "$STACKDEPLOY" == "1" ] ; then	
			#read -p "Enter No Of Nodes > " -e -i "11" NODESNUMBER
			read -p "Enter No Of Nodes > " -e -i "10" NODESNUMBER
			#read -p "Enter No Of Nodes > " -e -i "7" NODESNUMBER
			echo ''
		fi
		if [ "$STACKDEPLOY" == "0" ] || [ "$STACKDEPLOY" == "0" ] ; then	
			read -p "Enter No Of Nodes > " -e -i "3" NODESNUMBER
			echo ''
		fi
		read -p "SetUp (*Parallel OR *Linear) p/l > " -e -i "l" THESETUPMODE
		echo ''	
		if [ "$THESETUPMODE" == "P" ] || [ "$THESETUPMODE" == "p" ] ; then	
			read -p "Parallelization Limit > " -e -i "$PLIMIT" PLIMIT
			echo ''
		fi			
		read -p "Config (*Default OR *Custom) d/c > " -e -i "d" THECONFIGTYPE
		echo ''
		if [ $THECONFIGTYPE == "d" ] || [ $THECONFIGTYPE == "D" ] ; then				
			read -p "Enter Default Config (RAM {1024*n eg: 3GB RAM = 1024*3}, CORES, DISK SIZE {GB}) > " -e -i "3072,4,80" DEFAULTCONFIG
			echo ''
		fi
		if [ $THECONFIGTYPE == "c" ] || [ $THECONFIGTYPE == "C" ] ; then
			if [ "$STACKDEPLOY" == "1" ] || [ "$STACKDEPLOY" == "1" ] ; then	
				#read -p "Enter Custom Config(s) (RAM {1024*n eg: 3GB RAM = 1024*3}, CORES, DISK SIZE {GB}) > " -e -i "2048,1,50|2048,2,50|2048,2,50|2048,1,50|2048,1,50|2048,1,50|3584,8,80|3584,8,80|3584,2,50|2048,2,50|4096,4,100" DEFAULTCONFIG
				read -p "Enter Custom Config(s) (RAM {1024*n eg: 3GB RAM = 1024*3}, CORES, DISK SIZE {GB}) > " -e -i "2048,1,50|2048,2,50|2048,1,50|2048,1,50|2048,1,50|3840,8,80|3840,8,80|3584,2,50|3584,2,50|4096,4,100" DEFAULTCONFIG
				echo ''
			fi
			if [ "$STACKDEPLOY" == "0" ] || [ "$STACKDEPLOY" == "0" ] ; then	
				read -p "Enter Custom Config(s) (RAM {1024*n eg: 3GB RAM = 1024*3}, CORES, DISK SIZE {GB}) > " -e -i "2048,1,50|3072,4,80|3072,4,80" DEFAULTCONFIG
				echo ''
			fi									
		fi		
		read -p "LAN (*Private OR *Custom) p/c > " -e -i "c" LANTYPE
		echo ''
	fi
	THEIPBASE=""
	if [ $LANTYPE == "c" ] || [ $LANTYPE == "C" ] ; then
		echo '-----------------------'
		echo 'Network Cards Available'
		echo '-----------------------'
		ip -br -c addr show
		echo '-----------------------'				
		echo ''
		if [ "$USERINTERACTION" == "YES" ] || [ "$USERINTERACTION" == "yes" ] ; then	
			read -p "Enter NIC > " -e -i "enx7cc2c647669e" NIC
			echo ''
		fi
		THISCURRENTMACHINEIP=$(ip addr show $NIC | grep 'inet ' | awk '{print $2}' | awk -F'/' '{print $1}')
		echo '-----------------------'
		ifconfig $NIC
		echo ''
		route -n | grep "$NIC\|Gateway"
		echo '-----------------------'
		echo ''
		if [ "$USERINTERACTION" == "YES" ] || [ "$USERINTERACTION" == "yes" ] ; then		
			read -p "Enter Gateway > " -e -i "192.168.0.1" GATEWAY
			echo ''
			read -p "Enter Netmask > " -e -i "255.255.255.0" NETMASK
			echo ''
		fi	
		IFS='.'
		read -ra GTWY <<< "$GATEWAY"
		BASEIP=$(echo "${GTWY[0]}.${GTWY[1]}.${GTWY[2]}.")
		THEIPBASE=$(echo "${GTWY[0]}.${GTWY[1]}.${GTWY[2]}.")
		DIFF=$((200-100+1))
		R=$(($(($RANDOM%$DIFF))+100))
		if [ "$USERINTERACTION" == "YES" ] || [ "$USERINTERACTION" == "yes" ] ; then
			read -p "Random Starting IP > $BASEIP" -e -i "$R" STARTRANDOMIP
			echo ''
		fi
	else
		DIFF=$((200-100+1))
		R=$(($(($RANDOM%$DIFF))+100))
		BASEIP="192.168.50."
		THEIPBASE="192.168.50."
		if [ "$USERINTERACTION" == "YES" ] || [ "$USERINTERACTION" == "yes" ] ; then
			read -p "Random Starting IP > $BASEIP" -e -i "$R" STARTRANDOMIP
			echo ''	
		fi												
	fi
	if [ "$USERINTERACTION" == "YES" ] || [ "$USERINTERACTION" == "yes" ] ; then
		read -p "File Mount (*Local OR *Custom) l/c > " -e -i "l" FILEMOUNTOPTION
		echo ''	
	fi
	if [ $FILEMOUNTOPTION == "c" ] || [ $FILEMOUNTOPTION == "C" ] ; then
		if [ "$USERINTERACTION" == "YES" ] || [ "$USERINTERACTION" == "yes" ] ; then
			#read -p "Enter Mount Location(s) > " -e -i "$BASE/mounts/$CLUSTERNAME/disk1,$BASE/mounts/$CLUSTERNAME/disk2,$BASE/mounts/$CLUSTERNAME/disk3,$BASE/mounts/$CLUSTERNAME/disk1,$BASE/mounts/$CLUSTERNAME/disk2,$BASE/mounts/$CLUSTERNAME/disk3" REALFILEMOUNT
			if [ "$STACKDEPLOY" == "1" ] || [ "$STACKDEPLOY" == "1" ] ; then	
				#read -p "Enter Mount Location(s) > " -e -i "/opt/Matsya/mounts/SSD/1,/opt/Matsya/mounts/SSD/2,/opt/Matsya/mounts/SSD/3,/opt/Matsya/mounts/SSD/4,/opt/Matsya/mounts/SSD/5,/opt/Matsya/mounts/SSD/6,/opt/Matsya/mounts/SSD/7,/opt/Matsya/mounts/SSD/8,/opt/Matsya/mounts/System/1,/opt/Matsya/mounts/System/2,/opt/Matsya/mounts/SSD/9" REALFILEMOUNT
				read -p "Enter Mount Location(s) > " -e -i "/opt/Matsya/mounts/SSD/1,/opt/Matsya/mounts/SSD/2,/opt/Matsya/mounts/SSD/3,/opt/Matsya/mounts/SSD/4,/opt/Matsya/mounts/SSD/5,/opt/Matsya/mounts/SSD/6,/opt/Matsya/mounts/SSD/7,/opt/Matsya/mounts/SSD/8,/opt/Matsya/mounts/System/1,/opt/Matsya/mounts/System/2" REALFILEMOUNT
				echo ''
			fi
			if [ "$STACKDEPLOY" == "0" ] || [ "$STACKDEPLOY" == "0" ] ; then	
				read -p "Enter Mount Location(s) > " -e -i "/opt/Matsya/mounts/HDD/1,/opt/Matsya/mounts/HDD/2,/opt/Matsya/mounts/HDD/3" REALFILEMOUNT
				echo ''
			fi			
		fi
	fi
	SPARKSTACKDEPLOY_LIST=()
	SPARKMASTER_LIST=()
	ZOOKEEPER_LIST=()	
	NOTPARALLEL_LIST=()
	NOTPARALLEL_LIST+=("0")
		
	if [ "$USERINTERACTION" == "YES" ] || [ "$USERINTERACTION" == "yes" ] ; then
		#read -p "Stack Deploy [ 0=NA / 1=SPARK / 2=KAFKA ] > " -e -i "0" STACKDEPLOY
		#echo ''	
		if [ "$STACKDEPLOY" == "1" ] || [ "$STACKDEPLOY" == "1" ] ; then
			#read -p "Node Details (0 INDEXED) [ Master(s) / ZooKeeper(s) / Worker(s) / Driver(s) / SparkJEC ] > " -e -i "1,2|3,4,5|6,7|8,9|10" SPARKSTACKDEPLOY
			read -p "Node Details (0 INDEXED) [ Master(s) / ZooKeeper(s) / Worker(s) / Driver(s) / SparkJEC ] > " -e -i "1,2|3,4|5,6|7,8|9" SPARKSTACKDEPLOY
			#read -p "Node Details (0 INDEXED) [ Master(s) / ZooKeeper(s) / Worker(s) / Driver(s) / SparkJEC ] > " -e -i "1,2|3|4|5|6" SPARKSTACKDEPLOY
			echo ''
			read -p "Open Terminal y/n > " -e -i "n" OPENTERMINALS
			echo ''			
			IFS='|' read -r -a SPARKSTACKDEPLOYLIST <<< $SPARKSTACKDEPLOY
			THESPARKMASTERS=0
			THESPARKZOOKEEPERS=1
			THESPARKWORKERS=2
			THESPARKDRIVERS=3
			THESPARKJEC=4
			if [ "$THESETUPMODE" == "P" ] || [ "$THESETUPMODE" == "p" ] ; then
				NOTPARALLEL_LIST+=("1")
			fi
			
			IFS=',' read -r -a THESPARKMASTERSLIST <<< "${SPARKSTACKDEPLOYLIST[$THESPARKMASTERS]}"
			for THELONESPARKMASTER in "${THESPARKMASTERSLIST[@]}"
			do
				IFS='¬' read -r -a THELONESPARKMASTERVals <<< $THELONESPARKMASTER
				THELONESPARKMASTERVals_="${THELONESPARKMASTERVals[0]}"
				SPARKSTACKDEPLOY_LIST+=("M¬""$THELONESPARKMASTERVals_")
				SPARKMASTER_LIST+=("$THELONESPARKMASTERVals_")
				if [ "$THESETUPMODE" == "L" ] || [ "$THESETUPMODE" == "l" ] ; then
					NOTPARALLEL_LIST+=("$THELONESPARKMASTERVals_")
				fi				
			done			
			#SPARKSTACKDEPLOY_LIST+=("M¬""${SPARKSTACKDEPLOYLIST[$THESPARKMASTER]}")
			
			IFS=',' read -r -a THESPARKZOOKEEPERSLIST <<< "${SPARKSTACKDEPLOYLIST[$THESPARKZOOKEEPERS]}"
			for THELONESPARKZOOKEEPER in "${THESPARKZOOKEEPERSLIST[@]}"
			do
				IFS='¬' read -r -a THELONESPARKZOOKEEPERVals <<< $THELONESPARKZOOKEEPER
				THELONESPARKZOOKEEPERVals_="${THELONESPARKZOOKEEPERVals[0]}"
				SPARKPORT1Z=$(GetNewPort)
				SPARKPORT2Z=$(GetNewPort)
				SPARKPORT3Z=$(GetNewPort)				
				SPARKSTACKDEPLOY_LIST+=("Z¬""$THELONESPARKZOOKEEPERVals_""¬$SPARKPORT1Z""¬$SPARKPORT2Z""¬$SPARKPORT3Z")
				ZOOKEEPER_LIST+=("$THELONESPARKZOOKEEPERVals_")
				if [ "$THESETUPMODE" == "L" ] || [ "$THESETUPMODE" == "l" ] ; then
					NOTPARALLEL_LIST+=("$THELONESPARKZOOKEEPERVals_")
				fi
			done
						
			IFS=',' read -r -a THESPARKWORKERSLIST <<< "${SPARKSTACKDEPLOYLIST[$THESPARKWORKERS]}"
			for THELONESPARKWORKER in "${THESPARKWORKERSLIST[@]}"
			do
				IFS='¬' read -r -a THELONESPARKWORKERVals <<< $THELONESPARKWORKER
				THELONESPARKWORKERVals_="${THELONESPARKWORKERVals[0]}"
				SPARKSTACKDEPLOY_LIST+=("W¬""$THELONESPARKWORKERVals_")
				if [ "$THESETUPMODE" == "L" ] || [ "$THESETUPMODE" == "l" ] ; then
					NOTPARALLEL_LIST+=("$THELONESPARKWORKERVals_")
				fi
			done

			IFS=',' read -r -a THESPARKDRIVERSLIST <<< "${SPARKSTACKDEPLOYLIST[$THESPARKDRIVERS]}"
			for THELONESPARKDRIVER in "${THESPARKDRIVERSLIST[@]}"
			do
				IFS='¬' read -r -a THELONESPARKDRIVERVals <<< $THELONESPARKDRIVER
				THELONESPARKDRIVERVals_="${THELONESPARKDRIVERVals[0]}"
				SPARKSTACKDEPLOY_LIST+=("D¬""$THELONESPARKDRIVERVals_")
				if [ "$THESETUPMODE" == "L" ] || [ "$THESETUPMODE" == "l" ] ; then
					NOTPARALLEL_LIST+=("$THELONESPARKDRIVERVals_")
				fi
			done
									
			SPARKSTACKDEPLOY_LIST+=("S¬""${SPARKSTACKDEPLOYLIST[$THESPARKJEC]}")
			if [ "$THESETUPMODE" == "L" ] || [ "$THESETUPMODE" == "l" ] ; then
				NOTPARALLEL_LIST+=("${SPARKSTACKDEPLOYLIST[$THESPARKJEC]}")
			fi									
		fi		
	fi
	#for bla in "${SPARKMASTER_LIST[@]}"
	#do
	#echo $bla
	#done
	#COUNTERM=1
	#if printf '%s\0' "${NOTPARALLEL_LIST[@]}" | grep -Fxqz -- $COUNTERM; then
	#    echo "it works"
	#fi			
	#exit			
	sudo rm -rf $BASE/VagVBox/$CLUSTERNAME
	sudo mkdir -p $BASE/VagVBox/$CLUSTERNAME/Configs
	sudo mkdir -p $BASE/VagVBox/$CLUSTERNAME/Keys
	sudo mkdir -p $BASE/VagVBox/$CLUSTERNAME/VM
	sudo chown -R root:root $BASE/VagVBox/$CLUSTERNAME
	sudo chmod -R u=rwx,g=,o= $BASE/VagVBox/$CLUSTERNAME	
	echo '-----------------------'
	echo 'NODES (IP & HOSTNAME)'
	echo '-----------------------'
	SERIESSTART=$(echo "$(($STARTRANDOMIP + 0))")
	SERIESEND=$(echo "$(($STARTRANDOMIP + $NODESNUMBER))")	
	SSHBYCOORDINATOR="echo '-----------------------' && "
	COUNTERx=0
	SMALLWVAR=0
	SMALLHVAR=0
	SMALLZVAR=0
	ZOOSTARTPOINT=1	
	DEFAULTCONFIGCUSTOM_LIST=()

	JECDRIVER_ACCESS='#!/bin/bash'"
"
	echo "$JECDRIVER_ACCESS" | sudo tee $BASE/tmp/$THEUNIQUETHISRUNGUID/$JECDRIVERACCESS > /dev/null
	sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$JECDRIVERACCESS	
	sudo touch $BASE/tmp/$THEUNIQUETHISRUNGUID/$SLAVESFILE	
	sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$SLAVESFILE
	sudo touch $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE	
	sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE
	sudo touch $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE
	sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE		
	echo '#!/bin/bash' | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null
	echo '' | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null
	sudo touch $BASE/tmp/$THEUNIQUETHISRUNGUID/$FIREWALLFILE	
	sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$FIREWALLFILE	
	echo '#!/bin/bash' | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$FIREWALLFILE > /dev/null
	echo "
sudo firewall-cmd --permanent --zone=public --add-port=$OPENRANGEPORTS1-$OPENRANGEPORTS2/tcp
sudo firewall-cmd --permanent --zone=public --add-port=$OPENRANGEPORTS1-$OPENRANGEPORTS2/udp
" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$FIREWALLFILE > /dev/null

	THENEWPORTFUNCFILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	THENEWPORTFUNC='#!/bin/bash'"

P1=\"\$1\"
P2=\"\$2\"

function random_unused_port {
    local port=\$(shuf -i \$P1-\$P2 -n 1)
    netstat -lat | grep \$port > /dev/null
    if [[ \$? == 1 ]] ; then
        export RANDOM_PORT=\$port
    else
        random_unused_port
    fi
}

random_unused_port
echo \$RANDOM_PORT
"
	echo "$THENEWPORTFUNC" | sudo tee $BASE/tmp/$THEUNIQUETHISRUNGUID/$THENEWPORTFUNCFILE > /dev/null
	sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$THENEWPORTFUNCFILE

	THESPARKCONFFUNCFILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	THESPARKCONFFUNC='#!/bin/bash'"

P1=\"$OPENRANGEPORTS1\"
P2=\"$OPENRANGEPORTS2\"

if [ \"\$1\" == \"1\" ] ; then
        SPARKPORT1=\$(jec-newport \$P1 \$P2)
        SPARKPORT2=\$(jec-newport \$P1 \$P2)
        SPARKPORT3=\$(jec-newport \$P1 \$P2)
        SPARKPORT4=\$(jec-newport \$P1 \$P2)
        SPARKPORT5=\$(jec-newport \$P1 \$P2)
        SPARKPORT6=\$(jec-newport \$P1 \$P2)
        SPARKPORT7=\$(jec-newport \$P1 \$P2)
        CONF=\"--conf spark.driver.port=\$SPARKPORT1 --conf spark.ui.port=\$SPARKPORT2 --conf spark.fileserver.port=\$SPARKPORT3 --conf spark.broadcast.port=\$SPARKPORT4 --conf spark.replClassServer.port=\$SPARKPORT5 --conf spark.blockManager.port=\$SPARKPORT6 --conf spark.driver.blockManager.port=\$SPARKPORT7\"
        echo \$CONF
fi
"
	echo "$THESPARKCONFFUNC" | sudo tee $BASE/tmp/$THEUNIQUETHISRUNGUID/$THESPARKCONFFUNCFILE > /dev/null
	sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$THESPARKCONFFUNCFILE

	DOCKERFIRSTTIMEFILE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	DOCKERFIRSTTIME='#!/bin/bash'"

pushd /opt && sudo 7za x /opt/docker-generic-ubuntu-2204-v1-0-0.tar.7z -o. && popd && sudo systemctl restart docker && docker load --input /opt/docker-generic-ubuntu-2204-v1-0-0.tar && sudo rm -f /opt/docker-generic-ubuntu-2204-v1-0-0.tar && sudo rm -f /opt/docker-generic-ubuntu-2204-v1-0-0.tar.7z && docker images && docker ps -a && docker ps && sudo rm -f /opt/Docker1stTime.sh
"
	echo "$DOCKERFIRSTTIME" | sudo tee $BASE/tmp/$THEUNIQUETHISRUNGUID/$DOCKERFIRSTTIMEFILE > /dev/null
	sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$DOCKERFIRSTTIMEFILE
	
	SPARKSTACKDEPLOYINFO=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	sudo touch $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO	
	sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO	
	echo "=======================" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null	
	echo "====  SPARK STACK  ====" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null
	echo "=======================" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null
	
	ZOOKEEPERQUOROM=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	sudo touch $BASE/tmp/$THEUNIQUETHISRUNGUID/$ZOOKEEPERQUOROM	
	sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$ZOOKEEPERQUOROM	

	TERMINATORCOMMANDS=("ECHO1" "ECHO2" "ECHO3" "ECHO4" "ECHO5" "ECHO6" "ECHO7" "ECHO8" "ECHO9" "ECHOX" "ECHOY")
	TERMINATORCONFIG=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	if [ "$STACKDEPLOY" == "1" ] || [ "$STACKDEPLOY" == "1" ] ; then
		cp $TERMINALNEWCONFIG $BASE/tmp/$THEUNIQUETHISRUNGUID/$TERMINATORCONFIG
	fi
	
	THEWORKERLIST=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	sudo touch $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEWORKERLIST	
	sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEWORKERLIST

	THEDRIVERLIST=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	sudo touch $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEDRIVERLIST	
	sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEDRIVERLIST
	
	THEJECLIST=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	sudo touch $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEJECLIST	
	sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEJECLIST	

	THESECRETKEY=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	sudo touch $BASE/tmp/$THEUNIQUETHISRUNGUID/$THESECRETKEY	
	echo "$THESECRETKEY" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$THESECRETKEY > /dev/null
	sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$THESECRETKEY
	
	STARTSTOPSPARK0=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1) && sudo touch $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK0 && sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK0
	STARTSTOPSPARK1=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1) && sudo touch $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK1 && sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK1
	STARTSTOPSPARK2=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1) && sudo touch $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK2 && sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK2
	STARTSTOPSPARK3=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1) && sudo touch $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK3 && sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK3
	STARTSTOPSPARK4=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1) && sudo touch $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK4 && sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK4	
	STARTSTOPSPARK5=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1) && sudo touch $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK5 && sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK5
	STARTSTOPSPARK6=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1) && sudo touch $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK6 && sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK6
	STARTSTOPSPARK7=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1) && sudo touch $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK7 && sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK7
	STARTSTOPSPARK8=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1) && sudo touch $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK8 && sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK8
	STARTSTOPSPARKBLANK=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1) && sudo touch $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARKBLANK && sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARKBLANK
	STARTSTOPSPARKTOTAL1=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	STARTSTOPSPARKTOTAL2=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	STARTSTOPSPARKBASH=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1) && sudo touch $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARKBASH && sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARKBASH
	
	echo '#!/bin/bash' | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARKBASH > /dev/null
	echo '' | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARKBASH > /dev/null
	
	echo "
sleep 5
" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARKBLANK > /dev/null
			
	THESPARKMASTERLIST="spark://"
	THESPARKURLSLIST="firefox"
	SMALLSPRKLIST=0
						
	for ((i = SERIESSTART; i < SERIESEND; i++))
	do 
		if [ "$MAYADHICALL" == "YES" ] ; then
			target_key="$i"
			NEWIPADDR="${KEYVALIPS[$target_key]}"
			THENEWIDENTITYNAME="${KEYVALIDENTITIES[$target_key]}"
		else
			NEWIPADDR="${BASEIP}${i}"
		fi
		if [ "$REALFILEMOUNT" == "null" ] || [ "$REALFILEMOUNT" = "" ] ; then		
			IP_ADDRESS_LIST+=("$NEWIPADDR¬$BASE/VagVBox/$CLUSTERNAME/VM")
		else
			IFS=',' read -r -a ARRAYFILEMOUNT <<< $REALFILEMOUNT
			ARRAYLENFILEMOUNT=${#ARRAYFILEMOUNT[@]}
			ARRAYLENFILEMOUNT=$((ARRAYLENFILEMOUNT - 1))
			if (( $COUNTERx > $ARRAYLENFILEMOUNT )) ; then
				IP_ADDRESS_LIST+=("$NEWIPADDR¬$BASE/VagVBox/$CLUSTERNAME/VM")
			else
				IP_ADDRESS_LIST+=("$NEWIPADDR¬""${ARRAYFILEMOUNT[$COUNTERx]}")
			fi
		fi
		
		if [ $THECONFIGTYPE == "c" ] || [ $THECONFIGTYPE == "C" ] ; then				
			IFS='|' read -r -a DEFAULTCONFIGCUSTOM <<< $DEFAULTCONFIG
			DEFAULTCONFIGCUSTOM_=${#DEFAULTCONFIGCUSTOM[@]}
			DEFAULTCONFIGCUSTOM_=$((DEFAULTCONFIGCUSTOM_ - 1))
			DEFAULTCONFIGCUSTOM_LIST+=("${DEFAULTCONFIGCUSTOM[$COUNTERx]}")			
		fi		
						
		IP_ADDRESS_HYPHEN=${NEWIPADDR//./-}
		echo "$NEWIPADDR	op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN-$THENEWIDENTITYNAME-vvb"
		sudo mkdir -p $BASE/VagVBox/$CLUSTERNAME/Configs/op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN-$THENEWIDENTITYNAME
		
		TERMINALRUNCOMMAND="clear BLABLU sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \DOUBLEQStrictHostKeyChecking=no\DOUBLEQ -i \DOUBLEQ$BASE/Output/Pem/op-$CLUSTERNAME.pem\DOUBLEQ SINGLEQls -la . BLABLU echo \DOUBLEQ\DOUBLEQ BLABLU ls -la /opt BLABLU echo \DOUBLEQ\DOUBLEQSINGLEQ BLABLU sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \DOUBLEQStrictHostKeyChecking=no\DOUBLEQ -i \DOUBLEQ$BASE/Output/Pem/op-$CLUSTERNAME.pem\DOUBLEQ"
		
		if (( $COUNTERx > 0 )) ; then
			SSHBYCOORDINATOR+="sudo sshpass -p \"$MATSYAPWD\" ssh-copy-id -i /home/vagrant/.ssh/id_rsa.pub -o StrictHostKeyChecking=no -o IdentitiesOnly=yes matsya@$NEWIPADDR && "
		fi
		
		if [ "$STACKDEPLOY" == "0" ] || [ "$STACKDEPLOY" == "0" ] ; then
			if [ "$THESETUPMODE" == "L" ] || [ "$THESETUPMODE" == "l" ] ; then
				if (( $COUNTERx == 0 )) ; then
					echo ""
				else
					NOTPARALLEL_LIST+=("$COUNTERx")
				fi
			fi
		fi
		
		if [ "$STACKDEPLOY" == "1" ] || [ "$STACKDEPLOY" == "1" ] ; then
			for EACHSPARKENTRY in "${SPARKSTACKDEPLOY_LIST[@]}"
			do
				IFS='¬' read -r -a EACHSPARKENTRY_ <<< $EACHSPARKENTRY
				THESPARKNODETYPE="${EACHSPARKENTRY_[0]}"
				THESPARKNODENO="${EACHSPARKENTRY_[1]}"
				
				if (( THESPARKNODENO == COUNTERx )) ; then
				
					if [ "$THESPARKNODETYPE" == "M" ] ; then
						TERMINALRUNCOMMAND="clear BLABLU sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \DOUBLEQStrictHostKeyChecking=no\DOUBLEQ -i \DOUBLEQ$BASE/Output/Pem/op-$CLUSTERNAME.pem\DOUBLEQ SINGLEQls -la . BLABLU echo \DOUBLEQ\DOUBLEQ BLABLU ls -la /opt BLABLU echo \DOUBLEQ\DOUBLEQ BLABLU cat /opt/SparkHA.conf BLABLU echo \DOUBLEQ\DOUBLEQ BLABLU cat /opt/Spark/conf/slaves BLABLU echo \DOUBLEQ\DOUBLEQ BLABLU tail /opt/Spark/conf/spark-env.sh BLABLU echo \DOUBLEQ\DOUBLEQSINGLEQ BLABLU sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \DOUBLEQStrictHostKeyChecking=no\DOUBLEQ -i \DOUBLEQ$BASE/Output/Pem/op-$CLUSTERNAME.pem\DOUBLEQ"
					fi
					if [ "$THESPARKNODETYPE" == "Z" ] ; then
						TERMINALRUNCOMMAND="clear BLABLU sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \DOUBLEQStrictHostKeyChecking=no\DOUBLEQ -i \DOUBLEQ$BASE/Output/Pem/op-$CLUSTERNAME.pem\DOUBLEQ SINGLEQls -la . BLABLU echo \DOUBLEQ\DOUBLEQ BLABLU ls -la /opt BLABLU echo \DOUBLEQ\DOUBLEQ BLABLU java -version BLABLU echo \DOUBLEQ\DOUBLEQ BLABLU cat /opt/ZooKeeper/Data/myid BLABLU echo \DOUBLEQ\DOUBLEQ BLABLU cat /opt/ZooKeeper/Core/conf/zoo.cfg BLABLU echo \DOUBLEQ\DOUBLEQSINGLEQ BLABLU sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \DOUBLEQStrictHostKeyChecking=no\DOUBLEQ -i \DOUBLEQ$BASE/Output/Pem/op-$CLUSTERNAME.pem\DOUBLEQ"						
					fi					
					if [ "$THESPARKNODETYPE" == "W" ] ; then
						TERMINALRUNCOMMAND="clear BLABLU sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \DOUBLEQStrictHostKeyChecking=no\DOUBLEQ -i \DOUBLEQ$BASE/Output/Pem/op-$CLUSTERNAME.pem\DOUBLEQ SINGLEQls -la . BLABLU echo \DOUBLEQ\DOUBLEQ BLABLU ls -la /opt BLABLU echo \DOUBLEQ\DOUBLEQ BLABLU tail .bashrc BLABLU echo \DOUBLEQ\DOUBLEQSINGLEQ BLABLU sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \DOUBLEQStrictHostKeyChecking=no\DOUBLEQ -i \DOUBLEQ$BASE/Output/Pem/op-$CLUSTERNAME.pem\DOUBLEQ"
						
						echo "op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN-$THENEWIDENTITYNAME-vvb" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEWORKERLIST > /dev/null
					fi
					if [ "$THESPARKNODETYPE" == "D" ] ; then
						TERMINALRUNCOMMAND="clear BLABLU sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \DOUBLEQStrictHostKeyChecking=no\DOUBLEQ -i \DOUBLEQ$BASE/Output/Pem/op-$CLUSTERNAME.pem\DOUBLEQ SINGLEQls -la . BLABLU echo \DOUBLEQ\DOUBLEQ BLABLU ls -la /opt BLABLU echo \DOUBLEQ\DOUBLEQ BLABLU cat /opt/SparkJobHistoryServerConf BLABLU echo \DOUBLEQ\DOUBLEQ BLABLU docker images BLABLU echo \DOUBLEQ\DOUBLEQ BLABLU docker ps -a BLABLU echo \DOUBLEQ\DOUBLEQ BLABLU docker ps BLABLU echo \DOUBLEQ\DOUBLEQSINGLEQ BLABLU sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \DOUBLEQStrictHostKeyChecking=no\DOUBLEQ -i \DOUBLEQ$BASE/Output/Pem/op-$CLUSTERNAME.pem\DOUBLEQ"
						
						echo "op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN-$THENEWIDENTITYNAME-vvb" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEDRIVERLIST > /dev/null
					fi
					if [ "$THESPARKNODETYPE" == "S" ] ; then
						TERMINALRUNCOMMAND="clear BLABLU sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \DOUBLEQStrictHostKeyChecking=no\DOUBLEQ -i \DOUBLEQ$BASE/Output/Pem/op-$CLUSTERNAME.pem\DOUBLEQ SINGLEQls -la . BLABLU echo \DOUBLEQ\DOUBLEQ BLABLU ls -la /opt BLABLU echo \DOUBLEQ\DOUBLEQ BLABLU ls -la /opt/JEC/.Keys BLABLU echo \DOUBLEQ\DOUBLEQSINGLEQ BLABLU sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \DOUBLEQStrictHostKeyChecking=no\DOUBLEQ -i \DOUBLEQ$BASE/Output/Pem/op-$CLUSTERNAME.pem\DOUBLEQ"
						echo "op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN-$THENEWIDENTITYNAME-vvb" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEJECLIST > /dev/null						
					fi
					
					echo "sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT $GENERICUBUDOCKER vagrant@$NEWIPADDR:/home/vagrant &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null
					if [ "$THESPARKNODETYPE" == "D" ] || [ "$THESPARKNODETYPE" == "S" ] ; then
						echo "sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT $BASE/tmp/$THEUNIQUETHISRUNGUID/$DOCKERFIRSTTIMEFILE vagrant@$NEWIPADDR:/home/vagrant &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null					
						echo "sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"sudo chmod 777 /home/vagrant/$GENERICUBUDOCKER_ && sudo mv /home/vagrant/$GENERICUBUDOCKER_ /opt && sudo chmod 777 /opt/$GENERICUBUDOCKER_\" &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > /dev/null
						echo "sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"sudo chmod 777 /home/vagrant/$DOCKERFIRSTTIMEFILE && sudo mv /home/vagrant/$DOCKERFIRSTTIMEFILE /opt/Docker1stTime.sh && sudo chmod 777 /opt/Docker1stTime.sh\" &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > /dev/null						
					else
						echo "sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"sudo chmod 777 /home/vagrant/$GENERICUBUDOCKER_ && sudo mv /home/vagrant/$GENERICUBUDOCKER_ /opt && sudo chmod 777 /opt/$GENERICUBUDOCKER_\" &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > /dev/null
					fi
					
					if [ "$THESPARKNODETYPE" == "D" ] ; then
						echo "sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"sudo firewall-cmd --permanent --add-service=nfs && sudo firewall-cmd --permanent --add-service=mountd && sudo firewall-cmd --permanent --add-service=rpc-bind && sudo firewall-cmd --reload\" &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > /dev/null
						echo "sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT $NFSSETUPFILE vagrant@$NEWIPADDR:/home/vagrant &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null
						echo "sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT $BASE/tmp/$THEUNIQUETHISRUNGUID/$THESECRETKEY vagrant@$NEWIPADDR:/home/vagrant &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null
						echo "sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"sudo mv /home/vagrant/$THESECRETKEY /opt/.THESECRETKEY && sudo chmod u=r,g=r,o=r /opt/.THESECRETKEY && sudo chown root:root /opt/.THESECRETKEY\" &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > /dev/null
						echo "sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"sudo chmod 777 /home/vagrant/CreateNFSMount.sh && sudo mv /home/vagrant/CreateNFSMount.sh /opt/CreateNFSMount.sh && sudo chmod 777 /opt/CreateNFSMount.sh && sudo ln -s /opt/CreateNFSMount.sh /usr/bin/jec-nfsmount\" &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > /dev/null						
					fi
					if [ "$THESPARKNODETYPE" == "W" ] ; then
						echo "sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"sudo firewall-cmd --permanent --add-service=nfs && sudo firewall-cmd --permanent --add-service=mountd && sudo firewall-cmd --permanent --add-service=rpc-bind && sudo firewall-cmd --reload\" &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > /dev/null
						echo "sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT $NFSSETUPFILE vagrant@$NEWIPADDR:/home/vagrant &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null
						echo "sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT $BASE/tmp/$THEUNIQUETHISRUNGUID/$THESECRETKEY vagrant@$NEWIPADDR:/home/vagrant &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null
						echo "sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"sudo mv /home/vagrant/$THESECRETKEY /opt/.THESECRETKEY && sudo chmod u=r,g=r,o=r /opt/.THESECRETKEY && sudo chown root:root /opt/.THESECRETKEY\" &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > /dev/null
						echo "sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"sudo chmod 777 /home/vagrant/CreateNFSMount.sh && sudo mv /home/vagrant/CreateNFSMount.sh /opt/CreateNFSMount.sh && sudo chmod 777 /opt/CreateNFSMount.sh && sudo ln -s /opt/CreateNFSMount.sh /usr/bin/jec-nfsmount\" &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > /dev/null						
					fi										
					if [ "$THESPARKNODETYPE" == "S" ] ; then
						echo "sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"sudo firewall-cmd --permanent --add-service=nfs && sudo firewall-cmd --permanent --add-service=mountd && sudo firewall-cmd --permanent --add-service=rpc-bind && sudo firewall-cmd --reload\" &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > /dev/null
						echo "sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT $NFSSETUPFILE vagrant@$NEWIPADDR:/home/vagrant &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null
						echo "sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"sudo chmod 777 /home/vagrant/CreateNFSMount.sh && sudo mv /home/vagrant/CreateNFSMount.sh /opt/CreateNFSMount.sh && sudo chmod 777 /opt/CreateNFSMount.sh && sudo ln -s /opt/CreateNFSMount.sh /usr/bin/jec-nfsmount\" &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > /dev/null						
					fi
														
					if [ "$THESPARKNODETYPE" == "D" ] ; then
						echo "sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT $BASE/tmp/$THEUNIQUETHISRUNGUID/$THESPARKCONFFUNCFILE vagrant@$NEWIPADDR:/home/vagrant &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null
						echo "sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT $SHELLSETUPFILE vagrant@$NEWIPADDR:/home/vagrant &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null
						echo "sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT $SYNCJOBSETUPFILE vagrant@$NEWIPADDR:/home/vagrant &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null
						echo "sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"sudo chmod 777 /home/vagrant/SparkInitiate.sh && sudo mv /home/vagrant/SparkInitiate.sh /opt/SparkInitiate.sh && sudo chmod 777 /opt/SparkInitiate.sh && sudo ln -s /opt/SparkInitiate.sh /usr/bin/jec-spark-initiate\" &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > /dev/null
						echo "sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"sudo chmod 777 /home/vagrant/SyncJobLogs.sh && sudo mv /home/vagrant/SyncJobLogs.sh /opt/SyncJobLogs.sh && sudo chmod 777 /opt/SyncJobLogs.sh && sudo ln -s /opt/SyncJobLogs.sh /usr/bin/jec-spark-syncjoblogs\" &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > /dev/null
						echo "sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"sudo chmod 777 /home/vagrant/$THESPARKCONFFUNCFILE && sudo mv /home/vagrant/$THESPARKCONFFUNCFILE /opt/SparkConf.sh && sudo chmod 777 /opt/SparkConf.sh && sudo ln -s /opt/SparkConf.sh /usr/bin/jec-spark-conf\" &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > /dev/null

						echo "sudo cat /opt/JEC/.Keys/id_rsa.pub | sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"/home/vagrant/op-$CLUSTERNAME.pem\" 'cat >> \$HOME/.ssh/authorized_keys'" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$JECDRIVERACCESS > /dev/null
						
						SPARKDPORT1=$(GetNewPort)
						if (( $SMALLHVAR == 0 )) ; then
							echo "" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null
							echo "-----------------------" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null
							SMALLHVAR=$((SMALLHVAR + 1))
						fi
						echo -e "* SPARK_HISTORY_WEBUI		= ${BLUE}${BOLD}\x1b[4mhttp://op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN-$THENEWIDENTITYNAME-vvb:$SPARKDPORT1${NORM}${NC}" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null
						
						THESPARKURLSLIST+=" http://op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN-$THENEWIDENTITYNAME-vvb:$SPARKDPORT1"
						
						echo "* SPARK_HISTORY_START		= sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"cd /opt/Spark && ./sbin/start-history-server.sh --properties-file /opt/SparkJobHistoryServerConf && cd ~\"" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null
						echo "* SPARK_HISTORY_STOP 		= sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"cd /opt/Spark && ./sbin/stop-history-server.sh && cd ~\"" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null						
						echo "~~~~~~~~~~~~~~~~~~~~~~~" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null	
						echo "sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"sudo firewall-cmd --permanent --zone=public --add-port=$SPARKDPORT1/tcp && sudo firewall-cmd --reload && sudo touch /opt/SparkJobHistoryServerConf && echo \"spark.history.ui.port              $SPARKDPORT1\" | sudo tee -a /opt/SparkJobHistoryServerConf > /dev/null && echo \"spark.history.fs.logDirectory      file:/opt/SparkJob_History_Events_Logs\" | sudo tee -a /opt/SparkJobHistoryServerConf > /dev/null && sudo chown -R root:root /opt/SparkJobHistoryServerConf && sudo chmod -R u=rwx,g=rwx,o=rwx /opt/SparkJobHistoryServerConf\" &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > /dev/null																														
					fi
									
					if [ "$THESPARKNODETYPE" == "S" ] || [ "$THESPARKNODETYPE" == "D" ] ; then
						echo "sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT $BASE/tmp/$THEUNIQUETHISRUNGUID/$THENEWPORTFUNCFILE vagrant@$NEWIPADDR:/home/vagrant &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null
						echo "sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"sudo chmod 777 /home/vagrant/$THENEWPORTFUNCFILE && sudo mv /home/vagrant/$THENEWPORTFUNCFILE /opt/NewPort.sh && sudo chmod 777 /opt/NewPort.sh && sudo ln -s /opt/NewPort.sh /usr/bin/jec-newport\" &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > /dev/null																		
					fi
									
					if [ "$THESPARKNODETYPE" == "W" ] || [ "$THESPARKNODETYPE" == "D" ] ; then
						echo "sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT $SPARKSTACKBUNDLE vagrant@$NEWIPADDR:/home/vagrant &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null
						echo "sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"sudo chmod 777 Spark.7z && sudo 7z x Spark.7z -o. && sudo rm -f Spark.7z && sudo chmod -R 777 Spark && cd Spark && ./SetUpSpark.sh '/home/vagrant/$FIREWALLFILE' && cd .. && sudo rm -rf Spark\" &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > /dev/null						
					fi
					
					if [ "$THESPARKNODETYPE" == "M" ] ; then
						SPARKPORT1=$(GetNewPort)
						SPARKPORT2=$(GetNewPort)					
						echo "sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT $SPARKSTACKBUNDLE vagrant@$NEWIPADDR:/home/vagrant &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null
						echo "sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT $BASE/tmp/$THEUNIQUETHISRUNGUID/$SLAVESFILE vagrant@$NEWIPADDR:/home/vagrant &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null
						echo "sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"sudo chmod 777 Spark.7z && sudo 7z x Spark.7z -o. && sudo rm -f Spark.7z && sudo chmod -R 777 Spark && cd Spark && ./SetUpSpark.sh '/home/vagrant/$FIREWALLFILE' Y 'op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN-$THENEWIDENTITYNAME-vvb' $SPARKPORT1 $SPARKPORT2 '/home/vagrant/$SLAVESFILE' && cd .. && sudo rm -rf Spark\" &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > /dev/null
						THESPARKMASTERHOSTNAME="op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN-$THENEWIDENTITYNAME-vvb"
						
						echo "" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null
						echo "-----------------------" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null
						echo -e "* SPARK_MASTER 			= ${GREEN}spark://$THESPARKMASTERHOSTNAME:$SPARKPORT1${NORM}${NC}" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null
						echo -e "* SPARK_MASTER_WEBUI 		= ${BLUE}${BOLD}\x1b[4mhttp://$THESPARKMASTERHOSTNAME:$SPARKPORT2${NORM}${NC}" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null
						
						THESPARKURLSLIST+=" http://$THESPARKMASTERHOSTNAME:$SPARKPORT2"
						if (( $SMALLSPRKLIST == 0 )) ; then
							echo "" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null
							echo "-----------------------" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null
							THESPARKMASTERLIST+="$THESPARKMASTERHOSTNAME:$SPARKPORT1"
							SMALLSPRKLIST=$((SMALLSPRKLIST + 1))
						else
							THESPARKMASTERLIST+=",$THESPARKMASTERHOSTNAME:$SPARKPORT1"
						fi
												
						echo "* SPARK_START	 		= sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"cd /opt/Spark && ./sbin/start-all.sh && cd ~\"" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null
						echo "* SPARK_STOP	 		= sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"cd /opt/Spark && ./sbin/stop-all.sh && cd ~\"" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null																		
						echo "-----------------------" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null	
						echo "sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"sudo firewall-cmd --permanent --zone=public --add-port=$SPARKPORT1/tcp && sudo firewall-cmd --permanent --zone=public --add-port=$SPARKPORT2/tcp && sudo firewall-cmd --reload\" &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > /dev/null											
					fi
					
					echo "sudo firewall-cmd --permanent --zone=public --add-source=$NEWIPADDR/24" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$FIREWALLFILE > /dev/null
					echo "sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT $BASE/tmp/$THEUNIQUETHISRUNGUID/$FIREWALLFILE vagrant@$NEWIPADDR:/home/vagrant &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null										
				fi
									
				if [ "$THESPARKNODETYPE" == "w" ] || [ "$THESPARKNODETYPE" == "W" ] ; then
					if (( THESPARKNODENO == COUNTERx )) ; then
						echo "op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN-$THENEWIDENTITYNAME-vvb" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SLAVESFILE > /dev/null
						SPARKWPORT1=$(GetNewPort)
						SPARKWPORT2=$(GetNewPort)
						if (( $SMALLWVAR == 0 )) ; then
							echo "" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null
							echo "-----------------------" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null
							SMALLWVAR=$((SMALLWVAR + 1))
						fi
						echo "* SPARK_WORKER_HOST 		= op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN-$THENEWIDENTITYNAME-vvb" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null	
						echo "* SPARK_WORKER_PORT 		= $SPARKWPORT1" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null
						echo "* SPARK_WORKER_WEBUI_PORT 	= $SPARKWPORT2" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null
						echo "~~~~~~~~~~~~~~~~~~~~~~~" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null	
						echo "sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"sudo firewall-cmd --permanent --zone=public --add-port=$SPARKWPORT1/tcp && sudo firewall-cmd --permanent --zone=public --add-port=$SPARKWPORT2/tcp && sudo firewall-cmd --reload && echo \"\" | tee -a ~/.bashrc > /dev/null && echo \"export SPARK_WORKER_PORT=$SPARKWPORT1\" | tee -a ~/.bashrc > /dev/null && echo \"export SPARK_WORKER_WEBUI_PORT=$SPARKWPORT2\" | tee -a ~/.bashrc > /dev/null\" &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > /dev/null						
					fi				
				fi
				
				if [ "$THESPARKNODETYPE" == "z" ] || [ "$THESPARKNODETYPE" == "Z" ] ; then
					if (( THESPARKNODENO == COUNTERx )) ; then
						#echo "sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT $ZOOKEEPERJAVA vagrant@$NEWIPADDR:/home/vagrant &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null
						echo "sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT $ZOOKEEPERSTACK vagrant@$NEWIPADDR:/home/vagrant &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null				
						SPARKZPORT1="${EACHSPARKENTRY_[2]}"
						SPARKZPORT2="${EACHSPARKENTRY_[3]}"
						SPARKZPORT3="${EACHSPARKENTRY_[4]}"
						THEZKEEPERHOSTNAME="op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN-$THENEWIDENTITYNAME-vvb"
						echo "server.$ZOOSTARTPOINT=$THEZKEEPERHOSTNAME:$SPARKZPORT2:$SPARKZPORT3" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$ZOOKEEPERQUOROM > /dev/null
											
						if (( $SMALLZVAR == 0 )) ; then
							echo "" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null
							echo "-----------------------" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null
							ZKEEPERVAR+="$THEZKEEPERHOSTNAME:$SPARKZPORT1"
							SMALLZVAR=$((SMALLZVAR + 1))
						else
							ZKEEPERVAR+=",$THEZKEEPERHOSTNAME:$SPARKZPORT1"
						fi
											
						echo "* ZOOKEEPER_HOST 		= $THEZKEEPERHOSTNAME" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null	
						echo "* ZOOKEEPER_CLIENT_PORT 	= $SPARKZPORT1" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null
						echo "* ZOOKEEPER_LEADER_PORT 	= $SPARKZPORT2" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null
						echo "* ZOOKEEPER_PEER_PORT 		= $SPARKZPORT3" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null
						echo "* ZOOKEEPER_EXECUTE 		= sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"/opt/ZooKeeper/Core/bin/zkServer.sh start\"" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null												
						echo "~~~~~~~~~~~~~~~~~~~~~~~" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null	
						echo "sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"sudo firewall-cmd --permanent --zone=public --add-port=$SPARKZPORT1/tcp && sudo firewall-cmd --permanent --zone=public --add-port=$SPARKZPORT2/tcp && sudo firewall-cmd --permanent --zone=public --add-port=$SPARKZPORT3/tcp && sudo firewall-cmd --reload && sudo mkdir /opt/ZK && sudo chown -R root:root /opt/ZK && sudo chmod -R u=rwx,g=rwx,o=rwx /opt/ZK && sudo touch /opt/ZK/myid && echo \"$ZOOSTARTPOINT\" | sudo tee -a /opt/ZK/myid > /dev/null && sudo chown -R root:root /opt/ZK/myid && sudo chmod -R u=rwx,g=rwx,o=rwx /opt/ZK/myid\" &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > /dev/null
						ZOOSTARTPOINT=$((ZOOSTARTPOINT + 1))																		
					fi				
				fi								
			done									
		fi		
		
		THESTRINGTOREPLACE="${TERMINATORCOMMANDS[$COUNTERx]}"
		#echo $THESTRINGTOREPLACE
		if [ "$STACKDEPLOY" == "1" ] || [ "$STACKDEPLOY" == "1" ] ; then
		sed -i s~"$THESTRINGTOREPLACE"~"$TERMINALRUNCOMMAND"~g $BASE/tmp/$THEUNIQUETHISRUNGUID/$TERMINATORCONFIG
		fi
		#THESEDCOMMAND="sed s~$THESTRINGTOREPLACE~$TERMINALRUNCOMMAND~g $BASE/tmp/$THEUNIQUETHISRUNGUID/$TERMINATORCONFIG"
		#eval $THESEDCOMMAND
		#echo $THESEDCOMMAND
		
		COUNTERx=$((COUNTERx + 1))
	done
	#exit
	if [ "$STACKDEPLOY" == "1" ] || [ "$STACKDEPLOY" == "1" ] ; then
	#sed -i 's~BLABLU~&&~g' $BASE/tmp/$THEUNIQUETHISRUNGUID/$TERMINATORCONFIG
	#sed -i 's~BLU~&~g' $BASE/tmp/$THEUNIQUETHISRUNGUID/$TERMINATORCONFIG
	sed -i -e 's~BLABLU~\&\&~g' $BASE/tmp/$THEUNIQUETHISRUNGUID/$TERMINATORCONFIG	
	sed -i s~"SINGLEQ"~"'"~g $BASE/tmp/$THEUNIQUETHISRUNGUID/$TERMINATORCONFIG
	sed -i s~"DOUBLEQ"~"\""~g $BASE/tmp/$THEUNIQUETHISRUNGUID/$TERMINATORCONFIG
	sed -i 's~ECHOZ~resetterm~g' $BASE/tmp/$THEUNIQUETHISRUNGUID/$TERMINATORCONFIG	
	#sudo rm -f /home/prathamos/.config/terminator/config
	#sudo cp $BASE/tmp/$THEUNIQUETHISRUNGUID/$TERMINATORCONFIG /home/prathamos/.config/terminator/config
	#sudo chown prathamos:prathamos /home/prathamos/.config/terminator/config
	#sudo chmod -R u=rw,g=rw,o=r /home/prathamos/.config/terminator/config
	#sudo rm -f /root/.config/terminator/config
	#sudo cp $BASE/tmp/$THEUNIQUETHISRUNGUID/$TERMINATORCONFIG /root/.config/terminator/config
	#sudo chown root:root /root/.config/terminator/config
	#sudo chmod -R u=rw,g=rw,o=r /root/.config/terminator/config	
	#sudo terminator &
	#sudo rm -f /home/prathamos/.config/terminator/config
	#sudo cp $TERMINALOLDCONFIG /home/prathamos/.config/terminator/config
	#sudo chown prathamos:prathamos /home/prathamos/.config/terminator/config
	#sudo chmod -R u=rw,g=rw,o=r /home/prathamos/.config/terminator/config		
	#cat $BASE/tmp/$THEUNIQUETHISRUNGUID/$TERMINATORCONFIG && exit
	fi
	
	SPARKHACONF=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)	
	sudo touch $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKHACONF	
	sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKHACONF
	echo "spark.deploy.recoveryMode=ZOOKEEPER
spark.deploy.zookeeper.url=$ZKEEPERVAR
spark.deploy.zookeeper.dir=/spark" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKHACONF > /dev/null

	COUNTERx=0
	for ((i = SERIESSTART; i < SERIESEND; i++))
	do
		if [ "$MAYADHICALL" == "YES" ] ; then
			target_key="$i"
			NEWIPADDR="${KEYVALIPS[$target_key]}"
			THENEWIDENTITYNAME="${KEYVALIDENTITIES[$target_key]}"
		else
			NEWIPADDR="${BASEIP}${i}"
		fi
		IP_ADDRESS_HYPHEN=${NEWIPADDR//./-}
		if [ "$STACKDEPLOY" == "1" ] || [ "$STACKDEPLOY" == "1" ] ; then
			for EACHSPARKENTRY in "${SPARKSTACKDEPLOY_LIST[@]}"
			do
				IFS='¬' read -r -a EACHSPARKENTRY_ <<< $EACHSPARKENTRY
				THESPARKNODETYPE="${EACHSPARKENTRY_[0]}"
				THESPARKNODENO="${EACHSPARKENTRY_[1]}"
				if [ "$THESPARKNODETYPE" == "M" ] ; then
					if (( THESPARKNODENO == COUNTERx )) ; then
						echo "sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKHACONF vagrant@$NEWIPADDR:/home/vagrant &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null
						echo "sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"cd ~ && sudo chmod 777 $SPARKHACONF && sudo mv $SPARKHACONF /opt/SparkHA.conf && sudo chown root:root /opt/SparkHA.conf && sudo chmod u=rwx,g=rwx,o=rwx /opt/SparkHA.conf\" &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > /dev/null	
						
						echo 'sudo ssh vagrant@'"$NEWIPADDR"' -p '"$RANDOMSSHPORT"'  -o "StrictHostKeyChecking=no" -i "'"$BASE"'/op-'"$CLUSTERNAME"'.pem" "sg jec -c \"cd /opt/Spark && ./sbin/start-master.sh --properties-file /opt/SparkHA.conf && cd ~\""' | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK3 > /dev/null
						echo 'sudo ssh vagrant@'"$NEWIPADDR"' -p '"$RANDOMSSHPORT"'  -o "StrictHostKeyChecking=no" -i "'"$BASE"'/op-'"$CLUSTERNAME"'.pem" "sg jec -c \"cd /opt/Spark && ./sbin/stop-master.sh && cd ~\""' | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK4 > /dev/null										
					fi
				fi

				if [ "$THESPARKNODETYPE" == "d" ] || [ "$THESPARKNODETYPE" == "D" ] ; then
					if (( THESPARKNODENO == COUNTERx )) ; then
						echo "sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEWORKERLIST vagrant@$NEWIPADDR:/home/vagrant &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null
						echo "sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEJECLIST vagrant@$NEWIPADDR:/home/vagrant &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null
						echo "sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"sudo mv /home/vagrant/$THEWORKERLIST /opt && sudo chmod 777 /opt/$THEWORKERLIST && sudo mv /opt/$THEWORKERLIST /opt/THEWORKERLIST && sudo mv /home/vagrant/$THEJECLIST /opt && sudo chmod 777 /opt/$THEJECLIST && sudo mv /opt/$THEJECLIST /opt/THEJECLIST\" &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > /dev/null
						
						echo 'sudo ssh vagrant@'"$NEWIPADDR"' -p '"$RANDOMSSHPORT"'  -o "StrictHostKeyChecking=no" -i "'"$BASE"'/op-'"$CLUSTERNAME"'.pem" "jec-nfsmount D && sg jec -c \"cd /opt/Spark && ./sbin/start-history-server.sh --properties-file /opt/SparkJobHistoryServerConf && cd ~\""' | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK7 > /dev/null
						echo 'sudo ssh vagrant@'"$NEWIPADDR"' -p '"$RANDOMSSHPORT"'  -o "StrictHostKeyChecking=no" -i "'"$BASE"'/op-'"$CLUSTERNAME"'.pem" "sg jec -c \"cd /opt/Spark && ./sbin/stop-history-server.sh && cd ~\""' | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK8 > /dev/null																		
					fi
				fi
				
				if [ "$THESPARKNODETYPE" == "w" ] || [ "$THESPARKNODETYPE" == "W" ] ; then
					if (( THESPARKNODENO == COUNTERx )) ; then
						echo "sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEDRIVERLIST vagrant@$NEWIPADDR:/home/vagrant &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null
						echo "sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"sudo mv /home/vagrant/$THEDRIVERLIST /opt && sudo chmod 777 /opt/$THEDRIVERLIST && sudo mv /opt/$THEDRIVERLIST /opt/THEDRIVERLIST\" &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > /dev/null
						echo "sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEJECLIST vagrant@$NEWIPADDR:/home/vagrant &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null
						echo "sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"sudo mv /home/vagrant/$THEJECLIST /opt && sudo chmod 777 /opt/$THEJECLIST && sudo mv /opt/$THEJECLIST /opt/THEJECLIST\" &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > /dev/null						
						echo 'sudo ssh vagrant@'"$NEWIPADDR"' -p '"$RANDOMSSHPORT"'  -o "StrictHostKeyChecking=no" -i "'"$BASE"'/op-'"$CLUSTERNAME"'.pem" "sg jec -c \"cd /opt/Spark && ./sbin/start-worker.sh '"$THESPARKMASTERLIST"' && cd ~\" && sleep 10 && jec-nfsmount W"' | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK5 > /dev/null
						echo 'sudo ssh vagrant@'"$NEWIPADDR"' -p '"$RANDOMSSHPORT"'  -o "StrictHostKeyChecking=no" -i "'"$BASE"'/op-'"$CLUSTERNAME"'.pem" "sg jec -c \"cd /opt/Spark && ./sbin/stop-worker.sh && cd ~\""' | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK6 > /dev/null						
					fi
				fi
				
				if [ "$THESPARKNODETYPE" == "s" ] || [ "$THESPARKNODETYPE" == "S" ] ; then
					if (( THESPARKNODENO == COUNTERx )) ; then
						echo "sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEDRIVERLIST vagrant@$NEWIPADDR:/home/vagrant &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null
						echo "sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"sudo mv /home/vagrant/$THEDRIVERLIST /opt && sudo chmod 777 /opt/$THEDRIVERLIST && sudo mv /opt/$THEDRIVERLIST /opt/THEDRIVERLIST\" &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > /dev/null
						echo "sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEWORKERLIST vagrant@$NEWIPADDR:/home/vagrant &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null
						echo "sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"sudo mv /home/vagrant/$THEWORKERLIST /opt && sudo chmod 777 /opt/$THEWORKERLIST && sudo mv /opt/$THEWORKERLIST /opt/THEWORKERLIST\" &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > /dev/null
						echo 'sudo ssh vagrant@'"$NEWIPADDR"' -p '"$RANDOMSSHPORT"'  -o "StrictHostKeyChecking=no" -i "'"$BASE"'/op-'"$CLUSTERNAME"'.pem" "jec-nfsmount J"' | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK0 > /dev/null						
					fi
				fi								
																
				if [ "$THESPARKNODETYPE" == "z" ] || [ "$THESPARKNODETYPE" == "Z" ] ; then
					if (( THESPARKNODENO == COUNTERx )) ; then
						SPARKZPORT1="${EACHSPARKENTRY_[2]}"						
						ZOOKEEPERCONF=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
						ZOOKEEPERFINALCONF=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
						sudo touch $BASE/tmp/$THEUNIQUETHISRUNGUID/$ZOOKEEPERCONF	
						sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$ZOOKEEPERCONF					
						echo "tickTime=2000
dataDir=/opt/ZooKeeper/Data
clientPort=$SPARKZPORT1
initLimit=5
syncLimit=2
autopurge.snapRetainCount=3
autopurge.purgeInterval=24
maxClientCnxns=0" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$ZOOKEEPERCONF > /dev/null
						cat $BASE/tmp/$THEUNIQUETHISRUNGUID/$ZOOKEEPERCONF $BASE/tmp/$THEUNIQUETHISRUNGUID/$ZOOKEEPERQUOROM > $BASE/tmp/$THEUNIQUETHISRUNGUID/$ZOOKEEPERFINALCONF
						sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$ZOOKEEPERFINALCONF
						echo "sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT $BASE/tmp/$THEUNIQUETHISRUNGUID/$ZOOKEEPERFINALCONF vagrant@$NEWIPADDR:/home/vagrant &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null
						echo "sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"cd ~ && sudo chmod 777 $ZOOKEEPERFINALCONF && sudo mv $ZOOKEEPERFINALCONF zookeeper.properties\" &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > /dev/null	
						echo "sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT $ZKSETUPFILE vagrant@$NEWIPADDR:/home/vagrant &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null
						#echo "sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT $JAVASETUPFILE vagrant@$NEWIPADDR:/home/vagrant &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null						
						echo "sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"cd ~ && sudo chmod 777 SetUpZooKeeper.sh && ./SetUpZooKeeper.sh '/home/vagrant/$FIREWALLFILE' '$ZOOKEEPERJAVA_' '$ZOOKEEPERSTACK_' && sudo rm -rf *\" &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > /dev/null
						
						echo 'sudo ssh vagrant@'"$NEWIPADDR"' -p '"$RANDOMSSHPORT"'  -o "StrictHostKeyChecking=no" -i "'"$BASE"'/op-'"$CLUSTERNAME"'.pem" "sg jec -c \"/opt/ZooKeeper/Core/bin/zkServer.sh start\""' | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK1 > /dev/null
						echo 'sudo ssh vagrant@'"$NEWIPADDR"' -p '"$RANDOMSSHPORT"'  -o "StrictHostKeyChecking=no" -i "'"$BASE"'/op-'"$CLUSTERNAME"'.pem" "sg jec -c \"/opt/ZooKeeper/Core/bin/zkServer.sh stop\""' | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK2 > /dev/null																							
					fi				
				fi
				
				if [ "$THESPARKNODETYPE" == "s" ] || [ "$THESPARKNODETYPE" == "S" ] ; then
					if (( THESPARKNODENO == COUNTERx )) ; then
						echo "sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT $JECSETUPFILE vagrant@$NEWIPADDR:/home/vagrant &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null
						echo "sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT $BASE/Output/Pem/op-$CLUSTERNAME.pem vagrant@$NEWIPADDR:/home/vagrant &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null
						echo "sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT $BASE/tmp/$THEUNIQUETHISRUNGUID/$JECDRIVERACCESS vagrant@$NEWIPADDR:/home/vagrant &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null					
						echo "sudo ssh vagrant@$NEWIPADDR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"cd ~ && sudo chmod 777 SetUpJEC.sh && ./SetUpJEC.sh '/home/vagrant/$FIREWALLFILE' '$PEMFILENAME' '$NEWIPADDR' '$MATSYAPWD' '/home/vagrant/$JECDRIVERACCESS' && sudo rm -rf *\" &" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > /dev/null	
						
						echo "" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null
						echo "-----------------------" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null
						echo -e "* JEC_HOST 			= op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN-$THENEWIDENTITYNAME-vvb" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null
						echo -e "* DRIVER_ACCESS_PEM 		= /opt/JEC/.Keys/$PEMFILENAME.pem" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null																		
						echo "-----------------------" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null
					fi													
				fi				
			done									
		fi				
					
		COUNTERx=$((COUNTERx + 1))
	done
	COUNTERx=0
					
	echo "
wait
echo 'Spark Stack Bundle Copied Successfully'
" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE > /dev/null

	echo "
wait
echo 'Spark Stack Executed Successfully'
" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > /dev/null
	cat $BASE/tmp/$THEUNIQUETHISRUNGUID/$PSCPFILE $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILE > $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILEFINAL
	sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILEFINAL
	echo "
sudo firewall-cmd --reload" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$FIREWALLFILE > /dev/null

	cat $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARKBASH $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK0 $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARKBLANK $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK1 $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARKBLANK $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK3  $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARKBLANK  $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK5  $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK7 > $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARKTOTAL1
	sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARKTOTAL1

	cat $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARKBASH $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK8 $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK6  $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK4  $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARK2 > $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARKTOTAL2
	sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARKTOTAL2	

	if [ "$STACKDEPLOY" == "1" ] || [ "$STACKDEPLOY" == "1" ] ; then
		sudo mv $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARKTOTAL1 $BASE/op-$CLUSTERNAME-SparkStart.sh
		sudo mv $BASE/tmp/$THEUNIQUETHISRUNGUID/$STARTSTOPSPARKTOTAL2 $BASE/op-$CLUSTERNAME-SparkStop.sh
		sudo chown -R root:root $BASE/op-$CLUSTERNAME-SparkStart.sh
		sudo chmod -R u=x,g=,o= $BASE/op-$CLUSTERNAME-SparkStart.sh
		sudo chown -R root:root $BASE/op-$CLUSTERNAME-SparkStop.sh
		sudo chmod -R u=x,g=,o= $BASE/op-$CLUSTERNAME-SparkStop.sh
	fi
		
	echo "
-----------------------
* FULL_CLUSTER_START		= sudo $BASE/op-$CLUSTERNAME-SparkStart.sh
* FULL_CLUSTER_STOP 		= sudo $BASE/op-$CLUSTERNAME-SparkStop.sh
* SPARK_MASTERS 		= $THESPARKMASTERLIST
* OPEN_URLS 			= $THESPARKURLSLIST &
-----------------------" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null
	
	echo "" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null
	echo "=======================" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null	
	echo "" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO > /dev/null
		
	#for bla in "${SPARKSTACKDEPLOY_LIST[@]}"
	#do
	#echo $bla
	#done
	#cat $BASE/tmp/$THEUNIQUETHISRUNGUID/$SLAVESFILE && cat $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILEFINAL && cat $BASE/tmp/$THEUNIQUETHISRUNGUID/$FIREWALLFILE && cat $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO && echo $ZKEEPERVAR && exit
	
	SSHBYCOORDINATOR+="echo '-----------------------'"
	echo '-----------------------'
	echo ''
	WHENJOBBEGAN=$(echo $(date +%H):$(date +%M))
	if [ "$USERINTERACTION" == "YES" ] || [ "$USERINTERACTION" == "yes" ] ; then	
		read -p "Add To (/etc/hosts) y/n > " -e -i "y" ADDTOHOSTSFILE			
		echo ""
	fi
	DESTROYCLUSTERSCRIPT=$(echo '#!/bin/bash'"	
sudo vagrant global-status --prune | grep $CLUSTERNAME | cut -f 1 -d ' ' | xargs -L 1 sudo vagrant halt 
sudo vagrant global-status --prune | grep $CLUSTERNAME | cut -f 1 -d ' ' | xargs -L 1 sudo vagrant destroy -f  
sudo vagrant box list | grep $CLUSTERNAME | cut -f 1 -d ' ' | xargs -L 1 sudo vagrant box remove -f
sudo $BASE/op-$CLUSTERNAME-stop-post.sh
sudo rm -rf $BASE/VagVBox/$CLUSTERNAME
sudo rm -rf $BASE/Output/Pem/op-$CLUSTERNAME.pem
sudo rm -rf $BASE/op-$CLUSTERNAME.ppk 
sudo rm -rf $BASE/op-$CLUSTERNAME-start.sh
sudo rm -rf $BASE/op-$CLUSTERNAME-start-pre.sh	
sudo rm -rf $BASE/op-$CLUSTERNAME-stop.sh
sudo rm -rf $BASE/op-$CLUSTERNAME-stop-post.sh
sudo rm -rf $BASE/op-$CLUSTERNAME-kill.sh
sudo rm -rf $BASE/op-$CLUSTERNAME-push.sh
sudo rm -rf $BASE/op-$CLUSTERNAME-exec.sh
sudo rm -rf $BASE/op-$CLUSTERNAME-exec
sudo rm -rf $BASE/op-$CLUSTERNAME-add.sh
sudo rm -rf $BASE/op-$CLUSTERNAME-remove.sh
")
	echo "$DESTROYCLUSTERSCRIPT" | sudo tee $BASE/op-$CLUSTERNAME-kill.sh > /dev/null
	
	DESTROYCLUSTER1SCRIPT=$(echo '#!/bin/bash'"	
sudo $BASE/op-$CLUSTERNAME-stop-post.sh
#sudo rm -rf $BASE/Output/Pem/op-$CLUSTERNAME.pem
sudo rm -rf $BASE/op-$CLUSTERNAME.ppk 
sudo rm -rf $BASE/op-$CLUSTERNAME-start.sh
sudo rm -rf $BASE/op-$CLUSTERNAME-start-pre.sh	
sudo rm -rf $BASE/op-$CLUSTERNAME-stop.sh
sudo rm -rf $BASE/op-$CLUSTERNAME-stop-post.sh
sudo rm -rf $BASE/op-$CLUSTERNAME-kill.sh
sudo rm -rf $BASE/op-$CLUSTERNAME-push.sh
sudo rm -rf $BASE/op-$CLUSTERNAME-exec.sh
sudo rm -rf $BASE/op-$CLUSTERNAME-exec
sudo rm -rf $BASE/op-$CLUSTERNAME-add.sh
sudo rm -rf $BASE/op-$CLUSTERNAME-remove.sh
sudo vagrant box list | grep $CLUSTERNAME | cut -f 1 -d ' ' | xargs -L 1 sudo vagrant box remove -f
")
	echo "$DESTROYCLUSTER1SCRIPT" | sudo tee $BASE/op-$CLUSTERNAME-kill-opvvb.sh > /dev/null	
	
	if [ "$STACKDEPLOY" == "1" ] || [ "$STACKDEPLOY" == "1" ] ; then
		echo "sudo rm -rf $BASE/op-$CLUSTERNAME-SparkStart.sh" | sudo tee -a $BASE/op-$CLUSTERNAME-kill.sh > /dev/null
		echo "sudo rm -rf $BASE/op-$CLUSTERNAME-SparkStop.sh" | sudo tee -a $BASE/op-$CLUSTERNAME-kill.sh > /dev/null		
	fi
		
	STARTCLUSTERSCRIPT=$(echo '#!/bin/bash'"	

sudo $BASE/op-$CLUSTERNAME-start-pre.sh
sudo vagrant global-status --prune | grep $CLUSTERNAME | cut -f 1 -d ' ' | xargs -L 1 sudo vagrant up
")
	echo "$STARTCLUSTERSCRIPT" | sudo tee $BASE/op-$CLUSTERNAME-start.sh > /dev/null	

	STARTPRECLUSTERSCRIPT=$(echo '#!/bin/bash
	
	
	')
	echo "$STARTPRECLUSTERSCRIPT" | sudo tee $BASE/op-$CLUSTERNAME-start-pre.sh > /dev/null	
	
	STOPCLUSTERSCRIPT=$(echo '#!/bin/bash'"	

sudo vagrant global-status --prune | grep $CLUSTERNAME | cut -f 1 -d ' ' | xargs -L 1 sudo vagrant halt
sudo $BASE/op-$CLUSTERNAME-stop-post.sh
")
	echo "$STOPCLUSTERSCRIPT" | sudo tee $BASE/op-$CLUSTERNAME-stop.sh > /dev/null
	
	STOPPOSTCLUSTERSCRIPT=$(echo '#!/bin/bash
	
	
	')
	echo "$STOPPOSTCLUSTERSCRIPT" | sudo tee $BASE/op-$CLUSTERNAME-stop-post.sh > /dev/null	
			
	echo "127.0.0.1   localhost localhost-$THENEWIDENTITYNAME-vvbdomain localhost4 localhost4-$THENEWIDENTITYNAME-vvbdomain4
::1         localhost localhost-$THENEWIDENTITYNAME-vvbdomain localhost6 localhost6-$THENEWIDENTITYNAME-vvbdomain6
" | sudo tee $BASE/VagVBox/$CLUSTERNAME/Configs/hosts > /dev/null	
	if [ $ADDTOHOSTSFILE == "y" ] || [ $ADDTOHOSTSFILE == "Y" ] ; then
		sudo -H -u root bash -c "echo \"\" >> /etc/hosts"
		sudo -H -u root bash -c "echo \"#VagVBox => $CLUSTERNAME START \" >> /etc/hosts"
		for ((i = SERIESSTART; i < SERIESEND; i++))
		do 
			if [ "$MAYADHICALL" == "YES" ] ; then
				target_key="$i"
				NEWIPADDR="${KEYVALIPS[$target_key]}"
				THENEWIDENTITYNAME="${KEYVALIDENTITIES[$target_key]}"
			else
				NEWIPADDR="${BASEIP}${i}"
			fi
			IP_ADDRESS_HYPHEN2=${NEWIPADDR//./-}
			sudo -H -u root bash -c "sed -i -e s~\"$NEWIPADDR\"~\"#$NEWIPADDR\"~g /etc/hosts"
			sudo -H -u root bash -c "echo \"$NEWIPADDR	op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN2-$THENEWIDENTITYNAME-vvb\" >> /etc/hosts"
			echo "sudo sed -i -e s~\"$NEWIPADDR\"~\"#$NEWIPADDR\"~g /etc/hosts" | sudo tee -a $BASE/op-$CLUSTERNAME-kill.sh > /dev/null
			echo "$NEWIPADDR	op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN2-$THENEWIDENTITYNAME-vvb" | sudo tee -a $BASE/VagVBox/$CLUSTERNAME/Configs/hosts > /dev/null			
		done
		sudo -H -u root bash -c "echo \"#VagVBox => $CLUSTERNAME END \" >> /etc/hosts"
		sudo -H -u root bash -c "echo \"\" >> /etc/hosts"											
	fi
	
	if [ "$SSHKEYCREATE" == "YES" ] ; then		
		echo '-----------------------'
		echo 'NEW SSH KEYS'
		echo '-----------------------'
		sudo -H -u root bash -c "cd $BASE/VagVBox/$CLUSTERNAME/Keys && echo -e  'y\n'|ssh-keygen -b 2048 -t rsa -P '' -f id_rsa && cat id_rsa.pub >> authorized_keys && cp id_rsa op-$CLUSTERNAME.pem && puttygen op-$CLUSTERNAME.pem -o op-$CLUSTERNAME.ppk && cd ~"
		sudo rm -rf $BASE/Output/Pem/op-$CLUSTERNAME.pem
		sudo rm -rf $BASE/op-$CLUSTERNAME.ppk
		sudo mv $BASE/VagVBox/$CLUSTERNAME/Keys/op-$CLUSTERNAME.pem $BASE/Output/Pem
		sudo mv $BASE/VagVBox/$CLUSTERNAME/Keys/op-$CLUSTERNAME.ppk $BASE
		sudo chmod u=rwx,g=rx,o=rx $BASE/Output/Pem/op-$CLUSTERNAME.pem
		sudo chmod u=rwx,g=rx,o=rx $BASE/op-$CLUSTERNAME.ppk
		sudo rm -rf $BASE/VagVBox/$CLUSTERNAME/Keys/authorized_keys
		sudo rm -rf $BASE/VagVBox/$CLUSTERNAME/Keys/id_rsa	
		sudo chown -R root:root $BASE/VagVBox/$CLUSTERNAME/Keys/id_rsa.pub
		sudo chmod -R u=rx,g=,o= $BASE/VagVBox/$CLUSTERNAME/Keys/id_rsa.pub	
		echo '-----------------------'
	fi
	COUNTER=0
	COORDINATOR="NONE"

	RANDOMCONFIGFILENAME=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	touch $BASE/tmp/$THEUNIQUETHISRUNGUID/$RANDOMCONFIGFILENAME	
	sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$RANDOMCONFIGFILENAME
	COUNTER=0	
	for ((i = SERIESSTART; i < SERIESEND; i++))
	do
		if [ "$MAYADHICALL" == "YES" ] ; then
			target_key="$i"
			NEWIPADDR="${KEYVALIPS[$target_key]}"
			THENEWIDENTITYNAME="${KEYVALIDENTITIES[$target_key]}"
		else
			NEWIPADDR="${BASEIP}${i}"
		fi
		IP_ADDRESS_HYPHEN2=${NEWIPADDR//./-}
		if (( $COUNTER == 0 )) ; then
			echo ''
		else
			echo "
Host op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN2-$THENEWIDENTITYNAME-vvb
    HostName op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN2-$THENEWIDENTITYNAME-vvb
    User vagrant
    StrictHostKeyChecking no
    IdentityFile ~/.ssh/id_rsa
    Port $RANDOMSSHPORT
" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$RANDOMCONFIGFILENAME > /dev/null									
		fi				
		COUNTER=$((COUNTER + 1))			
	done
	COUNTER=0
	
	THEPARALLELFUNCTIONLIST=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
	THENEWPRFUNC='#!/bin/bash'"
"
	echo "$THENEWPRFUNC" | sudo tee $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEPARALLELFUNCTIONLIST > /dev/null
	sudo chmod 777 $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEPARALLELFUNCTIONLIST
	THEPARALLEL_LIST=()
	THEPARALLELFUNC_LIST=()
	PARALLELFUNCCOUNT=0

	COUNTER=0			
	for IP_ADDRESS_VALS_LIST in "${IP_ADDRESS_LIST[@]}"
	do
		IFS='¬' read -r -a IP_ADDRESS_VALS_LISTVals <<< $IP_ADDRESS_VALS_LIST
		VMIP="${IP_ADDRESS_VALS_LISTVals[0]}"
		THEFILEMOUNTLOCATION="${IP_ADDRESS_VALS_LISTVals[1]}"
		THEOTHERINFO2="${IP_ADDRESS_VALS_LISTVals[1]}"		
		IP_ADDRESS_HYPHEN3=${VMIP//./-}
		NAMEOFTHECLUSTERBOX="$CLUSTERNAME"
		CLUSTERBOXURL="https://bit.ly/MatsyaKLM15VagVBox"
		if [ $VBOXCHOICE == "MANUAL" ] || [ $VBOXCHOICE == "MANUAL" ] ; then
			CLUSTERBOXURL="$ISFA"
			if [ "$STACKDEPLOY" == "1" ] || [ "$STACKDEPLOY" == "1" ] ; then
				CLUSTERBOXURL="$SPARKISFA"
				#NAMEOFTHECLUSTERBOX="$CLUSTERNAME-SPARK"
				if (( $COUNTER == 0 )) ; then
					CLUSTERBOXURL="$ISFA"
					NAMEOFTHECLUSTERBOX="$CLUSTERNAME"
				fi
			fi	
		fi

		if [ "$MAYADHICALL" == "YES" ] ; then
			target_key=$((COUNTER + 1))
			THENEWIDENTITYNAME="${KEYVALIDENTITIES[$target_key]}"
		fi

		if [ $THECONFIGTYPE == "d" ] || [ $THECONFIGTYPE == "D" ] ; then				
			IFS=','
			read -ra DEFCONFG <<< "$DEFAULTCONFIG"
		fi
		THEOTHERINFO1=""
		if [ $THECONFIGTYPE == "c" ] || [ $THECONFIGTYPE == "C" ] ; then				
			IFS=','
			read -ra DEFCONFG <<< "${DEFAULTCONFIGCUSTOM_LIST[$COUNTER]}"
			#echo $DEFCONFG
			THEOTHERINFO1="${DEFAULTCONFIGCUSTOM_LIST[$COUNTER]}"
		fi		

		DEFCONFGMEM=$(echo "${DEFCONFG[0]}")
		DEFCONFGCORES=$(echo "${DEFCONFG[1]}")
		ORIGINALSIZEOFDISK=$(echo "${DEFCONFG[2]}")
		NEWSIZEOFDISK=$((40 + ORIGINALSIZEOFDISK + 17))				
		DEFCONFGDISKSIZE=$(echo "$NEWSIZEOFDISK""GB")
		#echo $DEFCONFGMEM
		#echo $DEFCONFGCORES
		#echo $ORIGINALSIZEOFDISK
		#echo $NEWSIZEOFDISK
		#echo $DEFCONFGDISKSIZE
		VMNETWORKADDRESS="config.vm.network \"private_network\", ip: \"$VMIP\""
		
		if [ $LANTYPE == "c" ] || [ $LANTYPE == "C" ] ; then
			VMNETWORKADDRESS="config.vm.network \"public_network\", bridge: \"$NIC\", ip: \"$VMIP\""	
		fi
		
		THENAMEOFVBBOX="op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-$THENEWIDENTITYNAME-vvb"
		THENAMETOSHOWONSCREEN="$VMIP"
		
		if (( $COUNTER == 0 )) ; then
			COORDINATOR="$VMIP"
			THENAMEOFVBBOX="op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-$THENEWIDENTITYNAME-vvbc"
			THENAMEOFTHECOORDINATOR="$THENAMEOFVBBOX"
			THEACTUALNAMEOFTHECOORDINATOR="op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-$THENEWIDENTITYNAME"			
			THEIPOFTHECOORDINATOR="$COORDINATOR"
			if [ $THECONFIGTYPE == "d" ] || [ $THECONFIGTYPE == "D" ] ; then
				DEFCONFGDISKSIZE="100GB"
				DEFCONFGMEM="2048"
				DEFCONFGCORES="1"
			fi
			THENAMETOSHOWONSCREEN="$VMIP (Coordinator)"
		fi
			
		if [ "$STACKDEPLOY" == "1" ] || [ "$STACKDEPLOY" == "1" ] ; then
			for EACHSPARKENTRY in "${SPARKSTACKDEPLOY_LIST[@]}"
			do
				IFS='¬' read -r -a EACHSPARKENTRY_ <<< $EACHSPARKENTRY
				THESPARKNODETYPE="${EACHSPARKENTRY_[0]}"
				THESPARKNODENO="${EACHSPARKENTRY_[1]}"
				
				if (( THESPARKNODENO == COUNTER )) ; then
					if [ "$THESPARKNODETYPE" == "M" ] ; then
						THENAMEOFVBBOX="op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-spark-master"
						THENAMETOSHOWONSCREEN="$VMIP (Spark Master)"
					fi
					if [ "$THESPARKNODETYPE" == "Z" ] ; then
						THENAMEOFVBBOX="op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-zookeeper"
						THENAMETOSHOWONSCREEN="$VMIP (ZooKeeper)"
						CLUSTERBOXURL="$ISFA"
						NAMEOFTHECLUSTERBOX="$CLUSTERNAME"						
					fi					
					if [ "$THESPARKNODETYPE" == "W" ] ; then
						THENAMEOFVBBOX="op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-spark-worker"
						THENAMETOSHOWONSCREEN="$VMIP (Spark Worker)"
					fi
					if [ "$THESPARKNODETYPE" == "D" ] ; then
						THENAMEOFVBBOX="op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-spark-driver"
						THENAMETOSHOWONSCREEN="$VMIP (Spark Driver)"
					fi
					if [ "$THESPARKNODETYPE" == "S" ] ; then
						THENAMEOFVBBOX="op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-spark-JEC"
						THENAMETOSHOWONSCREEN="$VMIP (Spark JEC)"
						CLUSTERBOXURL="$SPARKJECISFA"
						#NAMEOFTHECLUSTERBOX="$CLUSTERNAME-SPARK-JEC"						
					fi																				
				fi				
			done									
		fi
		
		sudo mkdir -p $BASE/VagVBox/$CLUSTERNAME/Configs/op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-$THENEWIDENTITYNAME
						    
	    	echo "Vagrant.configure(\"2\") do |config|
  unless Vagrant.has_plugin?(\"vagrant-disksize\")
    raise  Vagrant::Errors::VagrantError.new, \"vagrant-disksize Plugin Missing.Run 'sudo vagrant plugin install vagrant-disksize' & Restart\"
  end 
   
  config.vm.box = \"$NAMEOFTHECLUSTERBOX\"
  config.vm.boot_timeout = 600
  config.vm.box_url = \"$CLUSTERBOXURL\"
  config.vm.provider :virtualbox do |vb|
      vb.name = \"$THENAMEOFVBBOX\"
  end
  
  #config.ssh.private_key_path = \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\"
  
  #config.ssh.port = $RANDOMSSHPORT
  
  #config.ssh.host = \"$VMIP\"
  
  config.vm.synced_folder '.', '/vagrant', disabled: true
  
  $VMNETWORKADDRESS  

  config.disksize.size = '$DEFCONFGDISKSIZE'
  
  config.vm.provider \"virtualbox\" do |vb|
     vb.memory = \"$DEFCONFGMEM\"
     vb.cpus = \"$DEFCONFGCORES\"
  end

  if Vagrant.has_plugin?(\"vagrant-vbguest\")
    config.vbguest.auto_update = false  
  end
  
end" | sudo tee $BASE/VagVBox/$CLUSTERNAME/Configs/op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-$THENEWIDENTITYNAME/Vagrantfile > /dev/null

		echo ''
		echo '-----------------------'
		echo "$THENAMETOSHOWONSCREEN"
		echo '-----------------------'
		
		THEFIRSTCOMMAND="sudo rm -rf $THEFILEMOUNTLOCATION/* && pushd $BASE/VagVBox/$CLUSTERNAME/Configs/op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-$THENEWIDENTITYNAME && sudo vboxmanage setproperty machinefolder $THEFILEMOUNTLOCATION && sudo vagrant up && sudo vboxmanage setproperty machinefolder default && popd"
		
		THEPARALLELFUNCTIONNAME="ParallelFunction$COUNTER"
		echo "function $THEPARALLELFUNCTIONNAME(){" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEPARALLELFUNCTIONLIST > /dev/null
		
		if printf '%s\0' "${NOTPARALLEL_LIST[@]}" | grep -Fxqz -- $COUNTER; then
			sudo -H -u root bash -c "$THEFIRSTCOMMAND"
			echo "echo \"\"" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEPARALLELFUNCTIONLIST > /dev/null
		else
			THEPARALLEL_LIST+=("$COUNTER¬$THEFILEMOUNTLOCATION")
			THEPARALLELFUNC_LIST+=("$THEPARALLELFUNCTIONNAME")
			PARALLELFUNCCOUNT=$((PARALLELFUNCCOUNT + 1))	
			THEFIRSTCOMMAND="pushd $BASE/VagVBox/$CLUSTERNAME/Configs/op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-$THENEWIDENTITYNAME && sudo vboxmanage setproperty machinefolder $BASE/VagVBox/$CLUSTERNAME/VM && sudo vagrant up && sudo vboxmanage setproperty machinefolder default && popd"				
			echo "sudo -H -u root bash -c \"$THEFIRSTCOMMAND\"" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEPARALLELFUNCTIONLIST > /dev/null		
		fi
		
		if (( $COUNTER == 0 )) ; then
			echo ""
		else
			FINALPOINTTODISKSIZE=$((ORIGINALSIZEOFDISK + 45))
			#THECOMMAND=$(echo 'disknumber="1" && number="2" && sudo parted --script /dev/sda mkpart primary ext4 45GB '"$FINALPOINTTODISKSIZE"'GB && sudo partprobe /dev/sda && sudo mkfs -F -t ext4 /dev/sda$number && sudo mkfs -F /dev/sda$number -t ext4 && sudo tune2fs -m 0 /dev/sda$number && sdauuid=$(sudo blkid -s UUID -o value /dev/sda$number) && sudo mkdir -p /opt/MatsyaPlatformData/_$disknumber && sudo mkdir -p /opt/java/Open && sudo mkdir -p /usr/java && sudo mkdir -p /usr/share/java && sudo e2label /dev/sda$number MatsyaPlatformData_$disknumber && echo "UUID=$sdauuid  /opt/MatsyaPlatformData/_$disknumber ext4 defaults 0 3" | sudo tee -a /etc/fstab > /dev/null && echo "----------------------------------------------------------------------------------------------" && sudo cat /etc/fstab && echo "----------------------------------------------------------------------------------------------" && lsblk -o name,mountpoint,label,size,fstype,uuid && echo "----------------------------------------------------------------------------------------------" && sudo parted -ls && echo "----------------------------------------------------------------------------------------------" && sudo rm -rf /opt/MatsyaPlatformData/_$disknumber/*')
			THECOMMAND=$(echo 'disknumber="1" && number="2" && sudo mkdir -p /opt/MatsyaPlatformData/_$disknumber && echo "----------------------------------------------------------------------------------------------" && sudo cat /etc/fstab && echo "----------------------------------------------------------------------------------------------" && lsblk -o name,mountpoint,label,size,fstype,uuid && echo "----------------------------------------------------------------------------------------------" && sudo parted -ls && echo "----------------------------------------------------------------------------------------------" && sudo rm -rf /opt/MatsyaPlatformData/_$disknumber/*')
			
			if printf '%s\0' "${NOTPARALLEL_LIST[@]}" | grep -Fxqz -- $COUNTER; then
				sudo ssh vagrant@$VMIP -p 22  -o "StrictHostKeyChecking=no" -i "$BASE/VagVBox/$CLUSTERNAME/Configs/op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-$THENEWIDENTITYNAME/.vagrant/machines/default/virtualbox/private_key" "$THECOMMAND"
			else
				echo "THECOMMAND$COUNTER=\$(echo 'disknumber=\"1\" && number=\"2\" && sudo mkdir -p /opt/MatsyaPlatformData/_\$disknumber && echo \"----------------------------------------------------------------------------------------------\" && sudo cat /etc/fstab && echo \"----------------------------------------------------------------------------------------------\" && lsblk -o name,mountpoint,label,size,fstype,uuid && echo \"----------------------------------------------------------------------------------------------\" && sudo parted -ls && echo \"----------------------------------------------------------------------------------------------\" && sudo rm -rf /opt/MatsyaPlatformData/_\$disknumber/*')" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEPARALLELFUNCTIONLIST > /dev/null
				echo "sudo ssh vagrant@$VMIP -p 22  -o \"StrictHostKeyChecking=no\" -i \"$BASE/VagVBox/$CLUSTERNAME/Configs/op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-$THENEWIDENTITYNAME/.vagrant/machines/default/virtualbox/private_key\" \"\$THECOMMAND$COUNTER\"" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEPARALLELFUNCTIONLIST > /dev/null				
			fi
		fi
		#sudo useradd -m matsya && 
		THECOMMAND2=$(echo 'sudo usermod -p $(echo "matsya" | openssl passwd -1 -stdin) matsya && sudo usermod -p $(echo "matsya" | openssl passwd -1 -stdin) root && sudo usermod -aG sudo matsya && sudo rm -f /etc/sudoers.d/matsya-user && echo "matsya ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/matsya-user > /dev/null && sudo mkdir -p /opt/MatsyaPlatformData/_0 && sudo mkdir -p /opt/java/Open && sudo mkdir -p /usr/java && sudo mkdir -p /usr/share/java && echo "'"$MATSYAPWD"'" | sudo tee /usr/bin/.mtsypswd > /dev/null && sudo chmod u=r,g=,o= /usr/bin/.mtsypswd && sudo rm -rf /etc/hostname && echo "'"op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-$THENEWIDENTITYNAME-vvb"'" | sudo tee /etc/hostname')
		
		if printf '%s\0' "${NOTPARALLEL_LIST[@]}" | grep -Fxqz -- $COUNTER; then
			sudo ssh vagrant@$VMIP -p 22  -o "StrictHostKeyChecking=no" -i "$BASE/VagVBox/$CLUSTERNAME/Configs/op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-$THENEWIDENTITYNAME/.vagrant/machines/default/virtualbox/private_key" "$THECOMMAND2"
		else
			echo "THECOMMAND2$COUNTER=\$(echo 'sudo usermod -p \$(echo \"matsya\" | openssl passwd -1 -stdin) matsya && sudo usermod -p \$(echo \"matsya\" | openssl passwd -1 -stdin) root && sudo usermod -aG sudo matsya && sudo rm -f /etc/sudoers.d/matsya-user && echo \"matsya ALL=(ALL) NOPASSWD:ALL\" | sudo tee /etc/sudoers.d/matsya-user > /dev/null && sudo mkdir -p /opt/MatsyaPlatformData/_0 && sudo mkdir -p /opt/java/Open && sudo mkdir -p /usr/java && sudo mkdir -p /usr/share/java && echo \"'\"$MATSYAPWD\"'\" | sudo tee /usr/bin/.mtsypswd > /dev/null && sudo chmod u=r,g=,o= /usr/bin/.mtsypswd && sudo rm -rf /etc/hostname && echo \"'\"op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-$THENEWIDENTITYNAME-vvb\"'\" | sudo tee /etc/hostname')" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEPARALLELFUNCTIONLIST > /dev/null
			echo "sudo ssh vagrant@$VMIP -p 22  -o \"StrictHostKeyChecking=no\" -i \"$BASE/VagVBox/$CLUSTERNAME/Configs/op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-$THENEWIDENTITYNAME/.vagrant/machines/default/virtualbox/private_key\" \"\$THECOMMAND2$COUNTER\"" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEPARALLELFUNCTIONLIST > /dev/null	
		fi

		echo "}" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEPARALLELFUNCTIONLIST > /dev/null
		
		COUNTER=$((COUNTER + 1))
	done
	
	echo "function ParallelFunctionDummy(){
echo \"\"
}" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEPARALLELFUNCTIONLIST > /dev/null

	if [ "$PARALLELFUNCCOUNT" -gt "$PLIMIT" ]; then
		echo "" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEPARALLELFUNCTIONLIST > /dev/null
		THEREQPARALLEL=$((PARALLELFUNCCOUNT))
		ITERATIONREQ=$((THEREQPARALLEL / PLIMIT))
		ITERATIONREQMOD=$((THEREQPARALLEL % PLIMIT))
		if [ "$ITERATIONREQMOD" -gt 0 ]; then
			ITERATIONREQ=$((ITERATIONREQ + 1))
		fi
		TotalIteration=0
		LEFTOVERCOUNT=$((PARALLELFUNCCOUNT))
		TOBERUN=$((PLIMIT))
		for (( IterationOuter=0; IterationOuter<ITERATIONREQ; IterationOuter++ ))
		do
			if (( $TotalIteration == 0 )) ; then
				DEDUCTRUN=$((LEFTOVERCOUNT-TOBERUN))	
			else
				DEDUCTRUN=$((DEDUCTRUN-TOBERUN))	
			fi	
			if [ "$DEDUCTRUN" -lt 0 ]; then
				#echo $DEDUCTRUN
				TOBERUN=$((TOBERUN + DEDUCTRUN))
			fi
			#echo "ITERATION $IterationOuter"
			THEEXPORTLIST=""
			THEPARALLELEXECLIST="parallel -j $TOBERUN :::"	
			FromCurrent=$((TotalIteration))
			ToLimit=$((TOBERUN + TotalIteration))
			LastNumber=$((ToLimit - 1))
			for (( Iteration=FromCurrent; Iteration<ToLimit; Iteration++ ))
			do  
				#echo "element $Iteration is ${THEPARALLELFUNC_LIST[$Iteration]}"
				if (( $Iteration == $LastNumber )) ; then
					THEEXPORTLIST+="export -f ${THEPARALLELFUNC_LIST[$Iteration]}"
				else
					THEEXPORTLIST+="export -f ${THEPARALLELFUNC_LIST[$Iteration]} && "
				fi
				THEPARALLELEXECLIST+=" ${THEPARALLELFUNC_LIST[$Iteration]}"	   
				TotalIteration=$((TotalIteration + 1))
			done
			#echo $THEEXPORTLIST
			#echo $THEPARALLELEXECLIST
			echo "$THEEXPORTLIST" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEPARALLELFUNCTIONLIST > /dev/null
			echo "$THEPARALLELEXECLIST" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEPARALLELFUNCTIONLIST > /dev/null
			echo "" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEPARALLELFUNCTIONLIST > /dev/null			
		done
		#echo $ITERATIONREQ
		#echo $ITERATIONREQMOD
	else
		THEEXPORTLIST=""
		THEPARALLELEXECLIST="parallel -j $((PARALLELFUNCCOUNT + 1)) :::"
		#PARALLELANDTYPE=""
		for THEPARALLELFUNC_LIST_1 in "${THEPARALLELFUNC_LIST[@]}"
		do
			THEEXPORTLIST+="export -f $THEPARALLELFUNC_LIST_1 && "
			THEPARALLELEXECLIST+=" $THEPARALLELFUNC_LIST_1"
			#PARALLELANDTYPE+="$THEPARALLELFUNC_LIST_1 & "
		done
		THEEXPORTLIST+="export -f ParallelFunctionDummy"
		THEPARALLELEXECLIST+=" ParallelFunctionDummy"
		#PARALLELANDTYPE+="ParallelFunctionDummy"
		echo "$THEEXPORTLIST" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEPARALLELFUNCTIONLIST > /dev/null
		echo "$THEPARALLELEXECLIST" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEPARALLELFUNCTIONLIST > /dev/null
		#echo "$PARALLELANDTYPE" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEPARALLELFUNCTIONLIST > /dev/null
		#echo "wait" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEPARALLELFUNCTIONLIST > /dev/null
		#echo "echo 'PARALLEL NODE CREATION COMPLETE'" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEPARALLELFUNCTIONLIST > /dev/null	
		#echo "sleep 2" | sudo tee -a $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEPARALLELFUNCTIONLIST > /dev/null		
	fi
	
	#for bla in "${THEPARALLEL_LIST[@]}"
	#do
	#echo $bla
	#done
	#for bla in "${THEPARALLELFUNC_LIST[@]}"
	#do
	#echo $bla
	#done	
	#cat $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEPARALLELFUNCTIONLIST && exit
	sudo $BASE/tmp/$THEUNIQUETHISRUNGUID/$THEPARALLELFUNCTIONLIST 
	#exit
		
	COUNTER=0
	SSHBYMASTER="echo '-----------------------' && "		
	for IP_ADDRESS_VALS_LIST in "${IP_ADDRESS_LIST[@]}"
	do
		IFS='¬' read -r -a IP_ADDRESS_VALS_LISTVals <<< $IP_ADDRESS_VALS_LIST
		VMIP="${IP_ADDRESS_VALS_LISTVals[0]}"
		THEFILEMOUNTLOCATION="${IP_ADDRESS_VALS_LISTVals[1]}"
		THEOTHERINFO2="${IP_ADDRESS_VALS_LISTVals[1]}"		
		IP_ADDRESS_HYPHEN3=${VMIP//./-}
		NAMEOFTHECLUSTERBOX="$CLUSTERNAME"
		CLUSTERBOXURL="https://bit.ly/MatsyaKLM15VagVBox"
		if [ $VBOXCHOICE == "MANUAL" ] || [ $VBOXCHOICE == "MANUAL" ] ; then
			CLUSTERBOXURL="$ISFA"
			if [ "$STACKDEPLOY" == "1" ] || [ "$STACKDEPLOY" == "1" ] ; then
				CLUSTERBOXURL="$SPARKISFA"
				#NAMEOFTHECLUSTERBOX="$CLUSTERNAME-SPARK"
				if (( $COUNTER == 0 )) ; then
					CLUSTERBOXURL="$ISFA"
					NAMEOFTHECLUSTERBOX="$CLUSTERNAME"
				fi
			fi	
		fi

		if [ $THECONFIGTYPE == "d" ] || [ $THECONFIGTYPE == "D" ] ; then				
			IFS=','
			read -ra DEFCONFG <<< "$DEFAULTCONFIG"
		fi
		THEOTHERINFO1=""
		if [ $THECONFIGTYPE == "c" ] || [ $THECONFIGTYPE == "C" ] ; then				
			IFS=','
			read -ra DEFCONFG <<< "${DEFAULTCONFIGCUSTOM_LIST[$COUNTER]}"
			#echo $DEFCONFG
			THEOTHERINFO1="${DEFAULTCONFIGCUSTOM_LIST[$COUNTER]}"
		fi
		if [ "$MAYADHICALL" == "YES" ] ; then
			target_key=$((COUNTER + 1))
			THENEWIDENTITYNAME="${KEYVALIDENTITIES[$target_key]}"
		fi

		DEFCONFGMEM=$(echo "${DEFCONFG[0]}")
		DEFCONFGCORES=$(echo "${DEFCONFG[1]}")
		ORIGINALSIZEOFDISK=$(echo "${DEFCONFG[2]}")
		NEWSIZEOFDISK=$((40 + ORIGINALSIZEOFDISK + 17))				
		DEFCONFGDISKSIZE=$(echo "$NEWSIZEOFDISK""GB")

		VMNETWORKADDRESS="config.vm.network \"private_network\", ip: \"$VMIP\""
		
		if [ $LANTYPE == "c" ] || [ $LANTYPE == "C" ] ; then
			VMNETWORKADDRESS="config.vm.network \"public_network\", bridge: \"$NIC\", ip: \"$VMIP\""	
		fi
		
		THENAMEOFVBBOX="op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-$THENEWIDENTITYNAME-vvb"
		THENAMETOSHOWONSCREEN="$VMIP"
		
		if (( $COUNTER == 0 )) ; then
			COORDINATOR="$VMIP"
			THENAMEOFVBBOX="op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-$THENEWIDENTITYNAME-vvbc"
			THENAMEOFTHECOORDINATOR="$THENAMEOFVBBOX"
			THEACTUALNAMEOFTHECOORDINATOR="op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-$THENEWIDENTITYNAME"			
			THEIPOFTHECOORDINATOR="$COORDINATOR"			
			if [ $THECONFIGTYPE == "d" ] || [ $THECONFIGTYPE == "D" ] ; then
				DEFCONFGDISKSIZE="100GB"
				DEFCONFGMEM="2048"
				DEFCONFGCORES="1"
			fi
			THENAMETOSHOWONSCREEN="$VMIP (Coordinator)"
		fi
			
		if [ "$STACKDEPLOY" == "1" ] || [ "$STACKDEPLOY" == "1" ] ; then
			for EACHSPARKENTRY in "${SPARKSTACKDEPLOY_LIST[@]}"
			do
				IFS='¬' read -r -a EACHSPARKENTRY_ <<< $EACHSPARKENTRY
				THESPARKNODETYPE="${EACHSPARKENTRY_[0]}"
				THESPARKNODENO="${EACHSPARKENTRY_[1]}"
				
				if (( THESPARKNODENO == COUNTER )) ; then
					if [ "$THESPARKNODETYPE" == "M" ] ; then
						THENAMEOFVBBOX="op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-spark-master"
						THENAMETOSHOWONSCREEN="$VMIP (Spark Master)"
					fi
					if [ "$THESPARKNODETYPE" == "Z" ] ; then
						THENAMEOFVBBOX="op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-zookeeper"
						THENAMETOSHOWONSCREEN="$VMIP (ZooKeeper)"
					fi					
					if [ "$THESPARKNODETYPE" == "W" ] ; then
						THENAMEOFVBBOX="op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-spark-worker"
						THENAMETOSHOWONSCREEN="$VMIP (Spark Worker)"
						SSHBYMASTER+="sudo sshpass -p \"$VAGRANTPWD\" ssh-copy-id -i /home/vagrant/.ssh/id_rsa.pub -o StrictHostKeyChecking=no -o IdentitiesOnly=yes vagrant@$VMIP && "						
					fi
					if [ "$THESPARKNODETYPE" == "D" ] ; then
						THENAMEOFVBBOX="op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-spark-driver"
						THENAMETOSHOWONSCREEN="$VMIP (Spark Driver)"
					fi
					if [ "$THESPARKNODETYPE" == "S" ] ; then
						THENAMEOFVBBOX="op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-spark-JEC"
						THENAMETOSHOWONSCREEN="$VMIP (Spark JEC)"
						CLUSTERBOXURL="$SPARKJECISFA"
						#NAMEOFTHECLUSTERBOX="$CLUSTERNAME-SPARK-JEC"
					fi																				
				fi				
			done									
		fi

		echo ''
		echo '-----------------------'
		echo "$THENAMETOSHOWONSCREEN"
		echo '-----------------------'	
		
		if [ "$SSHKEYCREATE" == "YES" ] ; then					    
			sudo cat $BASE/VagVBox/$CLUSTERNAME/Keys/id_rsa.pub | sudo ssh vagrant@$VMIP -p 22  -o "StrictHostKeyChecking=no" -i "$BASE/VagVBox/$CLUSTERNAME/Configs/op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-$THENEWIDENTITYNAME/.vagrant/machines/default/virtualbox/private_key" 'cat >> $HOME/.ssh/authorized_keys'
		else
			sudo cat $BASE/Output/Pem/op-$CLUSTERNAME.pub | sudo ssh vagrant@$VMIP -p 22  -o "StrictHostKeyChecking=no" -i "$BASE/VagVBox/$CLUSTERNAME/Configs/op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-$THENEWIDENTITYNAME/.vagrant/machines/default/virtualbox/private_key" 'cat >> $HOME/.ssh/authorized_keys'
		fi
		
		WASFOUNDHERE=0
		for EACHPARALLELENTRY in "${THEPARALLEL_LIST[@]}"
		do
			IFS='¬' read -r -a EACHPARALLELENTRY_ <<< $EACHPARALLELENTRY
			THECOUNTERNODENO="${EACHPARALLELENTRY_[0]}"
			THECOUNTERNODELOCATION="${EACHPARALLELENTRY_[1]}"
			
			if (( THECOUNTERNODENO == COUNTER )) ; then
				#THEREQCOMMAND="pushd $BASE/VagVBox/$CLUSTERNAME/Configs/op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-$THENEWIDENTITYNAME && sudo vagrant halt && sudo mv $BASE/VagVBox/$CLUSTERNAME/VM/op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3 $THECOUNTERNODELOCATION && sed -i 's#$BASE/VagVBox/$CLUSTERNAME/VM/op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3/op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3.vbox#$THECOUNTERNODELOCATION/op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3/op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3.vbox#' /root/.config/VirtualBox/VirtualBox.xml && sed -i 's#$BASE/VagVBox/$CLUSTERNAME/VM/op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3/op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3.vbox#$THECOUNTERNODELOCATION/op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3/op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3.vbox#' /root/.config/VirtualBox/VirtualBox.xml-prev && sed -i 's/#config.ssh.private_key_path/config.ssh.private_key_path/' Vagrantfile && popd"
				#echo $THEREQCOMMAND
				THEREQCOMMAND="pushd $BASE/VagVBox/$CLUSTERNAME/Configs/op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-$THENEWIDENTITYNAME && sudo vagrant halt && sudo rm -rf $THECOUNTERNODELOCATION/* && sudo mv $BASE/VagVBox/$CLUSTERNAME/VM/$THENAMEOFVBBOX $THECOUNTERNODELOCATION && sudo ln -s $THECOUNTERNODELOCATION/$THENAMEOFVBBOX $BASE/VagVBox/$CLUSTERNAME/VM/$THENAMEOFVBBOX && sed -i 's/#config.ssh.private_key_path/config.ssh.private_key_path/' Vagrantfile && popd"				
				sudo -H -u root bash -c "$THEREQCOMMAND"
				#sudo -H -u root bash -c "pushd $BASE/VagVBox/$CLUSTERNAME/Configs/op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-$THENEWIDENTITYNAME && sudo vagrant halt && sed -i 's/#config.ssh.private_key_path/config.ssh.private_key_path/' Vagrantfile && popd"
				WASFOUNDHERE=$((WASFOUNDHERE + 1))
			fi
		done		
		
		if (( $WASFOUNDHERE == 0 )) ; then
			sudo -H -u root bash -c "pushd $BASE/VagVBox/$CLUSTERNAME/Configs/op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-$THENEWIDENTITYNAME && sudo vagrant halt && sed -i 's/#config.ssh.private_key_path/config.ssh.private_key_path/' Vagrantfile && popd"
		fi		
				
		sudo rm -rf $BASE/VagVBox/$CLUSTERNAME/Configs/op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-$THENEWIDENTITYNAME/.vagrant/machines/default/virtualbox/private_key
		
		sudo -H -u root bash -c "pushd $BASE/VagVBox/$CLUSTERNAME/Configs/op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-$THENEWIDENTITYNAME && sudo vagrant up && popd"
		
		#sudo ssh vagrant@$VMIP -p 22  -o "StrictHostKeyChecking=no" -i "$BASE/Output/Pem/op-$CLUSTERNAME.pem" "echo '$ROOTPWD' | sudo passwd --stdin 'root'"				
		#sudo ssh vagrant@$VMIP -p 22  -o "StrictHostKeyChecking=no" -i "$BASE/Output/Pem/op-$CLUSTERNAME.pem" "echo '$VAGRANTPWD' | sudo passwd --stdin 'vagrant'"				
		#sudo ssh vagrant@$VMIP -p 22  -o "StrictHostKeyChecking=no" -i "$BASE/Output/Pem/op-$CLUSTERNAME.pem" "echo '$MATSYAPWD' | sudo passwd --stdin 'matsya'"

		sudo ssh vagrant@$VMIP -p 22  -o "StrictHostKeyChecking=no" -i "$BASE/Output/Pem/op-$CLUSTERNAME.pem" "sudo usermod -p \$(echo \"$ROOTPWD\" | openssl passwd -1 -stdin) root"				
		sudo ssh vagrant@$VMIP -p 22  -o "StrictHostKeyChecking=no" -i "$BASE/Output/Pem/op-$CLUSTERNAME.pem" "sudo usermod -p \$(echo \"$VAGRANTPWD\" | openssl passwd -1 -stdin) vagrant"				
		sudo ssh vagrant@$VMIP -p 22  -o "StrictHostKeyChecking=no" -i "$BASE/Output/Pem/op-$CLUSTERNAME.pem" "sudo usermod -p \$(echo \"$MATSYAPWD\" | openssl passwd -1 -stdin) matsya"
		sudo ssh vagrant@$VMIP -p 22  -o "StrictHostKeyChecking=no" -i "$BASE/Output/Pem/op-$CLUSTERNAME.pem" "sudo usermod -p \$(echo \"$UBUPWD\" | openssl passwd -1 -stdin) ubuntu"
		sudo ssh vagrant@$VMIP -p 22  -o "StrictHostKeyChecking=no" -i "$BASE/Output/Pem/op-$CLUSTERNAME.pem" "sudo touch /opt/ISVM && sudo chmod 777 /opt/ISVM"
		sudo ssh vagrant@$VMIP -p 22  -o "StrictHostKeyChecking=no" -i "$BASE/Output/Pem/op-$CLUSTERNAME.pem" "echo \"$THISCURRENTMACHINEIP\" | sudo tee /opt/MYPARENT > /dev/null && sudo chmod 777 /opt/MYPARENT"
		
		THEOTHERINFOFINALVAL="${THEOTHERINFO1//,/'■'}■${THEOTHERINFO2}"
		sudo ssh vagrant@$VMIP -p 22  -o "StrictHostKeyChecking=no" -i "$BASE/Output/Pem/op-$CLUSTERNAME.pem" "echo \"$THEOTHERINFOFINALVAL\" | sudo tee /opt/THEOTHERINFO > /dev/null && sudo chmod 777 /opt/THEOTHERINFO"		
		
		if [ "$THEPARENTAUTHDETAILS" == "NOTHING" ] ; then
			echo ""
		else
			sudo ssh vagrant@$VMIP -p 22  -o "StrictHostKeyChecking=no" -i "$BASE/Output/Pem/op-$CLUSTERNAME.pem" "echo \"$THEPARENTAUTHDETAILS\" | sudo tee /opt/THEPARENTAUTHDETAILS > /dev/null && sudo chmod 777 /opt/THEPARENTAUTHDETAILS"
		fi		
				
		sudo ssh vagrant@$VMIP -p 22  -o "StrictHostKeyChecking=no" -i "$BASE/Output/Pem/op-$CLUSTERNAME.pem" 'sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config && sudo systemctl restart sshd.service'
		
		THEHOSTSFILE="$BASE/VagVBox/$CLUSTERNAME/Configs/hosts"
		SSHRELATEDRPMS="$BASE/Repo/Stack/Bundle/policycoreutils-python.7z"
		#https://www.tecmint.com/copy-files-to-multiple-linux-servers/
		#https://stackoverflow.com/questions/28025147/how-to-copy-multiple-files-simultaneously-using-scp
		sudo sshpass -p "$VAGRANTPWD" scp $THEHOSTSFILE vagrant@$VMIP:/home/vagrant
		sudo ssh vagrant@$VMIP -p 22  -o "StrictHostKeyChecking=no" -i "$BASE/Output/Pem/op-$CLUSTERNAME.pem" "sudo rm -f /etc/hosts && sudo mv /home/vagrant/hosts /etc"
		
		if [ "$STACKDEPLOY" == "0" ] || [ "$STACKDEPLOY" == "0" ] ; then
			#sudo sshpass -p "$VAGRANTPWD" scp $SSHRELATEDRPMS vagrant@$VMIP:/home/vagrant
			echo ""
		fi
		if [ "$STACKDEPLOY" == "1" ] || [ "$STACKDEPLOY" == "1" ] ; then
			if (( $COUNTER == 0 )) ; then
				#sudo sshpass -p "$VAGRANTPWD" scp $SSHRELATEDRPMS vagrant@$VMIP:/home/vagrant
				echo ""
			fi
		fi
		if printf '%s\0' "${ZOOKEEPER_LIST[@]}" | grep -Fxqz -- $COUNTER; then		
		#if (( $COUNTER == 1 )) ; then
			if [ "$STACKDEPLOY" == "1" ] || [ "$STACKDEPLOY" == "1" ] ; then
				#sudo sshpass -p "$VAGRANTPWD" scp $SSHRELATEDRPMS vagrant@$VMIP:/home/vagrant
				echo ""
			fi									
		fi
				
		if printf '%s\0' "${SPARKMASTER_LIST[@]}" | grep -Fxqz -- $COUNTER; then		
		#if (( $COUNTER == 1 )) ; then
			if [ "$STACKDEPLOY" == "1" ] || [ "$STACKDEPLOY" == "1" ] ; then
				sudo sshpass -p "$VAGRANTPWD" scp $BASE/tmp/$THEUNIQUETHISRUNGUID/$RANDOMCONFIGFILENAME vagrant@$VMIP:/home/vagrant
			fi									
		fi
				
		sudo -H -u root bash -c "pushd $BASE/VagVBox/$CLUSTERNAME/Configs/op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN3-$THENEWIDENTITYNAME && sed -i 's/#config.ssh.port/config.ssh.port/' Vagrantfile && sed -i 's/#config.ssh.host/config.ssh.host/' Vagrantfile && popd"								
		echo '-----------------------'
		
		COUNTER=$((COUNTER + 1))
	done
	SSHBYMASTER+="echo '-----------------------'"
	#exit
	sudo ssh vagrant@$COORDINATOR -p 22  -o "StrictHostKeyChecking=no" -i "$BASE/Output/Pem/op-$CLUSTERNAME.pem" "echo -e  'y\n'|ssh-keygen -t rsa -P '' -f /home/vagrant/.ssh/id_rsa && cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys && eval \$(ssh-agent) > /dev/null && ssh-add && MATSYAPSWD=\$(sudo cat /usr/bin/.mtsypswd) && sshpass -p \"\$MATSYAPSWD\" ssh-copy-id -i /home/vagrant/.ssh/id_rsa.pub -o StrictHostKeyChecking=no -o IdentitiesOnly=yes vagrant@$COORDINATOR"
	sudo ssh vagrant@$COORDINATOR -p 22  -o "StrictHostKeyChecking=no" -i "$BASE/Output/Pem/op-$CLUSTERNAME.pem" "$SSHBYCOORDINATOR"

	#SSHBYMASTER="echo '-----------------------' && "
	#COUNTER=0	
	#for ((i = SERIESSTART; i < SERIESEND; i++))
	#do 
	#	NEWIPADDR="${BASEIP}${i}"
	#	if (( $COUNTER > 0 )) ; then
	#		SSHBYMASTER+="sudo sshpass -p \"$VAGRANTPWD\" ssh-copy-id -i /home/vagrant/.ssh/id_rsa.pub -o StrictHostKeyChecking=no -o IdentitiesOnly=yes vagrant@$NEWIPADDR && "
	#	fi
	#	COUNTER=$((COUNTER + 1))
	#done	
	#SSHBYMASTER+="echo '-----------------------'"
	echo '-----------------------'
	echo ''
	#COUNTER=0
	
	COUNTER=0		
	for IP_ADDRESS_VALS_LIST in "${IP_ADDRESS_LIST[@]}"
	do
		IFS='¬' read -r -a IP_ADDRESS_VALS_LISTVals <<< $IP_ADDRESS_VALS_LIST
		VMIP="${IP_ADDRESS_VALS_LISTVals[0]}"
		THEFILEMOUNTLOCATION="${IP_ADDRESS_VALS_LISTVals[1]}"
		THEOTHERINFO2="${IP_ADDRESS_VALS_LISTVals[1]}"
		
		if [ "$STACKDEPLOY" == "0" ] || [ "$STACKDEPLOY" == "0" ] ; then
			echo ""
			#sudo ssh vagrant@$VMIP -p 22  -o "StrictHostKeyChecking=no" -i "$BASE/Output/Pem/op-$CLUSTERNAME.pem" "sudo rm -rf policycoreutils-python && sudo 7z x policycoreutils-python.7z -o. && sudo yum install -y policycoreutils-python/lsof-4.87-6.el7.x86_64.rpm && sudo rm -rf policycoreutils-python && sudo rm -rf policycoreutils-python.7z"
		fi
		if [ "$STACKDEPLOY" == "1" ] || [ "$STACKDEPLOY" == "1" ] ; then
			if (( $COUNTER == 0 )) ; then
				echo ""
				#sudo ssh vagrant@$VMIP -p 22  -o "StrictHostKeyChecking=no" -i "$BASE/Output/Pem/op-$CLUSTERNAME.pem" "sudo rm -rf policycoreutils-python && sudo 7z x policycoreutils-python.7z -o. && sudo yum install -y policycoreutils-python/lsof-4.87-6.el7.x86_64.rpm && sudo rm -rf policycoreutils-python && sudo rm -rf policycoreutils-python.7z"
			fi
		fi
		if printf '%s\0' "${ZOOKEEPER_LIST[@]}" | grep -Fxqz -- $COUNTER; then		
		#if (( $COUNTER == 1 )) ; then
			if [ "$STACKDEPLOY" == "1" ] || [ "$STACKDEPLOY" == "1" ] ; then
				echo ""
				#sudo ssh vagrant@$VMIP -p 22  -o "StrictHostKeyChecking=no" -i "$BASE/Output/Pem/op-$CLUSTERNAME.pem" "sudo rm -rf policycoreutils-python && sudo 7z x policycoreutils-python.7z -o. && sudo yum install -y policycoreutils-python/lsof-4.87-6.el7.x86_64.rpm && sudo rm -rf policycoreutils-python && sudo rm -rf policycoreutils-python.7z"
			fi									
		fi
				
		if printf '%s\0' "${SPARKMASTER_LIST[@]}" | grep -Fxqz -- $COUNTER; then		
		#if (( $COUNTER == 1 )) ; then
			if [ "$STACKDEPLOY" == "1" ] || [ "$STACKDEPLOY" == "1" ] ; then
				#https://phoenixnap.com/kb/ssh-config
				#https://unix.stackexchange.com/questions/10233/ssh-remote-server-on-some-port-other-than-22-without-password
				#echo "came here $VMIP"
				#echo "$SSHBYMASTER"
				sudo ssh vagrant@$VMIP -p 22  -o "StrictHostKeyChecking=no" -i "$BASE/Output/Pem/op-$CLUSTERNAME.pem" "echo -e  'y\n'|ssh-keygen -t rsa -P '' -f /home/vagrant/.ssh/id_rsa && cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys && eval \$(ssh-agent) > /dev/null && ssh-add && MATSYAPSWD=\$(sudo cat /usr/bin/.mtsypswd) && sshpass -p \"\$MATSYAPSWD\" ssh-copy-id -i /home/vagrant/.ssh/id_rsa.pub -o StrictHostKeyChecking=no -o IdentitiesOnly=yes vagrant@$VMIP"
				#echo "came here also $VMIP"
				sudo ssh vagrant@$VMIP -p 22  -o "StrictHostKeyChecking=no" -i "$BASE/Output/Pem/op-$CLUSTERNAME.pem" "sudo sshpass -p \"$VAGRANTPWD\" ssh-copy-id -i /home/vagrant/.ssh/id_rsa.pub -o StrictHostKeyChecking=no -o IdentitiesOnly=yes vagrant@$VMIP"
				sudo ssh vagrant@$VMIP -p 22  -o "StrictHostKeyChecking=no" -i "$BASE/Output/Pem/op-$CLUSTERNAME.pem" "$SSHBYMASTER"
				#echo "came here also 2 $VMIP"		
				sudo ssh vagrant@$VMIP -p 22  -o "StrictHostKeyChecking=no" -i "$BASE/Output/Pem/op-$CLUSTERNAME.pem" "sudo mv $RANDOMCONFIGFILENAME /home/vagrant/.ssh/config && sudo chown vagrant:vagrant /home/vagrant/.ssh/config && sudo chmod 777 /home/vagrant/.ssh/config && chmod 600 ~/.ssh/config"
			fi									
		fi

		if (( $COUNTER == 0 )) ; then
			echo ''
		else
			sudo ssh vagrant@$VMIP -p 22  -o "StrictHostKeyChecking=no" -i "$BASE/Output/Pem/op-$CLUSTERNAME.pem" "sudo rm -rf /usr/bin/.mtsypswd"									
		fi
						
		sudo ssh vagrant@$VMIP -p 22  -o "StrictHostKeyChecking=no" -i "$BASE/Output/Pem/op-$CLUSTERNAME.pem" "SSHPORT=\"$RANDOMSSHPORT\" && sudo systemctl stop ufw && sudo systemctl disable ufw && sudo systemctl start firewalld && sudo systemctl enable firewalld && sudo sed -i -e s~\"Port\"~\"#Port\"~g /etc/ssh/sshd_config && echo \"Port \$SSHPORT\" | sudo tee -a /etc/ssh/sshd_config > /dev/null && sudo firewall-cmd --permanent --zone=public --add-port=\$SSHPORT/tcp && sudo firewall-cmd --reload && sudo systemctl restart sshd.service && echo '-----' && sudo lsof -nP -iTCP -sTCP:LISTEN | grep \"COMMAND\|IPv4\" && echo '-----' && sudo netstat -tnlp | grep -v tcp6 && echo '-----' && sudo route del default gw 10.0.2.2 && sudo route add default gw $GATEWAY"
		COUNTER=$((COUNTER + 1))						
	done
	COUNTER=0
	
	if [ "$STACKDEPLOY" == "1" ] || [ "$STACKDEPLOY" == "1" ] ; then
		#sudo mv $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILEFINAL $BASE/op-$CLUSTERNAME-SparkStackDeploy.sh
		sudo $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKEXECUTEFILEFINAL
	fi
	
	if [ "$FINALOUTPUTREQ" == "YES" ] ; then		
		sudo touch "$FINALPROCESSOUTPUT"
		sudo chmod 777 "$FINALPROCESSOUTPUT"
		
		COUNTER=0		
		for IP_ADDRESS_VALS_LIST in "${IP_ADDRESS_LIST[@]}"
		do
			IFS='¬' read -r -a IP_ADDRESS_VALS_LISTVals <<< $IP_ADDRESS_VALS_LIST
			VMIP="${IP_ADDRESS_VALS_LISTVals[0]}"
			IP_ADDRESS_HYPHEN2=${VMIP//./-}
			
			if (( $COUNTER == 0 )) ; then
				ABC="XYZ"
			else
				ssh_info=$(sudo ssh vagrant@$VMIP -p $RANDOMSSHPORT  -o "StrictHostKeyChecking=no" -i "$BASE/Output/Pem/op-$CLUSTERNAME.pem" 'os_type=$(if command -v apt-get &> /dev/null; then echo "Ubuntu"; elif command -v yum &> /dev/null; then echo "RedHat"; else echo "WinMac"; fi); \
	    hostname=$(hostname); \
	    if command -v vagrant &> /dev/null && command -v virtualbox &> /dev/null; then vagrant_virtualbox_installed="Yes"; else vagrant_virtualbox_installed="No"; fi; \
	    total_ram=$(free -h | awk '"'"'{if (NR==2) print $2}'"'"' | sed "s/Gi//"); \
	    free_ram=$(free -h | awk '"'"'{if (NR==2) print $4}'"'"' | sed "s/Gi//"); \
	    cpu_cores=$(nproc); \
	    isvm_exists="No"; \
	    if [ -e "/opt/ISVM" ]; then isvm_exists="Yes"; fi; \
	    THEMACHPARENT=""; \
	    if [ -e "/opt/MYPARENT" ]; then THEMACHPARENT=$(head -n 1 "/opt/MYPARENT"); fi; \
	    THEMACHPARENTAUTH=""; \
	    if [ -e "/opt/THEPARENTAUTHDETAILS" ]; then THEMACHPARENTAUTH=$(head -n 1 "/opt/THEPARENTAUTHDETAILS"); fi; \    
	    #sudo rm -f /opt/THEPARENTAUTHDETAILS; \
	    THEOTHERINFO=""; \
	    if [ -e "/opt/THEOTHERINFO" ]; then THEOTHERINFO=$(head -n 1 "/opt/THEOTHERINFO"); fi; \	    	    
	    nic=$(ip addr | grep -B 2 "'"$VMIP"'" | awk '"'"'/^[0-9]/ {print $2; exit}'"'"'); \
	    nic=${nic%:}; \
	    gateway=$(ip route show dev "$nic" | grep -oP "^default via \K\S+"); \
	    netmask=$(ifconfig "$nic" | awk '"'"'/inet / {print $4}'"'"'); \
	    echo "$os_type├$hostname├$vagrant_virtualbox_installed├$total_ram├$free_ram├$cpu_cores├$isvm_exists├$THEMACHPARENT├$nic├$gateway├$netmask├$THEMACHPARENTAUTH├$THEOTHERINFO"')
				
				IFS='├' read -ra _gi <<< "$ssh_info"
				_gi0="${_gi[0]}"				
				_gi1="${_gi[1]}"
				_gi2="${_gi[2]}"
				_gi3="${_gi[3]}"
				_gi4="${_gi[4]}"
				_gi5="${_gi[5]}"
				_gi6="${_gi[6]}"
				_gi7="${_gi[7]}"				
				_gi8="${_gi[8]}"
				_gi9="${_gi[9]}"
				_gi10="${_gi[10]}"
				_gi11="${_gi[11]}"
				_gi12="${_gi[12]}"
				_gi12NEW="${_gi12//■/├}"
				_gi13=$(echo "$CLUSTERNAME" | grep -oP '(?<=Scope)\d+')
				_gi14=$(echo "$_gi1" | grep -oP '(?<=ID)\d+')
				
				echo "$_gi13,$_gi14,onprem,$_gi12NEW,,,$VMIP,$_gi7,$_gi8,$_gi9,$_gi10,$_gi11,$_gi6,$_gi1,Ubuntu,$_gi2,$_gi3,$_gi4,$_gi5,vagrant,$RANDOMSSHPORT,,$BASE/Output/Pem/op-$CLUSTERNAME.pem,N,N" >> $FINALPROCESSOUTPUT
				#_gi9="" && 
				#{ [[ -z "${_gi8}" ]] && _gi9="$VMIP" || _gi9="${_gi8}"; }
				#IFS='├' read -ra _gi <<< "$ssh_info" && _gi1="${_gi[1]}" && _gi2="${_gi[0]}" && _gi3="${_gi[2]}" && _gi4="${_gi[3]}" && _gi5="${_gi[4]}" && _gi6="${_gi[5]}" && _gi7="${_gi[6]}"                             		
				#echo ",$VMIP,$THISCURRENTMACHINEIP,$_gi7,op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN2,$_gi2,$_gi3,$_gi4,$_gi5,$_gi6,matysa,$RANDOMSSHPORT,$MATSYAPWD," >> $FINALPROCESSOUTPUT
				#CLUSTERNAME2="${CLUSTERNAME#ScopeId}"
				#echo "$CLUSTERNAME2,,onprem,,,,$VMIP,$_gi8,$_gi10,$_gi11,$_gi12,,,,,$_gi7,$_gi1,$_gi2,$_gi3,$_gi4,$_gi5,$_gi6,vagrant,$RANDOMSSHPORT,,$BASE/Output/Pem/op-$CLUSTERNAME.pem" >> $FINALPROCESSOUTPUT 
				    #echo "$_gi13,$_gi14,onprem,$_gi12NEW,,,$VMIP,$_gi7,$_gi8,$_gi9,$_gi10,$_gi11,$_gi6,$_gi1,Ubuntu,$_gi2,$_gi3,$_gi4,$_gi5,vagrant,$RANDOMSSHPORT,,$BASE/Output/Pem/op-$CLUSTERNAME.pem,N,N" | sudo tee -a /home/prathamos/Downloads/log > /dev/null
				    #echo "" | sudo tee -a /home/prathamos/Downloads/log > /dev/null				
			fi
			
			COUNTER=$((COUNTER + 1))						
		done
		COUNTER=0  			  								
	fi
				
	echo ''
	sudo cp $BASE/Resources/Vagrant-VirtualBox-NodeAddTemplate $BASE/op-$CLUSTERNAME-add.sh
	sudo sed -i s#CLUSTERADDTHEBASE#$BASE#g $BASE/op-$CLUSTERNAME-add.sh
	sudo sed -i s#CLUSTERADDTHECLUSTERNAME#$CLUSTERNAME#g $BASE/op-$CLUSTERNAME-add.sh
	sudo sed -i s#CLUSTERADDTHECONFIRMPROCEED#$CONFIRMPROCEED#g $BASE/op-$CLUSTERNAME-add.sh
	sudo sed -i s#CLUSTERADDTHEDEFAULTCONFIG#"$DEFAULTCONFIG"#g $BASE/op-$CLUSTERNAME-add.sh
	sudo sed -i s#CLUSTERADDTHELANTYPE#$LANTYPE#g $BASE/op-$CLUSTERNAME-add.sh
	sudo sed -i s#CLUSTERADDTHENIC#$NIC#g $BASE/op-$CLUSTERNAME-add.sh
	sudo sed -i s#CLUSTERADDTHEGATEWAY#$GATEWAY#g $BASE/op-$CLUSTERNAME-add.sh
	sudo sed -i s#CLUSTERADDTHENETMASK#$NETMASK#g $BASE/op-$CLUSTERNAME-add.sh
	sudo sed -i s#GETTHATIPPART#"${THEIPBASE}"#g $BASE/op-$CLUSTERNAME-add.sh
	sudo sed -i s#CLUSTERADDTHECOORDINATOR#$COORDINATOR#g $BASE/op-$CLUSTERNAME-add.sh
	sudo sed -i s#CLUSTERADDTHERANDOMSSHPORT#$RANDOMSSHPORT#g $BASE/op-$CLUSTERNAME-add.sh
	sudo sed -i s#CLUSTERADDTHEADDTOHOSTSFILE#$ADDTOHOSTSFILE#g $BASE/op-$CLUSTERNAME-add.sh		
	sudo cp $BASE/Resources/Vagrant-VirtualBox-NodeRemoveTemplate $BASE/op-$CLUSTERNAME-remove.sh
	sudo sed -i s#THEBASELOCATION#$BASE#g $BASE/op-$CLUSTERNAME-remove.sh
	sudo sed -i s#THECOORDINATOR#$COORDINATOR#g $BASE/op-$CLUSTERNAME-remove.sh
	sudo sed -i s#THECLUSTERNAME#$CLUSTERNAME#g $BASE/op-$CLUSTERNAME-remove.sh			
	sudo cp $BASE/Resources/Vagrant-VirtualBox-GlobalPushTemplate $BASE/op-$CLUSTERNAME-push.sh
	sudo sed -i s#THEBASELOCATION#$BASE#g $BASE/op-$CLUSTERNAME-push.sh
	sudo sed -i s#THECOORDINATOR#$COORDINATOR#g $BASE/op-$CLUSTERNAME-push.sh
	sudo sed -i s#THECLUSTERNAME#$CLUSTERNAME#g $BASE/op-$CLUSTERNAME-push.sh	
	sudo cp $BASE/Resources/Vagrant-VirtualBox-GlobalExecTemplate $BASE/op-$CLUSTERNAME-exec.sh
	sudo sed -i s#THEBASELOCATION#$BASE#g $BASE/op-$CLUSTERNAME-exec.sh
	sudo sed -i s#THECOORDINATOR#$COORDINATOR#g $BASE/op-$CLUSTERNAME-exec.sh
	sudo sed -i s#THECLUSTERNAME#$CLUSTERNAME#g $BASE/op-$CLUSTERNAME-exec.sh	
	sudo sed -i s#THERANDOMSSHPORT#$RANDOMSSHPORT#g $BASE/op-$CLUSTERNAME-push.sh
	sudo sed -i s#THERANDOMSSHPORT#$RANDOMSSHPORT#g $BASE/op-$CLUSTERNAME-exec.sh			
	sudo touch $BASE/op-$CLUSTERNAME-exec
	sudo touch $BASE/VagVBox/$CLUSTERNAME/.ports
	echo "SSH~$RANDOMSSHPORT" | sudo tee -a $BASE/VagVBox/$CLUSTERNAME/.ports > /dev/null
	sudo chown -R root:root $BASE/op-$CLUSTERNAME-start.sh
	sudo chmod -R u=x,g=,o= $BASE/op-$CLUSTERNAME-start.sh
	sudo chown -R root:root $BASE/op-$CLUSTERNAME-start-pre.sh
	sudo chmod -R u=rwx,g=,o= $BASE/op-$CLUSTERNAME-start-pre.sh	
	sudo chown -R root:root $BASE/op-$CLUSTERNAME-stop.sh
	sudo chmod -R u=x,g=,o= $BASE/op-$CLUSTERNAME-stop.sh
	sudo chown -R root:root $BASE/op-$CLUSTERNAME-stop-post.sh
	sudo chmod -R u=rwx,g=,o= $BASE/op-$CLUSTERNAME-stop-post.sh	
	sudo chown -R root:root $BASE/op-$CLUSTERNAME-kill.sh
	sudo chmod -R u=x,g=,o= $BASE/op-$CLUSTERNAME-kill.sh
	sudo chown -R root:root $BASE/op-$CLUSTERNAME-push.sh
	sudo chmod -R u=x,g=,o= $BASE/op-$CLUSTERNAME-push.sh
	sudo chown -R root:root $BASE/op-$CLUSTERNAME-exec.sh
	sudo chmod -R u=x,g=,o= $BASE/op-$CLUSTERNAME-exec.sh
	sudo chown -R root:root $BASE/op-$CLUSTERNAME-exec
	sudo chmod -R u=rw,g=,o= $BASE/op-$CLUSTERNAME-exec
	sudo chown -R root:root $BASE/op-$CLUSTERNAME-add.sh
	sudo chmod -R u=x,g=,o= $BASE/op-$CLUSTERNAME-add.sh	
	sudo chown -R root:root $BASE/op-$CLUSTERNAME-remove.sh
	sudo chmod -R u=x,g=,o= $BASE/op-$CLUSTERNAME-remove.sh	
	sudo chown -R root:root $BASE/VagVBox/$CLUSTERNAME/.ports
	sudo chmod -R u=r,g=,o= $BASE/VagVBox/$CLUSTERNAME/.ports						
	sudo chmod -R u=r,g=,o= $BASE/Output/Pem/op-$CLUSTERNAME.pem
	sudo chmod -R u=r,g=,o= $BASE/op-$CLUSTERNAME.ppk
	sudo rm -rf $BASE/VagVBox/$CLUSTERNAME/Configs/hosts
	
	echo ''		
	echo '-----------------------'
	echo ''	
	
	sleep 2
	clear
		
	echo -e "${ORANGE}==========================================================${NC}"
	echo -e "${BLUE}${BOLD}\x1b[4mM${NORM}${NC}odular ${BLUE}${BOLD}\x1b[4mA${NORM}${NC}malgamation ${BLUE}${BOLD}\x1b[4mT${NORM}${NC}ransforming ${BLUE}${BOLD}\x1b[4mS${NORM}${NC}ystems ${BLUE}${BOLD}\x1b[4mY${NORM}${NC}ielding ${BLUE}${BOLD}\x1b[4mA${NORM}${NC}gility"
	echo -e "${GREEN}==========================================================${NC}"
	echo ''
	echo -e "\x1b[3mM   M  AAAAA  TTTTT  SSS   Y   Y  AAAAA\x1b[m"
	echo -e "\x1b[3mMM MM  A   A    T   S        Y    A   A\x1b[m"
	echo -e "\x1b[3mM M M  AAAAA    T    SSS     Y    AAAAA\x1b[m"
	echo -e "\x1b[3mM   M  A   A    T       S    Y    A   A\x1b[m"
	echo -e "\x1b[3mM   M  A   A    T   SSSS     Y    A   A\x1b[m"
	echo ''
	echo -e "\x1b[3m\x1b[4mVAGRANT VIRTUALBOX\x1b[m"
	echo ''
	
	echo -e "${RED}-----------------------${NC}"
	echo -e "${RED}${BOLD}\x1b[5mNEW PASSWORDS${NORM}${NC}"
	echo -e "${RED}-----------------------${NC}"
	echo -e "${RED}root    => $ROOTPWD${NC}"
	echo -e "${RED}vagrant => $VAGRANTPWD${NC}"
	echo -e "${RED}ubuntu  => $UBUPWD${NC}"
	echo -e "${RED}matsya  => $MATSYAPWD${NC}"	
	echo -e "${RED}-----------------------${NC}"	
	echo "* $BASE/Output/Pem/op-$CLUSTERNAME.pem
* $BASE/op-$CLUSTERNAME.ppk"
	echo '-----------------------'
	echo "* PASSWORD LOGIN   => sudo sshpass -p \"$VAGRANTPWD\" ssh vagrant@$COORDINATOR -p $RANDOMSSHPORT"
	echo "* SSH KEY LOGIN    => sudo ssh vagrant@$COORDINATOR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\""
	echo "* FILE PUSH        => sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT File_Path_On_Current_System vagrant@$COORDINATOR:/home/vagrant"
	echo "* FILE PULL        => sudo sshpass -p \"$VAGRANTPWD\" scp -P $RANDOMSSHPORT vagrant@$COORDINATOR:/home/vagrant/RequiredFile Location_On_Current_System"
	echo "* EXECUTE          => sudo ssh vagrant@$COORDINATOR -p $RANDOMSSHPORT  -o \"StrictHostKeyChecking=no\" -i \"$BASE/Output/Pem/op-$CLUSTERNAME.pem\" \"echo 'Hello From '\$(hostname)\""		
	echo "* START CLUSTER    => sudo $BASE/op-$CLUSTERNAME-start.sh"	
	echo "* STOP CLUSTER     => sudo $BASE/op-$CLUSTERNAME-stop.sh"
	echo "* ADD NODE         => sudo $BASE/op-$CLUSTERNAME-add.sh"	
	echo "* REMOVE NODE      => sudo $BASE/op-$CLUSTERNAME-remove.sh"	
	echo "* KILL CLUSTER     => sudo $BASE/op-$CLUSTERNAME-kill.sh"
	echo "* GLOBAL FILE PUSH => sudo $BASE/op-$CLUSTERNAME-push.sh I $VAGRANTPWD File_Path_On_Current_System"
	echo "                      {Params - [1] (I)nclude / (E)xclude Coordinator [2] Password For User => vagrant [3] Full Path Of The Required File}"
	echo "* GLOBAL EXECUTE   => sudo $BASE/op-$CLUSTERNAME-exec.sh I $VAGRANTPWD"
	echo "                      {Params - [1] (I)nclude / (E)xclude Coordinator [2] Password For User => vagrant}"
	echo "                      {All Commands To Be Executed Can Be Written In $BASE/op-$CLUSTERNAME-exec File}"							
	echo '-----------------------'		
	echo '' 
	
	if [ "$STACKDEPLOY" == "1" ] || [ "$STACKDEPLOY" == "1" ] ; then
		cat $BASE/tmp/$THEUNIQUETHISRUNGUID/$SPARKSTACKDEPLOYINFO 		
	fi
		
	WHENJOBFIN=$(echo $(date +%H):$(date +%M))
	SEC1=`date +%s -d ${WHENJOBBEGAN}`
	SEC2=`date +%s -d ${WHENJOBFIN}`
	DIFFSEC=`expr ${SEC2} - ${SEC1}`
	THETOTALTIMETAKEN=$(echo `date +%M -ud @${DIFFSEC}`)
	echo "Total Time Taken => $THETOTALTIMETAKEN Minutes"	
	echo ''			
	echo "=============================================================================="
	echo ''
	if [ "$CONFIRMFILETOCREATE" == "" ] || [ "$CONFIRMFILETOCREATE" == "" ] ; then
		ABC="XYZ"
	else
		echo "$CONFIRMFILETOCREATE" | sudo tee -a $BASE/VagVBox/$CLUSTERNAME/$CONFIRMFILETOCREATE > /dev/null
	fi
	
	for bla in "${LISTOFALLPORTS[@]}"
	do
		echo $bla
	done
		
	if [ $OPENTERMINALS == "y" ] || [ $OPENTERMINALS == "Y" ] ; then
		sudo rm -f /root/.config/terminator/config
		if [ "$STACKDEPLOY" == "1" ] || [ "$STACKDEPLOY" == "1" ] ; then
		sudo cp $BASE/tmp/$THEUNIQUETHISRUNGUID/$TERMINATORCONFIG /root/.config/terminator/config
		fi
		sudo chown root:root /root/.config/terminator/config
		sudo chmod -R u=rw,g=rw,o=r /root/.config/terminator/config
		sudo rm -rf $BASE/tmp/$THEUNIQUETHISRUNGUID		
		sudo terminator &
	fi
	
	sudo rm -rf $BASE/tmp/$THEUNIQUETHISRUNGUID
	
	if [ "$FINALOUTPUTREQ" == "YES" ] ; then
		sudo -H -u root bash -c "pushd $BASE/VagVBox/$CLUSTERNAME/Configs/$THEACTUALNAMEOFTHECOORDINATOR && sudo vagrant halt && popd"
		sudo -H -u root bash -c "pushd $BASE/VagVBox/$CLUSTERNAME/Configs/$THEACTUALNAMEOFTHECOORDINATOR && sudo vagrant destroy -f && popd"
		sudo chmod 777 $BASE/op-$CLUSTERNAME-kill-opvvb.sh
		sudo $BASE/op-$CLUSTERNAME-kill-opvvb.sh
		sudo rm -rf $BASE/op-$CLUSTERNAME-kill-opvvb.sh
		sudo chmod -R 777 $BASE/VagVBox/$CLUSTERNAME
		sudo chmod 400 $BASE/Output/Pem/op-$CLUSTERNAME.pem
		sudo chown $CURRENTUSER:$CURRENTUSER $BASE/Output/Pem/op-$CLUSTERNAME.pem
		#IP_ADDRESS_HYPHEN9=${THISCURRENTMACHINEIP//./-}
		#sudo mv $BASE/Output/Pem/op-$CLUSTERNAME.pem $BASE/Output/Pem/op-$CLUSTERNAME-$IP_ADDRESS_HYPHEN9.pem
		sudo rm -rf $BASE/VagVBox/$CLUSTERNAME/.ports
		#sudo rm -rf $BASE/VagVBox/$CLUSTERNAME/Keys/id_rsa.pub
		sudo rm -rf $BASE/Output/Pem/op-$CLUSTERNAME.pub
		if [ "$ISSAMEASHOST" == "NO" ] ; then
			sudo chmod -R 777 $BASE/Secrets
			RANDOMFILENAME=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)				
			sudo cp $BASE/Output/Pem/op-$CLUSTERNAME.pem $BASE/Secrets/$RANDOMFILENAME
			sudo chown $CURRENTUSER:$CURRENTUSER $BASE/Secrets/$RANDOMFILENAME
			sudo chmod u=rwx,g=rwx,o=rwx $BASE/Secrets/$RANDOMFILENAME
			ITER=${THEREALVISIONKEY:7:6}
			openssl enc -a -aes-256-cbc -pbkdf2 -iter $ITER -in $BASE/Secrets/$RANDOMFILENAME -out $BASE/Secrets/".$RANDOMFILENAME" -k $THEREALVISIONKEY
			sudo chown $CURRENTUSER:$CURRENTUSER $BASE/Secrets/".$RANDOMFILENAME"
			sudo chmod u=rwx,g=rwx,o=rwx $BASE/Secrets/".$RANDOMFILENAME"
			sudo rm -rf $BASE/Secrets/$RANDOMFILENAME
			sudo mv $BASE/Secrets/".$RANDOMFILENAME" $BASE/Output/Pem/op-$CLUSTERNAME.peme
			sudo chmod u=rwx,g=rwx,o=rwx $BASE/Output/Pem/op-$CLUSTERNAME.peme								
			sudo rm -rf /root/.bash_history
			sudo rm -rf /home/$CURRENTUSER/.bash_history
						
			sudo rm -rf $BASE/Output/Pem/op-$CLUSTERNAME.pem
		fi
		sudo rm -rf $BASE/VagVBox/$CLUSTERNAME/Configs/$THEACTUALNAMEOFTHECOORDINATOR
		sudo rm -rf $BASE/Output/$CLUSTERNAME-CDR
		echo ""
		$BASE/Scripts/BashTabularPrint.sh "$FINALPROCESSOUTPUT■-1■,"
		echo ""	
		sudo rm -rf $BASE/tmp/$CLUSTERNAME-JOBLOG1.out
		sudo rm -rf $BASE/tmp/$CLUSTERNAME-JOBLOG2.out
		sudo rm -rf $BASE/tmp/$CLUSTERNAME-JOBLOG3.out		
	else
		sudo rm -rf $BASE/op-$CLUSTERNAME-kill-opvvb.sh
	fi	
else
	echo "Exiting For Now..."
	echo ''
	sudo rm -rf $BASE/tmp/$THEUNIQUETHISRUNGUID
	exit
fi			

