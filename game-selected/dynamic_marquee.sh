#!/bin/bash

# Get the directory of the current script
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

# Source config.sh from one directory up
source "$script_dir/../config.sh"

# Functions
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$logfile"
}

send_command() {
    local url="http://$dynaframe_hostname/command/?COMMAND=$1"
    curl -G --max-time 5 \
         --data-urlencode "VALUE=$2" \
         --data-urlencode "FALLBACK=${default_root}default.png" \
         "$url" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        log_message "Error sending command $1"
    fi
}
 
#Set logfile location and filename
logfile=/tmp/scriptlog.txt

# Parent path to Game marquees on Dynaframe
marquee_path="/home/pi/batocera/roms/"

# Initial values for systemname and romname
systemname=$1
romname=$(basename "${2%.*}")

# Example of overriding 'nes' to look for marquees with jpg extension instead of png
if [[ $systemname = 'nes' ]]; then
    extension='jpg'
else
    extension='png'
fi

# Log the system selected
log_message "system-selected"
log_message "$*"
log_message "System: $systemname"
log_message "ROM: $romname"

# Send commands
# Turns off AutomaticMode in Dynaframe
send_command "AutomaticMode" "FALSE"
# Tells Dynaframe to show the logo of the system selected
send_command "PLAYFILE" "${marquee_path}${systemname}/images/${romname}-marquee.${extension}"
