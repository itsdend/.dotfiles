#!/usr/bin/env bash

options="⏻  Power Off\n󰜉  Reboot\n󰿅  Logout\n󰒲  Sleep"
chosen=$(echo -e "$options" | rofi -dmenu -i -matching fuzzy -p "Power Menu")

confirm() {
  [[ "$(printf "No\nYes" | rofi -dmenu -i -p "$1")" == "Yes" ]]
}

case "$chosen" in
  *"Power Off") confirm "Power off?" && systemctl poweroff ;;
  *"Reboot") confirm "Reboot?" && systemctl reboot ;;
  *"Logout") hyprctl dispatch exit ;;
  *"Sleep")
    pidof hyprlock >/dev/null || hyprlock &
    sleep 1
    systemctl suspend
    ;;
esac
