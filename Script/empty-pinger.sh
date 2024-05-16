#!/bin/bash

# Specify the file path
pingLogPath="/www/pingstatus.txt"
modemLogPath="/www/modemx.txt"

# Empty the file
echo -n > "$pingLogPath"
echo -n > "$modemLogPath"


# Loop utama
while true; do
    echo -n > "$pingLogPath"
    sleep 3600
    # Menghapus modemx.txt setiap 12 jam
    # if [ "$(date +%H)" == "00" ] || [ "$(date +%H)" == "12" ]; then
    #     delete_file "$files"
    # fi
done