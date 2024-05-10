#!/bin/bash

#USAGE -> NEWPORT=$(./Utility_GetOpenPort.sh) && echo $NEWPORT

#Interface=$1
#IP=$(ifconfig $Interface | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
first_port=16746
last_port=19478
#echo $IP

function scanner

{
for ((port=$first_port; port<=$last_port; port++))
        do
                (echo >/dev/tcp/$IP/$port)> /dev/null 2>&1 && echo "$port open" || echo "$port closed"
        done
}

function random_unused_port {
    local port=$(shuf -i $first_port-$last_port -n 1)
    netstat -lat | grep $port > /dev/null
    if [[ $? == 1 ]] ; then
        export RANDOM_PORT=$port
    else
        random_unused_port
    fi
}

random_unused_port
echo $RANDOM_PORT
#scanner
#https://superuser.com/questions/885414/linux-command-get-unused-port
