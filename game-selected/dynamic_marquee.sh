#!/bin/bash

# Get the directory of the current script
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

# Source config.sh from one directory up
source "$script_dir/../config.sh"

# File used to debounce rapid-fire requests
debounce_file=/tmp/dynaframe_last_request

# Set logfile location and filename
logfile=/tmp/scriptlog.txt

# Log rotation settings
max_log_size_kb=500  # Maximum log file size in KB before rotation

# Functions
log_error() {
    # Rotate log if needed
    if [ -f "$logfile" ]; then
        current_size=$(du -k "$logfile" | cut -f1)
        if [ "$current_size" -gt "$max_log_size_kb" ]; then
            mv "$logfile" "${logfile}.old"
            echo "$(date '+%Y-%m-%d %H:%M:%S') - Log rotated due to size" > "$logfile"
        fi
    fi
    
    # Log the error message with timestamp
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$logfile"
}

debounced_send_command() {
    local filepath=$1
    printf '%s' "$filepath" > "$debounce_file"
    sleep "$idle_wait"
    local current=$(cat "$debounce_file" 2>/dev/null)
    if [ "$current" = "$filepath" ]; then
        send_command "$filepath"
    fi
}

send_command() {
    local filepath=$1
    
    # New API format only
    local url="http://$dynaframe_hostname:5000/api/PlayFileAPI/PlayFile"
    
    # Execute curl command with silent flag to prevent progress meter
    # -s: silent mode, -S: show error messages, -w: write out additional info
    local http_code=$(curl -s -S -G --max-time 5 \
                    --data-urlencode "FilePath=$filepath" \
                    -w "%{http_code}" \
                    -o /tmp/curl_response.tmp \
                    "$url" 2> /tmp/curl_error.tmp)
    
    local curl_status=$?
    
    # Check for curl execution errors
    if [ $curl_status -ne 0 ]; then
        local error_msg=$(cat /tmp/curl_error.tmp)
        log_error "Curl error (code: $curl_status) sending PlayFile command for '$filepath': $error_msg"
    # Check for HTTP errors
    elif [ "$http_code" -ge 400 ]; then
        local response=$(cat /tmp/curl_response.tmp)
        log_error "HTTP error $http_code sending PlayFile command for '$filepath': $response"
    fi
    
    # Clean up temporary files
    rm -f /tmp/curl_response.tmp /tmp/curl_error.tmp
}

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

# COMMENTED OUT: Turns off AutomaticMode in Dynaframe (legacy API call)
# send_command "AutomaticMode" "FALSE"

# Send command to show the logo of the system selected
debounced_send_command "${marquee_path}${systemname}/images/${romname}-marquee.${extension}"
