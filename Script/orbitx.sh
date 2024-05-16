#!/bin/bash

if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# Connection Settings
HOST="192.168.11.1"
PORT="22"

#Settings
SLEEP_TIME=5400
SERVICE_NAME="Orbit-Rebooter"
SCREEN_NAME=Orbit-Rebooter

function loop() {
  while true; do
    current_time=$(date +"%Y-%m-%d %H:%M:%S")
    
    # AT command to send
    AT_COMMAND="AT+ZSNT=6,0,0"
    UBUS_CMD="ubus call version set_atcmd_info '{\"atcmd\" : \"AT+ZSNT=6,0,0\"}'"

    #Send SSH
    response=$(sshpass -p 'root123' ssh -o KexAlgorithms=diffie-hellman-group14-sha1 -o HostKeyAlgorithms=+ssh-dss root@192.168.11.1 "${UBUS_CMD}")
    if [[ $response == *"OK"* ]]; then
     echo "[$current_time] | Command Executed Successfully." >> /www/modemx.txt
     echo "[$current_time] | Sleep $((${SLEEP_TIME}/60)) Minutes" >> /www/modemx.txt
     sleep ${SLEEP_TIME}
    else
     echo "[$current_time] | Command failed with response: $response" >> /www/modemx.txt
    fi
  done
}

function start() {
  echo -e "Starting ${SERVICE_NAME} service ..."
  screen -AmdS ${SCREEN_NAME} "${0}" -l
}

function stop() {
  echo -e "Stopping ${SERVICE_NAME} service ..."
  kill $(screen -list | grep ${SCREEN_NAME} | awk -F '[.]' {'print $1'})
}

function usage() {
  cat <<EOF
Usage:
  -r  Run ${SERVICE_NAME} service
  -s  Stop ${SERVICE_NAME} service
EOF
}

case "${1}" in
  -l)
    loop
    ;;
  -r)
    start
    ;;
  -s)
    stop
    ;;
  *)
    usage
    ;;
esac
