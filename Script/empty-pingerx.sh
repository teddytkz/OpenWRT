#!/bin/bash

if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

SERVICE_NAME="Empty Pinger"
SCREEN_NAME="empty-pinger"
pingLogPath="./www/pingstatus.txt"
modemLogPath="./www/modemx.txt"

function loop() {
  echo -n > "$pingLogPath"
  echo -n > "$modemLogPath"

  while true; do
    echo -n > "$pingLogPath"
    sleep 3600
    # Menghapus modemx.txt setiap 12 jam
    # if [ "$(date +%H)" == "00" ] || [ "$(date +%H)" == "12" ]; then
    #     delete_file "$files"
    # fi
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
