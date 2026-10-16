#!/usr/bin/env bash

if command -v notify-send &>/dev/null; then
	scan_id=$(notify-send -p "󱛃	Scanning networks	󱛃" -t 10000)
fi

# SSID goes last so colons inside it (escaped by nmcli as "\:") don't break splitting
mapfile -t wifi_list < <(nmcli -t -f SECURITY,SIGNAL,RATE,SSID device wifi list --rescan yes)

if [[ -n "$scan_id" ]]; then
  notify-send -r "$scan_id" -t 1500 "Found ${#wifi_list[@]} networks"
fi

labels=()
ssids=()
securities=()
declare -A seen

for line in "${wifi_list[@]}"; do
  IFS=':' read -r security signal rate ssid <<< "$line"
  ssid="${ssid//\\:/:}"
  ssid="${ssid//\\\\/\\}"

  [[ -z "$ssid" ]] && continue
  # same SSID from several APs/bands → keep the first (nmcli sorts by signal)
  [[ -n "${seen[$ssid]}" ]] && continue
  seen[$ssid]=1

  labels+=("$ssid ($signal% @ $rate) [${security:---}]")
  ssids+=("$ssid")
  securities+=("$security")
done

chosen_label=$(printf '%s\n' "${labels[@]}" | rofi -dmenu -i -matching fuzzy -p "Select Wi-Fi")
[[ -z "$chosen_label" ]] && exit 0

ssid=""
security=""
for i in "${!labels[@]}"; do
  if [[ "${labels[$i]}" == "$chosen_label" ]]; then
    ssid="${ssids[$i]}"
    security="${securities[$i]}"
    break
  fi
done

[[ -z "$ssid" ]] && exit 0

notify_result() {
  if [[ "$1" == 0 ]]; then
    notify-send "Wi-Fi" "Connected to $ssid"
  else
    notify-send -u critical "Wi-Fi" "Failed to connect to $ssid"
  fi
}

# Saved connection → just bring it up, no password needed
if nmcli -t -f NAME connection show | grep -qxF "$ssid"; then
  nmcli connection up id "$ssid" >/dev/null 2>&1
  notify_result $?
  exit 0
fi

if [[ -n "$security" && "$security" != "--" ]]; then
  password=$(rofi -dmenu -p "Password for $ssid" -password)
  [[ -z "$password" ]] && exit 0
  nmcli device wifi connect "$ssid" password "$password" >/dev/null 2>&1
else
  nmcli device wifi connect "$ssid" >/dev/null 2>&1
fi
notify_result $?
