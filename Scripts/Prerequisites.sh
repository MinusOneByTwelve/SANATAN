#!/bin/bash

# Directories with executables
dirs=("/usr/local/bin" "/usr/local/sbin" "/usr/bin" "/usr/sbin")

# Directory with files to search in
search_dir="/opt/Matsya/Scripts"

# Array to hold the distinct commands found
declare -A distinct_commands

# Loop over each directory
for dir in "${dirs[@]}"; do
    # Get all executable names from the directory
    commands=$(ls "$dir")

    # Loop over each file in the directory
    for file in "$search_dir"/*; do
        #echo "Processing $file..."

        # Read the file line by line
        while IFS= read -r line
        do
            # For each executable
            for cmd in $commands
            do
                # If the line contains the executable and the command is alphanumeric
                if [[ $line == *"$cmd"* ]] && [[ $cmd =~ ^[a-zA-Z0-9_]+$ ]]; then
                    # Add the command to the array of distinct commands
                    distinct_commands["$cmd"]=1
                fi
            done
        done < "$file"
    done
done

# Print the distinct commands, sorted by name
#echo "Distinct commands found:"
#for cmd in $(echo "${!distinct_commands[@]}" | tr ' ' '\n' | sort -u); do
#    echo "$cmd"
#done

# New array for commands installable via apt-get
instarr=()
sysarr=()
# Loop over the original array
#for cmd in "${distinct_commands[@]}"; do
for cmd in $(echo "${!distinct_commands[@]}" | tr ' ' '\n' | sort -u); do
    # Check if the command is available via apt-get
    apt_result=$(apt-cache search "^${cmd}$")

    # If the command is available via apt-get, add it to the new array
    if [[ $apt_result == *"$cmd"* ]]; then
        instarr+=("$cmd")
    else
        sysarr+=("$cmd")
    fi
done

# Array of blacklisted commands (example)
avoidarr=("sudo" "tar")

# New array for filtered commands
filteredarr=()

# Loop over the instarr array
for cmd in "${instarr[@]}"; do
    # If cmd is not in avoidarr, add it to filteredarr
    if [[ ! " ${avoidarr[@]} " =~ " ${cmd} " ]]; then
        filteredarr+=("$cmd")
    fi
done

clear
echo "====================================================================================="
# Print the new array
echo "Commands custom                                         : ${instarr[@]}" && echo ""
# Print the new array
echo "Commands installable via apt-get : sudo apt-get install ${filteredarr[@]}" && echo ""
# Print the system array
echo "Commands available in ubuntu                            : ${sysarr[@]}" && echo "====================================================================================="
echo ""

#sudo apt-get -y install ant curl git ipcalc ipset iptables jq mc nano nmap openssl parallel pv socat ssh sshpass ufw wget

