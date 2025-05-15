#!/usr/bin/env bash

# Define profiles with emojis
options=(
  "󱐌  Performance"
  "󰗑  Balanced"
  "  Power Saver"
)

# Show the menu
chosen=$(printf "%s\n" "${options[@]}" | rofi -dmenu -i matching fuzzy -p "Power Profile")

# Match and set the corresponding profile
case "$chosen" in
  "󱐌  Performance") powerprofilesctl set performance ;;
  "󰗑  Balanced")    powerprofilesctl set balanced ;;
  "  Power Saver") powerprofilesctl set power-saver ;;
esac
