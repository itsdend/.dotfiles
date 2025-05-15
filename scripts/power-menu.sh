#!/usr/bin/env bash

options="⏻  Power Off\n󰜉  Reboot\n󰿅  Logout\n󰒲  Sleep"
chosen=$(echo -e "$options" | rofi -dmenu -i matching fuzzy -p "Power Menu")

case "$chosen" in
  "⏻  Power Off") systemctl poweroff ;;
  "󰜉  Reboot") systemctl reboot ;;
  "󰿅  Logout") hyprctl dispatch exit ;;
  "󰒲  Sleep") systemctl suspend ;;
esac
