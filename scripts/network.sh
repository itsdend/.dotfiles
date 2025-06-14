#!/usr/bin/env bash

if command -v notify-send &>/dev/null; then
	notify-send "󱛃	Scanning networks	󱛃" -t 10000 
fi

mapfile -t wifi_list < <(nmcli -t -f SSID,SIGNAL,RATE,SECURITY device wifi list --rescan yes)

options=()

for line in "${wifi_list[@]}"; do
  IFS=':' read -r ssid signal rate security <<< "$line"

  [[ -z "$ssid" ]] && continue

  options+=("$ssid ($signal% @ $rate) [$security]|$ssid|$security")
done

chosen_label=$(printf '%s\n' "${options[@]}" | cut -d'|' -f1 | rofi -dmenu -i matching fuzzy -p "Select Wi-Fi")
[[ -z "$chosen_label" ]] && exit 1

ssid=""
security=""
for entry in "${options[@]}"; do
  label="${entry%%|*}"
  if [[ "$label" == "$chosen_label" ]]; then
    ssid="${entry#*|}"
    ssid="${ssid%%|*}"
    security="${entry##*|}"
    break
  fi
done

echo "Connecting to SSID: '$ssid' with security: $security"

if [[ "$security" != "--" ]]; then
  password=$(rofi -dmenu -p "Password for $ssid" -password)
  [[ -z "$password" ]] && exit 1
  nmcli device wifi connect "$ssid" password "$password"
else
  nmcli device wifi connect "$ssid"
fi
