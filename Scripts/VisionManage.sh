#!/bin/bash

set -e

clear

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
echo -e "\x1b[3m\x1b[4mVision Manage\x1b[m"
echo ''

files=$(find $BASE/Output/ -maxdepth 1 -type f -name "VISION*.json" | sort)

if [ -z "$files" ]; then
    echo "Nothing Yet Created"
    echo ''
    exit 1
fi

echo "$STACKLINELENGTHY"
index=1
for file in $files; do
    varb=$(basename "$file")
    varbresult="${varb#VISION_}"
    varbresult="${varbresult%.json}"
    echo -e "${BOLD}$index. $varbresult${NORM}"
    ((index++))
done
echo "$STACKLINELENGTHY"
echo ''

((index--))

if [ "$#" -ne 1 ]; then
	USERVALS=""
else
	USERVALS=$1
	USERINTERACTION="NO"
	IFS='¬' read -r -a USERLISTVALS <<< $USERVALS
	selection="${USERLISTVALS[0]}"
	SECRETTHEKEY="${USERLISTVALS[1]}"
	THEACTIONCHOICE="${USERLISTVALS[2]}"					
fi

if [ "$USERINTERACTION" == "YES" ] || [ "$USERINTERACTION" == "yes" ] ; then
	read -p "Enter Number 				> " -e -i "1" selection
	echo ''
fi
	
if ! [[ "$selection" =~ ^[1-9][0-9]*$ && "$selection" -le "$index" ]]; then
    echo "Invalid Input"
    echo ''
    exit 1
fi	
	
NODES__JSON=$(echo "$files" | sed -n "${selection}p")	
	
if [ ! -f "$NODES__JSON" ]; then
    echo "Error: No File : $NODES__JSON"
    echo ''
    exit 1
fi

if [ "$USERINTERACTION" == "YES" ] || [ "$USERINTERACTION" == "yes" ] ; then
	read -s -p "Secrets File Key 			> " -e -i "" SECRETTHEKEY
	echo ''
	echo ''
fi

ITER=${SECRETTHEKEY:7:6}

RANDOMSECFILENAME=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
sudo cp $NODES__JSON $BASE/tmp/$RANDOMSECFILENAME
sudo chown $CURRENTUSER:$CURRENTUSER $BASE/tmp/$RANDOMSECFILENAME
sudo chmod u=r,g=,o= $BASE/tmp/$RANDOMSECFILENAME
REALSECRETSFILENAME=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)
openssl enc -a -d -aes-256-cbc -pbkdf2 -iter $ITER -k $SECRETTHEKEY -in $BASE/tmp/$RANDOMSECFILENAME -out $BASE/tmp/$REALSECRETSFILENAME
sudo chown $CURRENTUSER:$CURRENTUSER $BASE/tmp/$REALSECRETSFILENAME
sudo chmod u=r,g=,o= $BASE/tmp/$REALSECRETSFILENAME

THEVISIONDETAILS=$(jq '.' "$BASE/tmp/$REALSECRETSFILENAME")

if [ $? -ne 0 ]; then
    echo "Error: Failed Parsing"
    echo ''
    sudo rm -rf $BASE/tmp/$REALSECRETSFILENAME				
    sudo rm -rf $BASE/tmp/$RANDOMSECFILENAME    
    exit 1
fi

THEACTUALSECRETS=$(<$BASE/tmp/$REALSECRETSFILENAME)	

sudo rm -rf $BASE/tmp/$REALSECRETSFILENAME				
sudo rm -rf $BASE/tmp/$RANDOMSECFILENAME

AllScopes=$(echo $THEACTUALSECRETS | jq -r '.Vision.Scope[] | select(.Name != null) | .Name' | tr '\n' ',' | sed 's/,$//')

extract_actions() {
    local level_name=$1
    local level_data=$2
    local parent_name=$3

    if [ -n "$level_data" ] && [ "$level_data" != "null" ]; then
        local actions=$(echo "$level_data" | jq -c '.Action[]' || echo "null")
        if [ "$actions" != "null" ]; then
            while IFS= read -r action; do
                action=$(echo "$action" | tr -d '"')
                action_array+=("$level_name┼$parent_name┼$action")
            done <<< "$actions"
        fi
    fi
}

action_array=()

vision_name=$(echo "$THEACTUALSECRETS" | jq -r '.Vision.Name')
varbresult="${vision_name#VISION_}"
varbresult="${varbresult%.json}"
vision_actions=$(echo "$THEACTUALSECRETS" | jq -c '.Vision.Action[]' || echo "null")
if [ "$vision_actions" != "null" ]; then
    action_array+=("Header┼Vision┼$varbresult")
    while IFS= read -r action; do
        action=$(echo "$action" | tr -d '"')
        action_array+=("Vision┼$vision_name┼$action")
    done <<< "$vision_actions"
fi

if [ -n "$(echo "$THEACTUALSECRETS" | jq -c '.Vision.Scope')" ]; then
    scopes=$(echo "$THEACTUALSECRETS" | jq -c '.Vision.Scope[]' || echo "null")
    if [ "$scopes" != "null" ]; then
        while IFS= read -r scope; do
            scope_name=$(echo "$scope" | jq -r '.Name')
            if [ "$scope_name" != "null" ]; then
                action_array+=("Header┼Scope┼$scope_name")
                extract_actions "Scope" "$scope" "$scope_name"
                
                identities=$(echo "$scope" | jq -c '.Identity[]' || echo "null")
                if [ "$identities" != "null" ]; then
                    while IFS= read -r identity; do
                        identity_name=$(echo "$identity" | jq -r '.Name')
                        identity_ip=$(echo "$identity" | jq -r '.IP')
                        if [ "$identity_name" != "null" ]; then
                            action_array+=("Header┼Identity┼$identity_name [ $identity_ip ]")
                            extract_actions "Identity" "$identity" "$identity_name┴$identity_name [ $identity_ip ]"
                        fi
                    done <<< "$identities"
                fi
            fi
        done <<< "$scopes"
    fi
fi

echo "$STACKLINELENGTHY"
OVERALLCOUNTER=1
ACTION_LIST=()
for item in "${action_array[@]}"; do
	IFS='┼' read -r -a USERLISTvarXVALS <<< $item
	varX1="${USERLISTvarXVALS[0]}" 
	varX2="${USERLISTvarXVALS[1]}"
	spaces=""
	realitem="${USERLISTvarXVALS[2]}"
	varX3="${USERLISTvarXVALS[2]}"
	if [ "$varX1" == "Header" ] ; then
		if [ "$varX2" == "Vision" ] ; then
			spaces="${ORANGE}${BOLD}"
		fi
		if [ "$varX2" == "Scope" ] ; then
			spaces="${LBLUE}${BOLD}    • "
		fi
		if [ "$varX2" == "Identity" ] ; then
			spaces="${GREEN}${BOLD}        • "
		fi
		realitem="${USERLISTvarXVALS[2]}"" ($varX2)"				
	fi 
	if [ "$varX1" == "Vision" ] ; then
		spaces="    • "
		realitem="${USERLISTvarXVALS[2]}"" ${PINK}${BOLD}($OVERALLCOUNTER)"
		ACTION_LIST+=("$OVERALLCOUNTER┼$varX1├$varX2├$varX3")
		OVERALLCOUNTER=$((OVERALLCOUNTER + 1))
	fi 
	if [ "$varX1" == "Scope" ] ; then
		spaces="        • "
		realitem="${USERLISTvarXVALS[2]}"" \e[1;93m${BOLD}($OVERALLCOUNTER)"
		ACTION_LIST+=("$OVERALLCOUNTER┼$varX1├$varX2├$varX3")
		OVERALLCOUNTER=$((OVERALLCOUNTER + 1))
	fi 
	if [ "$varX1" == "Identity" ] ; then
		spaces="            • "
		realitem="${USERLISTvarXVALS[2]}"" ${PURPLE}${BOLD}($OVERALLCOUNTER)"
		IFS='┴' read -r -a var_X2 <<< $varX2
		var__X2="${var_X2[0]}" 
		ACTION_LIST+=("$OVERALLCOUNTER┼$varX1├$var__X2├$varX3")
		OVERALLCOUNTER=$((OVERALLCOUNTER + 1))
	fi 
	echo -e "$spaces""$realitem${NORM}${NC}"			 
done
echo "$STACKLINELENGTHY"
echo ''

create_scope_identity_combination() {
    local scope_name=$1
    local scope_data=$2

    local scope_identity_combination=""
    if [ -n "$scope_data" ] && [ "$scope_data" != "null" ]; then
        local identities=$(echo "$scope_data" | jq -c '.Identity[]' || echo "null")
        if [ "$identities" != "null" ]; then
            while IFS= read -r identity; do
                local attribute=$(echo "$identity" | jq -r '.Attribute')
                local info=$(echo "$identity" | jq -r '.Info')
                local thetype=$(echo "$identity" | jq -r '.Type') 
                local identity_string="$attribute┼$info┼$thetype"
                if [ "$info" != "null" ]; then
                	if [ -n "$scope_identity_combination" ]; then
                    		scope_identity_combination+="├""$identity_string"
                	else
                    		scope_identity_combination="$identity_string"
                	fi
                fi
            done <<< "$identities"
        fi
    fi
    scope_name+="┘"
    scope_name+="$scope_identity_combination"
    scope_identity_array+=("$scope_name")
}

scope_identity_array=()

if [ -n "$(echo "$THEACTUALSECRETS" | jq -c '.Vision.Scope')" ]; then
    scopes=$(echo "$THEACTUALSECRETS" | jq -c '.Vision.Scope[]' || echo "null")
    if [ "$scopes" != "null" ]; then
        while IFS= read -r scope; do
            scope_name=$(echo "$scope" | jq -r '.Name')
            scope_info=$(echo "$scope" | jq -r '.Info')
            scope_thetype=$(echo "$scope" | jq -r '.Type')
            if [ "$scope_name" != "null" ]; then
                create_scope_identity_combination "$scope_name""┴""$scope_info""■""$scope_thetype" "$scope"
            fi
        done <<< "$scopes"
    fi
fi

identity_array=()

create_identity_array() {
    local scope_data=$1
    local scope_name=$2

    if [ -n "$scope_data" ] && [ "$scope_data" != "null" ]; then
        local identities=$(echo "$scope_data" | jq -c '.Identity[]' || echo "null")
        if [ "$identities" != "null" ]; then
            while IFS= read -r identity; do
                local attribute=$(echo "$identity" | jq -r '.Attribute')
                local info=$(echo "$identity" | jq -r '.Info')
                local thetype=$(echo "$identity" | jq -r '.Type')                
                local name=$(echo "$identity" | jq -r '.Name')
                if [ "$name" != "null" ]; then
                    local identity_string="$attribute┼$info┼$thetype"
                    identity_array+=("$name┘$identity_string")
                fi
            done <<< "$identities"
        fi
    fi
}

if [ -n "$(echo "$THEACTUALSECRETS" | jq -c '.Vision.Scope')" ]; then
    scopes=$(echo "$THEACTUALSECRETS" | jq -c '.Vision.Scope[]' || echo "null")
    if [ "$scopes" != "null" ]; then
        while IFS= read -r scope; do
            scope_name=$(echo "$scope" | jq -r '.Name')
            if [ "$scope_name" != "null" ]; then
                create_identity_array "$scope" "$scope_name"
            fi
        done <<< "$scopes"
    fi
fi

scope_array=()

create_scope_array() {
    local scope_data=$1

    if [ -n "$scope_data" ] && [ "$scope_data" != "null" ]; then
        local name=$(echo "$scope_data" | jq -r '.Name')
        local info=$(echo "$scope_data" | jq -r '.Info')
        local type=$(echo "$scope_data" | jq -r '.Type')

        if [ "$name" != "null" ] && [ "$info" != "null" ] && [ "$type" != "null" ]; then
            local scope_info="$name■$info┼$type"
            scope_array+=("$scope_info")
        fi
    fi
}

if [ -n "$(echo "$THEACTUALSECRETS" | jq -c '.Vision.Scope')" ]; then
    scopes=$(echo "$THEACTUALSECRETS" | jq -c '.Vision.Scope[]' || echo "null")
    if [ "$scopes" != "null" ]; then
        while IFS= read -r scope; do
            create_scope_array "$scope"
        done <<< "$scopes"
    fi
fi

scope_array_result=$(printf '¶%s' "${scope_array[@]}") && scope_array_result=${scope_array_result#¶}  

attribute_array=()
while read -r attribute; do
    if [ "$attribute" != "null" ]; then
        attribute_array+=("$attribute")
    fi
done < <(jq -r '.Vision.Scope[]?.Identity[]? | select(.Name != null) | .Attribute' <<< "$THEACTUALSECRETS")

attribute_string=$(IFS="¶"; echo "${attribute_array[*]}")

MAPPED_ACTION_LIST=()
for item in "${ACTION_LIST[@]}"; do
	IFS='┼' read -r -a USERLISTvarXVALS <<< $item
	varX1="${USERLISTvarXVALS[0]}" 
	varX2="${USERLISTvarXVALS[1]}"
	IFS='├' read -r -a _varX2 <<< $varX2
	_varX21="${_varX2[0]}" 
	_varX22="${_varX2[2]}"
	_varX23="${_varX2[1]}" 		

	if [ "$_varX21" == "Vision" ] && [ "$_varX22" == "DELETE" ]; then
		MAPPED_ACTION_LIST+=("$itemº$scope_array_result")
	fi
	if [ "$_varX21" == "Vision" ] && [ "$_varX22" == "SCOPEADD" ]; then
		MAPPED_ACTION_LIST+=("$itemº$SECRETTHEKEY")
	fi
	if [ "$_varX21" == "Vision" ] && [ "$_varX22" == "RUNSCRIPT" ]; then
		MAPPED_ACTION_LIST+=("$itemº$attribute_string")
	fi
	if [ "$_varX21" == "Vision" ] && [ "$_varX22" == "LOADFILE" ]; then
		MAPPED_ACTION_LIST+=("$itemº$attribute_string")
	fi
	
	if [ "$_varX21" == "Scope" ] && [ "$_varX22" == "DELETE" ]; then
		find_occur=$(echo "${scope_identity_array[@]}" | awk '{for(i=1;i<=NF;i++) if($i ~ /^'"$_varX23┴"'/) {print $i; exit}}')
		MAPPED_ACTION_LIST+=("$itemº$find_occur")
	fi
	if [ "$_varX21" == "Scope" ] && [ "$_varX22" == "IDENTITYADD" ]; then
		find_occur=$(echo "${scope_identity_array[@]}" | awk '{for(i=1;i<=NF;i++) if($i ~ /^'"$_varX23┴"'/) {print $i; exit}}')
		MAPPED_ACTION_LIST+=("$itemº$find_occur")
	fi
	if [ "$_varX21" == "Scope" ] && [ "$_varX22" == "RUNSCRIPT" ]; then
		find_occur=$(echo "${scope_identity_array[@]}" | awk '{for(i=1;i<=NF;i++) if($i ~ /^'"$_varX23┴"'/) {print $i; exit}}')
		MAPPED_ACTION_LIST+=("$itemº$find_occur")
	fi
	if [ "$_varX21" == "Scope" ] && [ "$_varX22" == "LOADFILE" ]; then
		find_occur=$(echo "${scope_identity_array[@]}" | awk '{for(i=1;i<=NF;i++) if($i ~ /^'"$_varX23┴"'/) {print $i; exit}}')
		MAPPED_ACTION_LIST+=("$itemº$find_occur")
	fi
	
	if [ "$_varX21" == "Identity" ] && [ "$_varX22" == "DELETE" ]; then
		find_occur=$(echo "${identity_array[@]}" | awk '{for(i=1;i<=NF;i++) if($i ~ /^'"$_varX23┘"'/) {print $i; exit}}')
		MAPPED_ACTION_LIST+=("$itemº$find_occur")
	fi
	if [ "$_varX21" == "Identity" ] && [ "$_varX22" == "RUNSCRIPT" ]; then
		find_occur=$(echo "${identity_array[@]}" | awk '{for(i=1;i<=NF;i++) if($i ~ /^'"$_varX23┘"'/) {print $i; exit}}')
		MAPPED_ACTION_LIST+=("$itemº$find_occur")
	fi
	if [ "$_varX21" == "Identity" ] && [ "$_varX22" == "LOADFILE" ]; then
		find_occur=$(echo "${identity_array[@]}" | awk '{for(i=1;i<=NF;i++) if($i ~ /^'"$_varX23┘"'/) {print $i; exit}}')
		MAPPED_ACTION_LIST+=("$itemº$find_occur")
	fi					
done

if [ "$USERINTERACTION" == "YES" ] || [ "$USERINTERACTION" == "yes" ] ; then
	read -p "Enter Action 				> " -e -i "0" actionselect
	echo ''
else	
	for MAPPED_ACTION in "${MAPPED_ACTION_LIST[@]}"; do
		IFS='┼' read -r -a _MAPPED_ACTION <<< $MAPPED_ACTION
		_MAPPED_ACTION1="${_MAPPED_ACTION[0]}" 
		_MAPPED_ACTION2="${_MAPPED_ACTION[1]}"
		#echo $_MAPPED_ACTION1
		#echo $_MAPPED_ACTION2
		if [[ "$_MAPPED_ACTION2" == $THEACTIONCHOICE* ]]; then
			actionselect="$_MAPPED_ACTION1"
			break
		fi
	done	
fi
#echo 1$actionselect
#echo 2$THEACTIONCHOICE
#exit
((OVERALLCOUNTER--))

if ! [[ "$actionselect" =~ ^[1-9][0-9]*$ && "$actionselect" -le "$OVERALLCOUNTER" ]]; then
    echo "Invalid Input"
    echo ''
    exit 1
fi

find_occur=$(echo "${MAPPED_ACTION_LIST[@]}" | awk '{for(i=1;i<=NF;i++) if($i ~ /^'"$actionselect┼"'/) {print $i; exit}}')
#echo $find_occur

IFS="º" read -ra INPUT <<< "$find_occur"
TEMP1="${INPUT[0]}"
IFS="┼" read -ra TEMP2 <<< "$TEMP1"
_INPUT1="${TEMP2[1]}"
IFS="├" read -ra INPUT_1 <<< "$_INPUT1"
INPUT_1_="${INPUT_1[0]}"
INPUT_1__="${INPUT_1[2]}"
THECHOICE="$INPUT_1_""_""$INPUT_1__"

#echo "$THECHOICE" 
#exit

$BASE/Scripts/ActionRUN.sh "$THECHOICE" "$find_occur"

echo ''

