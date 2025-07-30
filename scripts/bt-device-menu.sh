#!/bin/bash

device=""
action=""

while getopts "m:cd" opt; do
    case $opt in
        m) device=$OPTARG ;;
        c) action="connect" ;;
        d) action="disconnect" ;;
        \?) echo "Invalid option -$OPTARG" >&2; exit 1 ;;
        :) echo "Option -$OPTARG requires an argument." >&2; exit 1 ;;
    esac
done

mac=$(echo "$device" | jq -r '.mac')
name=$(echo "$device" | jq -r '.name')

case $action in
    connect)
        notify-send "Bluetooth" "Connecting to $name" -i bluetooth -r 133669
        bluetoothctl connect "$mac" & eww update selected-device="$(echo "$device" | jq -c '.connected = true')"
        ;;
    disconnect)
        notify-send "Bluetooth" "Disconnecting from $name" -i bluetooth -r 133669
        bluetoothctl disconnect "$mac" & eww update selected-device="$(echo $device | jq -c '.connected = false')"
        ;;
esac

