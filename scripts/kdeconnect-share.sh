#!/usr/bin/env bash

# Select device (skip the menu when only one is reachable)
mapfile -t devices < <(kdeconnect-cli -a --name-only 2>/dev/null)

if (( ${#devices[@]} == 0 )); then
  notify-send "KDE Connect" "No reachable devices"
  exit 1
elif (( ${#devices[@]} == 1 )); then
  device="${devices[0]}"
else
  device=$(printf "%s\n" "${devices[@]}" | rofi -dmenu -i -matching fuzzy -p "Select device")
  [ -z "$device" ] && exit
fi

# Prepare suggestions from your two folders (skip the ones that don't exist)
dirs=()
for dir in "$HOME/Downloads" "$HOME/.dotfiles/wallpapers"; do
  [ -d "$dir" ] && dirs+=("$dir")
done

# Get filenames from those folders, newest first, one per line
suggestions=""
if (( ${#dirs[@]} )); then
  suggestions=$(find "${dirs[@]}" -type f -printf '%T@ %p\n' | sort -nr | cut -d' ' -f2-)
fi

input=$(printf "%s\n" "$suggestions" | rofi -dmenu -i -matching fuzzy -p "Path or URL to send:")
[ -z "$input" ] && exit

# Send via kdeconnect
if kdeconnect-cli -n "$device" --share "$input"; then
  notify-send "KDE Connect" "Sent to $device: $(basename "$input")"
else
  notify-send -u critical "KDE Connect" "Failed to send to $device"
fi
