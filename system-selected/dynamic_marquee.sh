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

# Path to System logos on Dynaframe (Example: mame.png, cps2.png, etc)
logo_path="/home/pi/batocera/themes/Alekfull-ARTFLIX/assets/logos/"

# Initialize variables
systemname=""
romname=""

# Log the system selected
log_message "system-selected"
log_message "$*"
systemname=$1
log_message "System: $systemname"
romname=$(basename "${2%.*}")
log_message "ROM: $romname"

# Send commands
# Turns off AutomaticMode in Dynaframe so it stays static on the content you are about to send
send_command "AutomaticMode" "FALSE"
# Tells Dynaframe to show the logo of the system you have selected in the Batocera UI
send_command "PLAYFILE" "${logo_path}${systemname}.png"
