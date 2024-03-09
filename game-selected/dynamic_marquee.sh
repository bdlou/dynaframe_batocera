#!/bin/bash
#This is an example file how Events on START or STOP can be uses
#
 
#Set logfile location and filename
logfile=/tmp/scriptlog.txt

dyna_root="http://dfmarquee"
dyna_dir_root="/home/pi/batocera/roms/"
default_root="/home/pi/Pictures/Default/"

system_name=""
rom_name=""
extension=""

echo "game-selected" > $logfile
echo "$@" >> $logfile
system_name=$1
echo "System: $system_name" >> $logfile
rom_name=$(basename "${2%.*}")
echo "ROM: $rom_name" >> $logfile

if [[ $system_name = 'nes' ]]
then
    extension='jpg'
else
    extension='png'
fi

curl -G --max-time 5 \
    --data-urlencode "VALUE=FALSE" \
    ${dyna_root}/command/?COMMAND=AutomaticMode > /dev/null 2>&1 &

curl -G --max-time 5 --silent \
    --data-urlencode "VALUE=${dyna_dir_root}${system_name}/images/${rom_name}-marquee.${extension}" \
    --data-urlencode "FALLBACK=${default_root}default.png"\
    ${dyna_root}/command/?COMMAND=PLAYFILE > /dev/null 2>&1 &
