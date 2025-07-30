#!/bin/bash

#get options
while getopts "p::c::" opt; do
    case $opt in
        p) paired=$OPTARG ;;
        c) connected=$OPTARG ;;
        \?) echo "Invalid option -$OPTARG" >&2; exit 1 ;;
        :) echo "Option -$OPTARG requires an argument." >&2; exit 1 ;;
    esac
done

# Build filter string based on options
conditions=()
if [[ -n "$paired" ]]; then
    if [[ $paired == "true" ]]; then
        conditions+=(".paired==true")
    else
        conditions+=(".paired==false")
    fi
fi
if [[ -n "$connected" ]]; then
    if [[ $connected == "true" ]]; then
        conditions+=(".connected==true")
    else
        conditions+=(".connected==false")
    fi
fi

if [[ ${#conditions[@]} -gt 0 ]]; then
    # Properly join array elements with ' and '
    filterString=""
    for ((i=0; i<${#conditions[@]}; i++)); do
        if [[ $i -gt 0 ]]; then
            filterString="$filterString and "
        fi
        filterString="$filterString${conditions[i]}"
    done
else
    filterString="true"  # Show all if no filters
fi

# Get all devices
bluetoothctl devices | while read -r line; do
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
            echo "{\"name\":\"$name\",\"mac\":\"$mac\",\"paired\":$paired,\"connected\":$connected}"
        fi
    fi
done | jq -s "map(select($filterString))"