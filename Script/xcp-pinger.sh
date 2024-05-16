#!/bin/bash

if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

SERVICE_NAME="Pinger XCP"
SCREEN_NAME="xcp-pinger"
PING_HOST="[host]"

function loop() {
  while true; do
    current_time=$(date +"%Y-%m-%d %H:%M:%S")
    if curl --interface eth0.101 -X "GET" --connect-timeout 3 -so /dev/null ${PING_HOST}; then
        echo "[$current_time] | ${PING_HOST} | Koneksi Up" >> /www/pingstatus.txt
	    echo "Koneksi Up"
	    bledon -lan on
	    sleep 30
    else
        echo "[$current_time] | ${PING_HOST} | Koneksi Down" >> /www/pingstatus.txt
	    echo "Koneksi Down"
	    bledon -lan off
	    sleep 3
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
