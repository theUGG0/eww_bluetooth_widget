#!/bin/bash

SCAN_TIMEOUT=10

if bluetoothctl show | grep -q "Discovering: yes"; then
    # Not sure if this is needed, but just in case
    bluetoothctl scan off 
    # Kill any remaining scan processes
    pkill -f "bluetoothctl.*scan on" 2>/dev/null
    eww update bt_scanning=false

    notify-send "Bluetooth" "Scanning off" -i bluetooth -r 133769
else
    # Clear previous discovered devices
    > /tmp/bt_discovered

    eww update bt_scanning=true
    notify-send "Bluetooth" "Scanning started" -i bluetooth -r 133769
    
    bluetoothctl --timeout $SCAN_TIMEOUT scan on | while read -r line; do
        # Strip ANSI color codes from the line
        clean_line=$(echo "$line" | sed 's/\x1b\[[0-9;]*[mGK]//g')
        
        if [[ "$clean_line" =~ \[NEW\]\ Device ]]; then
            # Extract MAC and name
            mac=$(echo "$clean_line" | grep -o '[0-9A-F]\{2\}:[0-9A-F]\{2\}:[0-9A-F]\{2\}:[0-9A-F]\{2\}:[0-9A-F]\{2\}:[0-9A-F]\{2\}')
            name=$(echo "$clean_line" | sed 's/.*Device [0-9A-F:]\{17\} //')
            
            if [[ -n "$mac" && -n "$name" ]]; then
                echo "$mac $name" >> /tmp/bt_discovered
            fi
        fi
    done
    
    notify-send "Bluetooth" "Scanning stopped" -i bluetooth -r 133769
    eww update bt_scanning=false
fi