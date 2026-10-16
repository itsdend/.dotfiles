#!/usr/bin/env bash

# Icons must match "hyprland/workspaces" format-icons in status/waybar/config
icons=("" "󰣘" "󰣙" "" "" "" "󰻀" "󰻀" "󰻀" "󰻀")

active=$(hyprctl activeworkspace -j | jq -r '.id')
mapfile -t occupied < <(hyprctl workspaces -j | jq -r '.[] | select(.windows > 0) | .id')

choices=""
for i in {1..9}; do
  marker=""
  if [[ "$i" == "$active" ]]; then
    marker=" ●"
  elif [[ " ${occupied[*]} " == *" $i "* ]]; then
    marker=" ○"
  fi
  choices+="$i ${icons[$i]}$marker"$'\n'
done

selected=$(printf "%s" "$choices" | rofi -dmenu -p "Select Workspace:" | awk '{print $1}')

# If selection is not empty, switch to that workspace
if [[ -n "$selected" ]]; then
    hyprctl dispatch workspace "$selected"
fi
