#!/bin/sh

speedtest_cli_path="./tools/speedtest-cli"
speedtest_result_path="./www/speedtest-speed.txt"

if [ ! -f "$speedtest_cli_path" ]; then
    echo "File speedtest-cli tidak ditemukan. Mulai mengunduh..."
    wget -O "$speedtest_cli_path" https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py
    chmod +x "$speedtest_cli_path"
    echo "Speedtest-cli berhasil diunduh dan diinstal."
fi

$speedtest_cli_path > ./www/speedtest-result.txt

isp=$(grep "Testing from" /www/speedtest-result.txt | sed 's/Testing from \(.*\) (.*/\1/')
server=$(grep "Hosted by" /www/speedtest-result.txt | sed 's/Hosted by \(.*\) (.*/\1/')
location=$(grep "Hosted by" /www/speedtest-result.txt | sed 's/.*(\(.*\)) \[.*/\1/')
distance=$(grep "Hosted by" /www/speedtest-result.txt | sed 's/.*\[\(.*\) km\].*/\1/')
ping=$(grep "Hosted by" /www/speedtest-result.txt | sed 's/.*\]: \(.*\) ms/\1/')
download=$(grep "Download" /www/speedtest-result.txt | awk '{printf "%s %s", $2, $3}')
upload=$(grep "Upload" /www/speedtest-result.txt | awk '{printf "%s %s", $2, $3}')

speed_result="ISP: $isp | Server: $server | Location: $location | Distance: $distance km | Ping: $ping ms | Download: $download | Upload: $upload"

echo "$speed_result" > $speedtest_result_path

echo "Speedtest selesai. Hasil disimpan di ${speedtest_result_path}"

