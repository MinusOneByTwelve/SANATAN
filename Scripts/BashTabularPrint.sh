#!/bin/bash

IFS="■" read -ra REQPRM <<< "$1"
FILE="${REQPRM[0]}"
NOOFROWS="${REQPRM[1]}"
IFVALS="${REQPRM[2]}"
# Define the file path
#FILE="/opt/Matsya/tmp/v2XDdX.csv"

# Variable that controls the number of rows to display
#NOOFROWS="-1"  # Set this to -1 to display all rows, or to any positive integer to display that many rows

# Read the header line from the file and create an array of headers
IFS=''"$IFVALS"'' read -r -a headers < "$FILE"

# Initialize an array to hold the maximum length of each column
max_lengths=()
for header in "${headers[@]}"; do
    max_lengths+=(${#header})
done

# Adjust the data processing according to NOOFROWS
if [[ "$NOOFROWS" -eq -1 ]]; then
    # Read all lines if NOOFROWS is -1
    data_lines=$(tail -n +2 "$FILE")
else
    # Read only the first NOOFROWS lines if NOOFROWS is a positive integer
    data_lines=$(tail -n +2 "$FILE" | head -n "$NOOFROWS")
fi

# Calculate max column widths from the data lines
while IFS=''"$IFVALS"'' read -r -a line; do
    for i in "${!line[@]}"; do
        current_length=${#line[$i]}
        if [[ $current_length -gt ${max_lengths[$i]} ]]; then
            max_lengths[$i]=$current_length
        fi
    done
done <<< "$data_lines"

# Function to print horizontal line separator
print_separator() {
    echo -n "+"
    for length in "${max_lengths[@]}"; do
        printf "%0.s-" $(seq 1 $((length + 2)))  # +2 for padding around text
        echo -n "+"
    done
    echo
}

# Print the top border of the table
print_separator

# Print the headers with appropriate spacing
echo -n "|"
for i in "${!headers[@]}"; do
    printf " %-*s |" "${max_lengths[$i]}" "${headers[$i]}"
done
echo

# Print line after headers
print_separator

# Print each line from the processed data
while IFS=''"$IFVALS"'' read -r -a line; do
    echo -n "|"
    for i in "${!headers[@]}"; do  # Iterate based on header count
        if [ -z "${line[$i]}" ]; then  # Check for empty field
            printf " %-*s |" "${max_lengths[$i]}" ""
        else
            printf " %-*s |" "${max_lengths[$i]}" "${line[$i]}"
        fi
    done
    echo
done <<< "$data_lines"

# Print the bottom border of the table
print_separator

