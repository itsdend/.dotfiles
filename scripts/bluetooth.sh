#!/usr/bin/env bash

notify-send "Bluetooth" "Scanning for devices..."
bluetoothctl &
{ echo "scan on" 
	sleep 8 
	echo "scan off" 
	echo "exit" 
} | bluetoothctl

# Get ALL devices known to bluetoothctl (not only paired)
mapfile -t bt_devices < <(bluetoothctl devices | awk '{print $2}')

# Return "yes" or "no" depending on connection state
get_bt_status() {
    local mac="$1"
    bluetoothctl info "$mac" | awk '/Connected:/ {print $2}'
}

# Return device name
get_bt_name() {
    local mac="$1"
    bluetoothctl info "$mac" | awk -F': ' '/Name:/ {print $2}'
}

# Return "yes" if paired, "no" otherwise
get_bt_paired() {
    local mac="$1"
    bluetoothctl info "$mac" | awk '/Paired:/ {print $2}'
}

options=()

for mac in "${bt_devices[@]}"; do
    name=$(get_bt_name "$mac")
    [[ -z "$name" ]] && name="Unknown Device"

    status=$(get_bt_status "$mac")   # yes / no
    paired=$(get_bt_paired "$mac")   # yes / no

    display="${name} (conn:${status}, pair:${paired})"
    options+=("$display|$mac")
done

chosen_label=$(printf "%s\n" "${options[@]}" | cut -d '|' -f1 | \
    rofi -dmenu -i matching fuzzy -p "Bluetooth Devices")

mac_to_handle=$(printf "%s\n" "${options[@]}" | grep "^$chosen_label|" | cut -d '|' -f2-)

if [[ -z "$mac_to_handle" ]]; then
    exit 0
fi

status=$(get_bt_status "$mac_to_handle")
paired=$(get_bt_paired "$mac_to_handle")
name=$(get_bt_name "$mac_to_handle")

# ---- AUTO PAIR + TRUST + CONNECT ----
if [[ "$paired" == "no" ]]; then
    notify-send "Bluetooth" "Pairing $name..."
    bluetoothctl pair "$mac_to_handle"

    notify-send "Bluetooth" "Trusting $name..."
    bluetoothctl trust "$mac_to_handle"

    notify-send "Bluetooth" "Connecting to $name..."
    bluetoothctl connect "$mac_to_handle"
    notify-send "Bluetooth" "Connection to $name successful"

    exit 0
fi

# If paired → toggle connection state
if [[ "$status" == "yes" ]]; then
    notify-send "Bluetooth" "Disconnecting from $name"
    bluetoothctl disconnect "$mac_to_handle"
    notify-send "Bluetooth" "Connection to $name died"
else
    notify-send "Bluetooth" "Connecting to $name"
    bluetoothctl connect "$mac_to_handle"
    notify-send "Bluetooth" "Connection to $name successful"
fi
