#!/usr/bin/env bash

STATE_FILE="$HOME/.cache/mako_toggle_state"

[ ! -f "$STATE_FILE" ] && echo "on" > "$STATE_FILE"

STATE=$(cat "$STATE_FILE")

if [[ "$STATE" == "on" ]]; then
    echo "off" > "$STATE_FILE"

	if command -v notify-send &>/dev/null; then
		notify-send "󰂛	Notifications are off	󰂛"  -t 800
	fi
		makoctl mode -a do-not-disturb

else
    echo "on" > "$STATE_FILE"

    makoctl mode -r do-not-disturb 
	if command -v notify-send &>/dev/null; then
		notify-send "󰂚	Notifications are on	󰂚" 
	fi
fi
