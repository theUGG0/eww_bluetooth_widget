#!/bin/bash

raw_data=$(bluetoothctl show)

name=$(echo "$raw_data" | grep 'Name:' | sed 's/^[[:space:]]*//' | cut -d' ' -f2-)
discovering=$(echo "$raw_data" | grep -q 'Discovering: yes' && echo true || echo false)
powered=$(echo "$raw_data" | grep -q 'Powered: yes' && echo true || echo false)

jq -n \
    --arg name "$name" \
    --arg discovering "$discovering" \
    --arg powered "$powered" \
    '{
        name: $name,
        discovering: $discovering,
        powered: $powered
    }'