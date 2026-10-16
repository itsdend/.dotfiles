#!/usr/bin/env bash

# Get the list of devices that are paired and reachable
device_info=$(kdeconnect-cli -a --name-only 2>/dev/null)

if [ -z "$device_info" ]; then
  # No connected device
  echo '{"text":" ", "class":"disconnected"}'   # circle icon, or choose any you like
else
  # Join all reachable device names, escape for JSON
  device_name=$(printf "%s\n" "$device_info" | awk 'NR > 1 {printf ", "} {printf "%s", $0}')
  device_name="${device_name//\\/\\\\}"
  device_name="${device_name//\"/\\\"}"
  echo "{\"text\":\" $device_name \", \"class\":\"connected\"}"  # phone icon + name
fi
