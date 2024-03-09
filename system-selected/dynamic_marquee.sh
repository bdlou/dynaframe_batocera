#!/bin/bash
#This is an example file how Events on START or STOP can be uses
#
 
#Set logfile location and filename
logfile=/tmp/scriptlog.txt

dyna_root="http://dfmarquee"
batocera_root="/home/pi/batocera/"
dyna_dir_root="/home/pi/batocera/themes/Alekfull-ARTFLIX/assets/logos/"
default_root="/home/pi/Pictures/Default/"

systemname=""
romname=""



echo "system-selected" > $logfile
echo "$@" >> $logfile
systemname=$1
echo "System: $systemname" >> $logfile
romname=$(basename "${2%.*}")
echo "ROM: $romname" >> $logfile

curl -G --max-time 5 \
    --data-urlencode "VALUE=FALSE" \
    ${dyna_root}/command/?COMMAND=AutomaticMode > /dev/null 2>&1 &

curl -G --max-time 5 \
    --data-urlencode "VALUE=${dyna_dir_root}${systemname}.png" \
    --data-urlencode "FALLBACK=${default_root}default.png"\
    ${dyna_root}/command/?COMMAND=PLAYFILE > /dev/null 2>&1 &
