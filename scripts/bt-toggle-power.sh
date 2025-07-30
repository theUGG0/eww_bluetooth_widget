#!/bin/bash

if bluetoothctl show | grep -q "Powered: yes"; then
    bluetoothctl power off
    eww update bt_power=false
    notify-send "Bluetooth" "Turned off" -i bluetooth -r 133769
else
    bluetoothctl power on
    eww update bt_power=true
    notify-send "Bluetooth" "Turned on" -i bluetooth -r 133769
fi