#!/bin/bash

SCAN_TIMEOUT=10

if bluetoothctl show | grep -q "Discovering: yes"; then
    # Not sure if this is needed, but just in case
    bluetoothctl scan off 
    # Kill any remaining scan processes
    pkill -f "bluetoothctl.*scan on" 2>/dev/null
    eww poll bt-controller-poll

    notify-send "Bluetooth" "Scanning off" -i bluetooth -r 133769
else
    eww poll bt-controller-poll
    notify-send "Bluetooth" "Scanning started" -i bluetooth -r 133769
    
    bluetoothctl --timeout $SCAN_TIMEOUT scan on &
    eww poll bt-controller-poll &
    wait
    
    notify-send "Bluetooth" "Scanning stopped" -i bluetooth -r 133769

fi