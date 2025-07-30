#!/bin/bash

#arrays for devices in different states
connected_devices=$(jq -n '[]')
paired_devices=$(jq -n '[]')
devices=$(jq -n '[]')

while read -r line; do
    if [[ -n "$line" ]]; then
        mac=$(echo "$line" | awk '{print $2}')
        if [[ -n "$mac" ]]; then
            # Get info for each device
            info=$(bluetoothctl info "$mac")
            name=$(echo "$info" | grep 'Name:' | awk '{print $2}')
            paired=$(echo "$info" | grep -q 'Paired: yes' && echo true || echo false)
            connected=$(echo "$info" | grep -q 'Connected: yes' && echo true || echo false)
            
            # Fallback if name is empty
            if [[ -z "$name" ]]; then
                name=$(echo "$line" | cut -d' ' -f3-)
            fi

            device_obj=$(jq -n \
              --arg name "$name" \
              --arg mac "$mac" \
              --argjson paired "$paired" \
              --argjson connected "$connected" \
              '{
                name: $name,
                mac: $mac,
                paired: $paired,
                connected: $connected
              }')
            
            # assign devices to corresponding arrays
            if [[ $connected == "true" ]]; then
                connected_devices=$(echo "$connected_devices" | jq --argjson obj "$device_obj" '. + [$obj]')
            fi

            if [[ $paired == "true"]]; then
                paired_devices=$(echo "$paired_devices" | jq --argjson obj "$device_obj" '. + [$obj]')
            fi

            if [[ $connected == "false" && $paired == "false" ]]; then
                devices=$(echo "$devices" | jq --argjson obj "$device_obj" '. + [$obj]')
            fi           
        fi
    fi
done < <(bluetoothctl devices)

# Output the complete data structure
jq -n \
  --argjson devices "$devices" \
  --argjson connected "$connected_devices" \
  --argjson paired "$paired_devices" \
  '{
    devices: $devices,
    connected: $connected,
    paired: $paired
  }'
