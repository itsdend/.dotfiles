#!/usr/bin/env bash

# Define profiles with emojis
options=(
  "󱐌  Performance"
  "󰗑  Balanced"
  "  Power Saver"
)

# Show the menu
current=$(powerprofilesctl get)
chosen=$(printf "%s\n" "${options[@]}" | rofi -dmenu -i -matching fuzzy -p "Power Profile ($current)")

# Match and set the corresponding profile
case "$chosen" in
  *"Performance") profile=performance ;;
  *"Balanced") profile=balanced ;;
  *"Power Saver") profile=power-saver ;;
  *) exit 0 ;;
esac

if powerprofilesctl set "$profile"; then
  notify-send "Power Profile" "Switched to $profile"
else
  notify-send -u critical "Power Profile" "Failed to switch to $profile"
fi
