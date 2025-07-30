#!/bin/bash

if bluetoothctl show | grep -q "Powered: yes"; then
    bluetoothctl power off
    eww poll bt-controller-poll
    notify-send "Bluetooth" "Turned off" -i bluetooth -r 133769
else
    bluetoothctl power on
    eww poll bt-controller-poll
    notify-send "Bluetooth" "Turned on" -i bluetooth -r 133769
fi