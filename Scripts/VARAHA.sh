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
CGP1=""
CGP2=""
CGP3=""

MIN1IO=""
MIN2IO=""

if [ "$THECHOICE" == "CORE" ] ; then
	declare -a MANAGER_IPS
	MGRIPS="$2"
	IFS=',' read -r -a MANAGER_IPS <<< "$MGRIPS"
	STACKNAME="$3"
	STACKPRETTYNAME="$4"
	STACKPRETTYNAME=$(echo "$STACKPRETTYNAME" | tr '[:upper:]' '[:lower:]')	
	STATIC_CONTENT_PATH="$5"
	LOCALVARAHAPORT="$6"
	GLOBALVARAHAPORT="$7"
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
	websshPort1="${23}"
	webssh_PASSWORD="${24}"
	hash_webssh_PASSWORD=$(mkpasswd -m sha-256 $webssh_PASSWORD)	
	webssh_DIR="${25}"
	IDLE_LIMIT="${26}"
	THEVERWROUTER="${27}" 
	THEVERW1ROUTER="${28}"
	CHITRAGUPTA_DET="${29}"
	hash_admin_PASSWORD=$(mkpasswd -m sha-256 $ADMIN_PASSWORD)
	MIN_IO_DET="${30}"
	#MYNAME=$(head -n 1 /opt/THEMENAME)
	MYNAME="${31}"
	EFKPort3="${32}"
	EFKPort4="${33}"
	CDNPRX="${34}"	
	ALT_INDR_HA_PRT="${35}"
	
	sudo chown root:root $CERTS_DIR/cluster/full/$MYNAME.pem
	sudo chmod 644 $CERTS_DIR/cluster/full/$MYNAME.pem
	
	IFS='■' read -r -a CHITRAGUPTA_VAL <<< $CHITRAGUPTA_DET
	
	echo $CHITRAGUPTA_DET
	
	CGPORTSDET="${CHITRAGUPTA_VAL[1]}"		
	IFS=',' read -r -a CGPORTS_DET <<< "$CGPORTSDET"
	CGP1="${CGPORTS_DET[4]}"
	sudo firewall-cmd --zone=public --add-port=${CGP1}/tcp --permanent
	CGP2="${CGPORTS_DET[5]}"
	sudo firewall-cmd --zone=public --add-port=${CGP2}/tcp --permanent
	CGP3="${CGPORTS_DET[6]}"
	sudo firewall-cmd --zone=public --add-port=${CGP3}/tcp --permanent
	CGP5="${CGPORTS_DET[7]}"
	sudo firewall-cmd --zone=public --add-port=${CGP5}/tcp --permanent	
	
	CGPORTS2DET="${CHITRAGUPTA_VAL[5]}"		
	IFS=',' read -r -a CGPORTS2_DET <<< "$CGPORTS2DET"	
	CGP4="${CGPORTS2_DET[5]}"
	sudo firewall-cmd --zone=public --add-port=${CGP4}/tcp --permanent	
	
	CGPORTS3DET="${CHITRAGUPTA_VAL[6]}"		
	IFS=',' read -r -a CGPORTS3_DET <<< "$CGPORTS3DET"	
	CGP6="${CGPORTS3_DET[4]}"
	sudo firewall-cmd --zone=public --add-port=${CGP6}/tcp --permanent	
	CGP7="${CGPORTS3_DET[5]}"
	sudo firewall-cmd --zone=public --add-port=${CGP7}/tcp --permanent
	
	CGPORTS4DET="${CHITRAGUPTA_VAL[7]}"		
	IFS=',' read -r -a CGPORTS4_DET <<< "$CGPORTS4DET"	
	CGP8="${CGPORTS4_DET[3]}"
	sudo firewall-cmd --zone=public --add-port=${CGP8}/tcp --permanent	
	CGP9="${CGPORTS4_DET[4]}"
	sudo firewall-cmd --zone=public --add-port=${CGP9}/tcp --permanent	

	CGPORTS5DET="${CHITRAGUPTA_VAL[8]}"		
	IFS=',' read -r -a CGPORTS5_DET <<< "$CGPORTS5DET"	
	CGP35="${CGPORTS5_DET[2]}"
	CGP34="${CGPORTS5_DET[1]}"
	CGP36="${CGPORTS5_DET[12]}"	
	sudo firewall-cmd --zone=public --add-port=${CGP35}/tcp --permanent
								
	#sudo firewall-cmd --reload
	
	IFS=',' read -r -a MINIO_DET <<< $MIN_IO_DET
	
	echo $MIN_IO_DET
	
	MIN1IO="${MINIO_DET[3]}"
	sudo firewall-cmd --zone=public --add-port=${MIN1IO}/tcp --permanent
	MIN2IO="${MINIO_DET[4]}"
	sudo firewall-cmd --zone=public --add-port=${MIN2IO}/tcp --permanent
	FBR1="${MINIO_DET[9]}"
	sudo firewall-cmd --zone=public --add-port=${FBR1}/tcp --permanent
		
	sudo firewall-cmd --reload
	
	if [ "$CDNPRX" == "PASSIVE" ]; then
		IFS=',' read -r -a HAPRT <<< "$ALT_INDR_HA_PRT"
		PortainerWPort="${HAPRT[0]}"
		AdminPort="${HAPRT[1]}"
		GLOBALVARAHAPORT="${HAPRT[2]}"
		websshPort1="${HAPRT[3]}"	
		MIN1IO="${HAPRT[4]}"
		MIN2IO="${HAPRT[5]}"
		FBR1="${HAPRT[6]}"
		CGP1="${HAPRT[7]}"
		CGP2="${HAPRT[8]}"
		CGP3="${HAPRT[9]}"
		CGP4="${HAPRT[10]}"
		CGP5="${HAPRT[11]}"
		CGP6="${HAPRT[12]}"
		CGP7="${HAPRT[13]}"
		CGP8="${HAPRT[14]}"
		CGP9="${HAPRT[15]}"
		CGP35="${HAPRT[16]}"
		EFKPort3="${HAPRT[17]}"
		EFKPort4="${HAPRT[18]}"																				
	fi

	sudo firewall-cmd --zone=public --add-port=${PortainerWPort}/tcp --permanent 
	sudo firewall-cmd --zone=public --add-port=${AdminPort}/tcp --permanent
	sudo firewall-cmd --zone=public --add-port=${GLOBALVARAHAPORT}/tcp --permanent
	sudo firewall-cmd --zone=public --add-port=${websshPort1}/tcp --permanent
	sudo firewall-cmd --zone=public --add-port=${MIN1IO}/tcp --permanent
	sudo firewall-cmd --zone=public --add-port=${MIN2IO}/tcp --permanent 
	sudo firewall-cmd --zone=public --add-port=${FBR1}/tcp --permanent
	sudo firewall-cmd --zone=public --add-port=${CGP1}/tcp --permanent
	sudo firewall-cmd --zone=public --add-port=${CGP2}/tcp --permanent
	sudo firewall-cmd --zone=public --add-port=${CGP3}/tcp --permanent
	sudo firewall-cmd --zone=public --add-port=${CGP4}/tcp --permanent 
	sudo firewall-cmd --zone=public --add-port=${CGP5}/tcp --permanent
	sudo firewall-cmd --zone=public --add-port=${CGP6}/tcp --permanent
	sudo firewall-cmd --zone=public --add-port=${CGP7}/tcp --permanent
	sudo firewall-cmd --zone=public --add-port=${CGP8}/tcp --permanent
	sudo firewall-cmd --zone=public --add-port=${CGP9}/tcp --permanent 
	sudo firewall-cmd --zone=public --add-port=${CGP35}/tcp --permanent
	sudo firewall-cmd --zone=public --add-port=${EFKPort3}/tcp --permanent
	sudo firewall-cmd --zone=public --add-port=${EFKPort4}/tcp --permanent
	sudo firewall-cmd --reload			
fi

# Generate the HAProxy configuration
generate_cfg() {
    echo 'global
    log /dev/log local0
    log /dev/log local1 notice
    #chroot /var/lib/haproxy
    stats socket /run/haproxy/'"$STACKPRETTYNAME"'admin.sock mode 660 level admin
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
    
    SetUpMinIO
    SetUpCHITRAGUPTA
    
    echo '
frontend '"$STACKPRETTYNAME"'_VARAHA_Front
    bind *:'"$GLOBALVARAHAPORT"' ssl crt /certs/varaha.pem
    default_backend '"$STACKPRETTYNAME"'_VARAHA_Back

backend '"$STACKPRETTYNAME"'_VARAHA_Back
    mode http
    server static_cdn '"$THEROUTER"':'"$LOCALVARAHAPORT"'

listen '"$STACKPRETTYNAME"'_Admin_Front
    bind *:'"$AdminPort"' ssl crt /certs/varaha.pem
    stats enable
    stats uri /
    stats hide-version
    stats refresh 10s
    stats auth admin:'"$ADMIN_PASSWORD"'' | sudo tee -a $THECFGPATH > /dev/null

    THECNFGNM="VARAHA""_$CDNPRX""$STACKNAME.cfg"
    docker config create $THECNFGNM "$THECFGPATH"
    cat $THECFGPATH
}

SetUpMinIO() {	
	echo "
#resolvers docker
#    nameserver dns1 127.0.0.11:53
#    resolve_retries       3
#    timeout resolve       1s
#    timeout retry         1s
#    hold other           30s
#    hold refused         30s
#    hold nx              30s
#    hold timeout         30s
#    hold valid           10s
#    hold obsolete        30s

frontend ""$STACKPRETTYNAME""_CloudCommander_Front
    bind *:$FBR1 ssl crt /certs/varaha.pem
    mode http
    default_backend ""$STACKPRETTYNAME""_CloudCommander_Back

backend ""$STACKPRETTYNAME""_CloudCommander_Back
    mode http
    server ganesha_cloudcommander cloudcmd:8000 check
    	
frontend ""$STACKPRETTYNAME""_MinIO_Front
    bind *:$MIN1IO ssl crt /certs/self-varaha.pem
    mode http
    default_backend ""$STACKPRETTYNAME""_MinIO_Back

backend ""$STACKPRETTYNAME""_MinIO_Back
#    balance roundrobin
#    server-template minio 1-_N_ minio:9000 check resolvers docker
    mode http
    server ganesha_minio minio:9000 check
        
frontend ""$STACKPRETTYNAME""_MinIOConsole_Front
    bind *:$MIN2IO ssl crt /certs/varaha.pem
    default_backend ""$STACKPRETTYNAME""_MinIOConsole_Back    
    
backend ""$STACKPRETTYNAME""_MinIOConsole_Back
#    balance roundrobin
#    server-template minio_console 1-_N_ minio:9001 check resolvers docker
    mode http
    server ganesha_minioconsole minio:9001 check" | sudo tee -a $THECFGPATH > /dev/null			
}

SetUpCHITRAGUPTA() {
	echo "
frontend ""$STACKPRETTYNAME""_Elastic_Front
    bind *:$EFKPort3 ssl crt /certs/share-varaha.pem
    mode http
    default_backend ""$STACKPRETTYNAME""_Elastic_Back

backend ""$STACKPRETTYNAME""_Elastic_Back
    mode http
    server chitragupta_elastic elasticsearch:9200 check" | sudo tee -a $THECFGPATH > /dev/null 

	echo "
frontend ""$STACKPRETTYNAME""_Kibana_Front
    bind *:$EFKPort4 ssl crt /certs/varaha.pem
    mode http
    default_backend ""$STACKPRETTYNAME""_Kibana_Back

backend ""$STACKPRETTYNAME""_Kibana_Back
    mode http
    server chitragupta_kibana kibana:5601 check" | sudo tee -a $THECFGPATH > /dev/null

if [ "$CDNPRX" == "ACTIVE" ]; then    
	echo "
frontend ""$STACKPRETTYNAME""_Nextcloud_Front
    bind *:$CGP35 ssl crt /certs/varaha.pem
    mode http
    default_backend ""$STACKPRETTYNAME""_Nextcloud_Back

backend ""$STACKPRETTYNAME""_Nextcloud_Back
    mode http
    server chitragupta_pvtcld $CGP36:$CGP34" | sudo tee -a $THECFGPATH > /dev/null
fi
    	    
	echo "
frontend ""$STACKPRETTYNAME""_Guacamole_Front
    bind *:$CGP1 ssl crt /certs/varaha.pem
    mode http
    default_backend ""$STACKPRETTYNAME""_Guacamole_Back

backend ""$STACKPRETTYNAME""_Guacamole_Back
    mode http
    server chitragupta_guacamole guacamole:8080 check" | sudo tee -a $THECFGPATH > /dev/null

	echo "
frontend ""$STACKPRETTYNAME""_phpMyAdmin_Front
    bind *:$CGP2 ssl crt /certs/varaha.pem
    mode http
    default_backend ""$STACKPRETTYNAME""_phpMyAdmin_Back

backend ""$STACKPRETTYNAME""_phpMyAdmin_Back
    mode http
    server chitragupta_phpmyadmin phpmyadmin:80 check" | sudo tee -a $THECFGPATH > /dev/null
    
	echo "
frontend ""$STACKPRETTYNAME""_MySQL_Front
    bind *:$CGP3 ssl crt /certs/share-varaha.pem
    mode http
    default_backend ""$STACKPRETTYNAME""_MySQL_Back

backend ""$STACKPRETTYNAME""_MySQL_Back
    mode http
    server chitragupta_mysql mysql:3306 check" | sudo tee -a $THECFGPATH > /dev/null 

	echo "
frontend ""$STACKPRETTYNAME""_Prometheus_Front
    bind *:$CGP5 ssl crt /certs/varaha.pem
    mode http
    acl auth_prometheus http_auth(""$STACKPRETTYNAME""_Prometheus_Users)
    acl is_prometheus path_beg /
    http-request auth realm \"Prometheus Authentication\" if is_prometheus !auth_prometheus
    default_backend ""$STACKPRETTYNAME""_Prometheus_Back

backend ""$STACKPRETTYNAME""_Prometheus_Back
    mode http
    server chitragupta_prometheus prometheus:9090 check
    http-request set-header X-Forwarded-Proto https if { ssl_fc }
    http-request set-header X-Forwarded-Port %[dst_port]

userlist ""$STACKPRETTYNAME""_Prometheus_Users
    user admin password $hash_admin_PASSWORD" | sudo tee -a $THECFGPATH > /dev/null 
        
	echo "
frontend ""$STACKPRETTYNAME""_Grafana_Front
    bind *:$CGP4 ssl crt /certs/varaha.pem
    mode http
    default_backend ""$STACKPRETTYNAME""_Grafana_Back

backend ""$STACKPRETTYNAME""_Grafana_Back
    mode http
    server chitragupta_grafana grafana:3000 check" | sudo tee -a $THECFGPATH > /dev/null 
    
	echo "
frontend ""$STACKPRETTYNAME""_phpLDAPadmin_Front
    bind *:$CGP6 ssl crt /certs/varaha.pem
    mode http
    default_backend ""$STACKPRETTYNAME""_phpLDAPadmin_Back

backend ""$STACKPRETTYNAME""_phpLDAPadmin_Back
    mode http
    server chitragupta_phpldapadmin phpldapadmin:443 ssl verify none" | sudo tee -a $THECFGPATH > /dev/null   
    
	echo "
frontend ""$STACKPRETTYNAME""_OpenLDAP_Front
    bind *:$CGP7 ssl crt /certs/share-varaha.pem
    mode tcp
    default_backend ""$STACKPRETTYNAME""_OpenLDAP_Back

backend ""$STACKPRETTYNAME""_OpenLDAP_Back
    mode tcp
    option tcp-check
    server chitragupta_openldap openldap:389 check" | sudo tee -a $THECFGPATH > /dev/null 
    
	echo "
frontend ""$STACKPRETTYNAME""_KerberosKDC_Front
    bind *:$CGP8 ssl crt /certs/share-varaha.pem
    mode tcp
    default_backend ""$STACKPRETTYNAME""_KerberosKDC_Back

backend ""$STACKPRETTYNAME""_KerberosKDC_Back
    mode tcp
    option tcp-check
    server chitragupta_Kerberoskdc kerberos:88 check" | sudo tee -a $THECFGPATH > /dev/null 
    
	echo "
frontend ""$STACKPRETTYNAME""_KerberosAdmin_Front
    bind *:$CGP9 ssl crt /certs/share-varaha.pem
    mode tcp
    default_backend ""$STACKPRETTYNAME""_KerberosAdmin_Back

backend ""$STACKPRETTYNAME""_KerberosAdmin_Back
    mode tcp
    option tcp-check
    server chitragupta_Kerberosadmin kerberos:749 check" | sudo tee -a $THECFGPATH > /dev/null                          			
}

# Create the Docker Compose file
create_docker_compose_file() {
    echo 'version: '"'3.7'"'
 
services:                 
  haproxy:
    image: '"$THEVER1ROUTER"':'"$THEVERROUTER"'
    configs:
      - source: '"VARAHA"_$CDNPRX"$STACKNAME"'.cfg
        target: /usr/local/etc/haproxy/haproxy.cfg    
    ports:
      - "'"$PortainerWPort"':'"$PortainerWPort"'"
      - "'"$AdminPort"':'"$AdminPort"'"
      - "'"$GLOBALVARAHAPORT"':'"$GLOBALVARAHAPORT"'" 
      - "'"$websshPort1"':'"$websshPort1"'"  
      - "'"$MIN1IO"':'"$MIN1IO"'"
      - "'"$MIN2IO"':'"$MIN2IO"'"  
      - "'"$FBR1"':'"$FBR1"'"                
      - "'"$CGP1"':'"$CGP1"'"
      - "'"$CGP2"':'"$CGP2"'" 
      - "'"$CGP3"':'"$CGP3"'" 
      - "'"$CGP4"':'"$CGP4"'"
      - "'"$CGP5"':'"$CGP5"'"
      - "'"$CGP6"':'"$CGP6"'"   
      - "'"$CGP7"':'"$CGP7"'"  
      - "'"$CGP8"':'"$CGP8"'"   
      - "'"$CGP9"':'"$CGP9"'"  
      - "'"$CGP35"':'"$CGP35"'"
      - "'"$EFKPort3"':'"$EFKPort3"'"  
      - "'"$EFKPort4"':'"$EFKPort4"'"                                                        
    deploy:
      replicas: 1
      placement:
        constraints:
          - node.labels.'"$STACKNAME"'INDRA_'"$CDNPRX"'replica == true
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
        source: '"$CERTS_DIR"'/docker/'"$STACKNAME"'-share-VARAHA.pem
        target: /certs/share-varaha.pem
        read_only: true 
      - type: bind
        source: '"$CERTS_DIR"'/cluster/full/'"$MYNAME"'.pem
        target: /certs/self-varaha.pem
        read_only: true               
      - type: bind
        source: '"$ERRORS_DIR"'
        target: /etc/haproxy/errors 
      - type: bind
        source: '"$MISC_DIR"'
        target: /run/haproxy
      - type: bind
        source: '"$webssh_DIR"'
        target: '"$webssh_DIR"'
    networks:
      - '"$STACKNAME"'-encrypted-overlay    
   
networks:
  '"$STACKNAME"'-encrypted-overlay:
    external: true 
    
configs:
  '"VARAHA"_$CDNPRX"$STACKNAME"'.cfg:
    external: true' | sudo tee $THEDCYPATH > /dev/null
    
    cat $THEDCYPATH
}

# Create all support files
create_support_files() {
	echo "done through dockersetuptemplate"
	ls -l $webssh_DIR
	sudo chown -R $CURRENTUSER:$CURRENTUSER $webssh_DIR
	sudo chmod -R 777 $webssh_DIR
}

# Main function to set up everything
main() {
	if [ "$THECHOICE" == "CORE" ] ; then
	    #create_support_files	    	    
	    generate_cfg
	    create_docker_compose_file
	    echo "docker stack deploy --compose-file $THEDCYPATH $STACKNAME""_""$CDNPRX""_VARAHA"
	    docker stack deploy --compose-file $THEDCYPATH $STACKNAME"_""$CDNPRX""_VARAHA"
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

