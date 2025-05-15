#!/usr/bin/env bash

# Create a list of workspaces 1–9 with optional icons
choices=$(printf "1 󰣘\n2 󰣙\n3 \n4 \n5 \n6 󰻀\n7 󰻀\n8 󰻀\n9 󰻀")

# Show the menu (choose either rofi or wofi)
selected=$(echo "$choices" | rofi -dmenu -p "Select Workspace:" | awk '{print $1}')

# If selection is not empty, switch to that workspace
if [[ -n "$selected" ]]; then
    hyprctl dispatch workspace "$selected"
fi
