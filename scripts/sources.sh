#!/usr/bin/env bash

mapfile -t sources < <(pactl list short sources | awk '$2 !~ /\.monitor$/ {print $2}')

get_volume() {
  local source="$1"
  pactl list sources | awk -v s="$source" '
    $0 ~ "Name: "s {found=1}
    found && /Volume:/ {
      print $0
      found=0
    }' | sed -E 's/.* ([0-9]+)%.*$/\1%/'
}

declare -A source_icons
source_icons["alsa_input.pci-0000_00_1f.3.analog-stereo"]="🎤  Built-in Mic"
source_icons["alsa_input.usb-Logitech_Webcam_C920-00.analog-stereo"]="📷  Webcam Mic"

options=()
for src in "${sources[@]}"; do
  label="${source_icons[$src]:-$src}"
  vol=$(get_volume "$src")
  display="${label} (${vol})"
  options+=("$display|$src")
done

chosen_label=$(printf "%s\n" "${options[@]}" | cut -d '|' -f1 | rofi -dmenu -i matching fuzzy -p "Audio Input")

source_to_set=$(printf "%s\n" "${options[@]}" | grep "^$chosen_label|" | cut -d '|' -f2-)

if [[ -n "$source_to_set" ]]; then
  pactl set-default-source "$source_to_set"

  for stream in $(pactl list short source-output | awk '{print $1}'); do
    pactl move-source-output "$stream" "$source_to_set"
  done
fi
