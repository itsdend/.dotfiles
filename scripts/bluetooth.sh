#!/usr/bin/env bash

# Make sure the adapter is powered on
if ! bluetoothctl show | grep -q "Powered: yes"; then
    notify-send "Bluetooth" "Powering on adapter..."
    if ! bluetoothctl power on >/dev/null; then
        notify-send -u critical "Bluetooth" "Failed to power on adapter"
        exit 1
    fi
fi

SCAN_LABEL="🔍  Scan for new devices"

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

while true; do
    # Get ALL devices known to bluetoothctl (not only paired)
    mapfile -t bt_devices < <(bluetoothctl devices | awk '{print $2}')

    options=()

    for mac in "${bt_devices[@]}"; do
        name=$(get_bt_name "$mac")
        [[ -z "$name" ]] && name="Unknown Device"

        status=$(get_bt_status "$mac")   # yes / no
        paired=$(get_bt_paired "$mac")   # yes / no

        display="${name} (conn:${status}, pair:${paired})"
        options+=("$display|$mac")
    done

    chosen_label=$( { echo "$SCAN_LABEL"; ((${#options[@]})) && printf "%s\n" "${options[@]}" | cut -d '|' -f1; } | \
        rofi -dmenu -i -matching fuzzy -p "Bluetooth Devices")

    [[ -z "$chosen_label" ]] && exit 0
    [[ "$chosen_label" != "$SCAN_LABEL" ]] && break

    notify-send "Bluetooth" "Scanning for devices..."
    bluetoothctl --timeout 8 scan on >/dev/null
done

mac_to_handle=""
for entry in "${options[@]}"; do
    if [[ "${entry%|*}" == "$chosen_label" ]]; then
        mac_to_handle="${entry##*|}"
        break
    fi
done

[[ -z "$mac_to_handle" ]] && exit 0

status=$(get_bt_status "$mac_to_handle")
paired=$(get_bt_paired "$mac_to_handle")
name=$(get_bt_name "$mac_to_handle")

# Run a bluetoothctl step and report failure
bt_step() {
    local action="$1"
    if ! bluetoothctl "$action" "$mac_to_handle" >/dev/null; then
        notify-send -u critical "Bluetooth" "Failed to $action $name"
        exit 1
    fi
}

# ---- AUTO PAIR + TRUST + CONNECT ----
if [[ "$paired" == "no" ]]; then
    notify-send "Bluetooth" "Pairing $name..."
    bt_step pair

    notify-send "Bluetooth" "Trusting $name..."
    bt_step trust

    notify-send "Bluetooth" "Connecting to $name..."
    bt_step connect
    notify-send "Bluetooth" "Connection to $name successful"

    exit 0
fi

# If paired → toggle connection state
if [[ "$status" == "yes" ]]; then
    notify-send "Bluetooth" "Disconnecting from $name"
    bt_step disconnect
    notify-send "Bluetooth" "Disconnected from $name"
else
    notify-send "Bluetooth" "Connecting to $name"
    bt_step connect
    notify-send "Bluetooth" "Connection to $name successful"
fi
