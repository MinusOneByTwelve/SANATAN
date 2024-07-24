#!/bin/bash

clear

CURRENTUSER=$(whoami)
sudo rm -rf /home/$CURRENTUSER/.ssh/known_hosts
sudo rm -rf /root/.ssh/known_hosts
sudo rm -rf /root/.bash_history
sudo rm -rf /home/$CURRENTUSER/.bash_history

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

echo -e "${ORANGE}=================================================${NC}"
echo -e "\x1b[1;34mV\x1b[${NC}irtual \x1b[1;34mA\x1b[${NC}nonymized \x1b[1;34mR\x1b[${NC}outer \x1b[1;34mA\x1b[${NC}ccessing \x1b[1;34mH\x1b[${NC}idden \x1b[1;34mA\x1b[${NC}ssets"
echo -e "${GREEN}=================================================${NC}"
echo ''
echo -e "\x1b[3mV   V  AAAAA  RRRRR  AAAAA  H   H  AAAAA\x1b[m"
echo -e "\x1b[3mV   V  A   A  R   R  A   A  H   H  A   A\x1b[m"
echo -e "\x1b[3mV   V  AAAAA  RRRRR  AAAAA  HHHHH  AAAAA\x1b[m"
echo -e "\x1b[3m V V   A   A  R  R   A   A  H   H  A   A\x1b[m"
echo -e "\x1b[3m  V    A   A  R   R  A   A  H   H  A   A\x1b[m"
echo ''
echo -e "\x1b[3m\x1b[4mPORT MANAGEMENT & ROUTING\x1b[m"
echo ''

THECHOICE="$1"

if [ "$THECHOICE" == "CORE" ] ; then
	declare -a MANAGER_IPS
	MGRIPS="$2"
	IFS=',' read -r -a MANAGER_IPS <<< "$MGRIPS"
	STACKNAME="$3"
	STACKPRETTYNAME="$4"	
	STATIC_CONTENT_PATH="$5"
	LOCALCDNPORT="$6"
	GLOBALCDNPORT="$7"
	THECFGPATH="$8"
	PortainerWPort="$9"
	AdminPort="${10}"
	ADMIN_PASSWORD="${11}"
	PortainerPort="${12}"
	THEDCYPATH="${13}"
	C1ORE="${14}"
	R1AM="${15}"
	CERTS_DIR="${16}"
	ERRORS_DIR="${17}"	
	MISC_DIR="${18}"
	THEROUTER="${19}" 
	THEVERROUTER="${20}" 
	THEVER1ROUTER="${21}"
	SYNCWITHIFCONFIG="${22}"
	if [ "$SYNCWITHIFCONFIG" == "Y" ]; then	
		THEROUTER=$(ip addr show docker0 | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1)  
	fi
	WEBSSHPort1="${23}"
	WEBSSH_PASSWORD="${24}"	
	WEBSSH_DIR="${25}"
	IDLE_LIMIT="${26}"
	THEVERWROUTER="${27}" 
	THEVERW1ROUTER="${28}"								
fi

# Generate the HAProxy configuration
generate_cfg() {
    echo 'global
    log /dev/log local0
    log /dev/log local1 notice
    #chroot /var/lib/haproxy
    stats socket /run/haproxy/admin.sock mode 660 level admin
    stats timeout 30s
    user root
    group root
    daemon

    ca-base /etc/ssl/certs
    crt-base /etc/ssl/private
    ssl-default-bind-ciphers AES128+EECDH:AES128+EDH
    ssl-default-bind-options no-sslv3

defaults
    log global
    mode http
    option httplog
    option dontlognull
    option http-server-close
    option forwardfor
    timeout connect 5s
    timeout client 50s
    timeout server 50s
    errorfile 400 /etc/haproxy/errors/400.http
    errorfile 403 /etc/haproxy/errors/403.http
    errorfile 408 /etc/haproxy/errors/408.http
    errorfile 500 /etc/haproxy/errors/500.http
    errorfile 502 /etc/haproxy/errors/502.http
    errorfile 503 /etc/haproxy/errors/503.http
    errorfile 504 /etc/haproxy/errors/504.http

frontend '"$STACKPRETTYNAME"'_WebSSH_Front
    bind *:'"$WEBSSHPort1"' ssl crt /certs/varaha.pem
    mode http
    acl path_wetty path_beg -i /wetty
    use_backend %[path,map_beg(/etc/haproxy/backend.map)]
    http-request auth realm '"$STACKPRETTYNAME"' if !{ http_auth('"$STACKPRETTYNAME"'_WebSSH_Users) }

backend '"$STACKPRETTYNAME"'_WebSSH_Back
    mode http
    balance roundrobin
    http-reuse always

userlist '"$STACKPRETTYNAME"'_WebSSH_Users
    user admin password '"$WEBSSH_PASSWORD"'
    
frontend '"$STACKPRETTYNAME"'_Portainer_Front
    bind *:'"$PortainerWPort"' ssl crt /certs/varaha.pem
    mode http
    default_backend '"$STACKPRETTYNAME"'_Portainer_Back

backend '"$STACKPRETTYNAME"'_Portainer_Back
    mode http
    option httpchk GET /api/system/status
    http-check expect status 200
    balance roundrobin' | sudo tee $THECFGPATH > /dev/null

    for COUNTER in "${!MANAGER_IPS[@]}"; do
	echo "    server portainer$COUNTER ${MANAGER_IPS[$COUNTER]}:$PortainerPort ssl check inter 5s fall 2 rise 2 verify none" | sudo tee -a $THECFGPATH > /dev/null
	COUNTER=$((COUNTER + 1))
    done

    echo '
frontend '"$STACKPRETTYNAME"'_CDN_Front
    bind *:'"$GLOBALCDNPORT"' ssl crt /certs/varaha.pem
    default_backend '"$STACKPRETTYNAME"'_CDN_Back

backend '"$STACKPRETTYNAME"'_CDN_Back
    mode http
    server static_server '"$THEROUTER"':'"$LOCALCDNPORT"'

listen '"$STACKPRETTYNAME"'_Admin_Front
    bind *:'"$AdminPort"' ssl crt /certs/varaha.pem
    stats enable
    stats uri /
    stats hide-version
    stats refresh 10s
    stats auth admin:'"$ADMIN_PASSWORD"'' | sudo tee -a $THECFGPATH > /dev/null

    docker config create CDN$STACKNAME.cfg "$THECFGPATH"
    #cat $THECFGPATH
}

# Create the Docker Compose file
create_docker_compose_file() {
    echo 'version: '"'3.7'"'
 
services:                 
  haproxy:
    image: '"$THEVER1ROUTER"':'"$THEVERROUTER"'
    configs:
      - source: '"CDN$STACKNAME"'.cfg
        target: /usr/local/etc/haproxy/haproxy.cfg    
    ports:
      - "'"$PortainerWPort"':'"$PortainerWPort"'"
      - "'"$AdminPort"':'"$AdminPort"'"
      - "'"$GLOBALCDNPORT"':'"$GLOBALCDNPORT"'" 
      - "'"$WEBSSHPort1"':'"$WEBSSHPort1"'"                       
    deploy:
      replicas: 1
      placement:
        constraints:
          - node.labels.'"$STACKNAME"'routerreplica == true
      resources:
        limits:
          cpus: '"'$C1ORE'"'
          memory: '"'$R1AM""M'"'
    volumes:
      - type: bind
        source: '"$CERTS_DIR"'/docker/'"$STACKNAME"'-VARAHA.pem
        target: /certs/varaha.pem
        read_only: true
      - type: bind
        source: '"$ERRORS_DIR"'
        target: /etc/haproxy/errors 
      - type: bind
        source: '"$MISC_DIR"'
        target: /run/haproxy                                     
    networks:
      - '"$STACKNAME"'-encrypted-overlay    
   
networks:
  '"$STACKNAME"'-encrypted-overlay:
    external: true 
    
configs:
  '"CDN$STACKNAME"'.cfg:
    external: true' | sudo tee $THEDCYPATH > /dev/null
    
    #cat $THEDCYPATH
}

# Create all support files
create_support_files() {
	echo '#!/bin/bash

HASH=$1
PORT=$2

# Add new mapping to backend.map
echo "/wetty/$HASH '"$STACKPRETTYNAME"'_WebSSH_Back" >> '"$WEBSSH_DIR"'/backend.map

# Use the HAProxy Runtime API to add the new server to the backend
echo "add server '"$STACKPRETTYNAME"'_WebSSH_Back/wetty-$HASH '"$THEROUTER"':$PORT check" | socat stdio /run/haproxy/admin.sock
' | tee $WEBSSH_DIR/update_haproxy.sh > /dev/null
	chmod +x $WEBSSH_DIR/update_haproxy.sh
	
	echo '#!/bin/sh

LOGFILE="'"$WEBSSH_DIR"'/inactivity_check_'"$STACKPRETTYNAME"'.log"
IDLE_LIMIT='"$IDLE_LIMIT"'  # Idle limit in seconds

echo "$(date): Starting inactivity check script" >> $LOGFILE

while true; do
    # Get the last activity time of the tmux session
    LAST_ACTIVITY=$(tmux display -p -t ssh_session '"'#{client_activity}'"')
    CURRENT_TIME=$(date +%s)

    # Calculate the idle time
    IDLE_TIME=$((CURRENT_TIME - LAST_ACTIVITY))

    echo "$(date): Current time: $CURRENT_TIME, Last activity: $LAST_ACTIVITY, Idle time: $IDLE_TIME" >> $LOGFILE

    if [ "$IDLE_TIME" -gt "$IDLE_LIMIT" ]; then
        echo "$(date): Container idle for more than $IDLE_LIMIT seconds. Exiting." >> $LOGFILE
        kill 1  # Send SIGTERM to PID 1 to stop the container
        exit
    fi

    sleep 60  # Check every 60 seconds
done' | tee $WEBSSH_DIR/inactivity_check.sh > /dev/null
	chmod +x $WEBSSH_DIR/inactivity_check.sh
	
	echo 'FROM '"$THEVERW1ROUTER"':'"$THEVERWROUTER"'

# Install tmux
RUN apk update && apk add tmux

# Copy custom scripts
COPY '"$WEBSSH_DIR"'/custom_ssh.sh '"$WEBSSH_DIR"'/custom_ssh.sh
COPY '"$WEBSSH_DIR"'/inactivity_check.sh '"$WEBSSH_DIR"'/inactivity_check.sh

# Make scripts executable
RUN chmod +x '"$WEBSSH_DIR"'/custom_ssh.sh '"$WEBSSH_DIR"'/inactivity_check.sh' | tee $WEBSSH_DIR/dockerfile > /dev/null

	echo '#!/bin/bash

IP=$1
PORT=$2
PEM_FILE="/home/vagrant/op-Scope1000-240724152136.pem"

if [ -f "$PEM_FILE" ]; then
    tmux new-session -d -s ssh_session "ssh -i "$PEM_FILE" -o StrictHostKeyChecking=no -p "$PORT" vagrant@$IP"
    '"$WEBSSH_DIR"'/inactivity_check.sh &
    tmux attach-session -t ssh_session
else
    echo "PEM file for $IP not found."
    exit 1
fi' | tee $WEBSSH_DIR/custom_ssh.sh > /dev/null
	chmod +x $WEBSSH_DIR/custom_ssh.sh
	
	echo '' | tee $WEBSSH_DIR/start_wetty_container.sh > /dev/null
	chmod +x $WEBSSH_DIR/start_wetty_container.sh		
}

# Main function to set up everything
main() {
	if [ "$THECHOICE" == "CORE" ] ; then
	    create_support_files	    	    
	    generate_cfg
	    create_docker_compose_file
	    echo "docker stack deploy --compose-file $THEDCYPATH CDN$STACKNAME"
	    docker stack deploy --compose-file $THEDCYPATH CDN$STACKNAME
	    sudo rm -f $THECFGPATH  
	    sudo rm -f $THEDCYPATH 
	fi          
}

# Run the main function
main

sudo rm -rf /home/$CURRENTUSER/.ssh/known_hosts
sudo rm -rf /root/.ssh/known_hosts
sudo rm -rf /root/.bash_history
sudo rm -rf /home/$CURRENTUSER/.bash_history

