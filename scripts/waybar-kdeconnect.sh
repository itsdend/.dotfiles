#!/usr/bin/env bash

# Get the list of devices that are paired and reachable
device_info=$(kdeconnect-cli -l | grep -E 'paired and reachable' | head -n1)

if [ -z "$device_info" ]; then
  # No connected device
  echo '{"text":" ", "class":"disconnected"}'   # circle icon, or choose any you like
else
  # Extract device name (before the colon)
  device_name=$(echo "$device_info" | cut -d ':' -f1 | tr -d ' -')
  echo "{\"text\":\" $device_name \", \"class\":\"connected\"}"  # phone icon + name
fi
