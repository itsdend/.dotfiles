#!/usr/bin/env bash

# TODO select devices
# # Select device
# device=$(kdeconnect-cli -l | grep -oP '^\S+' | rofi -dmenu -p "Select device")
# [ -z "$device" ] && exit

# Input path or URL
# input=$(rofi -dmenu -p "Path or URL to send")


# Prepare suggestions from your two folders
downloads=("$HOME/Downloads")
wallpapers=("$HOME/.dotfiles/wallpapers")

# Get filenames from those folders, one per line
suggestions=$(find "${downloads[@]}" "${wallpapers[@]}" -type f -printf '%p\n' | sort -nr | cut -d' ' -f2-)
# input=$(fzf --prompt="Path or URL to send: ")

input=$(echo -e "${suggestions}" | rofi -dmenu -i matching fuzzy -p "Path or URL to send:")
[ -z "$input" ] && exit


# Send via kdeconnect
kdeconnect-cli -n s24 --share "$input"
