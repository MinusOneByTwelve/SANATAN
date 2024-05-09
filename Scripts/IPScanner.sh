#!/bin/bash

CURRENTUSER=$(whoami)
sudo rm -rf /home/$CURRENTUSER/.ssh/known_hosts
sudo rm -rf /root/.ssh/known_hosts

USERINTERACTION="YES"
USERVALS=""
MANUALRUN="NO"

# Define the NIC (Network Interface Controller)
nic="test"
seqstart=0
seqend=0

if [ $# -eq 0 ]; then
	USERVALS=""
else
	USERVALS=$1
	USERINTERACTION="NO"
	IFS='■' read -r -a USERLISTVALS <<< $USERVALS
	nic="${USERLISTVALS[0]}"
	seqstart="${USERLISTVALS[1]}"	
	seqend="${USERLISTVALS[2]}"
	num_ips="${USERLISTVALS[3]}"
	wheretowriteresult="${USERLISTVALS[4]}"	
	ip_type="random"					
fi

# Get the network address and subnet mask
network_info=$(ip -o -f inet addr show $nic | awk '$3 == "inet" {print $4}')
network=$(echo "$network_info" | cut -d '/' -f 1)
subnet_mask=$(echo "$network_info" | cut -d '/' -f 2)

# Calculate network address
network_address=$(ipcalc -n "$network" "$subnet_mask" | awk '/Network/ {print $2}')
network_address=$(echo "$network_address" | cut -d '/' -f 1)
broadcast_address=$(ipcalc -b "$network" "$subnet_mask" | awk '/Broadcast/ {print $2}')
ip_prefix=$(echo "$network_address" | cut -d '.' -f 1-3)

# Get the router's IP address
router_ip=$(ip route | awk '/default/ {print $3}')

# Create an array to store free IPs
FreeIPS=()

# Function to display a progress bar
function show_progress() {
    local current=$1
    local total=$2
    local width=50
    local progress=$((current * width / total))
    printf "["
    printf "%-${progress}s" ">"
    printf "%-$((width - progress))s" "]"
    printf " %d%% (%d/%d)\r" "$((current * 100 / total))" "$current" "$total"
}

# Loop through the IP range to find free IPs
total_ips=$seqend
current_ip=$seqstart
for ip in $(seq $seqstart $seqend); do
    current_ip=$((current_ip + 1))
    if [ "$USERINTERACTION" == "YES" ] || [ "$USERINTERACTION" == "yes" ] ; then
    	show_progress "$current_ip" "$total_ips"
    fi
    current_ip_address="$ip_prefix.$ip"
    # Exclude network and broadcast addresses
    if [ "$current_ip_address" != "$network" ] && [ "$current_ip_address" != "$network_address" ] && [ "$current_ip_address" != "$broadcast_address" ] && [ "$current_ip_address" != "$router_ip" ]; then
        # Ping the IP address
        if ! ping -c 1 -W 1 "$current_ip_address" >/dev/null 2>&1; then
            # If ping fails, IP address is free
            FreeIPS+=("$current_ip_address")
        fi
    fi
done

if [ "$USERINTERACTION" == "YES" ] || [ "$USERINTERACTION" == "yes" ] ; then
# Print a new line to clear the progress bar
echo ""
fi
# Print the list of free IPs
#echo "List of Free IPs (except network and broadcast IP addresses):"
#for ip in "${FreeIPS[@]}"; do
#    echo "$ip"
#done

# Function to validate numeric input
function validate_numeric() {
    local input=$1
    if ! [[ "$input" =~ ^[0-9]+$ ]]; then
        echo "Error: Not a valid number."
        exit 1
    fi
}

# Function to validate IP choice
function validate_ip_choice() {
    local choice_=$1
    local choice="$ip_prefix.$choice_"
    if ! [[ " ${FreeIPS[@]} " =~ " $choice " ]]; then
        echo "Error: IP not found in the list of free IPs."
        exit 1
    fi
}

if [ "$USERINTERACTION" == "YES" ] || [ "$USERINTERACTION" == "yes" ] ; then
# Ask the user for the number of IPs required
read -p "Enter the number of IPs required: " num_ips
validate_numeric "$num_ips"

# Ask the user for the type of IPs (range or random)
read -p "Enter 'range' if IPs should be in a range, or 'random' for random IPs: " ip_type
if [ "$ip_type" != "range" ] && [ "$ip_type" != "random" ]; then
    echo "Error: Invalid choice. Please enter 'range' or 'random'."
    exit 1
fi
fi

FINALIPS=()

if [ "$ip_type" == "range" ]; then
    # Ask the user for the starting and ending IPs
    read -p "Enter the starting IP: " start_ip
    validate_numeric "$start_ip"  
    validate_ip_choice "$start_ip"
    result=$((num_ips + start_ip))
    result=$((result - 1))      
    read -p "Enter the ending IP: " -e -i "$result" end_ip
    validate_numeric "$end_ip"
    validate_ip_choice "$end_ip"

    # Generate IPs in range
    #for ip in $(seq -f "%d" $start_ip $end_ip); do
    #    echo $ip
    #    if [[ " ${FreeIPS[@]} " =~ " $ip " ]]; then
     #       # Ping the IP address
    #        #if ping -c 1 -W 1 "$ip" >/dev/null 2>&1; then
     #       if ! ping -c 1 -W 1 "$ip" >/dev/null 2>&1; then
     #           FINALIPS+=("$ip")
     #       fi
     #   fi
    #done
	# Generate IPs in range
	for ((ip = start_ip; ip <= end_ip; ip++)); do
	    # Check if the IP is in the list of free IPs
	    if [[ " ${FreeIPS[@]} " =~ " $ip_prefix.$ip " ]]; then
		# Ping the IP address
		#if ping -c 1 -W 1 "$ip" >/dev/null 2>&1; then
		if ! ping -c 1 -W 1 "$ip" >/dev/null 2>&1; then
		    FINALIPS+=("$ip_prefix.$ip")
		fi
	    fi
	done    
else
    # Generate random IPs
    for ((i = 0; i < num_ips; i++)); do
        random_index=$((RANDOM % ${#FreeIPS[@]}))
        #echo $random_index
        random_ip="${FreeIPS[$random_index]}"
        #echo $random_ip
        # Ping the IP address
        #if ping -c 1 -W 1 "$random_ip" >/dev/null 2>&1; then
        if ! ping -c 1 -W 1 "$random_ip" >/dev/null 2>&1; then
            FINALIPS+=("$random_ip")
        fi
    done
fi

if [ "$USERINTERACTION" == "YES" ] || [ "$USERINTERACTION" == "yes" ] ; then
	# Print the list of final IPs
	echo "Final list of IPs after checking ping:"
	for ip in "${FINALIPS[@]}"; do
	    echo "$ip"
	done
else
	#clear
	IPAsString=$(IFS=,; echo "${FINALIPS[*]}")
	#echo "$IPAsString"
	echo "$IPAsString" | sudo tee $wheretowriteresult > /dev/null && sudo chmod 777 $wheretowriteresult
fi

