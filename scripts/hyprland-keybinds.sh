#!/usr/bin/env bash

HYPR_CONFIG="$HOME/.config/hypr/hyprland.conf"

grep '^bind\s*=' "$HYPR_CONFIG" | \
sed -E 's/^bind\s*=\s*([^,]+),\s*([^,]+),\s*(.*)/\1+\2 → \3/' | \
rofi -dmenu -i matching fuzzy  -p "Hyprland Keybinds"
