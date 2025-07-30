#!/bin/bash

mac=""
action=""

while getopts "m:cd" opt; do
    case $opt in
        m) mac=$OPTARG ;;
        c) action="connect" ;;
        d) action="disconnect" ;;
        \?) echo "Invalid option -$OPTARG" >&2; exit 1 ;;
        :) echo "Option -$OPTARG requires an argument." >&2; exit 1 ;;
    esac
done

case $action in
    connect)
        notify-send "Bluetooth" "Connecting to $mac" -i bluetooth -r 133669
        bluetoothctl connect "$mac"
        ;;
    disconnect)
        notify-send "Bluetooth" "Disconnecting from $mac" -i bluetooth -r 133669
        bluetoothctl disconnect "$mac"
        ;;
esac

