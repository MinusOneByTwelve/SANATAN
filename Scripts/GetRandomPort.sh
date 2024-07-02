#!/bin/bash

first_port=16746
last_port=19478
IP="127.0.0.1"

function random_unused_port {
    local port=$(shuf -i $first_port-$last_port -n 1)
    # Check if the port is being used
    if ! ss -ltn | grep -q ":$port " ; then
        echo $port
        return 0
    else
        random_unused_port
    fi
}

RANDOM_PORT=$(random_unused_port)
echo $RANDOM_PORT
