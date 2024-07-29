#!/bin/bash

# Define variables
LOG_DIR="$1"
FILE_PREFIX="$2"
TMUX_SESSION="LogMonitor$FILE_PREFIX"

# Function to add new logs to the tmux session
add_new_logs() {
    local existing_logs=$(tmux list-windows -t $TMUX_SESSION -F '#W' | grep "^$FILE_PREFIX")

    for file in $(find $LOG_DIR -type f -name "${FILE_PREFIX}*"); do
        local filename=$(basename "$file")
        if ! echo "$existing_logs" | grep -q "^$filename$"; then
            tmux new-window -t $TMUX_SESSION -n "$filename" "tail -f '$file'"
            existing_logs="$existing_logs\n$filename"
        fi
    done
}

# Check if tmux session already exists
if ! tmux has-session -t $TMUX_SESSION 2>/dev/null; then
    # Create a new tmux session
    tmux new-session -d -s $TMUX_SESSION
fi

# Add initial log files
add_new_logs

# Periodically check for new log files and add them
while true; do
    add_new_logs
    sleep 30
done &

# Attach to the tmux session
tmux attach-session -t $TMUX_SESSION

